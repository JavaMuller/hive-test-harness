package org.hortonworks.poc.ey.service;

import org.apache.commons.io.IOUtils;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hive.hcatalog.api.HCatClient;
import org.apache.hive.hcatalog.api.HCatCreateDBDesc;
import org.apache.hive.hcatalog.common.HCatException;
import org.hortonworks.poc.ey.domain.QueryResult;
import org.hortonworks.poc.ey.domain.ScriptType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;
import org.springframework.util.StringUtils;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.LineNumberReader;
import java.security.PrivilegedExceptionAction;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    private String getSqlString(Resource resource) throws IOException {

        EncodedResource encodedResource = new EncodedResource(resource);

        try (LineNumberReader reader = new LineNumberReader(encodedResource.getReader())) {

            String script = ScriptUtils.readScript(reader, ScriptUtils.DEFAULT_COMMENT_PREFIX, ScriptUtils.DEFAULT_STATEMENT_SEPARATOR);

            List<String> statements = new ArrayList<>();

            ScriptUtils.splitSqlScript(script, ScriptUtils.DEFAULT_STATEMENT_SEPARATOR, statements);

            assert statements.size() == 1;

            return statements.get(0);
        }
    }

    public QueryResult executeSqlQuery(Resource resource) throws IOException {

        String query = getSqlString(resource);

        int resultSize = 0;

        String error = null;

        long queryTime = 0;
        long countTime = 0;

        try (
                Connection connection = dataSource.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {

            StopWatch queryTimer = new StopWatch();
            queryTimer.start();

            ResultSet resultSet = statement.executeQuery();

            queryTimer.stop();
            queryTime = queryTimer.getTotalTimeMillis();


            StopWatch countTimer = new StopWatch();
            countTimer.start();

            while (resultSet.next()) {
                resultSize++;
            }

            countTimer.stop();
            countTime = countTimer.getTotalTimeMillis();

        } catch (SQLException e) {
            error = e.getMessage();

            log.error(error, e);
        }

        final QueryResult queryResult = new QueryResult(resource.getFilename(), queryTime, countTime, error, resultSize);

        log.info(queryResult.toString());

        return queryResult;

    }


    public void executeSqlScript(Resource resource) {

        StopWatch sw = new StopWatch("executed sql script: " + resource.getFilename());
        sw.start();


        try (Connection connection = dataSource.getConnection()) {

            ScriptUtils.executeSqlScript(connection, resource);

        } catch (SQLException e) {
            log.error(e.getMessage(), e);
        }

        sw.stop();

        log.debug(sw.shortSummary());
    }


    public void createDatabase() throws IOException, InterruptedException {

        HCatClient client = null;

        final String databaseName = environment.getProperty("hive.db.name");

        try {
            client = getHCatClient();

            log.debug("dropping database: " + databaseName);

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
