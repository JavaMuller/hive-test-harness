CREATE TABLE
    ex_gl016t1_balance_by_gl stored AS orc AS
SELECT
    CASE
        WHEN f.year_flag = 'CY'
        THEN 'Current'
        WHEN f.year_flag = 'PY'
        THEN 'Prior'
        WHEN f.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END,
    PP.period_flag_desc,
    PP.year_flag,
    PP.period_flag,
    f.EY_period,
    f.coa_id,
    coa.ey_account_type,
    coa.ey_account_sub_type,
    coa.ey_account_class,
    coa.ey_account_sub_class,
    coa.gl_account_name,
    coa.gl_account_cd,
    coa.ey_gl_account_name,
    coa.ey_account_group_I,
    COALESCE ( F.user_listing_id, 0 ),
    CASE
        WHEN f.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE UL.preparer_ref
    END,
    CASE
        WHEN f.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE UL.department
    END,
    CASE
        WHEN f.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE AUL.department
    END,
    CASE
        WHEN f.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE AUL.preparer_ref
    END,
    bu.bu_group,
    bu.bu_REF,
    bu.bu_cd,
    s1.ey_segment_group as ey_segment_group1,
    s1.ey_segment_ref as ey_segment_ref1,
    s2.ey_segment_group as ey_segment_group2,
    s2.ey_segment_ref as ey_segment_ref2,
    CASE
        WHEN f.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE src.source_group
    END,
    CASE
        WHEN f.source_type <> 'Activity'
        THEN 'N/A for balances'
        ELSE src.source_ref
    END,
    f.sys_man_ind,
    f.journal_type,
    f.functional_curr_cd,
    f.reporting_curr_cd,
    F.source_type,
    f.net_reporting_amount,
    f.net_reporting_amount_credit,
    f.net_reporting_amount_debit,
    f.net_functional_amount,
    f.net_functional_amount_credit,
    f.net_functional_amount_debit,
    COALESCE ( f.source_id, 0 ),
    COALESCE ( f.segment1_id, 0 ),
    COALESCE ( f.segment2_id, 0 ),
    COALESCE ( f.approved_by_id, 0 )
FROM
    GL_016_Balance_by_GL F
INNER JOIN
    mv_chart_of_accounts coa
 ON
    coa.coa_id = f.coa_id
AND coa.bu_id = f.bu_id
LEFT OUTER JOIN
    mv_user_listing UL
 ON
    UL.user_listing_id = F.user_listing_id
LEFT OUTER JOIN
    mv_user_listing AUL
 ON
    AUL.user_listing_id = F.approved_by_id
LEFT OUTER JOIN
    Parameters_period PP
 ON
    PP.year_flag = F.year_flag
AND PP.period_flag = F.period_flag
LEFT OUTER JOIN
    mv_business_unit_listing BU
 ON
    Bu.bu_id = f.bu_id
LEFT OUTER JOIN
    mv_source_listing src
 ON
    src.source_id = f.source_id
LEFT OUTER JOIN
    mv_segment01_listing S1
 ON
    S1.ey_segment_id = f.segment1_id
LEFT OUTER JOIN
    mv_segment02_listing S2
 ON
    S2.ey_segment_id = f.segment2_id;