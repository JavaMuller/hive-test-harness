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

The test can be executed in two modes by passing or not passing `args` to the `main(String[] args)` method of `Application.java`:

1) When run without `args` (null or empty), the application will execute all steps listed above.

2) When run with `args` (any value will do), the application will only execute queries and not attempt to build and load

You can further refine the test by updating `String[] filter` in `RunTest.java`.  If `filter` is not null, then only queries listed will be executed.  This is a great way to test individual queries.

```java
String[] filter = null;

filter = new String[]{"v_IL_GL018_KPI_Overview.sql"};
```


Current Problems
----------
The following queries are not currently working:

- VW_GL012T3_Date_Analysis.sql.broken
```
FAILED: SemanticException Line 0:-1 Both left and right aliases encountered in JOIN 'fiscal_period_end'
```

- VW_GL015T1_Cutoff_Analysis.sql.broken
```
FAILED: ParseException line 38:28 cannot recognize input near 'VARCHAR' '(' '10' in function specification
```

- VW_GL016T2_Zero_Balance_GL.sql.broken
```
FAILED: ParseException line 43:4 missing ALL at 'SELECT' near '(' in expression specification
```

Results
----------