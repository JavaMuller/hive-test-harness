create table mv_agg_act (
    coa_id INT,
    bu_id INT,
    source_id INT,
    year_flag string,
    period_flag string,
    Sys_man_ind string,
    journal_type string,
    dr_cr_ind string,
    user_listing_id INT,
    segment1_id INT,
    segment2_id INT,
    Ey_period string,
    reporting_amount_curr_cd string,
    functional_curr_cd string,
    Net_reporting_amount FLOAT,
    Net_reporting_amount_credit FLOAT,
    Net_reporting_amount_debit FLOAT,
    net_functional_amount FLOAT,
    net_functional_amount_credit FLOAT,
    net_functional_amount_debit FLOAT
)
CLUSTERED BY(coa_id, bu_id) into 100 buckets
stored AS orc;

INSERT
    overwrite TABLE mv_agg_act
SELECT
    AGG.coa_id,
    agg.bu_id,
    agg.source_id,
    agg.year_flag,
    agg.period_flag,
    agg.Sys_man_ind,
    agg.journal_type,
    agg.dr_cr_ind,
    agg.user_listing_id,
    agg.segment1_id,
    agg.segment2_id,
    agg.Ey_period,
    reporting_amount_curr_cd,
    functional_curr_cd,
    SUM ( Net_reporting_amount ) AS `Net_reporting_amount`,
    SUM ( Net_reporting_amount_credit ) AS `Net_reporting_amount_credit`,
    SUM ( Net_reporting_amount_debit ) AS `Net_reporting_amount_debit`,
    SUM ( net_functional_amount ) AS `net_functional_amount`,
    SUM ( net_functional_amount_credit ) AS `net_functional_amount_credit`,
    SUM ( net_functional_amount_debit ) AS `net_functional_amount_debit`
FROM
    FT_GL_Account AGG
GROUP BY
    AGG.coa_id,
    agg.bu_id,
    agg.source_id,
    agg.year_flag,
    agg.period_flag,
    agg.Sys_man_ind,
    agg.journal_type,
    agg.dr_cr_ind,
    agg.user_listing_id,
    agg.segment1_id,
    agg.segment2_id,
    agg.Ey_period,
    reporting_amount_curr_cd,
    functional_curr_cd;