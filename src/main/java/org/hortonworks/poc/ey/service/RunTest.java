package org.hortonworks.poc.ey.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class RunTest implements CommandLineRunner {

    @Autowired
    private Proof proof;

    @Override
    public void run(String... args) throws Exception {
        boolean buildAndLoad = args == null || args.length == 0;


        if (buildAndLoad) {
            proof.createDatabase();
        }

        if (buildAndLoad) {
            proof.buildTables();
            proof.buildViews();
            proof.loadData();
        }

        String[] filter = null;

        filter = new String[]{"v_IL_GL016T1_Balance_by_GL.sql"};

        proof.executeQueries(filter, true);

    }
}
