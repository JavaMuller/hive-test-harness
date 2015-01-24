
	SELECT
		Je_id+'-'+je_line_id as [Row_id],
		[je_id]				as [Journal entry ID]
		,FJ.[je_line_id]				as [Journal entry line ID]
		,FJ.[je_line_desc]			as [Journal entry line description]
		,FJ.[je_header_desc]			as [Journal entry header description]
		,FJ.[dr_cr_ind]				as [Debit or credit indicator]
		,FJ.[amount]					as [Amount]
		,FJ.[amount_debit]			as [Amount debit]
		,FJ.[amount_credit]			as [Amount credit]
		,FJ.[amount_curr_cd]			as [Amount currency code]
		,FJ.[ey_je_id]				as [EY journal entry ID]
		,FJ.[activity]				as [Activity]
		,FJ.[coa_id]					as [Chart of account ID]
		,FJ.[period_id]				as [Period ID]
		,FJ.[bu_id]					as [Business unit ID]
		,FJ.[gl_account_cd]			as [GL account code]
		,FJ.[gl_subacct_cd]			as [GL sub-account code]
		,FJ.[gl_account_name]		as [GL account name]
		,FJ.[gl_subacct_name]		as [GL sub-account name]
		,FJ.[ey_gl_account_name]		as [GL account]
		,FJ.[consolidation_account]	as [Consolidation name]
		,FJ.[ey_account_type]		as [EY account type]
		,FJ.[ey_account_sub_type]	as [EY account sub-type]
		,FJ.[ey_account_class]		as [EY account class]
		,FJ.[ey_cash_activity]		as [EY cash activity]
		,FJ.[ey_account_sub_class]	as [EY account sub-class]
		,FJ.[ey_index]				as [EY index]
		,FJ.[ey_sub_index]			as [EY sub-index]
		,FJ.[source_id]				as [Source ID]
		--,FJ.[source_cd]				as [Source code]
		--,FJ.[source_desc]			as [Source description]
		--,FJ.[source_ref]				as [Source]
		,src.[source_cd]			as [Source code]
		,src.[source_desc]			as [Source description]
		,src.[source_ref]				as [Source] -- ,src.[source_desc]-- fixed by prabakar on July 2nd since its refer to source_desc
		,FJ.[sys_manual_ind]			as [System manual indicator]
		,FJ.[sys_manual_ind_src]		as [System manual indicator source]
		,FJ.[sys_manual_ind_usr]		as [System manual indicator user]
		,FJ.[user_listing_id]		as [User listing ID]
		,FJ.[client_user_id]			as [Client user ID]
		,FJ.[preparer_ref]			as [Preparer]
		,FJ.[first_name]				as [Preparer first name]
		,FJ.[last_name]				as [Preparer last name]
		,FJ.[full_name]				as [Preparer full name]
		,FJ.[department]				as [Preparer department]
		,FJ.[role_resp]				as [Preparer role]
		,FJ.[title]					as [Preparer title]
		,FJ.[active_ind]				as [Active indicator]
		--,FJ.[bu_cd]					as [Business unit code]
		--,FJ.[bu_desc]				as [Business unit description]
		--,FJ.[bu_ref]					as [Business unit]
		--,FJ.[bu_group]				as [Business unit group]
		,bu.[bu_cd]					as [Business unit code]
		,bu.[bu_desc]				as [Business unit description]
		,bu.[bu_ref]					as [Business unit]
		,bu.[bu_group]				as [Business unit group]

		,FJ.[fiscal_period_cd]		as [Fiscal period code]
		,FJ.[fiscal_period_desc]		as [Fiscal period description]
		,FJ.[fiscal_period_start]	as [Fiscal period start]
		,FJ.[fiscal_period_end]		as [Fiscal period end]
		,FJ.[fiscal_quarter_start]	as [Fiscal quarter start]
		,FJ.[fiscal_quarter_end]		as [Fiscal quarter end]
		,FJ.[fiscal_year_start]		as [Fiscal year start]
		,FJ.[fiscal_year_end]		as [Fiscal year end]
		,FJ.[EY_fiscal_year]			as [EY fiscal year]
		,FJ.[EY_quarter]				as [EY quarter]
		,FJ.[EY_period]				as [Fiscal period]
		,FJ.[Entry_Date]				as [Entry date]
		,FJ.[Day_of_week]			as [Day of week]
		,FJ.[Effective_Date]			as [Effective date]
		,FJ.[Lag_Date]				as [Lag date]
		-- Commented and added the below piece of code to show the Accounting period based on the year_flag -- July 1st
		--Changes Begin
		--,FJ.year_flag_desc			as [Accounting period]
		,CASE WHEN year_flag = 'CY' THEN 'Current'
						WHEN year_flag = 'PY' THEN 'Prior'
						WHEN year_flag = 'SP' THEN 'Subsequent'
						ELSE year_flag_desc
					END	AS [Accounting period]
		-- Changes End
		,FJ.period_flag_desc			as [Accounting sub period]
		,FJ.[system_load_date]		as [System load date]
		--,FJ.[segment1_ref]					as [Segment 1]
		--,FJ.[segment2_ref]					as [Segment 2]
		,s1.[ey_segment_ref]					as [Segment 1]
		,s2.[ey_segment_ref]					as [Segment 2]

		,FJ.[functional_curr_cd]		as [Functional currency code]
		,FJ.[functional_amount]		as [Functional amount]
		,FJ.[functional_debit_amount]   as [Functional debit amount]
		,FJ.[functional_credit_amount]  as [Functional credit amount]
		,FJ.[reversal_ind]			   as [Reversal indicator]
		,FJ.[reporting_amount]		   as [Reporting amount]
		,FJ.[reporting_amount_curr_cd]  as [Reporting currency code]
		,FJ.[reporting_amount_debit]   as [Reporting debit amount]
		,FJ.[reporting_amount_credit]  as [Reporting credit amount]
		,FJ.[approver_department]	   as [Approver department]
		,FJ.[approver_ref]			   as [Approver]
		,FJ.[approved_by_id]			   as [Approver ID]
		--,FJ.[business_unit_group]	   as [Business unit group]
		--,FJ.[segment1_group]		   as [Segment 1 group]
		--,FJ.[segment2_group]		   as [Segment 2 group]
		--,FJ.[source_group]			   as [Source group]
		,s1.[ey_segment_group]		   as [Segment 1 group]
		,s2.[ey_segment_group]		   as [Segment 2 group]
		,src.[source_group]			   as [Source group]

		,FJ.[journal_type]		   as [Journal type]  -- Remove the column Journal Type from FLAT_JE
		,FJ.[year_flag]		  as [Year flag]
		,FJ.[period_flag]	as [Period flag]
		--,FJ.segment1_desc	as [Segment 1 desc]
		--,FJ.segment2_desc	as [Segment2_desc]
		,s1.segment_desc	as [Segment 1 desc]
		,s2.segment_desc	as [Segment2_desc]
		,FJ.segment2_id  as [Segment 2 id]  -- Updated from Segment 2 from Segment 1 on July 11 by prabakar tr
		,FJ.segment1_id  as [Segment 1 id]	-- Added from Segment 1 on July 11 by prabakar tr

		,'' as 'Accounting period end date'--year_flag_date
		,'' as 'Accounting subperiod end date' --period_flag_date
		,FJ.year_end_date                                   AS            [Year end date]
		,FJ.year_flag_desc                                  AS            [Year flag description]
		,''                                        AS            [period end date]
		,FJ.period_flag_desc                                AS            [period flag description]

		,FJ.functional_impact_to_assets as [Functional Journal impact to assets]
		,FJ.functional_impact_to_liabilities as [Functional Journal impact to liabilities]
		,FJ.functional_impact_to_equity as [Functional Journal impact to equity]
		,FJ.functional_impact_to_revenue as [Functional Journal impact to revenue]
		,FJ.functional_impact_to_expenses as [Functional Journal impact to expenses]

		,FJ.reporting_impact_to_assets as [Reporting Journal impact to assets]
		,FJ.reporting_impact_to_liabilities as [Reporting Journal impact to liabilities]
		,FJ.reporting_impact_to_equity as [Reporting Journal impact to equity]
		,FJ.reporting_impact_to_revenue as [Reporting Journal impact to revenue]
		,FJ.reporting_impact_to_expenses as [Reporting Journal impact to expenses]

		,'' as 'Audit period'
		,'' as 'Audit year'
		,'' as 'Business unit code hierarchy'
		,'' as 'Business unit description hierarchy'
		,'' as 'Business unit reference'
		,'' as 'Cash group'
		,'' as 'Interim period'
		,'' as 'Random number'
		,ey_subledger_type as [Ey subledger type]
		,ey_AR_type as [Ey AR type]
		,ey_AP_type as [Ey AP type]
		,ey_reconciliation_GL_group as [Ey reconciliation GL group]
		,TT.ey_trans_type as [Transaction type group] --added by Rajan 29th July 2014
		,TT.transaction_type_ref as [Transaction type] --added by Rajan 29th July 2014

  FROM [dbo].[FLAT_JE] FJ
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = FJ.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = FJ.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
		LEFT OUTER JOIN		 dbo.v_Transaction_type TT	ON	FJ.transaction_type_id = TT.transaction_type_id --added by Rajan 29th July 2014
	where fj.ver_end_date_id IS NULL -- Added by prabakar on July 2nd to bring latest version of data

