package hive.harness.config;

import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;

import javax.sql.DataSource;

@org.springframework.context.annotation.Configuration
public class HiveConfig implements EnvironmentAware {

    private final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(getClass());

    private Environment environment;

    @Override
    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    @Bean
    public DataSource buildDataSource() {
        String url = environment.getProperty("hive.jdbc.url");
        String database = environment.getProperty("hive.db.name");

        if (log.isDebugEnabled()) {
            log.debug("url: " + url);
            log.debug("db name: " + database);
        }

        return new HiveDataSource(url + "/" + database, environment.getProperty("hive.username"));
    }

}

