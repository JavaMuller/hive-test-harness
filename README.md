EY Hive Performance POC
=======================

Requirements
------------

To execute you'll need the following:
* Java 1.7 installed
* Maven installed (use latest)
* A HDP 2.2 cluster.  I like to use [Ambari Vagrant](https://cwiki.apache.org/confluence/display/AMBARI/Quick+Start+Guide) to install my cluster locally instead of the sandbox.  Make sure you update `src/main/resources/application.properties` with your cluster info.

How to Run
----------

This POC is a simple SpringBoot application.  The entry point is `Application.java`.  Once Spring has fully started, the `run(String... args)` method of `RunTest.java` is called.

The main method of `RunTest.java` can do the following:

* Create Test Database
* Build Tables & Views
* Load Test Data from Files
* Execute Queries
* Output Results to CSV File

The test requires two parameters be passed as `args` to the `main(String[] args)` method of `Application.java`:

1) The first `arg` should be `true` or `false` and indicates if you want the application to drop/create the database, build tables & views and load test data

2) The second `arg` is a description of the test being performed.  For example `'enabled tez'`, would indicate that this test was the first execution since enabling TEZ

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


Current Problems
----------

See project 

Results
----------