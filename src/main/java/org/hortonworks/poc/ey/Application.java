package org.hortonworks.poc.ey;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.fs.permission.FsPermission;
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
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.util.StopWatch;
import org.springframework.util.StringUtils;

import javax.sql.DataSource;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.security.PrivilegedExceptionAction;
import java.sql.Connection;
import java.util.Collection;

@Configuration
@ComponentScan
@EnableAutoConfiguration
public class Application {

    private static final Logger log = LoggerFactory.getLogger(Application.class);

    private static final String HIVE_DATABASE_NAME = "HIVE_POC";

    private static final String HIVE_USERNAME = "hive";
    private static final String HIVE_URL = "jdbc:hive2://c6401.ambari.apache.org:10000";
    private static final String HIVE_METASTORE_URL = "thrift://c6401.ambari.apache.org:9083";

    private static final String HDFS_USERNAME = "hdfs";
    private static final String HDFS_URL = "hdfs://c6401.ambari.apache.org:8020";
    private static final String DATA_PATH = "/poc/data/ey";
    private static final String DATA_PATH_ROOT = "/poc";

    private static enum ScriptType {table, view, query}

    public static void main(String[] args) throws IOException, InterruptedException {

        boolean buildAndLoad = args == null || args.length == 0;

        SpringApplication.run(Application.class, args);

        if (buildAndLoad) {
            createDatabase(HIVE_DATABASE_NAME);
        }

        DataSource dataSource = getDataSource(HIVE_DATABASE_NAME);

        JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);

        try (Connection connection = jdbcTemplate.getDataSource().getConnection()) {

            if (buildAndLoad) {
                buildTables(HIVE_DATABASE_NAME, connection);
                buildViews(HIVE_DATABASE_NAME, connection);
                loadData(HIVE_DATABASE_NAME, jdbcTemplate);
            }

            executeQueries(HIVE_DATABASE_NAME, connection, true);

            //executeQueries(databaseName, connection, false);

        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }

    private static FileSystem buildFileSystem() throws IOException, InterruptedException {
        org.apache.hadoop.conf.Configuration conf = new org.apache.hadoop.conf.Configuration();
        conf.set("fs.hdfs.impl", "org.apache.hadoop.hdfs.DistributedFileSystem");
        conf.set("fs.webhdfs.impl", "org.apache.hadoop.hdfs.web.WebHdfsFileSystem");
        conf.set("fs.file.impl", "org.apache.hadoop.fs.LocalFileSystem");

        return FileSystem.get(URI.create(HDFS_URL), conf, HDFS_USERNAME);
    }

