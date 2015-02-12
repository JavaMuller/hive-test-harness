package hive.harness.service;

import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.security.UserGroupInformation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;

import java.io.IOException;
import java.io.InputStream;
import java.security.PrivilegedExceptionAction;

@Service
public class HadoopService {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private FileSystem fs;

    @Autowired
    private Environment environment;


    public void createDirectory(final String directory) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs(new PrivilegedExceptionAction<String>() {

            public String run() throws Exception {

                Path path = new Path(directory);

                boolean exists = fs.exists(path);

                if (exists) {
                    log.debug("path [" + path.toString() + "] exists so it shall be deleted!");
                    deleteDirectory(path);
                }

                fs.mkdirs(path);
                fs.setPermission(path, new FsPermission(FsAction.ALL, FsAction.ALL, FsAction.ALL));

                return path.toString();
            }
        });
    }

    private void deleteDirectory(final Path path) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs(new PrivilegedExceptionAction<Boolean>() {

            public Boolean run() throws Exception {
                return fs.delete(path, true);
            }
        });
    }

    public void writeFile(final Resource resource) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs(new PrivilegedExceptionAction<Void>() {

            public Void run() throws Exception {

                Path path = new Path(environment.getProperty("hdfs.data.path") + "/" + resource.getFilename());

                StopWatch sw = new StopWatch("wrote file to path " + path);
                sw.start();

                FSDataOutputStream outputStream = fs.create(path, true);

                InputStream inputStream = resource.getInputStream();

                IOUtils.copyBytes(inputStream, outputStream, fs.getConf());

                sw.stop();

                log.debug(sw.shortSummary());

                return null;
            }
        });
    }
}
