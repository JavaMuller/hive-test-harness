package hive.harness.domain;


import com.google.common.base.Objects;
import org.apache.commons.lang3.builder.ToStringBuilder;

public class QueryResult {

    private final String file;
    private final long min;
    private final long max;
    private final double mean;
    private final double median;
    private final double standardDeviation;
    private final int iterations;
    private final long count;
    private final long countDuration;

    public QueryResult(String file, long min, long max, double mean, double median, double standardDeviation, int iterations, long count, long countDuration) {
        this.file = file;
        this.min = min;
        this.max = max;
        this.mean = mean;
        this.median = median;
        this.standardDeviation = standardDeviation;
        this.iterations = iterations;
        this.count = count;
        this.countDuration = countDuration;

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

    public long getCount() {
        return count;
    }

    public long getCountDuration() {
        return countDuration;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this)
                .append("file", file)
                .append("min", min)
                .append("max", max)
                .append("mean", mean)
                .append("median", median)
                .append("standardDeviation", standardDeviation)
                .append("iterations", iterations)
                .append("count", count)
                .append("countDuration", countDuration)
                .toString();
    }
}
