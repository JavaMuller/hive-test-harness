package org.hortonworks.poc.ey.domain;


import org.apache.commons.lang3.StringUtils;

public class QueryResult {

    private String file;
    private long executionTime;
    private String error;

    public QueryResult(String file, long executionTime, String error) {
        this.file = file;
        this.executionTime = executionTime;
        this.error = error;
    }

    public String getFile() {
        return file;
    }

    public long getExecutionTime() {
        return executionTime;
    }

    public String getError() {
        return error;
    }

    public boolean success() {
        return StringUtils.isBlank(this.error);
    }
}
