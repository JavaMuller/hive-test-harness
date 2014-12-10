	Select
		F.ey_account_type AS [Account Type]
		,F.ey_account_sub_type AS [Account Sub-type]
		,F.ey_account_class AS [Account Class]
		,F.ey_account_sub_class AS [Account Sub-class]
		,F.ey_gl_account_name AS [GL Account Name]
		,F.gl_account_cd AS [GL Account Code]
		,F.ey_gl_account_name AS [GL Account]

		,F.effective_date AS [Effective Date]
		,F.entry_date AS [Entry Date]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group AS [Business unit group]
		--,f.bu_ref AS [Business unit]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_group AS [Segment 2 group]
		--,f.segment2_ref AS [Segment 2]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref AS [Business unit]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--,f.year_flag_desc AS [Accounting period]
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
					WHEN f.year_flag ='PY' THEN 'Prior'
					WHEN f.year_flag ='SP' THEN 'Subsequent'
					ELSE f.year_flag_desc
		END AS [Accounting period]
		,f.year_flag AS [Year flag]
		,f.period_flag_desc AS [Accounting sub period]
		,f.period_flag AS [Period flag]
		,f.EY_period AS [Fiscal period]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.source_group AS [Source group]
		--,F.source_ref AS [Source]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,f.sys_manual_ind AS [Journal type]
		,f.journal_type AS [Journal type]
		,f.department AS [Preparer department]
		,F.preparer_ref AS [Preparer]
		,f.approver_department AS [Approver department]
		,f.approver_ref AS [Approver]
		,sum(f.reporting_amount) AS [Net reporting amount]
		,sum(F.reporting_amount_credit) AS [Net reporting amount credit]
		,sum(F.reporting_amount_debit) AS [Net reporting amount debit]
		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,sum(f.[functional_amount]) AS [Net functional amount]
		,sum(f.[functional_credit_amount])  AS [Net functional amount credit]
		,sum(f.[functional_debit_amount]) AS [Net functional amount debit]
		,f.functional_curr_cd AS [Functional Currency Code]

	FROM  dbo.flat_JE F INNER JOIN Parameters_period pa ON f.year_flag = pa.year_flag
				AND f.period_flag = pa.period_flag
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	WHERE F.entry_date > F.effective_date
		AND CASE WHEN pa.period_flag = 'IP' THEN pa.end_date END < f.entry_date

	GROUP BY
		F.ey_account_type
		,F.ey_account_sub_type
		,F.ey_account_class
		,F.ey_account_sub_class
		,F.ey_gl_account_name
		,F.gl_account_cd
		,F.ey_gl_account_name
		,F.effective_date
		,F.entry_date
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.bu_group
		--,f.bu_ref
		--,f.segment1_group
		--,f.segment1_ref
		--,f.segment2_group
		--,f.segment2_ref
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_group
		,s1.ey_segment_ref
		,s2.ey_segment_group
		,s2.ey_segment_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,f.year_flag_desc
		,f.year_flag
		,f.period_flag_desc
		,f.period_flag
		,f.EY_period
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,f.source_group
		--,F.source_ref
		,src.source_group
		,src.source_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,f.sys_manual_ind
		,f.journal_type
		,f.department
		,F.preparer_ref
		,f.approver_department
		,f.approver_ref
		,f.functional_curr_cd
		,f.reporting_amount_curr_cd