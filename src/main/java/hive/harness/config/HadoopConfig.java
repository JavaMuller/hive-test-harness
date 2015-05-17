package hive.harness.config;

import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.hdfs.DistributedFileSystem;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hive.hcatalog.api.HCatClient;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

import javax.sql.DataSource;
import java.io.IOException;
import java.net.URI;
import java.security.PrivilegedExceptionAction;

@Configuration
public class HadoopConfig implements EnvironmentAware {

    private final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(getClass());

    private Environment environment;

    @Override
    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    @Bean
    public FileSystem buildFileSystem() throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        return ugi.doAs(new PrivilegedExceptionAction<FileSystem>() {
            public FileSystem run() throws Exception {
                return DistributedFileSystem.get(URI.create(environment.getProperty("hdfs.url")), buildConfiguration(), environment.getProperty("hdfs.username"));
            }
        });
    }

    private org.apache.hadoop.conf.Configuration buildConfiguration() {
        org.apache.hadoop.conf.Configuration configuration = new org.apache.hadoop.conf.Configuration();

        configuration.set("fs.defaultFS", environment.getProperty("hdfs.url"));

        return configuration;
    }

    @Bean
    public HiveConf buildHiveConf() {
        HiveConf hiveConf = new HiveConf(buildConfiguration(), HiveConf.class);
        hiveConf.setVar(HiveConf.ConfVars.METASTOREURIS, environment.getProperty("hive.metastore.url"));

        return hiveConf;
    }

    @Bean
    public DataSource buildDataSource() {
        String url = environment.getProperty("hive.jdbc.url");
        String database = environment.getProperty("hive.db.name");

        if (log.isDebugEnabled()) {
            log.debug("url: " + url);
            log.debug("db name: " + database);
        }

        return new HiveDataSource(url + "/" + database, environment.getProperty("hive.username"));
    }

}

