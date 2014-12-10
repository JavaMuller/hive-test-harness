
SELECT
  all_version.coa_id
  ,latest_version.bu_id
  ,latest_version.engagement_id
  ,latest_version.coa_effective_date_id
  ,latest_version.gl_account_cd
  ,latest_version.gl_subacct_cd
  ,latest_version.gl_account_name
  ,latest_version.gl_subacct_name
  ,latest_version.consolidation_account
  ,latest_version.ey_account_type
  ,latest_version.ey_account_sub_type
  ,latest_version.ey_account_class
  ,latest_version.ey_account_sub_class
  ,latest_version.ey_account_group_I
  ,latest_version.ey_account_group_II
  ,latest_version.ey_sub_ledger
  ,latest_version.ey_cash_activity
  ,latest_version.ey_index
  ,latest_version.ey_sub_index
  ,latest_version.ey_management_account_ind
  ,latest_version.created_by_id
  ,latest_version.created_date_id
  ,latest_version.created_time_id
  ,latest_version.last_modified_by_id
  ,latest_version.last_modified_date_id
  ,latest_version.ver_start_date_id
  ,latest_version.ver_end_date_id
  ,latest_version.ver_desc
  ,latest_version.gl_account_cd + ' - ' + latest_version.gl_account_name		AS ey_gl_account_name

FROM				 dbo.Chart_of_accounts all_version
  LEFT OUTER JOIN		 dbo.Chart_of_accounts latest_version	ON		all_version.gl_account_cd = latest_version.gl_account_cd
  LEFT OUTER JOIN		 dbo.Business_unit_listing bu_all		ON		all_version.bu_id = bu_all.bu_id
  LEFT OUTER JOIN		 dbo.Business_unit_listing bu_latest	ON		latest_version.bu_id = bu_latest.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL
              AND	 bu_latest.bu_cd = bu_all.bu_cd