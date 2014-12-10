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
		AGG.coa_id							
		,COA.ey_account_type					
		,COA.ey_account_sub_type				
		,COA.ey_account_class					
		,COA.ey_account_sub_class				
		--,COA.gl_account_cd					
		,COA.gl_account_name				
		,COA.ey_gl_account_name				
		,COA.ey_gl_account_name				 -- should be removed as it's not standard
		,COA.gl_account_cd					 -- added as per standard by prabakar on july 30
		,COA.ey_account_group_I				 -- added as per standard by prabakar on july 30
		,COA.ey_account_group_II			 -- added as per standard by prabakar on july 30

		--,Net_amount						
		--,Net_amount_credit				
		--,Net_amount_debit				

		,Sys_man_ind					
		--,reversal_ind					
		,UL.preparer_ref
		,UL.department			

		--,Sys_man_ind					AS	'Journal type'
		,journal_type					

		,AGG.year_flag						
		,AGG.period_flag					
		,CASE WHEN AGG.year_flag = 'CY' THEN 'Current'
			WHEN AGG.year_flag = 'PY' THEN 'Prior'
			WHEN AGG.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc
		END  as [Accounting period]
		,PP.period_flag_desc				
		,Ey_period						


		,reporting_amount_curr_cd		
		,Net_reporting_amount			
		,Net_reporting_amount_credit	
		,Net_reporting_amount_debit		
		,functional_curr_cd				
		,net_functional_amount			
		,net_functional_amount_credit	
		,net_functional_amount_debit	

		,Bu.bu_group						
		,Bu.bu_ref							
		,DS.source_ref						
		,DS.source_group					
		,SEG1.ey_segment_ref					
		,SEG2.ey_segment_ref					
		,SEG1.ey_segment_group					
		,SEG2.ey_segment_group					
		,agg.dr_cr_ind
		-- commented below columns and added columns as part of the dyanmic changes by prabakar on july 1st -- end
	FROM	agg_acct  AGG
		INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = AGG.coa_id and COA.bu_id = AGG.bu_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.period_flag = AGG.period_flag AND PP.year_flag = AGG.year_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = AGG.user_listing_id
		LEFT OUTER JOIN [v_Source_listing] DS ON DS.source_id	= AGG.Source_Id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu ON BU.bu_id = AGG.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing Seg1 on seg1.ey_segment_id = AGG.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing Seg2 on seg2.ey_segment_id = AGG.segment2_id
