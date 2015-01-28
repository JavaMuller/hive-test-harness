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

        assert args != null && args.length == 4;

        final boolean build = Boolean.parseBoolean(args[0]);
        final boolean query = Boolean.parseBoolean(args[1]);
        final String description = args[2];
        final String dataPath = args[3];

        System.out.println();
        log.info("******************************************");
        log.info("Running Test with the following parameters...");
        log.info("\tBuild? " + build);
        log.info("\tQuery? " + query);
        log.info("\tDescription: " + description);
        log.info("\tData Path: " + dataPath);
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
                    "VW_GL016T2_Zero_Balance_GL.sql",
                    "VW_GL015T1_Cutoff_Analysis.sql",
                    "VW_GL012T3_Date_Analysis.sql",
                    "VW_GL018T1_Overview.sql",
                    "VW_GL017T3_Transactions_By_Relationship.sql",
                    "VW_GL013T1_Back_Postings1.sql",
                    "VW_GL011_Relationship_Analyses.sql",
                    "VW_GL010_Gross_Margin.sql",
                    "v_IL_GL018_KPI_Overview.sql"
            };

            System.out.println();
            log.info("******************************************");
            log.info("Executing queries");
            log.info("******************************************");
            System.out.println();

            List<QueryResult> results = proof.executeQueries(includeFilter, excludeFilter, 1);

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

        CSVFormat format = CSVFormat.DEFAULT.withHeader("file", "queryDuration", "countDuration", "resultCount", "error");

        try (FileWriter fileWriter = new FileWriter(filename);
             CSVPrinter printer = new CSVPrinter(fileWriter, format)) {

            for (QueryResult result : results) {
                printer.printRecord(result.getFile(), result.getQueryDuration(), result.getCountDuration(), result.getResultCount(), result.getError());
            }

            fileWriter.flush();

        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }
    }
}
