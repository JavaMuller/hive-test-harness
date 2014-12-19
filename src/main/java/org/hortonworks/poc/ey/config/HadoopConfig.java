package org.hortonworks.poc.ey.config;

import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hive.jdbc.HiveDriver;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

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
        org.apache.hadoop.conf.Configuration conf = new org.apache.hadoop.conf.Configuration();
        conf.set("fs.hdfs.impl", "org.apache.hadoop.hdfs.DistributedFileSystem");
        conf.set("fs.webhdfs.impl", "org.apache.hadoop.hdfs.web.WebHdfsFileSystem");
        conf.set("fs.file.impl", "org.apache.hadoop.fs.LocalFileSystem");

        return FileSystem.get(URI.create(environment.getProperty("hdfs.url")), conf, environment.getProperty("hdfs.username"));
    }

    @Bean
    public HiveConf buildHiveConf() {
        org.apache.hadoop.conf.Configuration conf = new org.apache.hadoop.conf.Configuration();

        HiveConf hiveConf = new HiveConf(conf, HiveConf.class);
        hiveConf.setVar(HiveConf.ConfVars.METASTOREURIS, environment.getProperty("hive.metastore.url"));

        return hiveConf;
    }

    @Bean
    public DataSource buildDataSource() {

        DriverManagerDataSource driverManagerDataSource = new DriverManagerDataSource(environment.getProperty("hive.jdbc.url"), environment.getProperty("hive.username"), null);
        driverManagerDataSource.setDriverClassName(HiveDriver.class.getName());

        return driverManagerDataSource;
    }


}

