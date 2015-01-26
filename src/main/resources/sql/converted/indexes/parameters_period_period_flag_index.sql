CREATE INDEX parameters_period_period_flag_idx ON TABLE parameters_period (period_flag) AS 'COMPACT' WITH DEFERRED REBUILD;
ALTER INDEX parameters_period_period_flag_idx ON parameters_period REBUILD;