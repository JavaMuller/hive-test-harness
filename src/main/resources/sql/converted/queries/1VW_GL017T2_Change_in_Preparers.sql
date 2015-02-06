SELECT
    cp.year_flag_desc,
    cp.period_flag_desc,
    cp.year_flag,
    cp.period_flag,
    bu.bu_group,
    bu.bu_ref,
    s1.ey_segment_ref,
    s2.ey_segment_ref,
    s1.ey_segment_group,
    s2.ey_segment_group,
    src.source_group,
    src.Source_ref,
    cp.Ey_period,
    cp.Journal_type,
    cp.preparer_ref,
    cp.department,
    cp.reporting_amount_curr_cd,
    cp.functional_curr_cd,
    cp.Category
FROM
    GL_017_Change_in_Preparers CP
    LEFT OUTER JOIN
    mv_business_unit_listing BU
        ON
            Bu.bu_id = cp.bu_id
    LEFT OUTER JOIN
    mv_source_listing src
        ON
            src.source_id = cp.source_id
    LEFT OUTER JOIN
    mv_segment01_listing S1
        ON
            S1.ey_segment_id = cp.segment1_id
    LEFT OUTER JOIN
    mv_segment02_listing S2
        ON
            S2.ey_segment_id = cp.segment2_id;