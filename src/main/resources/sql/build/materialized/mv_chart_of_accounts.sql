CREATE TABLE
    mv_chart_of_accounts
    (
        coa_id INT,
        bu_id INT,
        engagement_id string,
        coa_effective_date_id INT,
        gl_account_cd string,
        gl_subacct_cd string,
        gl_account_name string,
        gl_subacct_name string,
        consolidation_account string,
        ey_account_type string,
        ey_account_sub_type string,
        ey_account_class string,
        ey_account_sub_class string,
        ey_account_group_i string,
        ey_account_group_ii string,
        ey_sub_ledger string,
        ey_cash_activity string,
        ey_index string,
        ey_sub_index string,
        ey_management_account_ind string,
        created_by_id INT,
        created_date_id INT,
        created_time_id INT,
        last_modified_by_id INT,
        last_modified_date_id INT,
        ver_start_date_id INT,
        ver_end_date_id INT,
        ver_desc string,
        ey_gl_account_name string
)
CLUSTERED BY (coa_id, bu_id) sorted by (coa_id, bu_id) into 4 buckets
stored AS orc;



insert overwrite TABLE mv_chart_of_accounts
    SELECT
        all_version.coa_id,
        latest_version.bu_id,
        latest_version.engagement_id,
        latest_version.coa_effective_date_id,
        latest_version.gl_account_cd,
        latest_version.gl_subacct_cd,
        latest_version.gl_account_name,
        latest_version.gl_subacct_name,
        latest_version.consolidation_account,
        latest_version.ey_account_type,
        latest_version.ey_account_sub_type,
        latest_version.ey_account_class,
        latest_version.ey_account_sub_class,
        latest_version.ey_account_group_I,
        latest_version.ey_account_group_II,
        latest_version.ey_sub_ledger,
        latest_version.ey_cash_activity,
        latest_version.ey_index,
        latest_version.ey_sub_index,
        latest_version.ey_management_account_ind,
        latest_version.created_by_id,
        latest_version.created_date_id,
        latest_version.created_time_id,
        latest_version.last_modified_by_id,
        latest_version.last_modified_date_id,
        latest_version.ver_start_date_id,
        0,
        latest_version.ver_desc,
        concat(latest_version.gl_account_cd, ' - ',latest_version.gl_account_name) AS ey_gl_account_name
    FROM
        Chart_of_accounts all_version
        LEFT OUTER JOIN
        Chart_of_accounts latest_version
            ON
                all_version.gl_account_cd = latest_version.gl_account_cd
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