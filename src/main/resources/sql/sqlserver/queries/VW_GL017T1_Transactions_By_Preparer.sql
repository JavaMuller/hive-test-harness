	SELECT
		F.EY_period AS [Fiscal Period]
		,coa.coa_id as [COA ID]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_cd AS [Account Code]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I as [Account group]
		,UL.preparer_ref AS [Preparer]
		,UL.department AS [Preparer department]
		--,F.sys_manual_ind AS [Journal Type]
		,F.journal_type AS [Journal Type]
		,AUL.preparer_ref AS [Approver]
		,AUL.department AS [Approver Department]
		/* commented and  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		--,F.source_ref AS [Source Ref]
		--,F.segment1_ref AS [Segment 1]
		--,F.segment2_ref AS [Segment 2]
		--,f.segment1_group AS [Segment 1 Group]
		--,f.segment2_group AS [Segment 2 Group]
		--,f.source_group AS [Source group]
		--,F.bu_ref AS [Business Unit]
		--,f.bu_group AS [Business Unit Group]
		,src.source_ref AS [Source Ref]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 Group]
		,s2.ey_segment_group AS [Segment 2 Group]
		,src.source_group AS [Source group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business Unit Group]
		/* commented and added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--,f.transaction_type_group_desc as [Transaction type group]
		--,f.transaction_type as [Transaction type]
		,f.year_flag as [Year flag]
		,f.period_flag as [Period flag]
		--,f.year_flag_desc as [Accounting period]
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END AS [Accounting period]

		,pp.period_flag_desc as [Accounting sub period]
		,F.reporting_amount_curr_cd		as	[Reporting currency code]
		,F.functional_curr_cd		as	[Functional currency code]
		--,count(F.je_id) AS [Count of JE ID]
		,sum(f.count_je_id) AS [Count of JE ID]
		,count(distinct F.user_listing_id) AS [Count of distinct Preparers]
		--,count(F.je_line_id) AS [Count of JE Line ID]
		,sum(f.count_je_id)  AS [Count of JE Line ID]
		,sum(F.net_reporting_amount_credit) AS [Credit Amount]
		,sum(F.net_reporting_amount_debit) AS [Debit Amount]
		,abs(sum(F.net_reporting_amount_credit))+abs(sum(F.net_reporting_amount_debit)) AS [Net Amount]  -- added round function by prabakartr may 19th
		,abs(sum(F.net_functional_amount_credit))+abs(sum(F.net_functional_amount_debit)) AS [Functional Amount] -- added functional_amount by Ashish May 20th


	FROM dbo.FT_GL_Account F --dbo.Flat_JE F
		INNER JOIN dbo.Parameters_period PP  on pp.period_flag = f.period_flag and PP.year_flag = F.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id and coa.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN DBO.v_User_listing AUL ON AUL.user_listing_id = f.approved_by_id
	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	--WHERE F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		F.EY_period
		,coa.coa_id
		,coa.ey_account_type
		,coa.ey_account_sub_type
		,coa.ey_account_class
		,coa.ey_account_sub_class
		,coa.gl_account_cd
		,coa.ey_gl_account_name
		,coa.ey_account_group_I
		,UL.preparer_ref
		,UL.department
		--,F.sys_manual_ind
		,F.journal_type
		,AUL.preparer_ref
		,AUL.department


		/* commented and added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.source_ref
		--,F.segment1_ref
		--,F.segment2_ref
		--,f.segment1_group
		--,f.segment2_group
		--,f.source_group
		--,F.bu_ref
		--,f.bu_group

		,src.source_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group
		,bu.bu_ref
		,bu.bu_group
		/* commented and added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--,f.transaction_type_group_desc
		--,f.transaction_type
		,f.year_flag
		,f.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd