CREATE TABLE
    mv_fiscal_calendar
    (
        period_id INT,
        bu_id INT,
        engagement_id string,
        fiscal_period_cd string,
        fiscal_period_desc string,
        fiscal_period_seq INT,
        fiscal_period_start string,
        fiscal_period_end string,
        fiscal_quarter_cd string,
        fiscal_quarter_desc string,
        fiscal_quarter_start string,
        fiscal_quarter_end string,
        fiscal_year_cd string,
        fiscal_year_desc string,
        fiscal_year_start string,
        fiscal_year_end string,
        adjustment_period string,
        ver_start_date_id INT,
        ver_end_date_id INT,
        ver_desc string
) stored AS orc;


insert overwrite TABLE mv_fiscal_calendar
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
        0,
        latest_version.ver_desc
    FROM
        Fiscal_calendar all_version
        LEFT OUTER JOIN
        Fiscal_calendar latest_version
            ON
                all_version.fiscal_period_cd = latest_version.fiscal_period_cd
        LEFT OUTER JOIN
        Business_unit_listing bu_all
            ON
                all_version.bu_id = bu_all.bu_id
        LEFT OUTER JOIN
        Business_unit_listing bu_latest
            ON
                latest_version.bu_id = bu_latest.bu_id
    WHERE
        latest_version.ver_end_date_id IS NULL
        AND bu_latest.bu_cd = bu_all.bu_cd;