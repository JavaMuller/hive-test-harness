set mapred.reduce.tasks=20;

SELECT
    F.EY_period,
    coa.coa_id,
    coa.ey_account_type,
    coa.ey_account_sub_type,
    coa.ey_account_class,
    coa.ey_account_sub_class,
    coa.gl_account_cd,
    coa.ey_gl_account_name,
    coa.ey_account_group_I,
    UL.preparer_ref,
    UL.department,
    F.journal_type,
    AUL.preparer_ref,
    AUL.department,
    src.source_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    bu.bu_ref,
    bu.bu_group,
    f.year_flag,
    f.period_flag,
    CASE
    WHEN f.year_flag = 'CY'
    THEN 'Current'
    WHEN f.year_flag = 'PY'
    THEN 'Prior'
    WHEN f.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END,
    pp.period_flag_desc,
    F.reporting_amount_curr_cd,
    F.functional_curr_cd,
    SUM(f.count_je_id),
    COUNT(DISTINCT F.user_listing_id),
    SUM(f.count_je_id),
    SUM(F.net_reporting_amount_credit),
    SUM(F.net_reporting_amount_debit),
    ABS(SUM(F.net_reporting_amount_credit)) + ABS(SUM(F.net_reporting_amount_debit)),
    ABS(SUM(F.net_functional_amount_credit)) + ABS(SUM(F.net_functional_amount_debit))
FROM
    FT_GL_Account F
    INNER JOIN
    mv_chart_of_accounts coa
        ON
            coa.coa_id = f.coa_id
            AND coa.bu_id = f.bu_id
    INNER JOIN
    Parameters_period PP
        ON
            pp.period_flag = f.period_flag
            AND PP.year_flag = F.year_flag

    LEFT OUTER JOIN
    mv_user_listing UL
        ON
            UL.user_listing_id = F.user_listing_id
    LEFT OUTER JOIN
    mv_user_listing AUL
        ON
            AUL.user_listing_id = f.approved_by_id
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
            S2.ey_segment_id = f.segment2_id
GROUP BY
    F.EY_period,
    coa.coa_id,
    coa.ey_account_type,
    coa.ey_account_sub_type,
    coa.ey_account_class,
    coa.ey_account_sub_class,
    coa.gl_account_cd,
    coa.ey_gl_account_name,
    coa.ey_account_group_I,
    UL.preparer_ref,
    UL.department,
    F.journal_type,
    AUL.preparer_ref,
    AUL.department,
    src.source_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    bu.bu_ref,
    bu.bu_group,
    f.year_flag,
    f.period_flag,
    PP.year_flag_desc,
    PP.period_flag_desc,
    f.reporting_amount_curr_cd,
    f.functional_curr_cd
    ;

set mapred.reduce.tasks=-1;
