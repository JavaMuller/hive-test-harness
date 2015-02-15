# Hive Test Harness

## About

The purpose of this project is to provide an easy to use, easy to share, easy to deploy harness for testing Hive queries against HDP clusters.  The harness has the ability to create tables, load data, execute queries and capture detailed statistics about those queries.  This can be particularly useful when performance benchmarking or turning.  I use this tool frequently to establish a performance baseline, then capture results after each configuration or code change.

The code ships with Sean Lahman's terrific baseball statistics [data](http://www.seanlahman.com/baseball-archive/statistics/) but can be easily replaced with data, schema and queries of your choosing.

## Requirements

To execute you'll need the following:
* Java 1.7 installed
* Maven installed (use latest)
* A running HDP 2.2 cluster

## Getting Started

Essentially the application will execute any `*.sql` file in the `src/main/resources/sql/tables` directory and then execute any query in `src/main/resources/sql/queries` and output the results to a `*.csv` file.  This behavior can be refined by altering the `application.properties` file or the command line arguments as described below:

The entry point is `Application.java`.  Once Spring has fully started, the `run(String... args)` method of `RunTest.java` is called.

The main method of `RunTest.java` can do the following:

* Create Test Database
* Build Tables
* Load Test Data from Files
* Execute Queries
* Output Results to CSV File

The following parameters can be passed as command line arguments:

```
usage: java -jar <Hive Test Harness Jar>
 -b,--build              build database, tables and load data
 -c,--count              when executing queries, count the records
                         returned from the query
    --data.path <PATH>   path to local data to be uploaded to HDFS and
                         used by build scripts
 -i,--iterations <arg>   number of times the query will be executed
 -q,--query              execute queries
    --test.name <NAME>   short name or description of test being run
```

You can further refine the test by updating `String[] includeFilter` and `String[] excludeFilter` in `RunTest.java`.  This is a great way to test individual queries (use `includeFilter`) or eliminate problematic ones (use `excludeFilter`).

```java
String[] includeFilter = new String[]{};
String[] excludeFilter = new String[]{
        "some-problematic-query.sql"
};
```

## Running Locally

You can run this locally with either IntelliJ or via the Command Line.

### Build Cluster with Vagrant (Optional)

I like to use [Vagrant](https://www.vagrantup.com/) to install my cluster locally instead of the HDP sandbox.  A `Vagrantfile` file is included in the root of the project.  To use install Vagrant and run `vagrant up` in the root of the project.  The `Vagrantfile` uses the following plugins `vagrant-multi-hostsupdater` and `vagrant-vbguest`.  To install the plugins, run the following from the root of the project.

```bash
vagrant plugin install vagrant-multi-hostsupdater
vagrant plugin install vagrant-vbguest
```

### Command Line

From the project's base directory execute the following from the command line

```bash

# builds the spring boot jar called hive-test-harness-0.0.1-SNAPSHOT.jar
> mvn package clean

# for example, to build only using default "data.path"
> java -jar target/hive-test-harness-0.0.1-SNAPSHOT.jar -b

# for example, to query only using default "test.name" with 10 iterations
> java -jar target/hive-test-harness-0.0.1-SNAPSHOT.jar -q -i 10

# for example, to do everything with custom values
> java -jar target/hive-test-harness-0.0.1-SNAPSHOT.jar -b --data.path "/foo/bar" -q --test.name "super important test" -i 50

```

### IntelliJ

Create an "Application" "Run Configuration" like the following [screenshot](https://github.com/timveil/hive-test-harness/blob/master/docs/Run_Debug_Configurations.png)


## Running on a Remote Cluster

Run on a remote cluster by setting the active profile (eg `-Dspring.profiles.active=remote`) and updating `src/main/resources/application-remote.properties`

Once the jar has been deployed to the remote cluster, you can execute the following...

```
java -jar -Dspring.profiles.active=remote hive-test-harness-0.0.1-SNAPSHOT.jar -b --data.path "/foo/bar" -q --test.name "super important test" -i 50
```

