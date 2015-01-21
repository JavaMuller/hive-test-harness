package org.hortonworks.poc.ey.service;

import org.apache.commons.io.IOUtils;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hive.hcatalog.api.HCatClient;
import org.apache.hive.hcatalog.api.HCatCreateDBDesc;
import org.apache.hive.hcatalog.common.HCatException;
import org.hortonworks.poc.ey.domain.ScriptType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;
import org.springframework.util.StringUtils;

import javax.sql.DataSource;
import java.io.IOException;
import java.security.PrivilegedExceptionAction;
import java.sql.Connection;
import java.sql.SQLException;

@Service
public class HiveService {


    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private Environment environment;

    @Autowired
    private HiveConf hiveConf;

    @Autowired
    private DataSource dataSource;


    public HCatClient getHCatClient() throws IOException, InterruptedException {
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hive.username"));

        return ugi.doAs(new PrivilegedExceptionAction<HCatClient>() {
            public HCatClient run() throws Exception {
                return HCatClient.create(hiveConf);
            }
        });
    }


    public void executeSqlScript(String location, ScriptType scriptType) {

        log.debug("attempting to load sql script from [" + location + "]");


        try (Connection connection = dataSource.getConnection()) {

            Resource originalResource = new FileSystemResource(location);

            StopWatch sw = new StopWatch("executed sql script: " + location);
            sw.start();

            ScriptUtils.executeSqlScript(connection, originalResource);

            sw.stop();

            log.debug(sw.shortSummary());

            if (scriptType.equals(ScriptType.table)) {

                Resource tmpResource = new FileSystemResource(location);

                String tempContents = IOUtils.toString(tmpResource.getInputStream());

                tempContents = StringUtils.replace(tempContents, "stored AS orc", "ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\054' stored AS textfile");
                String filename = StringUtils.replace(tmpResource.getFilename(), ".sql", "");
                tempContents = StringUtils.replace(tempContents, filename, filename + "_csv");

                ScriptUtils.executeSqlScript(connection, new ByteArrayResource(tempContents.getBytes()));


            }

        } catch (IOException | SQLException e) {
            log.error(e.getMessage(), e);
        }
    }


    public void createDatabase() throws IOException, InterruptedException {

        HCatClient client = null;

        final String databaseName = environment.getProperty("hive.db.name");

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
}
