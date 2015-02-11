# Hive Test Harness

## Requirements

To execute you'll need the following:
* Java 1.7 installed
* Maven installed (use latest)
* A HDP 2.2 cluster.  I like to use [Ambari Vagrant](https://cwiki.apache.org/confluence/display/AMBARI/Quick+Start+Guide) to install my cluster locally instead of the sandbox.  Make sure you update `src/main/resources/application.properties` with your cluster info.

## About

This POC is a simple SpringBoot application.  The entry point is `Application.java`.  Once Spring has fully started, the `run(String... args)` method of `RunTest.java` is called.

The main method of `RunTest.java` can do the following:

* Create Test Database
* Build Tables
* Load Test Data from Files
* Execute Queries
* Output Results to CSV File

The test requires 5 parameters be passed as `args` to the `main(String[] args)` method of `Application.java`:

1.  The first `arg` should be `true` or `false` and indicates if you want the application to drop/create the database, build tables and load data

1.  The second `arg` should be `true` or `false` and indicates if you want execute queries

1.  The third `arg` is a description of the test being performed.  For example `"enabled tez"`, would indicate that this test was the first execution since enabling TEZ

1.  The forth `arg` is absolute path of data to be loaded.  For example `/Users/tveil/dev/projects/hw/clients/ey-hive-poc/data`.  This directory should contain `.csv` files whose name matches that of the table its loading.

1.  The fifth `arg` is the number of times to execute the query.  Set this to 5 to "warm up" each query before saving results.

You can further refine the test by updating `String[] includeFilter` and `String[] excludeFilter` in `RunTest.java`.  This is a great way to test individual queries (use `includeFilter`) or eliminate problematic ones (use `excludeFilter`).

```java
String[] includeFilter = new String[]{};
String[] excludeFilter = new String[]{
        "some-problematic-query.sql"
};
```

## Running Locally

You can run this locally with either IntelliJ or via the Command Line.

### Command Line

From the project's base directory execute the following from the command line

```bash

# builds the spring boot jar called hive-test-harness-0.0.1-SNAPSHOT.jar
> mvn package clean

# runs the spring boot jar.  must pass 4 parameters.
> java -jar target/hive-test-harness-0.0.1-SNAPSHOT.jar [true|false] [true|false] "[test description]" "[data location]" [iterations]

# for example
> java -jar target/hive-test-harness-0.0.1-SNAPSHOT.jar true true "some test" "/some/path/to/data/locally" 5

```

### IntelliJ

Create an "Application" "Run Configuration" like the following [screenshot](https://github.com/timveil/ey-hive-poc/blob/master/docs/Run_Debug_Configurations.png)


## Running on remote clusters

Run on a remote by setting the active profile (eg `-Dspring.profiles.active=remote`) and updating `src/main/resources/application-remote.properties`

```
java -jar -Dspring.profiles.active=remote hive-test-harness-0.0.1-SNAPSHOT.jar true true "testing in remote" "/path/to/data/in/azure" 5
```

