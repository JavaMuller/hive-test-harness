package hive.harness.domain;


import com.google.common.base.Objects;
import org.apache.commons.lang3.StringUtils;

public class QueryResult {

    private String file;
    private long min;
    private long max;
    private double mean;
    private double median;
    private double standardDeviation;
    private int iterations;

    private long recordCount;

    public QueryResult(String file, long min, long max, double mean, double median, double standardDeviation, int iterations, long recordCount) {
        this.file = file;
        this.min = min;
        this.max = max;
        this.mean = mean;
        this.median = median;
        this.standardDeviation = standardDeviation;
        this.iterations = iterations;
        this.recordCount = recordCount;
    }

    public String getFile() {
        return file;
    }

    public long getMin() {
        return min;
    }

    public long getMax() {
        return max;
    }

    public double getMean() {
        return mean;
    }

    public double getMedian() {
        return median;
    }

    public double getStandardDeviation() {
        return standardDeviation;
    }

    public int getIterations() {
        return iterations;
    }

    public long getRecordCount() {
        return recordCount;
    }

    @Override
    public String toString() {
        return Objects.toStringHelper(this)
                .add("file", file)
                .add("min", min)
                .add("max", max)
                .add("mean", mean)
                .add("median", median)
                .add("standardDeviation", standardDeviation)
                .add("iterations", iterations)
                .add("recordCount", recordCount)
                .toString();
    }
}
