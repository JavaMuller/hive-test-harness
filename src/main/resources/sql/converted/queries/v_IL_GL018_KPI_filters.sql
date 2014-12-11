SELECT
  f.bu_id,
  f.segment1_id,
  f.segment2_id,
  bu.bu_ref,
  bu.bu_group,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  src.source_group,
  src.source_ref,
  CASE
  WHEN f.year_flag = 'CY'
  THEN 'Current'
  WHEN f.year_flag = 'PY'
  THEN 'Prior'
  WHEN f.year_flag = 'SP'
  THEN 'Subsequent'
  ELSE f.year_flag_desc
  END,
  f.journal_type,
  f.period_flag_desc,
  f.fiscal_period_cd,
  f.period_id,
  f.department,
  f.preparer_ref
FROM
  FLAT_JE AS f
  LEFT OUTER JOIN
  v_Business_unit_listing bu
    ON
      bu.bu_id = f.bu_id
  LEFT OUTER JOIN
  v_Segment01_listing s1
    ON
      s1.ey_segment_id = F.segment1_id
  LEFT OUTER JOIN
  v_Segment02_listing s2
    ON
      s2.ey_segment_id = F.segment2_id
  LEFT OUTER JOIN
  v_Source_listing src
    ON
      src.source_id = f.source_id
WHERE
  f.year_flag != 'SP'
  AND F.ver_end_date_id IS NULL
GROUP BY
  f.bu_id,
  f.segment1_id,
  f.segment2_id,
  bu.bu_ref,
  bu.bu_group,
  s1.ey_segment_group,
  s1.ey_segment_ref,
  s2.ey_segment_group,
  s2.ey_segment_ref,
  src.source_group,
  src.source_ref,
  f.fiscal_period_cd,
  f.period_id,
  f.journal_type,
  f.year_flag,
  f.year_flag_desc,
  f.period_flag_desc,
  f.department,
  f.preparer_ref;