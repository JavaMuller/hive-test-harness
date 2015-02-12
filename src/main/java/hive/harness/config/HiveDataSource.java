package hive.harness.config;


import org.springframework.util.StopWatch;

import javax.sql.DataSource;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.logging.Logger;

public class HiveDataSource implements DataSource {

    private final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(getClass());

    private final String username;
    private final String password;
    private final String url;

    public HiveDataSource(String url, String username, String password) {
        this.username = username;
        this.password = password;
        this.url = url;
    }

    @Override
    public Connection getConnection() throws SQLException {
        return getConnection(this.username, this.password);
    }

    @Override
    public Connection getConnection(String username, String password) throws SQLException {

        StopWatch sw = new StopWatch("opened connection to " + url);
        sw.start();

        try {
            Class.forName("org.apache.hive.jdbc.HiveDriver");
        } catch (ClassNotFoundException e) {
            log.error(e.getMessage(), e);
        }

        final Connection connection = DriverManager.getConnection(url, username, password);

        sw.stop();

        if (log.isTraceEnabled()) {
            log.trace(sw.shortSummary());
        }

        return connection;
    }

    @Override
    public PrintWriter getLogWriter() throws SQLException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }

    @Override
    public void setLogWriter(PrintWriter out) throws SQLException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }

    @Override
    public void setLoginTimeout(int seconds) throws SQLException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }

    @Override
    public int getLoginTimeout() throws SQLException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }

    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }

    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }

    @Override
    public boolean isWrapperFor(Class<?> iface) throws SQLException {
        throw new SQLFeatureNotSupportedException("Method not supported");
    }
}
