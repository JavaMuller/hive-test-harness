SELECT
    COA.ey_account_type,
    COA.ey_account_class,
    COA.ey_account_group_I,
    f.ey_period,
    CASE
    WHEN f.year_flag = 'CY'
    THEN 'Current'
    WHEN f.year_flag = 'PY'
    THEN 'Prior'
    WHEN f.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE pp.year_flag_desc
    END,
    PP.period_flag_desc,
    f.year_flag,
    f.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.source_ref,
    UL.preparer_ref,
    UL.department,
    AUL.department,
    AUL.preparer_ref,
    f.journal_type,
    f.reporting_amount_curr_cd,
    f.functional_curr_cd,
    ROUND ( SUM (
                CASE
                WHEN COA.ey_account_type = 'Revenue'
                THEN f.net_reporting_amount
                ELSE 0
                END ), 2 ) - ROUND ( SUM (
                                         CASE
                                         WHEN COA.ey_account_type = 'Expenses'
                                         THEN f.net_reporting_amount
                                         ELSE 0
                                         END ), 2 ),
    ROUND ( SUM (
                CASE
                WHEN COA.ey_account_type = 'Revenue'
                THEN f.net_functional_amount
                ELSE 0
                END ), 2 ) - ROUND ( SUM (
                                         CASE
                                         WHEN COA.ey_account_type = 'Expenses'
                                         THEN f.net_functional_amount
                                         ELSE 0
                                         END ), 2 )
FROM
    FT_GL_Account F
    INNER JOIN
    mv_chart_of_accounts COA
        ON
            COA.coa_id = F.coa_id
            AND COA.bu_id = F.bu_id
    INNER JOIN
    Parameters_period PP
        ON
            PP.year_flag = F.year_flag
            AND pp.period_flag = f.period_flag
    LEFT OUTER JOIN
    mv_user_listing UL
        ON
            UL.user_listing_id = f.user_listing_id
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
WHERE
    f.year_flag IN ( 'CY',
                     'PY' )
GROUP BY
    coa.ey_account_type,
    coa.ey_account_class,
    f.ey_period,
    PP.year_flag_desc,
    PP.period_flag_desc,
    f.year_flag,
    f.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.source_ref,
    UL.preparer_ref,
    UL.department,
    AUL.department,
    AUL.preparer_ref,
    F.journal_type,
    COA.ey_account_group_I,
    f.reporting_amount_curr_cd,
    f.functional_curr_cd;