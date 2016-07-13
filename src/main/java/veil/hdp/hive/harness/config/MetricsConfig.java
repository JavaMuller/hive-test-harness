package veil.hdp.hive.harness.config;

import com.codahale.metrics.MetricRegistry;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MetricsConfig {

    @Bean
    public MetricRegistry buildRegistry() {
        return new MetricRegistry();
    }

}
