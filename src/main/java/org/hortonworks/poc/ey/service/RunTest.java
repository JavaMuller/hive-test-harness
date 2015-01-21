package org.hortonworks.poc.ey.service;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.commons.lang.StringUtils;
import org.hortonworks.poc.ey.domain.QueryResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.format.annotation.DateTimeFormat;
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

        assert args != null && args.length == 2;

        final boolean build = Boolean.parseBoolean(args[0]);
        final String description = args[1];


        if (build) {
            proof.createDatabase();
        }

        if (build) {
            proof.buildTables();
            proof.buildViews();
            proof.loadData();
        }

        String[] filter = null;

        //filter = new String[]{"v_IL_GL016_Missing_info.sql"};

        List<QueryResult> results = proof.executeQueries(filter);

        generateResultFile(description, results);

    }

    private void generateResultFile(String description, List<QueryResult> results) {

        String[] words = StringUtils.split(StringUtils.trim(description.toLowerCase()));

        final String filename = "query-results-" + StringUtils.join(words, "-") + ".csv";

        FileWriter fileWriter = null;
        CSVPrinter printer = null;

        try {
            final CSVFormat format = CSVFormat.DEFAULT.withHeader("file", "executionTime", "error");

            fileWriter = new FileWriter(filename);
            printer = new CSVPrinter(fileWriter, format);


            for (QueryResult result : results) {
                printer.printRecord(result.getFile(), result.getExecutionTime(), result.getError());
            }

            printer.printComment("comment: " + description);
            printer.printComment("executed on " + SimpleDateFormat.getDateTimeInstance().format(new Date()));

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                fileWriter.flush();
                fileWriter.close();
                printer.close();
            } catch (IOException ignore) {
            }
        }
    }
}
