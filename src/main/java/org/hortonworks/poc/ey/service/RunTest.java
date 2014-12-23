package org.hortonworks.poc.ey.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class RunTest implements CommandLineRunner {

    private final Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private Proof proof;

    @Override
    public void run(String... args) throws Exception {

        boolean buildAndLoad = args == null || args.length == 0;

        log.debug("buildAndLoad = [" + buildAndLoad + "]");


        if (buildAndLoad) {
            proof.createDatabase();
        }

        if (buildAndLoad) {
            proof.buildTables();
            proof.buildViews();
            proof.loadData();
        }

        String[] filter = null;

        //filter = new String[]{"v_IL_GL018_KPI_Overview.sql"};

        proof.executeQueries(filter);
    }
}