    private static void loadData(String databaseName, JdbcTemplate jdbcTemplate) throws IOException, InterruptedException {

        FileSystem fs = buildFileSystem();
        createDirectory(DATA_PATH, fs);

        String[] extensions = {"csv"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/data/converted"), extensions, false);

        int count = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {

            writeFile(file, fs);

            String tableName = StringUtils.replace(file.getName(), ".csv", "");
            String tableNameCsv = tableName + "_csv";

            String loadFile = "load data inpath '" + DATA_PATH + "/" + file.getName() + "' into table " + tableNameCsv;
            log.debug("running: " + loadFile);
            jdbcTemplate.execute(loadFile);

            String loadOrc = "insert overwrite table " + tableName + " select * from " + tableNameCsv;
            log.debug("running: " + loadOrc);
            jdbcTemplate.execute(loadOrc);

            count++;
        }

        sw.stop();

        log.info("LOADED " + count + " FILES INTO DATABASE [" + databaseName + "] IN " + sw.getTotalTimeMillis() + "ms");

    }


    private static void executeQueries(String databaseName, Connection connection, boolean warmup) {
        String[] extensions = {"sql"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/queries"), extensions, false);

        int count = 0;

        int countFails = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {

            try {

                executeSqlScript(file.getPath(), connection, ScriptType.query);
                count++;
            } catch (Exception e) {
                log.error(e.getMessage(), e);
                countFails++;
            }

        }

        sw.stop();

        log.info("EXECUTED " + count + " QUERIES AGAINST DATABASE [" + databaseName + "] IN " + sw.getTotalTimeMillis() + "ms; " + countFails + " failed!");
    }

    private static void buildTables(String databaseName, Connection connection) {
        String[] extensions = {"sql"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/tables"), extensions, false);

        int count = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {
            executeSqlScript(file.getPath(), connection, ScriptType.table);
            count++;
        }

        sw.stop();

        log.info("CREATED " + count + " TABLES ON DATABASE [" + databaseName + "] IN " + sw.getTotalTimeMillis() + "ms");
    }

    private static void buildViews(String databaseName, Connection connection) {
        String[] extensions = {"sql"};

        Collection<File> files = FileUtils.listFiles(new File("src/main/resources/sql/converted/views"), extensions, false);

        int count = 0;

        StopWatch sw = new StopWatch();
        sw.start();

        for (File file : files) {
            executeSqlScript(file.getPath(), connection, ScriptType.view);
            count++;
        }

        sw.stop();

        log.info("CREATED " + count + " VIEWS ON DATABASE [" + databaseName + "] IN " + sw.getTotalTimeMillis() + "ms");
    }

    public static void createDatabase(String databaseName) throws IOException, InterruptedException {


        HCatClient client = null;

        try {
            client = getHCatClient();


            client.dropDatabase(databaseName, true, HCatClient.DropDBMode.CASCADE);

            HCatCreateDBDesc dbDesc = HCatCreateDBDesc.create(databaseName)
                    .ifNotExists(true)
                    .build();

            log.debug("creating database: " + dbDesc);

            client.createDatabase(dbDesc);


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

    private static void executeSqlScript(String location, Connection connection, ScriptType scriptType) {

        log.debug("attempting to load file from [" + location + "]");

        Resource originalResource = new FileSystemResource(location);

        ScriptUtils.executeSqlScript(connection, originalResource);

        if (scriptType.equals(ScriptType.table)) {

            Resource tmpResource = new FileSystemResource(location);

            try {
                String tempContents = IOUtils.toString(tmpResource.getInputStream());

                tempContents = StringUtils.replace(tempContents, "stored AS orc", "ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\054' stored AS textfile");
                String filename = StringUtils.replace(tmpResource.getFilename(), ".sql", "");
                tempContents = StringUtils.replace(tempContents, filename, filename + "_csv");

                ScriptUtils.executeSqlScript(connection, new ByteArrayResource(tempContents.getBytes()));

            } catch (IOException e) {
                log.error(e.getMessage(), e);
            }
        }
    }


    public static String createDirectory(final String directory, final FileSystem fs) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(HDFS_USERNAME);


        return ugi.doAs(new PrivilegedExceptionAction<String>() {

            public String run() throws Exception {

                Path path = new Path(directory);

                boolean exists = fs.exists(path);

                if (exists) {
                    log.debug("path [" + path.toString() + "] exists so it shall be deleted!");
                    deleteDirectory(DATA_PATH_ROOT, fs);
                }

                fs.mkdirs(path);
                fs.setPermission(path, new FsPermission(FsAction.ALL, FsAction.ALL, FsAction.ALL));

                return path.toString();
            }
        });

    }

    public static boolean deleteDirectory(final String directory, final FileSystem fs) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(HDFS_USERNAME);


        return ugi.doAs(new PrivilegedExceptionAction<Boolean>() {

            public Boolean run() throws Exception {
                Path path = new Path(directory);

                return fs.delete(path, true);
            }
        });


    }

    public static void writeFile(final File file, final FileSystem fs) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(HDFS_USERNAME);


        ugi.doAs(new PrivilegedExceptionAction<Void>() {

            public Void run() throws Exception {

                byte[] chunk = new byte[1024];

                Path path = new Path(DATA_PATH + "/" + file.getName());

                log.debug("writing file to path [" + path.toString() + "]");

                FSDataOutputStream outputStream = fs.create(path, true);

                InputStream inputStream = new FileInputStream(file);

                while (inputStream.read(chunk) != -1) {
                    outputStream.write(chunk);
                }

                outputStream.close();

                log.debug("file written successfully!");

                return null;
            }
        });


    }

}
