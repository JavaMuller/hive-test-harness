	SELECT
		--FJ.[je_id]  
		--,FJ.[je_line_id] 
		NULL  
		,NULL 

		,coa.gl_account_cd 
		,coa.ey_gl_account_name 
		,coa.ey_account_class 
		,FJ.EY_period 
		,FJ.year_flag 
		,FJ.period_flag 
		--,FJ.year_flag_desc  
		,CASE	WHEN FJ.year_flag ='CY' THEN 'Current'
				WHEN FJ.year_flag ='PY' THEN 'Prior'
				WHEN FJ.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc
		END 
		,PP.period_flag_desc 
		,bu.bu_ref 
		,bu.bu_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,src.Source_ref 
		,src.source_group 
		,FJ.journal_type 
		,UL.preparer_ref 
		,UL.department 
		--,AUL.department 
		--,AUL.preparer_ref 
		,NULL 
		,NULL 

		,FJ.reporting_amount_curr_cd 
		,FJ.functional_curr_cd [Functional Currency Code]

		,FJ.net_reporting_amount 
		,FJ.Net_reporting_amount_credit 
		,FJ.Net_reporting_amount_debit   
		,FJ.net_functional_amount  
		,FJ.Net_functional_amount_debit  
		,FJ.Net_functional_amount_credit 

		----,FJ.adjusted_fiscal_period 
		--(	SELECT  fc1.fiscal_period_cd
		--	FROM dbo.v_Fiscal_calendar FC1
		--	WHERE FJ.bu_id = FC1.bu_id
		--		AND FJ.ENTRY_DATE BETWEEN FC1.fiscal_period_start AND FC1.fiscal_period_end
		--		and Fc1.adjustment_period = 'N'
		--)
		, FC.fiscal_period_cd 
		,EntCal.day_number_of_week   
		,EntCal.day_of_week_desc 
		,EFFCAL.day_number_of_month AS  [Day of month]  --(entyr id , but in flat_je its effective date)

		,Net_Amount 
		,Net_Amount_Credit 
		,Net_Amount_Debit 
		,EntCal.calendar_date  
		,cd.Sequence  

	FROM dbo.FT_GL_Account FJ
		INNER JOIN Gregorian_calendar EntCal ON FJ.entry_date_id = EntCal.date_id
		INNER JOIN Gregorian_calendar EFFCAL ON FJ.effective_date_id = EFFCAL.date_id
		INNER JOIN dbo.DIM_Calendar_seq_date cd ON EntCal.calendar_date = cd.Calendar_date  --ON fj.Effective_Date = cd.Calendar_date -- changed from Effective(month) to entry (week) by prabakar on july 17

		INNER JOIN dbo.Parameters_period PP on PP.period_flag = FJ.period_flag and PP.year_flag = FJ.YEAR_FLAG
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = FJ.coa_id
		LEFT JOIN v_Fiscal_calendar FC ON  FJ.bu_id = FC.bu_id AND ENTCAL.calendar_date BETWEEN FC.fiscal_period_start AND FC.fiscal_period_end
										AND FC.adjustment_period = 'N'
		LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = FJ.user_listing_id
		--LEFT OUTER JOIN dbo.v_User_listing AUL ON UL.user_listing_id = FJ.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fJ.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fJ.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fJ.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fJ.segment2_id

