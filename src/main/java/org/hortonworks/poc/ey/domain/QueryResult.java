package org.hortonworks.poc.ey.domain;


import com.google.common.base.Objects;
import org.apache.commons.lang3.StringUtils;

public class QueryResult {

    private String file;
    private long queryDuration;
    private long countDuration;
    private String error;
    private long resultCount;

    public QueryResult(String file, long queryDuration, long iterateResultsDuration, String error, long resultCount) {
        this.file = file;
        this.queryDuration = queryDuration;
        this.countDuration = iterateResultsDuration;
        this.error = error;
        this.resultCount = resultCount;
    }

    public String getFile() {
        return file;
    }

    public long getQueryDuration() {
        return queryDuration;
    }

    public long getCountDuration() {
        return countDuration;
    }

    public String getError() {
        return error;
    }

    public long getResultCount() {
        return resultCount;
    }

    public boolean success() {
        return StringUtils.isBlank(this.error);
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("file", file)
                .add("queryDuration", queryDuration)
                .add("countDuration", countDuration)
                .add("resultCount", resultCount)
                .add("error", error)
                .toString();
    }
}
