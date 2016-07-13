package veil.hdp.hive.harness.config;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.Option;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.env.CommandLinePropertySource;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CommonsCLIPropertySource extends CommandLinePropertySource<CommandLine> {

    public CommonsCLIPropertySource(CommandLine source) {
        super(source);
    }


    @Override
    protected boolean containsOption(String name) {
        return StringUtils.isNotBlank(name) && this.source.hasOption(name);
    }

    @Override
    protected List<String> getOptionValues(String name) {

        Option option = getOption(name);

        if (option != null && option.hasArg()) {
            return Arrays.asList(this.source.getOptionValues(name));
        }

        return null;
    }

    @Override
    protected List<String> getNonOptionArgs() {
        List<String> nonOptions = new ArrayList<>();


        for (Option option : this.source.getOptions()) {
            if (!option.hasArg()) {
                nonOptions.add(getKey(option));
            }
        }

        return nonOptions;
    }

    @Override
    public String[] getPropertyNames() {

        List<String> propertyNames = new ArrayList<>();


        for (Option option : this.source.getOptions()) {
            propertyNames.add(getKey(option));
        }

        return propertyNames.toArray(new String[propertyNames.size()]);
    }

    private Option getOption(String name) {

        if (this.containsOption(name)) {

            for (Option option : this.source.getOptions()) {

                String key = getKey(option);

                if (StringUtils.equalsIgnoreCase(name, key)) {
                    return option;
                }

            }
        }


        return null;
    }


    private String getKey(Option option) {
        return (option.getOpt() == null) ? option.getLongOpt() : option.getOpt();
    }
}
