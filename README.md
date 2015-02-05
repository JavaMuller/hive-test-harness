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

The test requires 5 parameters be passed as `args` to the `main(String[] args)` method of `Application.java`:

1.  The first `arg` should be `true` or `false` and indicates if you want the application to drop/create the database, build tables, build views and load data

1.  The second `arg` should be `true` or `false` and indicates if you want execute queries

1.  The third `arg` is a description of the test being performed.  For example `"enabled tez"`, would indicate that this test was the first execution since enabling TEZ

1.  The forth `arg` is absolute path of data to be loaded.  For example `/Users/tveil/dev/projects/hw/clients/ey-hive-poc/data/converted`.  This directory should contain `.csv` files whose name matches that of the table its loading.

1.  The fifth `arg` is the number of times to execute the query.  Set this to 5 to "warm up" each query before saving results.

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
> java -jar target/hive-poc-0.0.1-SNAPSHOT.jar [true|false] [true|false] "[test description]" "[data location]" [iterations]

# for example
> java -jar target/hive-poc-0.0.1-SNAPSHOT.jar true true "some test" "/Users/tveil/dev/projects/hw/clients/ey-hive-poc/data/converted" 5

```

### IntelliJ

Create an "Application" "Run Configuration" like the following [screenshot](https://github.com/timveil/ey-hive-poc/blob/master/docs/Run_Debug_Configurations.png)


## Running in Azure

Run in Azure by setting the active profile (eg `-Dspring.profiles.active=azure`)

```
java -jar -Dspring.profiles.active=azure hive-poc-0.0.1-SNAPSHOT.jar true true "testing in azure" "/path/to/data/in/azure" 5
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
1.  hive.vectorized.execution.reduce.enabled=true

set hive.prewarm.enabled=true
set hive.prewarm.numcontainers=50
hive.optimize.bucketmapjoin.sortedmerge=true

set hive.auto.convert.join.noconditionaltask.size = 512mb?

set hive.stats.fetch.partition.stats=false;


### Not Working
1.  hive.optimize.bucketmapjoin.sortedmerge=true - HURT PERFORMANCE LOCALLY
1.  increase ez.task.resource.memory.mb from 512 to 1024 - HURT PERFORMANCE LOCALLY
1.  hive.cbo.enable=true ALREADY ENABLED
1.  hive.vectorized.execution.enabled=true ALREADY ENABLED

### possible indexes / partitions

#### where clauses
Business_unit_listing ver_end_date_id
Business_unit_listing bu_cd
Source_listing ver_end_date_id
User_listing ver_end_date_id
FLAT_JE year_flag
FLAT_JE period_flag
FLAT_JE ver_end_date_id
FLAT_JE entry_date
FLAT_JE effective_date
trial_balance ver_end_date_id
Parameters_period year_flag
Parameters_period period_flag
Parameters_period end_date
Parameters_period fiscal_year_cd
Dim_Fiscal_calendar fiscal_period_seq
FT_GL_Account user_listing_id
FT_GL_Account year_flag
FT_GL_Account active_ind
DIM_Chart_of_Accounts ey_account_type
DIM_Chart_of_Accounts ey_account_sub_type
DIM_Chart_of_Accounts ey_account_group_I



hive.auto.convert.join=true to do auto-join conversion

set hive.auto.convert.join.noconditionaltask = true;
set hive.auto.convert.join.noconditionaltask.size = 10000;

hive.enforce.bucketing = true

prewarm containers
