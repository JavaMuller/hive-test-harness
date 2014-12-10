SELECT
  all_version.Transaction_type_id,
  latest_version.bu_id,
  latest_version.engagement_id,
  latest_version.Transaction_type_cd,
  latest_version.transaction_type_desc,
  latest_version.transaction_type_group_desc,
  latest_version.EY_transaction_type,
  latest_version.entry_by_id,
  latest_version.entry_date_id,
  latest_version.entry_time_id,
  latest_version.last_modified_by_id,
  latest_version.last_modified_date_id,
  latest_version.ver_start_date_id,
  latest_version.ver_end_date_id,
  latest_version.ver_desc,
  latest_version.ey_transaction_type         AS ey_trans_type,
  ISNULL(latest_version.Transaction_type_cd, '') + ' - ' + ISNULL
  (latest_version.transaction_type_desc, '') AS transaction_type_ref
FROM
  dbo.Transaction_type all_version
  LEFT OUTER JOIN
  dbo.Transaction_type latest_version
    ON
      all_version.Transaction_type_cd = latest_version.Transaction_type_cd
WHERE
  latest_version.ver_end_date_id IS NULL