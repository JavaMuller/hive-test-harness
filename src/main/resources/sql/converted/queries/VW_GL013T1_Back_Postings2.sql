SELECT
    F.ey_account_type ,
    F.ey_account_sub_type ,
    F.ey_account_class ,
    F.ey_account_sub_class ,
    F.ey_gl_account_name ,
    F.gl_account_cd ,
    F.ey_gl_account_name ,
    F.effective_date ,
    F.entry_date ,
    bu.bu_group ,
    bu.bu_ref ,
    s1.ey_segment_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_group ,
    s2.ey_segment_ref ,
    CASE
        WHEN f.year_flag ='CY'
        THEN 'Current'
        WHEN f.year_flag ='PY'
        THEN 'Prior'
        WHEN f.year_flag ='SP'
        THEN 'Subsequent'
        ELSE f.year_flag_desc
    END ,
    f.year_flag ,
    f.period_flag_desc ,
    f.period_flag ,
    f.EY_period ,
    src.source_group ,
    src.source_ref ,
    f.journal_type ,
    f.department ,
    F.preparer_ref ,
    f.approver_department ,
    f.approver_ref ,
    SUM(f.reporting_amount) ,
    SUM(F.reporting_amount_credit) ,
    SUM(F.reporting_amount_debit) ,
    f.reporting_amount_curr_cd ,
    SUM(f.functional_amount) ,
    SUM(f.functional_credit_amount) ,
    SUM(f.functional_debit_amount) ,
    f.functional_curr_cd
FROM
    flat_JE F
INNER JOIN
    Parameters_period pa
ON
    f.year_flag = pa.year_flag
AND f.period_flag = pa.period_flag
LEFT OUTER JOIN
    v_Business_unit_listing BU
ON
    Bu.bu_id = f.bu_id
LEFT OUTER JOIN
    v_Source_listing src
ON
    src.source_id = f.source_id
LEFT OUTER JOIN
    v_Segment01_listing S1
ON
    S1.ey_segment_id = f.segment1_id
LEFT OUTER JOIN
    v_Segment02_listing S2
ON
    S2.ey_segment_id = f.segment2_id
WHERE
    F.entry_date > F.effective_date
AND
    CASE
        WHEN pa.period_flag = 'IP'
        THEN pa.end_date
    END < f.entry_date
GROUP BY
    F.ey_account_type ,
    F.ey_account_sub_type ,
    F.ey_account_class ,
    F.ey_account_sub_class ,
    F.ey_gl_account_name ,
    F.gl_account_cd ,
    F.ey_gl_account_name ,
    F.effective_date ,
    F.entry_date ,
    bu.bu_group ,
    bu.bu_ref ,
    s1.ey_segment_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_group ,
    s2.ey_segment_ref ,
    f.year_flag_desc ,
    f.year_flag ,
    f.period_flag_desc ,
    f.period_flag ,
    f.EY_period ,
    src.source_group ,
    src.source_ref ,
    f.sys_manual_ind ,
    f.journal_type ,
    f.department ,
    F.preparer_ref ,
    f.approver_department ,
    f.approver_ref ,
    f.functional_curr_cd ,
    f.reporting_amount_curr_cd