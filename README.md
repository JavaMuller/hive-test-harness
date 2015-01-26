# EY Hive Performance POC

## Requirements

To execute you'll need the following:
* Java 1.7 installed
* Maven installed (use latest)
* A HDP 2.2 cluster.  I like to use [Ambari Vagrant](https://cwiki.apache.org/confluence/display/AMBARI/Quick+Start+Guide) to install my cluster locally instead of the sandbox.  Make sure you update `src/main/resources/application.properties` with your cluster info.

## About

This POC is a simple SpringBoot application.  The entry point is `Application.java`.  Once Spring has fully started, the `run(String... args)` method of `RunTest.java` is called.

The main method of `RunTest.java` can do the following:

* Create Test Database
* Build Tables & Views
* Load Test Data from Files
* Execute Queries
* Output Results to CSV File

The test requires 4 parameters be passed as `args` to the `main(String[] args)` method of `Application.java`:

1.  The first `arg` should be `true` or `false` and indicates if you want the application to drop/create the database, build tables, build views and load data

1.  The third `arg` should be `true` or `false` and indicates if you want execute queries

1.  The forth `arg` is a description of the test being performed.  For example `"enabled tez"`, would indicate that this test was the first execution since enabling TEZ

1.  The fifth `arg` is absolute path of data to be loaded.  For example `/Users/tveil/dev/projects/hw/clients/ey-hive-poc/data/converted`.  This directory should contain `.csv` files whose name matches that of the table its loading.

You can further refine the test by updating `String[] includeFilter` and `String[] excludeFilter` in `RunTest.java`.  This is a great way to test individual queries (use `includeFilter`) or eliminate problematic ones (use `excludeFilter`).

```java
String[] includeFilter = new String[]{};
String[] excludeFilter = new String[]{
        "VW_GL016T2_Zero_Balance_GL.sql",
        "VW_GL015T1_Cutoff_Analysis.sql",
        "VW_GL012T3_Date_Analysis.sql",
        "VW_GL018T1_Overview.sql",
        "VW_GL017T3_Transactions_By_Relationship.sql",
        "VW_GL013T1_Back_Postings1.sql",
        "VW_GL011_Relationship_Analyses.sql",
        "VW_GL010_Gross_Margin.sql",
        "v_IL_GL018_KPI_Overview.sql"
};
```

## Running Locally

You can run this locally with either IntelliJ or via the Command Line.

### Command Line

From the project's base directory execute the following from the command line

```bash

# builds the spring boot jar called hive-poc-0.0.1-SNAPSHOT.jar
> mvn package clean

# runs the spring boot jar.  must pass 4 parameters.
> java -jar target/hive-poc-0.0.1-SNAPSHOT.jar [true|false] [true|false] "[test description]" "[data location]

# for example
> java -jar target/hive-poc-0.0.1-SNAPSHOT.jar true true "some test" "/Users/tveil/dev/projects/hw/clients/ey-hive-poc/data/converted"

```

### IntelliJ

Create an "Application" "Run Configuration" like the following [screenshot](https://github.com/timveil/ey-hive-poc/blob/master/docs/Run_Debug_Configurations.png)


## Running in Azure

Run in Azure by setting the active profile (eg `-Dspring.profiles.active=azure`)

```
java -jar -Dspring.profiles.active=azure hive-poc-0.0.1-SNAPSHOT.jar true true "testing in azure" "/path/to/data/in/azure"
```

## Current Problems


See project [issues](https://github.com/timveil/ey-hive-poc/issues)

This issue is affecting some queries.

https://issues.apache.org/jira/browse/HIVE-9249


## Tuning

### Working
1.  hive.execution.engine = tez
1.  hive.server2.tez.initialize.default.sessions = true
1.  hive.tez.auto.reducer.parallelism=true

### Not Working
1.  hive.optimize.bucketmapjoin.sortedmerge=true - HURT PERFORMANCE LOCALLY
1.  increase ez.task.resource.memory.mb from 512 to 1024 - HURT PERFORMANCE LOCALLY
1.  hive.cbo.enable=true ALREADY ENABLED
1.  hive.vectorized.execution.enabled=true ALREADY ENABLED