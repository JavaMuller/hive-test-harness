	SELECT
		f.bu_id
		,f.segment1_id
		,f.segment2_id
		-- commented and Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		--,f.bu_ref AS  [Business Unit]
		--,f.bu_group AS [Business unit group]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_group AS [Segment 2 group]
		--,f.segment2_ref AS [Segment 2]
		--,f.source_group AS [Source group]
		--,f.source_ref AS [Source]
		--,f.year_flag_desc AS [Accounting period]
		--,f.sys_manual_ind AS [Journal type]
		,bu.bu_ref AS  [Business Unit]
		,bu.bu_group AS [Business unit group]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref AS [Segment 2]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]

		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE f.year_flag_desc
		END AS [Accounting period]
		,f.journal_type AS [Journal type]
		-- commented and Added below dynamic views to pull bu,segment, source by prabakar on 1st july end


		,f.period_flag_desc AS [Accounting sub-period]
		,f.fiscal_period_cd AS [Fiscal period]
		,f.period_id


		,f.department AS [Preparer department]
		,f.preparer_ref AS [Preparer]
	FROM
		dbo.FLAT_JE AS f
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = F.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = F.segment2_id
		LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = f.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE
		f.year_flag != 'SP'
		and  F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		f.bu_id
		,f.segment1_id
		,f.segment2_id
		-- commented and Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		--f.bu_ref
		--,f.bu_group
		--,f.segment1_group
		--,f.segment1_ref
		--,f.segment2_group
		--,f.segment2_ref
		--,f.source_group
		--,f.source_ref

		,bu.bu_ref
		,bu.bu_group
		,s1.ey_segment_group
		,s1.ey_segment_ref
		,s2.ey_segment_group
		,s2.ey_segment_ref
		,src.source_group
		,src.source_ref
		--commented and  Added below dynamic views to pull bu,segment, source by prabakar on 1st july end

		,f.fiscal_period_cd
		,f.period_id
		--,f.sys_manual_ind
		,f.journal_type
		,f.year_flag
		,f.year_flag_desc
		,f.period_flag_desc

		,f.department
		,f.preparer_ref