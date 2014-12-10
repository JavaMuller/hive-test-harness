SELECT
  je_id,
  je_line_id,
  je_line_desc,
  je_header_desc,
  gl_account_cd,
  gl_subacct_name,
  ey_gl_account_name,
  ey_account_type,
  ey_account_sub_type,
  ey_account_class,
  source_id,
  user_listing_id,
  client_user_id,
  preparer_ref,
  department,
  first_name,
  role_resp,
  bu_id,
  year_flag_desc,
  period_flag_desc,
  approver_department,
  approver_ref,
  approved_by_id,
  journal_type,
  year_flag,
  period_flag,
  segment1_id,
  segment2_id,
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  ''
FROM
  dbo.FLAT_JE
WHERE
  (
    je_line_desc IS NULL
    OR je_header_desc IS NULL
    OR gl_account_cd IS NULL
    OR client_user_id IS NULL
    OR department IS NULL
    OR role_resp IS NULL
    OR bu_id IS NULL
    OR approver_department IS NULL
    OR approver_ref IS NULL)
  AND ver_end_date_id IS NULL