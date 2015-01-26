CREATE INDEX ft_gl_account_year_flag_idx ON TABLE ft_gl_account (year_flag) AS 'COMPACT' WITH DEFERRED REBUILD;
ALTER INDEX ft_gl_account_year_flag_idx ON ft_gl_account REBUILD;