SELECT
	cp.year_flag_desc 
,cp.period_flag_desc 
,cp.year_flag 
,cp.period_flag 
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
--,bu_group 
--,bu_ref 
--,segment1_ref 
--,segment2_ref 
--,segment1_group 
--,segment2_group 
--,source_group 
--,Source_ref 
,bu.bu_group 
,bu.bu_ref 
,s1.ey_segment_ref 
,s2.ey_segment_ref 
,s1.ey_segment_group 
,s2.ey_segment_group 
,src.source_group 
,src.Source_ref 
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

,cp.Ey_period 

--,sys_manual_ind 
,cp.Journal_type 
,cp.preparer_ref 
,cp.department 
,cp.reporting_amount_curr_cd		as	[Reporting currency code]
,cp.functional_curr_cd		as	[Functional currency code]
,cp.Category  

FROM [dbo].GL_017_Change_in_Preparers CP
/*  added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = cp.bu_id
LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = cp.source_id
LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = cp.segment1_id
LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = cp.segment2_id
/*  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	