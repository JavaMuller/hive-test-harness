package hive.harness.service;

import hive.harness.domain.QueryResult;
import org.apache.commons.cli.*;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Component
public class RunTest implements CommandLineRunner {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private Proof proof;

    @Autowired
    private Options options;

    @Autowired
    private Environment environment;

    @Override
    public void run(String... args) throws Exception {

        CommandLineParser parser = new BasicParser();
        CommandLine commandLine = parser.parse(options, args);

        final boolean build = commandLine.hasOption("b");
        final boolean query = commandLine.hasOption("q");
        final boolean count = commandLine.hasOption("c");
        final String testName = commandLine.getOptionValue("test.name", environment.getProperty("test.name"));
        final String localDataPath = commandLine.getOptionValue("local.data.path", environment.getProperty("local.data.path"));
        final String hdfsDataPath = commandLine.getOptionValue("hdfs.data.path", environment.getProperty("hdfs.data.path"));
        final String databaseName = commandLine.getOptionValue("hive.db.name", environment.getProperty("hive.db.name"));
        final int iterations = Integer.parseInt(commandLine.getOptionValue("i", "1"));

        System.out.println();
        log.info("******************************************");
        log.info("Running Test with the following parameters...");
        log.info("\tBuild: " + build);
        log.info("\tQuery: " + query);

        if (query) {
            log.info("\tCount Records: " + count);
            log.info("\tTest Name: " + testName);
        }

        if (build) {
            log.info("\tLocal Data Path: " + localDataPath);
            log.info("\tHDFS Data Path: " + hdfsDataPath);
            log.info("\tDatabase Name: " + databaseName);
        }

        if (query) {
            log.info("\tIterations: " + iterations);
        }

        log.info("******************************************");
        System.out.println();


        if (build) {
            System.out.println();
            log.info("******************************************");
            log.info("Building Database, Tables and Load Data");
            log.info("******************************************");
            System.out.println();

            String[] dataFilter = new String[]{};

            String[] tableFilter = new String[]{};

            proof.build(localDataPath, hdfsDataPath, dataFilter, tableFilter, databaseName);
        }


        if (query) {

            String[] includeFilter = new String[]{};

            String[] excludeFilter = new String[]{};

            System.out.println();
            log.info("******************************************");
            log.info("Executing queries");
            log.info("******************************************");
            System.out.println();

            List<QueryResult> results = proof.executeQueries(includeFilter, excludeFilter, iterations, count);

            System.out.println();
            log.info("******************************************");
            log.info("Test Finished!  Writing results to file...");
            log.info("******************************************");
            System.out.println();

            generateResultFile(testName, results);
        }

        if (!query && !build) {
            log.warn("Whoops!  You didn't build or query!");
        }

    }

    private void generateResultFile(String description, List<QueryResult> results) {

        String[] words = StringUtils.split(StringUtils.trim(description.toLowerCase()));

        SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy_HH-mm-ss_");

        final String filename = "query-results_" + sdf.format(new Date()) + StringUtils.join(words, "-") + ".csv";

        CSVFormat format = CSVFormat.DEFAULT.withHeader("file", "min", "max", "mean", "median", "standard deviation", "iterations", "count", "countDuration");

        try (FileWriter fileWriter = new FileWriter(filename);
             CSVPrinter printer = new CSVPrinter(fileWriter, format)) {

            for (QueryResult result : results) {
                printer.printRecord(result.getFile(), result.getMin(), result.getMax(), result.getMean(), result.getMedian(), result.getStandardDeviation(), result.getIterations(), result.getCount(), result.getCountDuration());
            }

            fileWriter.flush();

        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }
    }
}
