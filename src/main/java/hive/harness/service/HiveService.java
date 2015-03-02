package hive.harness.service;

import com.codahale.metrics.Histogram;
import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.Snapshot;
import hive.harness.domain.QueryResult;
import org.apache.commons.lang.StringUtils;
import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.security.UserGroupInformation;
import org.apache.hive.hcatalog.api.HCatClient;
import org.apache.hive.hcatalog.api.HCatCreateDBDesc;
import org.apache.hive.hcatalog.common.HCatException;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

@Service
public class HiveService {

    private final Logger log = LoggerFactory.getLogger(getClass());

    public static final String PATH_TOKEN = "@@HDFS_PATH@@";

    @Autowired
    private Environment environment;

    @Autowired
    private HiveConf hiveConf;

    @Autowired
    private DataSource dataSource;

    @Autowired
    private MetricRegistry metricRegistry;


    public HCatClient getHCatClient() throws IOException, InterruptedException {
        UserGroupInformation ugi = UserGroupInformation.createRemoteUser(environment.getProperty("hive.username"));

        return ugi.doAs(new PrivilegedExceptionAction<HCatClient>() {
            public HCatClient run() throws Exception {
                return HCatClient.create(hiveConf);
            }
        });
    }


    public QueryResult executeSqlQuery(Resource resource, int iterations, boolean countResults) throws IOException {

        final String query = getSqlString(resource);

        final NumberFormat numberInstance = NumberFormat.getNumberInstance();
        numberInstance.setMaximumFractionDigits(2);


        try (
                Connection connection = dataSource.getConnection();
                PreparedStatement statement = connection.prepareStatement(query)
        ) {

            final String filename = resource.getFilename();

            if (log.isDebugEnabled()) {
                log.debug("executing: " + filename);
            }

            final Histogram histogram = metricRegistry.histogram(filename);

            for (int i = 0; i < iterations; i++) {

                StopWatch queryTimer = new StopWatch();
                queryTimer.start();

                ResultSet resultSet = statement.executeQuery();

                queryTimer.stop();

                final long totalTimeMillis = queryTimer.getTotalTimeMillis();

                histogram.update(totalTimeMillis);

                if (log.isDebugEnabled()) {
                    log.debug("executing " + (i + 1) + " of " + iterations + " in " + numberInstance.format(totalTimeMillis) + " ms, " + numberInstance.format(totalTimeMillis / 1000) + " s");
                }

                resultSet.close();
            }

            final Snapshot snapshot = histogram.getSnapshot();

            long count = 0;

            long countDuration = 0;

            if (countResults) {
                ResultSet resultSet = statement.executeQuery();

                StopWatch sw = new StopWatch();
                sw.start();
                while (resultSet.next()) {
                    count++;
                }
                sw.stop();

                countDuration = sw.getTotalTimeMillis();

                resultSet.close();
            }

            final QueryResult queryResult = new QueryResult(filename, snapshot.getMin(), snapshot.getMax(), snapshot.getMean(), snapshot.getMedian(), snapshot.getStdDev(), snapshot.size(), count, countDuration);

            if (log.isDebugEnabled()) {
                log.debug(queryResult.toString());
            }

            return queryResult;

        } catch (Exception e) {
            log.error("message [" + e.getMessage() + "],  resource [" + resource.getFilename() + "]", e);
        }

        return null;

    }


    public void executeSqlScript(Resource resource, String hdfsDataPath) throws IOException {

        final List<String> statements = getSqlStrings(resource);

        try (
                Connection connection = dataSource.getConnection()
        ) {

            for (String query : statements) {
                Statement statement = connection.createStatement();


                if (StringUtils.contains(query, PATH_TOKEN)) {

                    if (log.isDebugEnabled()) {
                        log.debug("replacing " + PATH_TOKEN + " with [" + hdfsDataPath + "]");
                    }

                    query = StringUtils.replace(query, PATH_TOKEN, hdfsDataPath);
                }

                StopWatch sw = new StopWatch(query);
                sw.start();

                statement.execute(query);

                sw.stop();

                if (log.isDebugEnabled()) {
                    log.debug(sw.shortSummary());
                }

            }

        } catch (Exception e) {
            log.error("message [" + e.getMessage() + "],  resource [" + resource.getFilename() + "]", e);
        }
    }


    public void createDatabase(String databaseName) throws IOException, InterruptedException {

        HCatClient client = null;

        try {
            client = getHCatClient();

            if (log.isDebugEnabled()) {
                log.debug("dropping database: " + databaseName);
            }

            client.dropDatabase(databaseName, true, HCatClient.DropDBMode.CASCADE);

            HCatCreateDBDesc dbDesc = HCatCreateDBDesc.create(databaseName)
                    .ifNotExists(true)
                    .build();

            if (log.isDebugEnabled()) {
                log.debug("creating database: " + dbDesc);
            }

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


    private String getSqlString(Resource resource) throws IOException {

        List<String> statements = getSqlStrings(resource);

        assert statements.size() == 1;

        return statements.get(0);
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
}
