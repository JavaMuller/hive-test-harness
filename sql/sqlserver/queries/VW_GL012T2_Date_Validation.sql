	SELECT
		DV.COA_ID							AS	[Coa Id]
		,DV.year_flag						AS	[Year flag]
		,DV.period_flag					AS	[Period flag]
		,CASE	WHEN DV.year_flag ='CY' THEN 'Current'
				WHEN DV.year_flag ='PY' THEN 'Prior'
				WHEN DV.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
				END AS [Accounting period]
		,pp.Period_flag_desc				AS	[Accounting sub period]
		,DV.ey_period						AS	[Fiscal period]
		,DV.entry_date						AS	[Entry Date]
		,DV.Effective_date					AS	[Effective Date]
		,DV.min_max_ent_eff_date			AS	[Min Max Date]
		,DV.category						AS	[Category]
		,DV.je_id_count					AS	[Count of JE]
		,DV.days_lag						AS	[Days Lag]
		,0		AS	[Days Entry After Effective]
		,src.Source_ref						AS	[Source]
		,src.Source_group					AS	[Source group]
		,UL.Preparer_ref					AS	[Preparer]
		,UL.department			AS	[Preparer department]
		,coa.gl_Account_cd					AS	[Account Code]
		,coa.ey_gl_account_name				AS	[GL Account]
		,coa.ey_account_type					AS	[Account Type]
		,coa.ey_account_sub_type				AS	[Account Sub Type]
		,coa.ey_account_class				AS	[Account Class]
		,coa.ey_account_sub_class				AS	[Account Sub Class]
		,coa.ey_account_group_I				AS	[Account Group]
		,bu.bu_ref							AS	[Business Unit]
		,bu.bu_group						AS	[Business unit group]
		--,DV.sys_manual_ind					AS	[Journal Type]
		,DV.journal_type					AS	[Journal Type]
		,s1.ey_segment_ref					AS	[Segment 1]
		,s2.ey_segment_ref					AS	[Segment 2]
		,s1.ey_segment_group					AS	[Segment 1 group]
		,s2.ey_segment_group					AS	[Segment 2 group]
		,AUL.department			AS	[Approver department]
		,AUL.preparer_ref		AS	[Approver]
		,DV.functional_curr_cd				AS	[Functional Currency Code]
		,DV.reporting_amount_curr_cd		AS	[Reporting currency code]
		,DV.net_reporting_amount			AS	[Net reporting amount]
		,DV.net_reporting_amount_credit	AS	[Net reporting amount credit]
		,DV.net_reporting_amount_debit		AS	[Net reporting amount debit]
		,DV.net_functional_amount			AS	[Net functional amount]
		,DV.net_functional_credit_amount	AS	[Net functional amount credit]
		,DV.net_functional_debit_amount	AS	[Net functional amount debit]

	FROM	dbo.[GL_012_Date_Validation] DV
		INNER JOIN DBO.v_Chart_of_accounts  coa on COA.coa_id = DV.coa_id
		INNER JOIN dbo.Parameters_period	PP on PP.period_flag = DV.period_flag AND PP.year_flag = dv.year_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = dv.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = dv.approver_by_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = DV.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = DV.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = DV.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = DV.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
