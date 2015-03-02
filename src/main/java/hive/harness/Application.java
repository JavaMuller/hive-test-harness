package hive.harness;

import com.codahale.metrics.MetricRegistry;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration;
import org.springframework.boot.autoconfigure.groovy.template.GroovyTemplateAutoConfiguration;
import org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration;
import org.springframework.boot.autoconfigure.jmx.JmxAutoConfiguration;
import org.springframework.boot.autoconfigure.jta.JtaAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan
@EnableAutoConfiguration(exclude = {DataSourceAutoConfiguration.class, DataSourceTransactionManagerAutoConfiguration.class, JtaAutoConfiguration.class, JmxAutoConfiguration.class, GroovyTemplateAutoConfiguration.class, GsonAutoConfiguration.class, PersistenceExceptionTranslationAutoConfiguration.class})
public class Application {

    public static void main(String[] args) throws Exception {
        SpringApplication app = new SpringApplication(Application.class);
        app.setWebEnvironment(false);
        app.run(args);
    }

    @Bean
    public MetricRegistry buildRegistry() {
        return new MetricRegistry();
    }

    @Bean
    public Options commandLineOptions() {
        Options options = new Options();

        options.addOption("b", "build", false, "build database, tables and load data");
        options.addOption("q", "query", false, "execute queries");
        options.addOption("c", "count", false, "when executing queries, count the records returned from the query");
        options.addOption("i", "iterations", true, "number of times the query will be executed");

        options.addOption(OptionBuilder.withLongOpt("test.name").withDescription("short name or description of test being run").hasArg().withArgName("NAME").create());
        options.addOption(OptionBuilder.withLongOpt("hdfs.data.path").withDescription("path to where the data should be stored on HDFS").hasArg().withArgName("PATH").create());
        options.addOption(OptionBuilder.withLongOpt("local.data.path").withDescription("path to local data to be uploaded to HDFS and used by build scripts ").hasArg().withArgName("PATH").create());
        options.addOption(OptionBuilder.withLongOpt("hive.db.name").withDescription("name of database to create in Hive ").hasArg().withArgName("NAME").create());

        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp("java -jar <Hive Test Harness Jar>", options );

        return options;
    }

}
