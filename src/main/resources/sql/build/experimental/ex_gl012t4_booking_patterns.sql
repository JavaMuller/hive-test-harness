CREATE TABLE
    ex_gl012t4_booking_patterns stored AS orc AS
SELECT
    SUM ( FJ.COUNT_JE_ID ),
    SUM ( FJ.COUNT_JE_ID ),
    ROUND ( SUM ( FJ.net_amount ), 2 ),
    COA.ey_account_class,
    COA.ey_gl_account_name,
    bu.bu_ref,
    bu.bu_group,
    s1.ey_segment_group AS ey_segment_group1,
    s1.ey_segment_ref AS ey_segment_ref1,
    s2.ey_segment_group AS ey_segment_group2,
    s2.ey_segment_ref AS ey_segment_ref2,
    src.source_group,
    src.source_ref,
    CASE
        WHEN FJ.year_flag = 'CY'
        THEN 'Current'
        WHEN FJ.year_flag = 'PY'
        THEN 'Prior'
        WHEN FJ.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END AS year_flag_desc,
    PP.period_flag_desc,
    FJ.EY_period,
    FJ.journal_type as journal_type1,
    ul.department as department_ul,
    ul.preparer_ref as preparer_ref_ul,
    aul.department as department_aul,
    aul.preparer_ref as preparer_ref_aul,
    FJ.functional_curr_cd,
    FJ.reporting_amount_curr_cd,
    FJ.journal_type as journal_type2,
    FJ.reversal_ind,
    CASE
        WHEN FJ.reversal_ind = 'Y'
        THEN 'Reversal'
        WHEN FJ.reversal_ind = 'N'
        THEN 'Non-Reversal'
        ELSE 'None'
    END,
    SUM ( FJ.NET_reporting_amount ),
    SUM ( FJ.NET_reporting_amount_credit ),
    SUM ( FJ.NET_reporting_amount_debit ),
    SUM ( FJ.NET_functional_amount ),
    SUM ( FJ.NET_functional_amount_credit ),
    SUM ( FJ.NET_functional_amount_debit )
FROM
    FT_GL_Account FJ
INNER JOIN
    mv_chart_of_accounts coa
 ON
    coa.coa_id = FJ.coa_id
AND coa.bu_id = FJ.bu_id
INNER JOIN
    Parameters_period PP
 ON
    PP.year_flag = fj.year_flag
AND PP.period_flag = FJ.period_flag
LEFT OUTER JOIN
    mv_user_listing UL
 ON
    ul.user_listing_id = FJ.user_listing_id
LEFT OUTER JOIN
    mv_user_listing AUL
 ON
    Aul.user_listing_id = FJ.approved_by_id
LEFT OUTER JOIN
    mv_business_unit_listing BU
 ON
    Bu.bu_id = fJ.bu_id
LEFT OUTER JOIN
    mv_source_listing src
 ON
    src.source_id = fJ.source_id
LEFT OUTER JOIN
    mv_segment01_listing S1
 ON
    S1.ey_segment_id = fJ.segment1_id
LEFT OUTER JOIN
    mv_segment02_listing S2
 ON
    S2.ey_segment_id = fJ.segment2_id
GROUP BY
    COA.ey_account_class,
    COA.ey_gl_account_name,
    bu.bu_ref,
    bu.bu_group,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.Source_ref,
    src.source_group,
    FJ.year_flag,
    fj.period_flag,
    PP.year_flag_desc,
    PP.period_flag_desc,
    FJ.EY_period,
    FJ.journal_type,
    ul.department,
    ul.preparer_ref,
    aul.department,
    aul.preparer_ref,
    FJ.functional_curr_cd,
    FJ.reporting_amount_curr_cd,
    FJ.reversal_ind;