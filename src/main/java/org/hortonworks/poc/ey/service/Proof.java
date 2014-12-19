package org.hortonworks.poc.ey.service;

import org.apache.commons.io.FileUtils;
import org.hortonworks.poc.ey.domain.ScriptType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;
import org.springframework.util.StringUtils;

import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Collection;

@Service
public class Proof {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private Environment environment;

    @Autowired
    private HiveService hiveService;

    @Autowired
    private HadoopService hadoopService;

    @Autowired
    private DataSource dataSource;

    public void createDatabase() throws IOException, InterruptedException {
        hiveService.createDatabase();
    }


    public void loadData() throws IOException, InterruptedException {

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

        final String dataPath = environment.getProperty("data.path");

        hadoopService.createDirectory(dataPath);

        String[] extensions = {"csv"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/data/converted"), extensions, false);

        int count = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {

            hadoopService.writeFile(file);

            String tableName = StringUtils.replace(file.getName(), ".csv", "");
            String tableNameCsv = tableName + "_csv";

            String loadFile = "load data inpath '" + dataPath + "/" + file.getName() + "' into table " + tableNameCsv;
            log.debug("running: " + loadFile);
            jdbcTemplate.execute(loadFile);

            String loadOrc = "insert overwrite table " + tableName + " select * from " + tableNameCsv;
            log.debug("running: " + loadOrc);
            jdbcTemplate.execute(loadOrc);

            count++;
        }

        sw.stop();

        log.info("LOADED " + count + " FILES INTO DATABASE IN " + sw.getTotalTimeMillis() + "ms");

    }


    public void executeQueries(String[] filter, boolean warmup) {
        String[] extensions = {"sql"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/queries"), extensions, false);

        boolean filtered = filter != null && filter.length > 0;

        int count = 0;
        int countFails = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {

            if (filtered && !Arrays.asList(filter).contains(file.getName())) {
                continue;
            }

            try {

                hiveService.executeSqlScript(file.getPath(), ScriptType.query);
                count++;
            } catch (Exception e) {
                log.error(e.getMessage(), e);
                countFails++;
            }

        }

        sw.stop();

        log.info("EXECUTED " + count + " QUERIES AGAINST DATABASE IN " + sw.getTotalTimeMillis() + "ms; " + countFails + " failed!");
    }

    public void buildTables() {
        String[] extensions = {"sql"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/tables"), extensions, false);

        int count = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {
            hiveService.executeSqlScript(file.getPath(), ScriptType.table);
            count++;
        }

        sw.stop();

        log.info("CREATED " + count + " TABLES ON DATABASE IN " + sw.getTotalTimeMillis() + "ms");
    }

    public void buildViews() {
        String[] extensions = {"sql"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/views"), extensions, false);

        int count = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {
            hiveService.executeSqlScript(file.getPath(), ScriptType.view);
            count++;
        }

        sw.stop();

        log.info("CREATED " + count + " VIEWS ON DATABASE IN " + sw.getTotalTimeMillis() + "ms");
    }
}
