	WITH agg_acct
	as
	(

		SELECT
			AGG.coa_id
			,agg.bu_id
			,agg.source_id
			,agg.year_flag
			,agg.period_flag
			,agg.Sys_man_ind
			,agg.journal_type
			,agg.dr_cr_ind
			,agg.user_listing_id
			,agg.segment1_id
			,agg.segment2_id
			,agg.Ey_period
			,reporting_amount_curr_cd
			,functional_curr_cd
			,sum(Net_reporting_amount)			as 	Net_reporting_amount
			,sum(Net_reporting_amount_credit)	as	Net_reporting_amount_credit
			,sum(Net_reporting_amount_debit)	as	Net_reporting_amount_debit

			,sum(net_functional_amount)			as	net_functional_amount
			,sum(net_functional_amount_credit)	as net_functional_amount_credit
			,sum(net_functional_amount_debit)	as net_functional_amount_debit
		FROM	dbo.FT_GL_Account  AGG
		group  by
			AGG.coa_id
			,agg.bu_id
			,agg.source_id
			,agg.year_flag
			,agg.period_flag
			,agg.Sys_man_ind
			,agg.journal_type
			,agg.dr_cr_ind
			,agg.user_listing_id
			,agg.segment1_id
			,agg.segment2_id
			,agg.Ey_period
			,reporting_amount_curr_cd
			,functional_curr_cd

	)

	SELECT
		AGG.coa_id							AS	[COA Id]
		,COA.ey_account_type					AS	[Account Type]
		,COA.ey_account_sub_type				AS	[Account Sub-type]
		,COA.ey_account_class					AS	[Account Class]
		,COA.ey_account_sub_class				AS	[Account Sub-class]
		--,COA.gl_account_cd					AS	[GL Account Code]
		,COA.gl_account_name				AS	[GL Account Name]
		,COA.ey_gl_account_name				AS	[GL Account]
		,COA.ey_gl_account_name				AS	[EY GL Account Name] -- should be removed as it's not standard
		,COA.gl_account_cd					AS	[GL Account Cd] -- added as per standard by prabakar on july 30
		,COA.ey_account_group_I				AS	[Account group] -- added as per standard by prabakar on july 30
		,COA.ey_account_group_II			AS	[Account sub group] -- added as per standard by prabakar on july 30

		--,Net_amount						AS	[Net Amount]
		--,Net_amount_credit				AS	[Net Amount Credit]
		--,Net_amount_debit				AS	[Net Amount Debit]

		,Sys_man_ind					AS	[System-Manual]
		--,reversal_ind					AS	[Rev-Non_Rev]
		,UL.preparer_ref					AS	Preparer
		,UL.department			AS	[Preparer department]

		--,Sys_man_ind					AS	'Journal type'
		,journal_type					AS	[Journal type]

		,AGG.year_flag						AS	[Year flag]
		,AGG.period_flag					AS	[Period flag]
		,CASE WHEN AGG.year_flag = 'CY' THEN 'Current'
			WHEN AGG.year_flag = 'PY' THEN 'Prior'
			WHEN AGG.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc
		END  as [Accounting period]
		,PP.period_flag_desc				AS	[Accounting sub period]
		,Ey_period						AS	[Fiscal period]


		,reporting_amount_curr_cd		AS	[Reporting currency code]
		,Net_reporting_amount			AS	[Net reporting amount]
		,Net_reporting_amount_credit	AS	[Net reporting credit amount]
		,Net_reporting_amount_debit		AS	[Net reporting debit amount]
		,functional_curr_cd				AS	[Functional currency code]
		,net_functional_amount			AS	[Net functional amount]
		,net_functional_amount_credit	AS	[Net functional credit amount]
		,net_functional_amount_debit	AS	[Net functional debit amount]

		,Bu.bu_group						AS	[Business unit group]
		,Bu.bu_ref							AS	[Business Unit]
		,DS.source_ref						AS	[Source]
		,DS.source_group					AS	[Source group]
		,SEG1.ey_segment_ref					AS	[Segment 1]
		,SEG2.ey_segment_ref					AS	[Segment 2]
		,SEG1.ey_segment_group					AS	[Segment 1 group]
		,SEG2.ey_segment_group					AS	[Segment 2 group]
		,agg.dr_cr_ind					[Indicator]
		-- commented below columns and added columns as part of the dyanmic changes by prabakar on july 1st -- end
	FROM	agg_acct  AGG
		INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = AGG.coa_id and COA.bu_id = AGG.bu_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.period_flag = AGG.period_flag AND PP.year_flag = AGG.year_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = AGG.user_listing_id
		LEFT OUTER JOIN [v_Source_listing] DS ON DS.source_id	= AGG.Source_Id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu ON BU.bu_id = AGG.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing Seg1 on seg1.ey_segment_id = AGG.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing Seg2 on seg2.ey_segment_id = AGG.segment2_id
