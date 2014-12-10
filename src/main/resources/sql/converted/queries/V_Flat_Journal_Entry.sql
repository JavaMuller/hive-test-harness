SELECT Je_id + '-' + je_line_id,
[je_id]
, FJ.[je_line_id]
, FJ.[je_line_desc]
, FJ.[je_header_desc]
, FJ.[dr_cr_ind]
, FJ.[amount]
, FJ.[amount_debit]
, FJ.[amount_credit]
, FJ.[amount_curr_cd]
, FJ.[ey_je_id]
, FJ.[activity]
, FJ.[coa_id]
, FJ.[period_id]
, FJ.[bu_id]
, FJ.[gl_account_cd]
, FJ.[gl_subacct_cd]
, FJ.[gl_account_name]
, FJ.[gl_subacct_name]
, FJ.[ey_gl_account_name]
, FJ.[consolidation_account]
, FJ.[ey_account_type]
, FJ.[ey_account_sub_type]
, FJ.[ey_account_class]
, FJ.[ey_cash_activity]
, FJ.[ey_account_sub_class]
, FJ.[ey_index]
, FJ.[ey_sub_index]
, FJ.[source_id]
, src.[source_cd]
, src.[source_desc]
, src.[source_ref]
, FJ.[sys_manual_ind]
, FJ.[sys_manual_ind_src]
, FJ.[sys_manual_ind_usr]
, FJ.[user_listing_id]
, FJ.[client_user_id]
, FJ.[preparer_ref]
, FJ.[first_name]
, FJ.[last_name]
, FJ.[full_name]
, FJ.[department]
, FJ.[role_resp]
, FJ.[title]
, FJ.[active_ind]
, bu.[bu_cd]
, bu.[bu_desc]
, bu.[bu_ref]
, bu.[bu_group]
, FJ.[fiscal_period_cd]
, FJ.[fiscal_period_desc]
, FJ.[fiscal_period_start]
, FJ.[fiscal_period_end]
, FJ.[fiscal_quarter_start]
, FJ.[fiscal_quarter_end]
, FJ.[fiscal_year_start]
, FJ.[fiscal_year_end]
, FJ.[EY_fiscal_year]
, FJ.[EY_quarter]
, FJ.[EY_period]
, FJ.[Entry_Date]
, FJ.[Day_of_week]
, FJ.[Effective_Date]
, FJ.[Lag_Date]
, CASE WHEN year_flag = 'CY' THEN 'Current'
WHEN year_flag = 'PY' THEN 'Prior'
WHEN year_flag = 'SP' THEN 'Subsequent'
ELSE year_flag_desc
END
, FJ.period_flag_desc
, FJ.[system_load_date]
, s1.[ey_segment_ref]
, s2.[ey_segment_ref]
, FJ.[functional_curr_cd]
, FJ.[functional_amount]
, FJ.[functional_debit_amount]
, FJ.[functional_credit_amount]
, FJ.[reversal_ind]
, FJ.[reporting_amount]
, FJ.[reporting_amount_curr_cd]
, FJ.[reporting_amount_debit]
, FJ.[reporting_amount_credit]
, FJ.[approver_department]
, FJ.[approver_ref]
, FJ.[approved_by_id]
, s1.[ey_segment_group]
, s2.[ey_segment_group]
, src.[source_group]
, FJ.[journal_type]
, FJ.[year_flag]
, FJ.[period_flag]
, s1.segment_desc
, s2.segment_desc
, FJ.segment2_id
, FJ.segment1_id
, '' AS 'Accounting period end date'
, '' AS 'Accounting subperiod end date'
, FJ.year_end_date
, FJ.year_flag_desc
, ''
, FJ.period_flag_desc
, FJ.functional_impact_to_assets
, FJ.functional_impact_to_liabilities
, FJ.functional_impact_to_equity
, FJ.functional_impact_to_revenue
, FJ.functional_impact_to_expenses
, FJ.reporting_impact_to_assets
, FJ.reporting_impact_to_liabilities
, FJ.reporting_impact_to_equity
, FJ.reporting_impact_to_revenue
, FJ.reporting_impact_to_expenses
, '' AS 'Audit period'
, '' AS 'Audit year'
, '' AS 'Business unit code hierarchy'
, '' AS 'Business unit description hierarchy'
, '' AS 'Business unit reference'
, '' AS 'Cash group'
, '' AS 'Interim period'
, '' AS 'Random number'
, ey_subledger_type
, ey_AR_type
, ey_AP_type
, ey_reconciliation_GL_group
, TT.ey_trans_type
, TT.transaction_type_ref

FROM [FLAT_JE] FJ
LEFT OUTER JOIN dbo.v_Business_unit_listing BU ON Bu.bu_id = FJ.bu_id
LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = FJ.source_id
LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
LEFT OUTER JOIN dbo.v_Transaction_type TT ON FJ.transaction_type_id = TT.transaction_type_id
WHERE fj.ver_end_date_id IS NULL

