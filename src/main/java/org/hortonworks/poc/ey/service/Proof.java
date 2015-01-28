package org.hortonworks.poc.ey.service;

import com.google.common.base.Function;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.hortonworks.poc.ey.domain.QueryResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.util.*;

@Service
public class Proof {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private Environment environment;

    @Autowired
    private HiveService hiveService;

    @Autowired
    private HadoopService hadoopService;


    public void build(String dataPath, String[] dataFilter, String[] tableFilter, String[] viewFilter) throws IOException, InterruptedException {

        loadFilesIntoHdfs(dataPath, dataFilter);

        createDatabase();

        buildTables(tableFilter);

        buildViews(viewFilter);

    }

    public List<QueryResult> executeQueries(String[] includeFilter, String[] excludeFilter, int iterations) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath:sql/converted/queries/*.sql");

        List<Resource> filteredResources = applyFilters(resources, includeFilter, excludeFilter);

        List<QueryResult> results = new ArrayList<>(filteredResources.size());

        Collections.sort(filteredResources, Ordering.natural().onResultOf(new Function<Resource, String>() {
            @Override
            public String apply(Resource input) {
                return input.getFilename();
            }
        }));

        for (Resource file : filteredResources) {

            for (int i = 0; i < iterations; i++) {
                QueryResult queryResult = hiveService.executeSqlQuery(file);

                if (i == iterations -1) {
                    results.add(queryResult);
                }
            }

        }

        return results;


    }

    private void createDatabase() throws IOException, InterruptedException {
        hiveService.createDatabase();
    }


    private void loadFilesIntoHdfs(String dataPath, String[] dataFilter) throws IOException, InterruptedException {

        final String hdfsPath = environment.getProperty("data.path");

        hadoopService.createDirectory(hdfsPath);

        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

        final String locationPattern = cleanPath(dataPath);

        Resource[] resources = resolver.getResources("file:" + locationPattern);

        List<Resource> filteredResources = applyFilters(resources, dataFilter, null);

        for (Resource resource : filteredResources) {
            hadoopService.writeFile(resource);
        }
    }


    private String cleanPath(String dataPath) {
        return (StringUtils.endsWith(dataPath, File.separator) ? dataPath : dataPath + File.separator) + "*.csv";
    }


    private List<Resource> applyFilters(Resource[] resources, String[] includeFilter, String[] excludeFilter) throws IOException {

        Map<String, Resource> fileMap = new HashMap<>();

        for (Resource resource : resources) {
            fileMap.put(resource.getFilename(), resource);
        }

        List<Resource> filteredFiles = new ArrayList<>();

        Set<String> allFileNames = fileMap.keySet();


        if (excludeFilter != null && excludeFilter.length > 0) {
            Set<String> excludedNames = Sets.newHashSet(excludeFilter);
            final Set<String> difference = Sets.difference(allFileNames, excludedNames).immutableCopy();

            for (String fileName : difference) {
                filteredFiles.add(fileMap.get(fileName));
            }
        }

        if (includeFilter != null && includeFilter.length > 0) {
            Set<String> includedNames = Sets.newHashSet(includeFilter);
            final Set<String> intersection = Sets.intersection(allFileNames, includedNames).immutableCopy();

            for (String fileName : intersection) {
                filteredFiles.add(fileMap.get(fileName));
            }
        }

        if (filteredFiles.isEmpty()) {
            filteredFiles.addAll(fileMap.values());
        }

        return filteredFiles;
    }

    private void buildTables(String[] tableFilter) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath:sql/build/tables/*.sql");

        List<Resource> filteredResources = applyFilters(resources, tableFilter, null);

        for (Resource resource : filteredResources) {
            hiveService.executeSqlScript(resource);
        }
    }

    private void buildViews(String[] viewFilter) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath:sql/build/views/*.sql");

        List<Resource> filteredResources = applyFilters(resources, viewFilter, null);

        for (Resource resource : filteredResources) {
            hiveService.executeSqlScript(resource);
        }
    }


    private void buildIndexes() throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath:sql/converted/indexes/*.sql");

        for (Resource resource : resources) {
            hiveService.executeSqlScript(resource);
        }
    }

}
