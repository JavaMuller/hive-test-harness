package veil.hdp.hive.harness.service;

import com.google.common.base.Function;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Service;
import veil.hdp.hive.harness.domain.QueryResult;

import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class Proof {

    @Autowired
    private HiveService hiveService;

    @Autowired
    private HadoopService hadoopService;


    public void build(String localDataPath, String hdfsDataPath, String[] dataFilter, String[] tableFilter, String databaseName) throws IOException, InterruptedException {

        loadFilesIntoHdfs(localDataPath, hdfsDataPath, dataFilter);

        createDatabase(databaseName);

        buildTables(tableFilter, hdfsDataPath);

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

    private void createDatabase(String databaseName) throws IOException, InterruptedException {
        hiveService.createDatabase(databaseName);
    }


    private void loadFilesIntoHdfs(String localDataPath, String hdfsDataPath, String[] dataFilter) throws IOException, InterruptedException {

        hadoopService.createDirectory(hdfsDataPath);

        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

        final String locationPattern = cleanPath(localDataPath);

        Resource[] resources = resolver.getResources("file:" + locationPattern);

        List<Resource> filteredResources = applyFilters(resources, dataFilter, null);

        for (Resource resource : filteredResources) {
            hadoopService.writeFile(resource, hdfsDataPath);
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

            filteredFiles.addAll(difference.stream().map(fileMap::get).collect(Collectors.toList()));
        }

        if (includeFilter != null && includeFilter.length > 0) {
            Set<String> includedNames = Sets.newHashSet(includeFilter);
            final Set<String> intersection = Sets.intersection(allFileNames, includedNames).immutableCopy();

            filteredFiles.addAll(intersection.stream().map(fileMap::get).collect(Collectors.toList()));
        }

        if (filteredFiles.isEmpty()) {
            filteredFiles.addAll(fileMap.values());
        }

        return filteredFiles;
    }

    private void buildTables(String[] tableFilter, String hdfsDataPath) throws IOException {
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        Resource[] resources = resolver.getResources("classpath:sql/tables/*.sql");

        List<Resource> filteredResources = applyFilters(resources, tableFilter, null);

        for (Resource resource : filteredResources) {
            hiveService.executeSqlScript(resource, hdfsDataPath);
        }
    }

}
