	SELECT
			CASE WHEN FJ.year_flag = 'CY' THEN 'Current'
				WHEN FJ.year_flag = 'PY' THEN 'Prior'
				WHEN FJ.year_flag = 'SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
			END	AS [Accounting period]
			,PP.period_flag_desc AS [Accounting sub period]
			,FJ.EY_period AS [Fiscal period]
			,coa.ey_account_type AS [Account Type]
			,coa.ey_account_sub_type AS [Account Sub-type]
			,coa.ey_account_class AS [Account Class]
			,coa.ey_account_sub_class AS [Account Sub-class]
			,coa.gl_account_name AS [Account Name]
			,coa.gl_account_cd AS [Account Number]
			,coa.gl_account_cd  AS [GL Account Cd]
			,coa.ey_gl_account_name AS [GL Account]
			,coa.ey_account_group_I  AS [Account group]
			,Ul.preparer_ref  AS [Preparer]
			,ul.department  AS [Preparer department]
			,aul.department AS [Approver department]
			,aul.preparer_ref AS [Approver]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			--,FJ.bu_group  AS  [Business unit group]
			--,FJ.bu_ref  AS [Business Unit]
			--,FJ.segment1_group AS [Segment 1 group]
			--,FJ.segment1_ref AS [Segment 1]
			--,FJ.segment2_group AS [Segment 2 group]
			--,FJ.segment2_ref  AS [Segment 2]
			--,FJ.source_group  AS  [Source group]
			--,FJ.source_ref  AS [Source]
			,bu.bu_group  AS  [Business unit group]
			,bu.bu_ref  AS [Business Unit]
			,s1.ey_segment_group AS [Segment 1 group]
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_group AS [Segment 2 group]
			,s2.ey_segment_ref  AS [Segment 2]
			,src.source_group  AS  [Source group]
			,src.source_ref  AS [Source]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,FJ.journal_type  AS [Journal type]
			,FJ.functional_curr_cd AS [Functional Currency Code]
			,FJ.reporting_amount_curr_cd  AS [Reporting Currency Code]
			,'Activity' AS [Source Type]
			--,CAST(FJ.Entry_Date AS nvarchar(11)) AS [Entry Date]
			--,CAST(FJ.Effective_Date AS nvarchar(11)) AS [Effective Date]
			--,FJ.Entry_Date AS [Entry Date]
			--,FJ.Effective_Date AS [Effective Date]
			,CONVERT(DATETIME,CONVERT(VARCHAR(10),Fj.entry_date_id,101),101) AS [Entry Date]
			,CONVERT(DATETIME,CONVERT(VARCHAR(10),Fj.effective_date_id,101),101) AS [Effective Date]

			,sum(FJ.net_reporting_amount)  AS  [Net reporting amount]
			,sum(FJ.net_reporting_amount_credit) AS [Net reporting credit amount]
			,sum(FJ.net_reporting_amount_debit) AS [Net reporting debit amount]
			,sum(FJ.net_functional_amount) AS  [Net functional amount]
			,sum(FJ.net_functional_amount_credit) AS  [Net functional credit amount]
			,sum(FJ.net_functional_amount_debit)  AS  [Net functional debit amount]

		FROM dbo.FT_GL_Account FJ--dbo.FLAT_JE FJ
			INNER JOIN  dbo.v_Chart_of_accounts coa on coa.coa_id = FJ.coa_id and COA.bu_id = FJ.bu_id
			LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = FJ.user_listing_id
			LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = FJ.approved_by_id
			LEFT OUTER JOIN dbo.Parameters_period pp ON PP.period_flag = FJ.period_flag
								AND PP.year_flag = FJ.year_flag
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

			LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
			LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
			LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
			LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--where FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd

		GROUP BY

			 COA.ey_account_type
			,COA.ey_account_sub_type
			,COA.ey_account_class
			,COA.ey_account_sub_class
			,COA.gl_account_name
			,COA.gl_account_cd
			,COA.ey_gl_account_name
			,COA.ey_account_group_I
			,UL.preparer_ref
			,UL.department
			,pp.period_flag_desc
			,FJ.EY_period
			,AUL.preparer_ref
			,AUL.department
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
			--,bu_ref
			--,bu_group
			--,segment1_group
			--,segment2_group
			--,segment1_ref
			--,segment2_ref

			--,source_group
			--,source_ref
			,bu.bu_group
			,bu.bu_ref
			,s1.ey_segment_group
			,s1.ey_segment_ref
			,s2.ey_segment_group
			,s2.ey_segment_ref
			,src.source_group
			,src.source_ref
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,journal_type
			--,Entry_Date
			--,Effective_Date
			,entry_date_id
			,effective_date_id
			,reporting_amount_curr_cd
			,functional_curr_cd
			,FJ.year_flag
			,pp.year_flag_desc

	--GO
		UNION
			SELECT

				CASE WHEN pp.year_flag = 'CY' THEN 'Current'
					WHEN pp.year_flag = 'PY' THEN 'Prior'
					WHEN pp.year_flag = 'SP' THEN 'Subsequent'
					ELSE pp.year_flag_desc
				END	AS [Accounting period]
				,pp.period_flag_desc AS [Accounting sub period]
				,fc.fiscal_period_cd AS [Fiscal period]
				,coa.ey_account_type AS [Account Type]
				,coa.ey_account_sub_type AS [Account Sub-type]
				,coa.ey_account_class AS [Account Class]
				,coa.ey_account_sub_class AS [Account Sub-class]
				,coa.gl_account_name AS [Account Name]
				,coa.gl_account_cd AS [Account Number]
				,coa.gl_account_cd AS [GL Account Cd]
				,coa.ey_gl_account_name AS [GL Account]
				,coa.ey_account_group_I AS [Account Group]
				,'N/A for balances' AS [Preparer]
				,'N/A for balances' AS [Preparer department]
				,'N/A for balances' AS [Approver department]
				,'N/A for balances' AS [Approver]
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
				,bu.bu_group AS [Business unit group]
				,bu.bu_REF AS [Business unit]
				,s1.ey_segment_group AS [Segment 1 group]
				,s1.ey_segment_ref AS [Segment 1]
				,s2.ey_segment_group AS [Segment 2 group]
				,s2.ey_segment_ref  AS [Segment 2]
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
				,'N/A for balances' AS [Source group]
				,'N/A for balances' AS [Source]
				,'N/A for balances' AS [Journal type]
				,tb.functional_curr_cd AS [Functional Currency Code]
				,tb.reporting_curr_cd AS [Reporting currency code]
				,'Beginning balance' AS [Source Type]
				,NULL AS [Entry Date]
				,NULL AS [Effective Date]
				,tb.reporting_beginning_balance  AS [Net reporting amount]
				,0.0 AS [Net reporting credit amount]
				,0.0 AS [Net reporting credit amount]
				,tb.functional_beginning_balance  AS [Net functional amount]
				,0.0 AS [Net functional credit amount]
				,0.0 AS [Net functional credit amount]

			FROM dbo.TrialBalance tb

				INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
				INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
				INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
					AND fc.fiscal_year_cd = pp.fiscal_year_cd

				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
				--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
				--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
				LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
				LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
				LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

			WHERE fc.fiscal_period_seq = (
											SELECT MAX(pp1.fiscal_period_seq_end)
											FROM dbo.Parameters_period pp1
											WHERE PP1.year_flag = PP.year_flag and pp1.fiscal_year_cd = pp.fiscal_year_cd

										)
			and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
		UNION

			SELECT
				CASE WHEN pp.year_flag = 'CY' THEN 'Current'
					WHEN pp.year_flag = 'PY' THEN 'Prior'
					WHEN pp.year_flag = 'SP' THEN 'Subsequent'
					ELSE pp.year_flag_desc
				END	AS [Accounting period]
				,pp.period_flag_desc AS [Accounting sub period]
				,fc.fiscal_period_cd AS [Fiscal period]
				,coa.ey_account_type AS [Account Type]
				,coa.ey_account_sub_type AS [Account Sub-type]
				,coa.ey_account_class AS [Account Class]
				,coa.ey_account_sub_class AS [Account Sub-class]
				,coa.gl_account_name AS [Account Name]
				,coa.gl_account_cd AS [Account Number]
				,coa.gl_account_cd AS [GL Account Cd]
				,coa.ey_gl_account_name AS [GL Account]
				,coa.ey_account_group_I AS [Account Group]
				,'N/A for balances' AS [Preparer]
				,'N/A for balances' AS [Preparer department]
				,'N/A for balances' AS [Approver department]
				,'N/A for balances' AS [Approver]
				,bu.bu_group AS [Business unit group]
				,bu.bu_REF AS [Business unit]
				/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				,s1.ey_segment_group AS [Segment 1 group]
				,s1.ey_segment_ref AS [Segment 1]
				,s2.ey_segment_group AS [Segment 2 group]
				,s2.ey_segment_ref  AS  [Segment 2]
				/*  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
				,'N/A for balances' AS [Source group]
				,'N/A for balances' AS [Source]
				,'N/A for balances' AS [Journal type]
				,tb.functional_curr_cd AS [Functional Currency Code]
				,tb.reporting_curr_cd AS [Reporting currency code]
				,'Ending balance' AS [Source Type]
				,NULL AS [Entry Date]
				,NULL AS [Effective Date]
				,TB.reporting_ending_balance  AS [Net reporting amount]
				,0.0 AS [Net reporting credit amount]
				,0.0 AS [Net reporting credit amount]
				,tb.functional_ending_balance AS [Net functional amount]
				,0.0 AS [Net functional credit amount]
				,0.0 AS [Net functional credit amount]

			FROM dbo.TrialBalance tb

				INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
				INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
				INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
					AND fc.fiscal_year_cd = pp.fiscal_year_cd

			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
				--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
				--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
				LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
				LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
				LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			WHERE fc.fiscal_period_seq = (
											SELECT MAX(pp1.fiscal_period_seq_end)
											FROM dbo.Parameters_period pp1
											WHERE PP1.year_flag = PP.year_flag AND pp1.fiscal_year_cd = pp.fiscal_year_cd
										)
			and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd

