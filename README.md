EY Hive Performance POC
===========

This POC is a simple SpringBoot application.  The entry point is `Application.java`.  Once spring has started RunTest is executed.
The test can be executed in two modes:

1) When run without arguments, the application will drop/create a hive database, create the tables & views, load data and then execute all queries.

2) When run with any parameter, the application will only execute queries.

If you only want to run certain queries, update `RunTest.java`  Only queries listed in the filter array will be executed.  Set filter to null if you want all queries to run.

```
String[] filter = null;

filter = new String[]{"v_IL_GL018_KPI_Overview.sql"};
```
