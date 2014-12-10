SELECT
  all_version.Vendor_master_id,
  latest_version.bu_id,
  latest_version.engagement_id,
  latest_version.vendor_master_as_of_date_id,
  latest_version.vendor_account_cd,
  latest_version.vendor_account_name,
  latest_version.vendor_group,
  latest_version.vendor_physical_street_addr1,
  latest_version.vendor_physical_street_addr2,
  latest_version.vendor_physical_city,
  latest_version.vendor_physical_state_province,
  latest_version.vendor_physical_country,
  latest_version.vendor_physical_zip_code,
  latest_version.vendor_tax_id,
  latest_version.vendor_billing_address1,
  latest_version.vendor_billing_address2,
  latest_version.vendor_billing_city,
  latest_version.vendor_billing_state_province,
  latest_version.vendor_billing_country,
  latest_version.vendor_billing_zip_code,
  latest_version.payment_terms_desc,
  latest_version.payment_terms_days,
  latest_version.bank_name,
  latest_version.bank_account_no,
  latest_version.beneficiary,
  latest_version.active_ind,
  latest_version.active_ind_change_date_id,
  latest_version.credit_limit_curr_cd,
  latest_version.transaction_credit_limit,
  latest_version.overall_credit_limit,
  latest_version.created_by_id,
  latest_version.created_date_id,
  latest_version.created_time_id,
  latest_version.last_modified_by_id,
  latest_version.last_modified_date_id,
  latest_version.approved_by_id,
  latest_version.approved_by_date_id,
  latest_version.ver_start_date_id,
  latest_version.ver_end_date_id,
  latest_version.ver_desc,
  latest_version.ey_related_party,
  ISNULL(latest_version.vendor_account_cd, '') + ' - ' + ISNULL
  (latest_version.vendor_account_name, '') AS vendor_ref,
  bu_latest.bu_cd
FROM
  dbo.Vendor_master all_version
  LEFT OUTER JOIN
  dbo.Vendor_master latest_version
    ON
      all_version.Vendor_account_cd = latest_version.Vendor_account_cd
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