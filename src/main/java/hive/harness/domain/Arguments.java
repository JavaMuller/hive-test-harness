package hive.harness.domain;

import com.google.common.base.Objects;
import org.springframework.core.env.Environment;

public class Arguments {

    private boolean build;
    private boolean query;
    private boolean count;
    private Integer iterations;
    private String testName;
    private String hdfsDataPath;
    private String localDataPath;
    private String databaseName;

    public Arguments(Environment environment) {
        this.build = environment.containsProperty("b");
        this.query = environment.containsProperty("q");
        this.count = environment.containsProperty("c");
        this.testName = environment.getProperty("test.name");
        this.localDataPath = environment.getProperty("local.data.path");
        this.hdfsDataPath = environment.getProperty("hdfs.data.path");
        this.databaseName = environment.getProperty("hive.db.name");
        this.iterations = Integer.parseInt(environment.getProperty("i", "1"));
    }

    public boolean isBuild() {
        return build;
    }

    public boolean isQuery() {
        return query;
    }

    public boolean isCount() {
        return count;
    }

    public Integer getIterations() {
        return iterations;
    }

    public String getTestName() {
        return testName;
    }

    public String getHdfsDataPath() {
        return hdfsDataPath;
    }

    public String getLocalDataPath() {
        return localDataPath;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("build", build)
                .add("query", query)
                .add("count", count)
                .add("iterations", iterations)
                .add("testName", testName)
                .add("hdfsDataPath", hdfsDataPath)
                .add("localDataPath", localDataPath)
                .add("databaseName", databaseName)
                .toString();
    }

    public void prettyPrint() {
        System.out.println();
        System.out.println("******************************************");
        System.out.println("Running Test with the following parameters...");
        System.out.println("\tBuild: " + build);
        System.out.println("\tQuery: " + query);
        System.out.println("\tTest Name: " + testName);
        System.out.println("\tCount Records: " + count);
        System.out.println("\tIterations: " + iterations);
        System.out.println("\tLocal Data Path: " + localDataPath);
        System.out.println("\tHDFS Data Path: " + hdfsDataPath);
        System.out.println("\tDatabase Name: " + databaseName);
        System.out.println("******************************************");
        System.out.println();
    }
}
