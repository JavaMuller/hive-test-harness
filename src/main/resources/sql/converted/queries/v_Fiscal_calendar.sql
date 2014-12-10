SELECT
    all_version.period_id,
    latest_version.bu_id,
    latest_version.engagement_id,
    latest_version.fiscal_period_cd,
    latest_version.fiscal_period_desc,
    latest_version.fiscal_period_seq,
    latest_version.fiscal_period_start,
    latest_version.fiscal_period_end,
    latest_version.fiscal_quarter_cd,
    latest_version.fiscal_quarter_desc,
    latest_version.fiscal_quarter_start,
    latest_version.fiscal_quarter_end,
    latest_version.fiscal_year_cd,
    latest_version.fiscal_year_desc,
    latest_version.fiscal_year_start,
    latest_version.fiscal_year_end,
    latest_version.adjustment_period,
    latest_version.ver_start_date_id,
    latest_version.ver_end_date_id,
    latest_version.ver_desc
FROM
    dbo.Fiscal_calendar all_version
LEFT OUTER JOIN
    dbo.Fiscal_calendar latest_version
ON
    all_version.fiscal_period_cd = latest_version.fiscal_period_cd
LEFT OUTER JOIN
    dbo.Business_unit_listing bu_all
ON
    all_version.bu_id = bu_all.bu_id
LEFT OUTER JOIN
    dbo.Business_unit_listing bu_latest
ON
    latest_version.bu_id = bu_latest.bu_id
WHERE
    latest_version.ver_end_date_id IS NULL
AND bu_latest.bu_cd = bu_all.bu_cd