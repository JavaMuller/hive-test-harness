
	SELECT DISTINCT
		JE.EY_period												AS [Fiscal period]
		,JE.year_flag														AS [Year flag]
		,JE.period_flag														AS [Period flag]
		,BU.[bu_ref]														AS [Business unit]
		,BU.[bu_group]														AS [Business unit group]
		,CASE WHEN PP.year_flag ='CY' THEN 'Current'
			WHEN PP.year_flag ='PY' THEN 'Prior'
			WHEN PP.year_flag ='SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc
		END																	AS [Accounting period]
		,PP.period_flag_desc												AS [Accounting sub period]
		,PRP.preparer_ref													AS [Preparer]
		,PRP.department														AS [Preparer department]
		,ARP.preparer_ref													AS [Approver]
		,ARP.department														AS [Approver department]

		,SL1.[ey_segment_group]												AS [Segment 1 group]
		,SL1.[ey_segment_ref]												AS [Segment 1]
		,SL2.[ey_segment_group]												AS [Segment 2 group]
		,SL2.[ey_segment_ref]												AS [Segment 2]
		,SL.source_ref														AS [Source]
		,SL.source_group													AS [Source group]
		,JE.journal_type													AS [Journal Type]

		,JE.reporting_amount_curr_cd										AS [Reporting currency code]
		,JE.functional_curr_cd												AS [Functional currency code]
		,COA.ey_account_group_I AS [Account group]
		,COA.ey_account_type AS [Account Type]
		,COA.ey_account_sub_type AS [Account Sub-type]
		,COA.ey_account_class AS [Account Class]
		,COA.ey_account_sub_class AS [Account Sub-class]
		,COA.gl_account_cd AS [GL Account Cd]
		,COA.gl_account_name AS [GL Account Name]
		,COA.ey_gl_account_name AS [GL Account]

	FROM	dbo.FT_GL_Account JE --dbo.FLAT_JE JE
	LEFT OUTER JOIN		 dbo.v_Business_unit_listing BU	ON	JE.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [Parameters_period] PP	ON	JE.period_flag = PP.period_flag
	LEFT OUTER JOIN		 dbo.v_User_listing PRP			ON	JE.user_listing_id = PRP.user_listing_id
	LEFT OUTER JOIN		 dbo.v_User_listing ARP			ON	JE.approved_by_id = ARP.user_listing_id
	LEFT OUTER JOIN		 [v_Segment01_listing] SL1 ON	JE.segment1_id = SL1.ey_segment_id
	LEFT OUTER JOIN		 [v_Segment02_listing] SL2 ON	JE.segment2_id = SL2.ey_segment_id
	LEFT OUTER JOIN		v_Source_listing	SL		ON  JE.source_id = SL.source_id
	LEFT OUTER JOIN		v_Chart_of_accounts COA		ON  JE.coa_id = COA.coa_id
