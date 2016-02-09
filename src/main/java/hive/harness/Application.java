package hive.harness;

import hive.harness.config.CommonsCLIPropertySource;
import org.apache.commons.cli.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.dao.PersistenceExceptionTranslationAutoConfiguration;
import org.springframework.boot.autoconfigure.groovy.template.GroovyTemplateAutoConfiguration;
import org.springframework.boot.autoconfigure.gson.GsonAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration;
import org.springframework.boot.autoconfigure.jmx.JmxAutoConfiguration;
import org.springframework.boot.context.event.ApplicationEnvironmentPreparedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan
@EnableAutoConfiguration(exclude = {DataSourceAutoConfiguration.class, DataSourceTransactionManagerAutoConfiguration.class, JmxAutoConfiguration.class, GroovyTemplateAutoConfiguration.class, GsonAutoConfiguration.class, PersistenceExceptionTranslationAutoConfiguration.class})
public class Application {

    public static void main(String[] args) throws Exception {

        final CommandLine commandLine = buildCommandLine(args);

        SpringApplication app = new SpringApplication(Application.class);
        app.setWebEnvironment(false);
        app.addListeners(new ApplicationListener<ApplicationEnvironmentPreparedEvent>() {
            @Override
            public void onApplicationEvent(ApplicationEnvironmentPreparedEvent event) {
                event.getEnvironment().getPropertySources().addLast(new CommonsCLIPropertySource(commandLine));
            }
        });

        app.run(args);
    }

    private static CommandLine buildCommandLine(String[] args) throws ParseException {
        Options options = new Options();

        options.addOption(buildOption("b", "build", false, "build database, tables and load data", null, false));
        options.addOption(buildOption("q", "query", false, "execute queries", null, false));
        options.addOption(buildOption("c", "count", false, "when executing queries, count the records returned from the query", null, false));
        options.addOption(buildOption("i", "iterations", true, "number of times the query will be executed", "ITERATIONS", false));

        options.addOption(Option.builder().longOpt("test.name").desc("short name or description of test being run").hasArg().argName("NAME").build());
        options.addOption(Option.builder().longOpt("hdfs.data.path").desc("path to where the data should be stored on HDFS").hasArg().argName("PATH").build());
        options.addOption(Option.builder().longOpt("local.data.path").desc("path to local data to be uploaded to HDFS and used by build scripts ").hasArg().argName("PATH").build());
        options.addOption(Option.builder().longOpt("hive.db.name").desc("name of database to create in Hive ").hasArg().argName("NAME").build());

        HelpFormatter formatter = new HelpFormatter();
        formatter.printHelp("java -jar <Hive Test Harness Jar>", options);

        CommandLineParser parser = new DefaultParser();

        return parser.parse(options, args, true);
    }

    private static Option buildOption(String option, String longOption, boolean hasArg, String description, String argName, boolean required) {
        Option opt = new Option(option, longOption, hasArg, description);
        opt.setRequired(required);

        if (StringUtils.isNotBlank(argName)) {
            opt.setArgName(argName);
        }

        return opt;
    }


}
