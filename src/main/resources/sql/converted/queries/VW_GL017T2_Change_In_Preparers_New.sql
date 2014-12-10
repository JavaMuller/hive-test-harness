	Select

		--PP.year_flag_desc	-- AS 	[Accounting period]
		CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc
		END 
		,PP.period_flag_desc	-- AS 	[Accounting sub period]
		,pp.year_flag	-- AS 	[Year flag]
		,PP.period_flag -- AS 	[Period Flag]
		,f.Ey_period		-- AS 	[Fiscal period]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,f.bu_id
		,f.source_id
		,f.segment1_id
		,f.segment2_id

		--,Bu.bu_group	-- AS 	[Business unit group]
		--,Bu.bu_ref	-- AS 	[Business unit]
		--,S1.segment_ref	 AS segment1_ref	--[Segement 1]
		--,S2.segment_ref	 AS segment2_ref--	[Segement 2]
		--,S1.ey_segment_group AS segment1_group	-- AS 	[Segment 1 group]
		--,S2.ey_segment_group AS segment2_group			-- AS 	[Segment 2 group]
		--,Src.ey_source_group		-- AS 	[Source group]
		--,Src.Source_ref		-- AS 	[Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,F.sys_man_ind		-- AS 	[Journal type]
		,f.journal_type
		,Dp.preparer_ref  -- AS  [Preparer]
		,Dp.department		-- AS 	[Preparer department]
		--,Dp1.department		-- AS 	[Approver department]
		--,Dp1.Preparer_Ref		-- AS 	[Approver]
		,F.reporting_amount_curr_cd		-- AS 	[Reporting currency code]
		,F.functional_curr_cd		-- AS 	[Functional currency code]
		,'New'  AS  [Category]
	FROM dbo.FT_GL_Account F--dbo.Ft_JE_Amounts F

		INNER JOIN dbo.Parameters_period PP on PP.year_flag  = f.year_flag and PP.period_flag = f.period_flag
		INNER JOIN dbo.Dim_Preparer DP on DP.user_listing_id = f.user_listing_id
		--INNER JOIN dbo.Dim_Preparer dp1 on DP1.user_listing_id = f.approved_by_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--INNER JOIN dbo.Dim_BU Bu on bu.bu_id = f.bu_id
		--INNER JOIN dbo.DIM_Source_listing  src on src.Source_Id = f.source_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 on s1.segment_id = f.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing S2 on s2.segment_id = f.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

	WHERE F.user_listing_id NOT IN (Select fl.user_listing_id from dbo.FT_GL_Account fl where fl.year_flag IN ('PY'))
	and F.year_flag='CY'