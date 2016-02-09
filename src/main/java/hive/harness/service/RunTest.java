package hive.harness.service;

import hive.harness.domain.Arguments;
import hive.harness.domain.QueryResult;
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
    private Environment environment;

    @Override
    public void run(String... args) throws Exception {
        Arguments arguments = new Arguments(environment);
        arguments.prettyPrint();

        if (arguments.isBuild()) {
            System.out.println();
            log.info("******************************************");
            log.info("Building Database, Tables and Load Data");
            log.info("******************************************");
            System.out.println();

            String[] dataFilter = new String[]{};

            String[] tableFilter = new String[]{};

            proof.build(arguments.getLocalDataPath(), arguments.getHdfsDataPath(), dataFilter, tableFilter, arguments.getDatabaseName());
        }


        if (arguments.isQuery()) {

            String[] includeFilter = new String[]{};

            String[] excludeFilter = new String[]{
                    "average_player_weight_by_birth_year.sql",
                    "player_count_by_school.sql"
            };

            System.out.println();
            log.info("******************************************");
            log.info("Executing queries");
            log.info("******************************************");
            System.out.println();

            List<QueryResult> results = proof.executeQueries(includeFilter, excludeFilter, arguments.getIterations(), arguments.isCount());

            System.out.println();
            log.info("******************************************");
            log.info("Test Finished!  Writing results to file...");
            log.info("******************************************");
            System.out.println();

            generateResultFile(arguments.getTestName(), results);
        }

        if (!arguments.isQuery() && !arguments.isBuild()) {
            log.warn("Whoops! You didn't build or query!");
        }

    }

    private void generateResultFile(String description, List<QueryResult> results) {

        String[] words = StringUtils.split(StringUtils.trim(description.toLowerCase()));

        SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy_HH-mm-ss_");

        final String filename = "out/query-results_" + sdf.format(new Date()) + StringUtils.join(words, "-") + ".csv";

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
