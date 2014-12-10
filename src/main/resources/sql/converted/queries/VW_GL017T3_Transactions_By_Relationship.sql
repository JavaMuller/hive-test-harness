	SELECT
		full_result.gl_account_group 
		,CASE	WHEN full_result.year_flag ='CY' THEN 'Current'
					WHEN full_result.year_flag ='PY' THEN 'Prior'
					WHEN full_result.year_flag ='SP' THEN 'Subsequent'
					ELSE PP.year_flag_desc
		END 
		,PP.period_flag_desc 
		,DP.preparer_ref 
		,DP.department 
		,full_result.journal_type 
		,full_result.EY_period  -- added by prabkar on 6/14 as requested by Jonny
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 

		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,b.bu_ref 
		,b.bu_group 

		,src.source_group  

		,src.source_ref 
		,full_result.sum_of_amount 
		,full_result.sum_of_func_amount 
		,full_result.count_je_id AS  [Number of Postings]
		,full_result.reporting_amount_curr_cd		
		,full_result.functional_curr_cd		


	FROM
	(
		SELECT
			f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,'Cash & Revenue' AS gl_account_group
			,f.EY_period  -- added by prabkar on 6/14 as requested by Jonny
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd
			,SUM(case when (Pa.ey_account_type = 'Revenue' or Pa.ey_account_group_I = 'Cash' )  then ABS(F.NET_reporting_amount_credit) + ABS(f.NET_reporting_amount_debit) else 0 end)sum_of_amount
			,SUM( case when (Pa.ey_account_type = 'Revenue' or Pa.ey_account_group_I = 'Cash' )  then ABS(F.NET_functional_amount_credit) + ABS(f.NET_functional_amount_debit) else 0 end)sum_of_func_amount
			,SUM(f.count_je_id)  AS count_je_id -- , case when (Pa.ey_account_type = 'Revenue' or Pa.ey_account_group_I = 'Cash' ) then f.je_id else '' end
		FROM dbo.FT_GL_Account F -- dbo.Flat_JE F
			INNER JOIN dbo.DIM_Chart_of_Accounts pa  ON f.coa_id = pa.coa_id
		WHERE (Pa.ey_account_type = 'Revenue' or Pa.ey_account_group_I = 'Cash' )
			AND f.user_listing_id IN
					(	SELECT DISTINCT f1.user_listing_id
						FROM dbo.FT_GL_Account F1 --dbo.Flat_JE F1
							INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
							AND pa1.ey_account_type in ('Revenue')

						INTERSECT

						SELECT  DISTINCT f1.user_listing_id
						FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
							INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
							AND pa1.ey_account_group_I in ('Cash')
					)

		GROUP BY f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,f.EY_period
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd

		UNION

		SELECT
			f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,'Receivables & Payables' as gl_account_group
			,f.EY_period
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd
			,SUM(case when (Pa.ey_account_group_I = 'Accounts receivable' or Pa.ey_account_group_I = 'Accounts payable' )  then ABS(F.net_reporting_amount_credit) + ABS(f.net_reporting_amount_debit) else 0 end)sum_of_amount
			,SUM( case when (Pa.ey_account_group_I = 'Accounts receivable' or Pa.ey_account_group_I = 'Accounts payable' )  then ABS(F.net_functional_amount_credit) + ABS(f.net_functional_amount_debit) else 0 end)sum_of_func_amount
			,SUM(f.count_je_id)  AS count_je_id --, case when (Pa.ey_account_group_I = 'Accounts receivable' or Pa.ey_account_group_I = 'Accounts payable' ) then f.je_id else '' end AS count_je_id
		FROM DBO.FT_GL_Account f -- dbo.Flat_JE F
			INNER JOIN dbo.DIM_Chart_of_Accounts Pa ON f.coa_id = pa.coa_id
		WHERE (Pa.ey_account_group_I = 'Accounts payable' or Pa.ey_account_group_I =  'Accounts receivable')
			AND f.user_listing_id IN
				(	SELECT DISTINCT f1.user_listing_id
					FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
						INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
							AND pa1.ey_account_group_I in ('Accounts receivable')

					INTERSECT

					SELECT  DISTINCT f1.user_listing_id
					FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
							INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
							AND pa1.ey_account_group_I in ('Accounts payable')

				)

		GROUP BY f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,pa.ey_account_group_I
			,f.EY_period
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd

		UNION

		SELECT
			f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,'Cash & Cost of sales' as gl_account_group
			,f.EY_period  -- added by prabkar on 6/14 as requested by Jonny
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd

			,SUM(case when (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_group_I = 'Cash' )  then ABS(F.NET_reporting_amount_credit) + ABS(f.NET_reporting_amount_debit) else 0 end)sum_of_amount
			,SUM(case when (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_group_I = 'Cash' )  then ABS(F.net_functional_amount_credit) + ABS(f.net_functional_amount_debit) else 0 end)sum_of_func_amount
			,SUM(f.count_je_id)  AS count_je_id --, case when (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_group_I = 'Cash' ) then f.je_id else '' end AS count_je_id
		FROM dbo.FT_GL_Account F--dbo.Flat_JE F
			INNER JOIN dbo.DIM_Chart_of_Accounts Pa ON f.coa_id = pa.coa_id

		WHERE  (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_group_I = 'Cash' )
			AND f.user_listing_id IN
					(	SELECT DISTINCT f1.user_listing_id
						FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
							INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
								AND pa1.ey_account_sub_type in ('Cost of sales')

						INTERSECT

						SELECT  DISTINCT f1.user_listing_id
						FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
							INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
								AND pa1.ey_account_group_I in ('Cash')

					)

		GROUP BY f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,f.EY_period  -- added by prabkar on 6/14 as requested by Jonny
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd

		UNION

		SELECT
			f.user_listing_id
			,f.bu_id
			,f.source_id

			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,'Revenue & Cost of sales' as gl_account_group
			,f.EY_period  -- added by prabkar on 6/14 as requested by Jonny
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd

			,SUM(case when (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_type = 'Revenue' )  then ABS(F.net_reporting_amount_credit) + ABS(f.net_reporting_amount_debit) else 0 end)sum_of_amount
			,SUM( case when (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_type = 'Revenue' )  then ABS(F.net_functional_amount_credit) + ABS(f.net_functional_amount_debit) else 0 end)sum_of_func_amount
			,SUM(f.count_je_id)  AS count_je_id --, case when (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_type = 'Revenue' ) then f.je_id else '' end AS count_je_id
		FROM dbo.FT_GL_Account F--dbo.Flat_JE F
				   INNER JOIN dbo.DIM_Chart_of_Accounts Pa	ON f.coa_id = pa.coa_id

		WHERE (Pa.ey_account_sub_type = 'Cost of sales' or Pa.ey_account_type = 'Revenue' )
			AND f.user_listing_id IN
							(	SELECT DISTINCT f1.user_listing_id
								FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
									INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
										AND pa1.ey_account_sub_type in ('Cost of sales')

								INTERSECT

								SELECT  DISTINCT f1.user_listing_id
									FROM dbo.FT_GL_Account F1--dbo.Flat_JE F1
										INNER JOIN dbo.DIM_Chart_of_Accounts Pa1 ON f1.coa_id = pa1.coa_id
											AND pa1.ey_account_type in ('Revenue')
							)

		GROUP BY f.user_listing_id
			,f.bu_id
			,f.source_id
			,f.year_flag
			,f.period_flag
			,f.segment1_id
			,f.segment2_id
			,f.sys_man_ind
			,F.journal_type
			,f.EY_period  -- added by prabkar on 6/14 as requested by Jonny
			,f.reporting_amount_curr_cd
			,f.functional_curr_cd

	) as full_result
	INNER JOIN dbo.Parameters_period PP ON PP.year_flag = full_result.year_flag	 AND pp.period_flag = full_result.period_flag
	LEFT OUTER JOIN dbo.Dim_Preparer dp 	ON full_result.user_listing_id = dp.user_listing_id
	LEFT OUTER JOIN dbo.v_Business_unit_listing B on B.bu_id = full_result.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = full_result.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = full_result.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = full_result.segment2_id
