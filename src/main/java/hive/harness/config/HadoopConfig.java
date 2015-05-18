package hive.harness.config;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.UserGroupInformation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.data.hadoop.config.annotation.EnableHadoop;
import org.springframework.data.hadoop.config.annotation.SpringHadoopConfigurerAdapter;
import org.springframework.data.hadoop.config.annotation.builders.HadoopConfigConfigurer;
import org.springframework.data.hadoop.fs.FsShell;

import java.io.IOException;
import java.security.PrivilegedExceptionAction;

@org.springframework.context.annotation.Configuration
@EnableHadoop
public class HadoopConfig extends SpringHadoopConfigurerAdapter {

    @Autowired
    private Environment environment;

    @Autowired
    private Configuration configuration;


    @Override
    public void configure(HadoopConfigConfigurer config) throws Exception {
        config.fileSystemUri(environment.getProperty("hdfs.url"));
        config.withProperties()
                .property("hadoop.user.group.static.mapping.overrides", "vagrant=users,hadoop,hdfs;dr.who=;")
                .property("fs.hdfs.impl.disable.cache", "true")
                .property("fs.file.impl.disable.cache", "true");
    }


    @Bean(destroyMethod = "close")
    public FsShell buildShell() throws IOException, InterruptedException {

        UserGroupInformation.setConfiguration(configuration);
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        return ugi.doAs(new PrivilegedExceptionAction<FsShell>() {
            public FsShell run() throws Exception {
                return new FsShell(configuration);
            }
        });

    }
}
