package hive.harness.config;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.UserGroupInformation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;
import org.springframework.data.hadoop.config.annotation.EnableHadoop;
import org.springframework.data.hadoop.config.annotation.SpringHadoopConfigurerAdapter;
import org.springframework.data.hadoop.fs.FsShell;

import java.io.IOException;
import java.security.PrivilegedExceptionAction;

@org.springframework.context.annotation.Configuration
@EnableHadoop
public class HadoopConfig extends SpringHadoopConfigurerAdapter {

    @Autowired
    private Environment environment;

    @Bean
    public FsShell buildMyFsShellShell() throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        return ugi.doAs(new PrivilegedExceptionAction<FsShell>() {

            public FsShell run() throws Exception {
                Configuration configuration = new Configuration();
                configuration.set("fs.defaultFS", environment.getProperty("hdfs.url"));
                return new FsShell(configuration);
            }

        });

    }

}
