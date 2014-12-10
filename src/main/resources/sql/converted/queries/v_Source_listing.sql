SELECT
  all_version.source_id,
  latest_version.engagement_id,
  latest_version.source_cd,
  latest_version.source_desc,
  latest_version.erp_subledger_module,
  latest_version.bus_process_major,
  latest_version.bus_process_minor,
  latest_version.sys_manual_ind,
  latest_version.ver_start_date_id,
  latest_version.ver_end_date_id,
  latest_version.ver_desc,
  CONVERT(VARCHAR(100), ISNULL(latest_version.ey_source_group, SOURCE_MAPPING.source_group)) AS
                                                                                                source_group,
  latest_version.source_cd + ' - ' + latest_version.source_desc                              AS source_ref
FROM
  dbo.Source_listing all_version
  LEFT OUTER JOIN
  dbo.Source_listing latest_version
    ON
      all_version.source_cd = latest_version.source_cd
  LEFT OUTER JOIN
  (
    SELECT
      'AA'           AS source_cd,
      'Fixed Assets' AS source_group
    UNION ALL
    SELECT
      'AB'     AS source_cd,
      'Manual' AS source_group
    UNION ALL
    SELECT
      'AF'           AS source_cd,
      'Fixed Assets' AS source_group
    UNION ALL
    SELECT
      'KA'       AS source_cd,
      'Payables' AS source_group
    UNION ALL
    SELECT
      'KG'       AS source_cd,
      'Payables' AS source_group
    UNION ALL
    SELECT
      'KP'       AS source_cd,
      'Payables' AS source_group
    UNION ALL
    SELECT
      'KR'       AS source_cd,
      'Payables' AS source_group
    UNION ALL
    SELECT
      'PR'        AS source_cd,
      'Inventory' AS source_group
    UNION ALL
    SELECT
      'RE'       AS source_cd,
      'Payables' AS source_group
    UNION ALL
    SELECT
      'RV'          AS source_cd,
      'Receivables' AS source_group
    UNION ALL
    SELECT
      'SA'     AS source_cd,
      'Manual' AS source_group
    UNION ALL
    SELECT
      'SB'          AS source_cd,
      'Adjustments' AS source_group
    UNION ALL
    SELECT
      'WA'        AS source_cd,
      'Inventory' AS source_group
    UNION ALL
    SELECT
      'WE'        AS source_cd,
      'Inventory' AS source_group
    UNION ALL
    SELECT
      'WI'        AS source_cd,
      'Inventory' AS source_group
    UNION ALL
    SELECT
      'WL'        AS source_cd,
      'Inventory' AS source_group
    UNION ALL
    SELECT
      'ZP'   AS source_cd,
      'Cash' AS source_group
    UNION ALL
    SELECT
      'ZR'   AS source_cd,
      'Cash' AS source_group
    UNION ALL
    SELECT
      'ZV'   AS source_cd,
      'Cash' AS source_group) AS SOURCE_MAPPING
    ON
      latest_version.source_cd = SOURCE_MAPPING.source_cd
WHERE
  latest_version.ver_end_date_id IS NULL