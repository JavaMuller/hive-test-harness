package org.hortonworks.poc.ey;

import org.apache.commons.io.FileUtils;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hive.hcatalog.api.HCatClient;
import org.apache.hive.hcatalog.api.HCatCreateDBDesc;
import org.apache.hive.hcatalog.common.HCatException;
import org.apache.hive.jdbc.HiveDriver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.util.StopWatch;

import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.security.PrivilegedExceptionAction;
import java.sql.Connection;
import java.util.Collection;

@Configuration
@ComponentScan
@EnableAutoConfiguration
public class Application {

    private static final Logger log = LoggerFactory.getLogger(Application.class);

    public static final String HIVE_USERNAME = "hive";
    public static final String HIVE_URL = "jdbc:hive2://c6401.ambari.apache.org:10000";
    public static final String HIVE_METASTORE_URL = "thrift://c6401.ambari.apache.org:9083";

    public static void main(String[] args) throws IOException, InterruptedException {

        SpringApplication.run(Application.class, args);

        String databaseName = createDatabase();

        DataSource dataSource = getDataSource(databaseName);

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

        try (Connection connection = jdbcTemplate.getDataSource().getConnection()) {

            String[] extensions = {"sql"};

            Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/tables"), extensions, false);

            int count =0;

            StopWatch sw = new StopWatch();
            sw.start();

            for (File file : files) {
                executeSqlScript(file.getPath(), connection);
                count++;
            }

            sw.stop();

            log.info("CREATED " + count + " TABLES ON DATABASE [" + databaseName + "] IN " + sw.getTotalTimeMillis() + "ms");

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }

    }

    public static String createDatabase() throws IOException, InterruptedException {


        HCatClient client = null;

        try {
            client = getHCatClient();

            final String databaseName = "HIVE_POC";

            client.dropDatabase(databaseName, true, HCatClient.DropDBMode.CASCADE);

            HCatCreateDBDesc dbDesc = HCatCreateDBDesc.create(databaseName)
                    .ifNotExists(true)
                    .build();

            log.debug("creating database: " + dbDesc);

            client.createDatabase(dbDesc);

            return databaseName;


        } finally {

            if (client != null) {
                try {
                    client.close();
                } catch (HCatException ignore) {

                }
            }
        }

    }

    private static HCatClient getHCatClient() throws IOException, InterruptedException {
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(HIVE_USERNAME);

        return ugi.doAs(new PrivilegedExceptionAction<HCatClient>() {
            public HCatClient run() throws Exception {

                org.apache.hadoop.conf.Configuration conf = new org.apache.hadoop.conf.Configuration();

                HiveConf hiveConf = new HiveConf(conf, HiveConf.class);
                hiveConf.setVar(HiveConf.ConfVars.METASTOREURIS, HIVE_METASTORE_URL);


                return HCatClient.create(hiveConf);
            }
        });
    }

    private static SimpleDriverDataSource getDataSource(String databaseName) {
        final String hiveUrl = HIVE_URL + "/" + databaseName;

        return new SimpleDriverDataSource(new HiveDriver(), hiveUrl, HIVE_USERNAME, null);
    }

    private static void executeSqlScript(String location, Connection connection) {
        try {

            log.debug("attempting to load file from [" + location + "]");

            Resource resource = new FileSystemResource(location);

            ScriptUtils.executeSqlScript(connection, resource);

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }

}
