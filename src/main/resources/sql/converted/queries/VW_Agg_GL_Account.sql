WITH
    agg_acct AS
    (
        SELECT
            AGG.coa_id ,
            agg.bu_id ,
            agg.source_id ,
            agg.year_flag ,
            agg.period_flag ,
            agg.Sys_man_ind ,
            agg.journal_type ,
            agg.dr_cr_ind ,
            agg.user_listing_id ,
            agg.segment1_id ,
            agg.segment2_id ,
            agg.Ey_period ,
            reporting_amount_curr_cd ,
            functional_curr_cd ,
            SUM(Net_reporting_amount)          ,
            SUM(Net_reporting_amount_credit)   ,
            SUM(Net_reporting_amount_debit)    ,
            SUM(net_functional_amount)         ,
            SUM(net_functional_amount_credit) ,
            SUM(net_functional_amount_debit)
        FROM
            FT_GL_Account AGG
        GROUP BY
            AGG.coa_id ,
            agg.bu_id ,
            agg.source_id ,
            agg.year_flag ,
            agg.period_flag ,
            agg.Sys_man_ind ,
            agg.journal_type ,
            agg.dr_cr_ind ,
            agg.user_listing_id ,
            agg.segment1_id ,
            agg.segment2_id ,
            agg.Ey_period ,
            reporting_amount_curr_cd ,
            functional_curr_cd
    )
SELECT
    AGG.coa_id ,
    COA.ey_account_type ,
    COA.ey_account_sub_type ,
    COA.ey_account_class ,
    COA.ey_account_sub_class ,
    COA.gl_account_name ,
    COA.ey_gl_account_name ,
    COA.ey_gl_account_name ,
    COA.gl_account_cd ,
    COA.ey_account_group_I ,
    COA.ey_account_group_II ,
    Sys_man_ind ,
    UL.preparer_ref ,
    UL.department ,
    journal_type ,
    AGG.year_flag ,
    AGG.period_flag ,
    CASE
        WHEN AGG.year_flag = 'CY'
        THEN 'Current'
        WHEN AGG.year_flag = 'PY'
        THEN 'Prior'
        WHEN AGG.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END AS accounting_period ,
    PP.period_flag_desc ,
    Ey_period ,
    reporting_amount_curr_cd ,
    Net_reporting_amount ,
    Net_reporting_amount_credit ,
    Net_reporting_amount_debit ,
    functional_curr_cd ,
    net_functional_amount ,
    net_functional_amount_credit ,
    net_functional_amount_debit ,
    Bu.bu_group ,
    Bu.bu_ref ,
    DS.source_ref ,
    DS.source_group ,
    SEG1.ey_segment_ref ,
    SEG2.ey_segment_ref ,
    SEG1.ey_segment_group ,
    SEG2.ey_segment_group ,
    agg.dr_cr_ind
FROM
    agg_acct AGG
INNER JOIN
    v_Chart_of_accounts COA
ON
    COA.coa_id = AGG.coa_id
AND COA.bu_id = AGG.bu_id
LEFT OUTER JOIN
    Parameters_period PP
ON
    PP.period_flag = AGG.period_flag
AND PP.year_flag = AGG.year_flag
LEFT OUTER JOIN
    v_User_listing UL
ON
    UL.user_listing_id = AGG.user_listing_id
LEFT OUTER JOIN
    v_Source_listing DS
ON
    DS.source_id = AGG.Source_Id
LEFT OUTER JOIN
    v_Business_unit_listing Bu
ON
    BU.bu_id = AGG.bu_id
LEFT OUTER JOIN
    v_Segment01_listing Seg1
ON
    seg1.ey_segment_id = AGG.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing Seg2
ON
    seg2.ey_segment_id = AGG.segment2_id;