package org.hortonworks.poc.ey.service;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.lang.StringUtils;
import org.hortonworks.poc.ey.domain.QueryResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
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

    @Override
    public void run(String... args) throws Exception {

        assert args != null && args.length == 5;

        final boolean build = Boolean.parseBoolean(args[0]);
        final boolean query = Boolean.parseBoolean(args[1]);
        final String description = args[2];
        final String dataPath = args[3];
        final int iterations = Integer.parseInt(args[4]);

        System.out.println();
        log.info("******************************************");
        log.info("Running Test with the following parameters...");
        log.info("\tBuild? " + build);
        log.info("\tQuery? " + query);
        log.info("\tDescription: " + description);
        log.info("\tData Path: " + dataPath);
        log.info("\tIterations: " + iterations);
        log.info("******************************************");
        System.out.println();


        if (build) {
            System.out.println();
            log.info("******************************************");
            log.info("Building Database, Tables and Views");
            log.info("******************************************");
            System.out.println();

            String[] dataFilter = new String[]{};

            String[] tableFilter = new String[]{};

            String[] viewFilter = new String[]{};

            proof.build(dataPath, dataFilter, tableFilter, viewFilter);
        }


        if (query) {

            String[] includeFilter = new String[]{};

            String[] excludeFilter = new String[]{
                    "vw_gl016t2_zero_balance_gl.sql",
                    "vw_gl015t1_cutoff_analysis.sql",
                    "vw_gl012t3_date_analysis.sql",
                    "vw_gl018t1_overview.sql",
                    "vw_gl017t3_transactions_by_relationship.sql",
                    "vw_gl013t1_back_postings1.sql",
                    "vw_gl011_relationship_analyses.sql",
                    "vw_gl010_gross_margin.sql",
                    "v_il_gl018_kpi_overview.sql"
            };

            System.out.println();
            log.info("******************************************");
            log.info("Executing queries");
            log.info("******************************************");
            System.out.println();

            List<QueryResult> results = proof.executeQueries(includeFilter, excludeFilter, iterations, false);

            System.out.println();
            log.info("******************************************");
            log.info("Test Finished!  Writing results to file...");
            log.info("******************************************");
            System.out.println();

            generateResultFile(description, results);
        }

    }

    private void generateResultFile(String description, List<QueryResult> results) {

        String[] words = StringUtils.split(StringUtils.trim(description.toLowerCase()));

        SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy_HH-mm-ss_");

        final String filename = "query-results_" + sdf.format(new Date()) + StringUtils.join(words, "-") + ".csv";

        CSVFormat format = CSVFormat.DEFAULT.withHeader("file", "min", "max", "mean", "median", "standard deviation", "iterations");

        try (FileWriter fileWriter = new FileWriter(filename);
             CSVPrinter printer = new CSVPrinter(fileWriter, format)) {

            for (QueryResult result : results) {
                printer.printRecord(result.getFile(), result.getMin(), result.getMax(), result.getMean(), result.getMedian(), result.getStandardDeviation(), result.getIterations());
            }

            fileWriter.flush();

        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }
    }
}
