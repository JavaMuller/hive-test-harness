CREATE TABLE ft_gl_account (
    coa_id INT,
    period_id INT,
    bu_id INT,
    source_id INT,
    segment1_id INT,
    segment2_id INT,
    user_listing_id INT,
    approved_by_id INT,
    ey_period string,
    period_flag string,
    dr_cr_ind string,
    reversal_ind string,
    Sys_man_ind string,
    journal_type string,
    entry_date_id INT,
    effective_date_id INT,
    amount_curr_cd string,
    reporting_amount_curr_cd string,
    functional_curr_cd string,
    net_amount FLOAT,
    net_amount_credit FLOAT,
    net_amount_debit FLOAT,
    net_reporting_amount FLOAT,
    net_reporting_amount_debit FLOAT,
    net_reporting_amount_credit FLOAT,
    net_functional_amount FLOAT,
    net_functional_amount_debit FLOAT,
    net_functional_amount_credit FLOAT,
    count_je_id INT
)
PARTITIONED BY(year_flag string)
stored AS orc;

CREATE TABLE ft_gl_account_csv (
    coa_id INT,
    period_id INT,
    bu_id INT,
    source_id INT,
    segment1_id INT,
    segment2_id INT,
    user_listing_id INT,
    approved_by_id INT,
    ey_period string,
    year_flag string,
    period_flag string,
    dr_cr_ind string,
    reversal_ind string,
    Sys_man_ind string,
    journal_type string,
    entry_date_id INT,
    effective_date_id INT,
    amount_curr_cd string,
    reporting_amount_curr_cd string,
    functional_curr_cd string,
    net_amount FLOAT,
    net_amount_credit FLOAT,
    net_amount_debit FLOAT,
    net_reporting_amount FLOAT,
    net_reporting_amount_debit FLOAT,
    net_reporting_amount_credit FLOAT,
    net_functional_amount FLOAT,
    net_functional_amount_debit FLOAT,
    net_functional_amount_credit FLOAT,
    count_je_id INT
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\054'
stored AS textfile;

load data inpath '/poc/data/ey/ft_gl_account.csv' into table ft_gl_account_csv;

insert into table ft_gl_account partition(year_flag) select coa_id, period_id, bu_id, source_id, segment1_id, segment2_id, user_listing_id, approved_by_id, ey_period, period_flag, dr_cr_ind, reversal_ind, Sys_man_ind, journal_type, entry_date_id, effective_date_id, amount_curr_cd, reporting_amount_curr_cd, functional_curr_cd, net_amount, net_amount_credit, net_amount_debit, net_reporting_amount, net_reporting_amount_debit, net_reporting_amount_credit, net_functional_amount, net_functional_amount_debit, net_functional_amount_credit, count_je_id, year_flag from ft_gl_account_csv where year_flag = 'CY';
insert into table ft_gl_account partition(year_flag) select coa_id, period_id, bu_id, source_id, segment1_id, segment2_id, user_listing_id, approved_by_id, ey_period, period_flag, dr_cr_ind, reversal_ind, Sys_man_ind, journal_type, entry_date_id, effective_date_id, amount_curr_cd, reporting_amount_curr_cd, functional_curr_cd, net_amount, net_amount_credit, net_amount_debit, net_reporting_amount, net_reporting_amount_debit, net_reporting_amount_credit, net_functional_amount, net_functional_amount_debit, net_functional_amount_credit, count_je_id, year_flag from ft_gl_account_csv where year_flag = 'PY';
insert into table ft_gl_account partition(year_flag) select coa_id, period_id, bu_id, source_id, segment1_id, segment2_id, user_listing_id, approved_by_id, ey_period, period_flag, dr_cr_ind, reversal_ind, Sys_man_ind, journal_type, entry_date_id, effective_date_id, amount_curr_cd, reporting_amount_curr_cd, functional_curr_cd, net_amount, net_amount_credit, net_amount_debit, net_reporting_amount, net_reporting_amount_debit, net_reporting_amount_credit, net_functional_amount, net_functional_amount_debit, net_functional_amount_credit, count_je_id, year_flag from ft_gl_account_csv where year_flag = 'SP';