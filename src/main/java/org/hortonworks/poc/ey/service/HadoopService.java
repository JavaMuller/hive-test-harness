package org.hortonworks.poc.ey.service;

import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.fs.permission.FsPermission;
import org.apache.hadoop.security.UserGroupInformation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
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


    public String createDirectory(final String directory) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        return ugi.doAs(new PrivilegedExceptionAction<String>() {

            public String run() throws Exception {

                Path path = new Path(directory);

                boolean exists = fs.exists(path);

                if (exists) {
                    log.debug("path [" + path.toString() + "] exists so it shall be deleted!");
                    deleteDirectory(environment.getProperty("data.root"));
                }

                fs.mkdirs(path);
                fs.setPermission(path, new FsPermission(FsAction.ALL, FsAction.ALL, FsAction.ALL));

                return path.toString();
            }
        });

    }

    public boolean deleteDirectory(final String directory) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        return ugi.doAs(new PrivilegedExceptionAction<Boolean>() {

            public Boolean run() throws Exception {
                Path path = new Path(directory);

                return fs.delete(path, true);
            }
        });


    }

    public void writeFile(final File file) throws IOException, InterruptedException {

        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hdfs.username"));

        ugi.doAs(new PrivilegedExceptionAction<Void>() {

            public Void run() throws Exception {

                byte[] chunk = new byte[1024];

                Path path = new Path(environment.getProperty("data.path") + "/" + file.getName());

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
