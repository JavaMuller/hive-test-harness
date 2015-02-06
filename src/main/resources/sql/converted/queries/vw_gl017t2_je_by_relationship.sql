SELECT
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
    F.year_flag,
    F.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.Source_ref,
    F.Ey_period,
    f.journal_type,
    ul.preparer_ref,
    ul.department,
    F.reporting_amount_curr_cd,
    F.functional_curr_cd,
    SUM(f.count_je_id)
FROM
    FT_GL_Account F
    INNER JOIN
    Parameters_period PP
        ON
            PP.year_flag = f.year_flag
            AND PP.period_flag = F.period_flag
    LEFT OUTER JOIN
    mv_user_listing UL
        ON
            UL.user_listing_id = f.user_listing_id
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
    pp.year_flag_desc,
    pp.period_flag_desc,
    F.year_flag,
    F.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.Source_ref,
    F.Ey_period,
    f.journal_type,
    ul.preparer_ref,
    ul.department,
    F.reporting_amount_curr_cd,
    F.functional_curr_cd;