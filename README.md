EY Hive Performance POC
===========

NOTE:  This POC requires Java and Maven.  It is most easily executed from IntelliJ.

This POC is a simple SpringBoot application.  The entry point is `Application.java`.  Once Spring has fully started, the `run(String... args)` method of `RunTest.java` is called.

The main method of `RunTest.java` can do the following:

* Create Test Database
* Build Tables & Views
* Load Test Data from Files
* Execute Queries

The test can be executed in two modes by passing or not passing `args`:

1) When run without `args`, the application will execute all steps listed above.

2) When run with `args` (any value will do), the application will only execute queries and not attempt to build and load

You can further refine the test by updating `String[] filter` in `RunTest.java`.  If `filter` is not null, then only queries listed will be executed.  This is a great way to test individual queries.

```
String[] filter = null;

filter = new String[]{"v_IL_GL018_KPI_Overview.sql"};
```
