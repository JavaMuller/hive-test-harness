CREATE INDEX parameters_period_year_flag_idx ON TABLE parameters_period (year_flag) AS 'COMPACT' WITH DEFERRED REBUILD;
ALTER INDEX parameters_period_year_flag_idx ON parameters_period REBUILD;