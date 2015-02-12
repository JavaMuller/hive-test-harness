package hive.harness.service;

import com.google.common.base.Function;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import hive.harness.domain.QueryResult;
import org.apache.commons.lang3.StringUtils;
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

    @Autowired
    private Environment environment;

    @Autowired
    private HiveService hiveService;

    @Autowired
    private HadoopService hadoopService;


    public void build(String dataPath, String[] dataFilter, String[] tableFilter) throws IOException, InterruptedException {

        loadFilesIntoHdfs(dataPath, dataFilter);

        createDatabase();

        buildTables(tableFilter);

    }

    public List<QueryResult> executeQueries(String[] includeFilter, String[] excludeFilter, int iterations, boolean countResults) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath:sql/queries/*.sql");

        List<Resource> filteredResources = applyFilters(resources, includeFilter, excludeFilter);

        List<QueryResult> results = new ArrayList<>(filteredResources.size());

        Collections.sort(filteredResources, Ordering.natural().onResultOf(new Function<Resource, String>() {
            @Override
            public String apply(Resource input) {
                return input.getFilename();
            }
        }));

        for (Resource file : filteredResources) {

            QueryResult queryResult = hiveService.executeSqlQuery(file, iterations, countResults);

            if (queryResult != null) {
                results.add(queryResult);
            }

        }

        return results;

    }

    private void createDatabase() throws IOException, InterruptedException {
        hiveService.createDatabase();
    }


    private void loadFilesIntoHdfs(String dataPath, String[] dataFilter) throws IOException, InterruptedException {

        final String hdfsPath = environment.getProperty("hdfs.data.path");

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


    private List<Resource> applyFilters(Resource[] resources, String[] includeFilter, String[] excludeFilter) {

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
        Resource[] resources = resolver.getResources("classpath:sql/tables/*.sql");

        List<Resource> filteredResources = applyFilters(resources, tableFilter, null);

        for (Resource resource : filteredResources) {
            hiveService.executeSqlScript(resource);
        }
    }

}
