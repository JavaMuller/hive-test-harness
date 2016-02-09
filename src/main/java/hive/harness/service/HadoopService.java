package hive.harness.service;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.security.UserGroupInformation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.data.hadoop.fs.FsShell;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;

import java.io.IOException;
import java.security.PrivilegedExceptionAction;

@Service
public class HadoopService {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private Environment environment;

    @Autowired
    private FsShell shell;

    @Autowired
    private Configuration configuration;


    public void createDirectory(final String directory) throws IOException, InterruptedException {

        UserGroupInformation.setConfiguration(configuration);
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs((PrivilegedExceptionAction<String>) () -> {

            boolean exists = shell.test(directory);

            if (exists) {
                if (log.isDebugEnabled()) {
                    log.debug("path [" + directory + "] exists so it shall be deleted!");
                }

                deleteDirectory(directory);
            }

            shell.mkdir(directory);
            shell.chmodr(777, directory);

            return directory;
        });
    }

    private void deleteDirectory(final String directory) throws IOException, InterruptedException {

        UserGroupInformation.setConfiguration(configuration);
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs((PrivilegedExceptionAction<Void>) () -> {
            shell.rm(true, directory);

            return null;
        });
    }

    public void writeFile(final Resource resource, final String hdfsDataPath) throws IOException, InterruptedException {

        UserGroupInformation.setConfiguration(configuration);
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs((PrivilegedExceptionAction<Void>) () -> {

            String hdfsPath = hdfsDataPath + "/" + resource.getFilename();

            StopWatch sw = new StopWatch("wrote file to path " + hdfsPath);
            sw.start();

            shell.put(resource.getFile().getAbsolutePath(), hdfsPath);

            sw.stop();

            if (log.isDebugEnabled()) {
                log.debug(sw.shortSummary());
            }

            return null;
        });
    }
}
