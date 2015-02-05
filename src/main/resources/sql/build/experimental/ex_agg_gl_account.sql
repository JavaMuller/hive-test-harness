CREATE TABLE
    ex_agg_gl_account
    (
        coa_id INT,
        ey_account_type string,
        ey_account_sub_type string,
        ey_account_class string,
        ey_account_sub_class string,
        gl_account_name string,
        ey_gl_account_name string,
        gl_account_cd string,
        ey_account_group_i string,
        ey_account_group_ii string,
        sys_man_ind string,
        preparer_ref string,
        department string,
        journal_type string,
        year_flag string,
        period_flag string,
        account_period string,
        period_flag_desc string,
        ey_period string,
        reporting_amount_curr_cd string,
        net_reporting_amount FLOAT,
        net_reporting_amount_credit FLOAT,
        net_reporting_amount_debit FLOAT,
        functional_curr_cd string,
        net_functional_amount FLOAT,
        net_functional_amount_credit FLOAT,
        net_functional_amount_debit FLOAT,
        bu_group string,
        bu_ref string,
        source_ref string,
        source_group string,
        ey_segment1_ref string,
        ey_segment2_ref string,
        ey_segment1_group string,
        ey_segment2_group string,
        dr_cr_ind string
    ) stored as orc;
    
INSERT
    overwrite TABLE ex_agg_gl_account
SELECT
    AGG.coa_id,
    COA.ey_account_type,
    COA.ey_account_sub_type,
    COA.ey_account_class,
    COA.ey_account_sub_class,
    COA.gl_account_name,
    COA.ey_gl_account_name,
    COA.gl_account_cd,
    COA.ey_account_group_I,
    COA.ey_account_group_II,
    Sys_man_ind,
    UL.preparer_ref,
    UL.department,
    journal_type,
    AGG.year_flag,
    AGG.period_flag,
    CASE
        WHEN AGG.year_flag = 'CY'
        THEN 'Current'
        WHEN AGG.year_flag = 'PY'
        THEN 'Prior'
        WHEN AGG.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END,
    PP.period_flag_desc,
    Ey_period,
    reporting_amount_curr_cd,
    Net_reporting_amount,
    Net_reporting_amount_credit,
    Net_reporting_amount_debit,
    functional_curr_cd,
    net_functional_amount,
    net_functional_amount_credit,
    net_functional_amount_debit,
    Bu.bu_group,
    Bu.bu_ref,
    DS.source_ref,
    DS.source_group,
    SEG1.ey_segment_ref,
    SEG2.ey_segment_ref,
    SEG1.ey_segment_group,
    SEG2.ey_segment_group,
    agg.dr_cr_ind
FROM
    mv_agg_act AGG
INNER JOIN
    mv_chart_of_accounts COA
 ON
    COA.coa_id = AGG.coa_id
AND COA.bu_id = AGG.bu_id
LEFT OUTER JOIN
    Parameters_period PP
 ON
    PP.period_flag = AGG.period_flag
AND PP.year_flag = AGG.year_flag
LEFT OUTER JOIN
    mv_user_listing UL
 ON
    UL.user_listing_id = AGG.user_listing_id
LEFT OUTER JOIN
    mv_source_listing DS
 ON
    DS.source_id = AGG.Source_Id
LEFT OUTER JOIN
    mv_business_unit_listing Bu
 ON
    BU.bu_id = AGG.bu_id
LEFT OUTER JOIN
    mv_segment01_listing Seg1
 ON
    seg1.ey_segment_id = AGG.segment1_id
LEFT OUTER JOIN
    mv_segment02_listing Seg2
 ON
    seg2.ey_segment_id = AGG.segment2_id;
