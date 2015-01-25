package org.hortonworks.poc.ey.config;

import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.hive.conf.HiveConf;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

import javax.sql.DataSource;
import java.io.IOException;
import java.net.URI;

@Configuration
public class HadoopConfig implements EnvironmentAware {


    private Environment environment;

    @Override
    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    @Bean
    public FileSystem buildFileSystem() throws IOException, InterruptedException {
        return FileSystem.get(URI.create(environment.getProperty("hdfs.url")), buildConfiguration(), environment.getProperty("hdfs.username"));
    }

    private org.apache.hadoop.conf.Configuration buildConfiguration() {
        return new org.apache.hadoop.conf.Configuration();
    }

    @Bean
    public HiveConf buildHiveConf() {
        HiveConf hiveConf = new HiveConf(buildConfiguration(), HiveConf.class);
        hiveConf.setVar(HiveConf.ConfVars.METASTOREURIS, environment.getProperty("hive.metastore.url"));

        return hiveConf;
    }

    @Bean
    public DataSource buildDataSource() {
        return new HiveDataSource(environment.getProperty("hive.jdbc.url"), environment.getProperty("hive.username"), null);
    }

}

