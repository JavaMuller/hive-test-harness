package org.hortonworks.poc.ey.service;

import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hive.hcatalog.api.HCatClient;
import org.apache.hive.hcatalog.api.HCatCreateDBDesc;
import org.apache.hive.hcatalog.common.HCatException;
import org.hortonworks.poc.ey.domain.QueryResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.LineNumberReader;
import java.security.PrivilegedExceptionAction;
import java.sql.*;
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


    private List<String> getSqlStrings(Resource resource) throws IOException {

        EncodedResource encodedResource = new EncodedResource(resource);

        try (LineNumberReader reader = new LineNumberReader(encodedResource.getReader())) {

            String script = ScriptUtils.readScript(reader, ScriptUtils.DEFAULT_COMMENT_PREFIX, ScriptUtils.DEFAULT_STATEMENT_SEPARATOR);

            List<String> statements = new ArrayList<>();

            ScriptUtils.splitSqlScript(script, ScriptUtils.DEFAULT_STATEMENT_SEPARATOR, statements);


            return statements;
        }
    }

    public QueryResult executeSqlQuery(Resource resource, int iterations, boolean countResults) throws IOException {

        String query = getSqlString(resource);


        try (
                Connection connection = dataSource.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {

            final String filename = resource.getFilename();

            log.debug("executing: " + filename);

            for (int i = 0; i < iterations; i++) {

                StopWatch queryTimer = new StopWatch();
                queryTimer.start();

                ResultSet resultSet = statement.executeQuery();

                queryTimer.stop();

                final long totalTimeMillis = queryTimer.getTotalTimeMillis();

                log.debug("warm up " + (i + 1) + " of " + iterations + " in " + totalTimeMillis + "ms");


                if (i == iterations - 1) {

                    long resultSize = 0;
                    long countTime = 0;

                    if (countResults) {

                        log.debug("counting results and capturing timings");

                        StopWatch countTimer = new StopWatch();
                        countTimer.start();

                        while (resultSet.next()) {
                            resultSize++;
                        }

                        countTimer.stop();

                        countTime = countTimer.getTotalTimeMillis();
                    }

                    final QueryResult queryResult = new QueryResult(filename, totalTimeMillis, countTime, null, resultSize);

                    log.info(queryResult.toString());

                    resultSet.close();

                    return queryResult;
                }

                resultSet.close();
            }
        } catch (SQLException e) {
            log.error(e.getMessage(), e);
        }

        return null;

    }


    public void executeSqlScript(Resource resource) throws IOException {

        List<String> statements = getSqlStrings(resource);


        try (
                Connection connection = dataSource.getConnection()
        ) {

            for (String query : statements) {
                Statement statement = connection.createStatement();

                StopWatch sw = new StopWatch(query);
                sw.start();

                statement.execute(query);

                sw.stop();

                log.debug(sw.shortSummary());

            }

        } catch (SQLException e) {
            log.error(e.getMessage(), e);
        }
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
