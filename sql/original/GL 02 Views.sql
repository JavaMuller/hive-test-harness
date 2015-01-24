
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_Agg_GL_Account]')) Drop VIEW [dbo].[VW_Agg_GL_Account] 
GO

CREATE	VIEW	[dbo].[VW_Agg_GL_Account]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FT_GL_ACCOUNT --GL_005_Agg_GL_Account
Script Date:	16/06/2014
Created By:		
Version:		2
Sample Command:	SELECT	*	FROM	[dbo].[VW_Agg_GL_Account]
History:		Updated the select statement to have gl accound code, and gl account name 
************************************************************************************************************************************************/
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
		AGG.coa_id							AS	[COA Id]
		,COA.ey_account_type					AS	[Account Type]
		,COA.ey_account_sub_type				AS	[Account Sub-type]
		,COA.ey_account_class					AS	[Account Class]
		,COA.ey_account_sub_class				AS	[Account Sub-class]
		--,COA.gl_account_cd					AS	[GL Account Code]
		,COA.gl_account_name				AS	[GL Account Name]
		,COA.ey_gl_account_name				AS	[GL Account]
		,COA.ey_gl_account_name				AS	[EY GL Account Name] -- should be removed as it's not standard
		,COA.gl_account_cd					AS	[GL Account Cd] -- added as per standard by prabakar on july 30
		,COA.ey_account_group_I				AS	[Account group] -- added as per standard by prabakar on july 30
		,COA.ey_account_group_II			AS	[Account sub group] -- added as per standard by prabakar on july 30
				
		--,Net_amount						AS	[Net Amount]
		--,Net_amount_credit				AS	[Net Amount Credit]
		--,Net_amount_debit				AS	[Net Amount Debit]
		
		,Sys_man_ind					AS	[System-Manual]
		--,reversal_ind					AS	[Rev-Non_Rev]
		,UL.preparer_ref					AS	Preparer
		,UL.department			AS	[Preparer department]

		--,Sys_man_ind					AS	'Journal type'
		,journal_type					AS	[Journal type]
						
		,AGG.year_flag						AS	[Year flag]
		,AGG.period_flag					AS	[Period flag]
		,CASE WHEN AGG.year_flag = 'CY' THEN 'Current'
			WHEN AGG.year_flag = 'PY' THEN 'Prior'
			WHEN AGG.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc 
		END  as [Accounting period] 
		,PP.period_flag_desc				AS	[Accounting sub period]
		,Ey_period						AS	[Fiscal period]
				
		
		,reporting_amount_curr_cd		AS	[Reporting currency code]
		,Net_reporting_amount			AS	[Net reporting amount]
		,Net_reporting_amount_credit	AS	[Net reporting credit amount]
		,Net_reporting_amount_debit		AS	[Net reporting debit amount]
		,functional_curr_cd				AS	[Functional currency code]
		,net_functional_amount			AS	[Net functional amount]
		,net_functional_amount_credit	AS	[Net functional credit amount]
		,net_functional_amount_debit	AS	[Net functional debit amount]
		
		,Bu.bu_group						AS	[Business unit group]
		,Bu.bu_ref							AS	[Business Unit]
		,DS.source_ref						AS	[Source]
		,DS.source_group					AS	[Source group]
		,SEG1.ey_segment_ref					AS	[Segment 1]
		,SEG2.ey_segment_ref					AS	[Segment 2]
		,SEG1.ey_segment_group					AS	[Segment 1 group]
		,SEG2.ey_segment_group					AS	[Segment 2 group]
		,agg.dr_cr_ind					[Indicator]
		-- commented below columns and added columns as part of the dyanmic changes by prabakar on july 1st -- end
	FROM	agg_acct  AGG
		INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = AGG.coa_id and COA.bu_id = AGG.bu_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.period_flag = AGG.period_flag AND PP.year_flag = AGG.year_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = AGG.user_listing_id
		LEFT OUTER JOIN [dbo].[v_Source_listing] DS ON DS.source_id	= AGG.Source_Id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu ON BU.bu_id = AGG.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing Seg1 on seg1.ey_segment_id = AGG.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing Seg2 on seg2.ey_segment_id = AGG.segment2_id

		
GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_Balance_By_GL]')) Drop VIEW [dbo].VW_Balance_By_GL
GO

CREATE VIEW [dbo].[VW_Balance_By_GL]

AS
/**********************************************************************************************************************************************
Description:	View for fetching data from GL_016_Balance_By_GL
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_Balance_By_GL]
History:		
************************************************************************************************************************************************/

	SELECT   
		gl.coa_id AS [COA Id] 
		,gl.ey_account_type AS [Account Type]
		,gl.ey_account_sub_type AS [Account Sub-type]
		,gl.ey_account_class AS [Account Class]
		,gl.ey_account_sub_class AS [Account Sub-class]
		,gl.gl_account_cd AS [GL Account Code]
		,gl.gl_account_name AS [GL Account Name]
		,gl.ey_gl_account_name AS [GL Account]
		,gl.ey_account_group_I [Account group]
		,gl.department AS [Preparer department]
		,gl.preparer_ref AS [Preparer]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,source_group AS  [Source group]
		--,source_ref AS [Source]
		--,segment1_ref AS [Segment 1]	 
		--,segment2_ref AS [Segment 2]	 
		--,segment1_group AS  [Segment 1 group] 
		--,segment2_group AS  [Segment 2 group]
		--,bu_group AS  [Business unit group]
		--,bu_ref AS  [Business unit]
		
		,isnull(src.source_group,'N/A for balances') AS [Source group]  -- Is null condition was added outside the view to since TB wouldn't have source info
		,isnull(src.Source_ref,'N/A for balances') AS [Source] -- Is null condition was added outside the view to since TB wouldn't have source info
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref AS [Business unit]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

		,gl.year_flag_desc AS  [Accounting period]
		,gl.period_flag_desc AS  [Accounting sub period]
		,gl.year_flag AS [Year flag]
		,gl.period_flag AS [Period flag]
		,gl.ey_period AS  [Fiscal period]
		,gl.functional_curr_cd AS [Functional Currency Code]
		,gl.reporting_curr_cd AS  [Reporting currency code]
		--,' AS [Audit peirod]
		--,'' AS [Fiscal Period Id]
		--,gl.sys_manual_ind AS [Journal type]
		,gl.journal_type AS [Journal type]
		,gl.trial_balance_start_date_id
		,gl.trial_balance_end_date_id

		,gl.Beginning_balance AS [Beginning Balance] 
		,gl.Ending_balance AS [Ending Balance] 
	
		--,Calc_Ending_Bal AS [Calc Ending Balance] 
		--,Diff_between_Calc_Ending_And_Ending AS [Diff Between Calc Ending And Ending]
	
		,gl.Net_reporting_amount AS  [Net reporting amount]
		,gl.Net_functional_amount AS  [Net functional amount]

		,gl.functional_beginning_balance AS [Functional beginning balance]
		,gl.functional_ending_balance AS [Functional ending balance]
		,gl.reporting_beginning_balance AS [Reporting beginning balance]
		,gl.reporting_ending_balance AS [Reporting ending balance]
	
		,gl.Calc_reporting_ending_bal AS [Calculated reporting ending balance]
		,gl.Diff_btw_calc_end_and_report_ending AS [Diffeence between calculated ending and reporting ending]
		,gl.Calc_functional_ending_bal AS  [Calculated functional ending balance]
		,gl.Diff_btw_calc_end_and_func_ending AS [Diffeence between calculated ending and functional ending]

		--,TOTAL_CREDIT AS  [Net reporting credit amount]
		--,TOTAL_DEBIT AS  [Net reporting debit amount] 
	
		--,functional_credit_amount AS  [Net functional credit amount]
		--,functional_debit_amount AS  [Net functional debit amount]
	
	

	FROM         dbo.GL_016_Balance_By_GL gl
	 /*  added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
			LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = gl.bu_id
			LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = gl.source_id
			LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = gl.segment1_id
			LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = gl.segment2_id
		/*  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

GO

  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_Data_Stats_Blanks]')) Drop VIEW [dbo].[VW_Data_Stats_Blanks] 
GO

CREATE VIEW  [dbo].[VW_Data_Stats_Blanks] 
AS 
/**********************************************************************************************************************************************
Description:	View for fetching data from GL_016_Data_stats_blanks
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_Data_Stats_Blanks]
History:		
************************************************************************************************************************************************/
SELECT 
	[Metric_B]
	,[Metric_Count_B]
	,[Period_Type_B]
	,[Period_Flag]
	,[Column_Name]
	,[Start_Date]
	,[End_Date]
FROM  [dbo].GL_016_Data_stats_blanks  --Data_stats_blanks

GO  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_Data_Stats_Totals]')) Drop VIEW [dbo].[VW_Data_Stats_Totals] 
GO

CREATE  VIEW  [dbo].[VW_Data_Stats_Totals]  
AS 
/**********************************************************************************************************************************************
Description:	View for fetching data from GL_016_Data_stats_totals
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_Data_Stats_Totals]
History:		
************************************************************************************************************************************************/

SELECT	Metric_T
		,Metric_Count_T
		,Period_Type_T
FROM	dbo.GL_016_Data_stats_totals  -- replaced [dbo].[Data_stats_totals]
	
GO  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL004_Cashflow_Analysis]')) Drop VIEW [dbo].[VW_GL004_Cashflow_Analysis] 
GO

create VIEW [dbo].[VW_GL004_Cashflow_Analysis]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Flat_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL004_Cashflow_Analysis] WHERE [source type] <> 'Activity' 
History:		
************************************************************************************************************************************************/
	
	Select 
	
		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,PP.year_flag  AS [Year flag]
		,PP.period_flag   AS [Period flag]
		,f.EY_period AS [Fiscal period]
		,f.coa_id	AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class] 
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_name AS [GL Account Name]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.ey_gl_account_name AS [GL Account] 
		,coa.ey_account_group_I AS [Account Group]
		,ISNULL(F.user_listing_id,0)	AS		[Preparer ID]							-- [Manish]23Jun2014: added on Stu's requirement for GL004
		
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.preparer_ref END AS [Preparer]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.department END AS [Preparer department]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.department END AS [Approver department]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.preparer_ref END  AS [Approver]
		
		,bu.bu_group AS [Business unit group]
		,bu.bu_REF AS [Business unit]
		,bu.bu_cd AS [Business unit code]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_group END AS [Source group]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_ref END AS [Source]
		
		,f.sys_man_ind AS [EY system manual indicator]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type AS [Journal type]
		,f.functional_curr_cd AS [Functional Currency Code]
		,f.reporting_curr_cd AS [Reporting currency code]

		,F.source_type AS [Source Type]
		

		,f.net_reporting_amount AS [Net reporting amount]
		,f.net_reporting_amount_credit AS [Net reporting amount credit]
		,f.net_reporting_amount_debit AS [Net reporting amount debit]

		,f.net_functional_amount AS [Net functional amount]
		,f.net_functional_amount_credit AS [Net functional amount credit]
		,f.net_functional_amount_debit AS [Net functional amount debit]
	
		
		,ISNULL(f.source_id,0) AS [Source id]
		,ISNULL(f.segment1_id,0) AS [segment1 id]
		,ISNULL(f.segment2_id,0) AS [segment2 id]
		,ISNULL(f.approved_by_id,0) AS [Approver ID]

	FROM dbo.GL_004_Cashflow_Analysis F
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id and coa.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
			
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	

	/*
	
	Select 

		--f.year_flag_desc AS [Accounting period]
		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE f.year_flag_desc END AS [Accounting period]
		,f.period_flag_desc AS [Accounting sub period]
		,f.EY_period AS [Fiscal period]
		,f.coa_id					AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,F.ey_account_type AS [Account Type]
		,F.ey_account_sub_type AS [Account Sub-type]
		,F.ey_account_class AS [Account Class] 
		,F.ey_account_sub_class AS [Account Sub-class]
		,F.gl_account_name AS [GL Account Name]
		,F.gl_account_cd AS [GL Account Cd]
		,F.ey_gl_account_name AS [GL Account] 
		,F.ey_account_group_I AS [Account Group]
		,F.user_listing_id	AS		[Preparer ID]							-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,F.preparer_ref AS [Preparer]
		,f.department AS [Preparer department]
		,f.approver_department AS [Approver department]
		,f.approver_ref AS [Approver]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,f.bu_group AS [Business unit group]
		--,f.bu_REF AS [Business unit]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_group AS [Segment 2 group]
		--,f.segment2_ref  AS [Segment 2]
		--,f.source_group AS [Source group]
		--,f.source_ref AS [Source]
		,bu.bu_group AS [Business unit group]
		,bu.bu_REF AS [Business unit]
		,bu.bu_cd AS [Business unit code]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		,f.sys_manual_ind AS [EY system manual indicator]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type AS [Journal type]
		,f.functional_curr_cd AS [Functional Currency Code]
		,f.reporting_amount_curr_cd AS [Reporting currency code]

		,'Activity' AS [Source Type]
		--,tb.functional_beginning_balance AS 'Functional beginning balance'
		--,tb.functional_ending_balance AS 'Functional ending balance'
		--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		--,tb.reporting_ending_balance AS 'Reporting ending balance'

		,SUM(f.reporting_amount) AS [Net reporting amount]
		,SUM(f.reporting_amount_credit) AS [Net reporting amount credit]
		,SUM(f.reporting_amount_debit) AS [Net reporting amount debit]

		,SUM(f.functional_amount) AS [Net functional amount]
		,SUM(f.functional_credit_amount) AS [Net functional amount credit]
		,SUM(f.functional_debit_amount) AS [Net functional amount debit]
	
		--,f.cash_group AS 'Cash Group' -- commented by prabakar since cash group concept is used in GL
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.source_id AS [Source id]
		,f.segment1_id AS [segment1 id]
		,f.segment2_id AS [segment2 id]
		,f.approved_by_id AS [Approver ID]
	FROM dbo.Flat_JE F
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */		
	--WHERE f.Cash_Group IS NOT NULL -- commented by prabakar based on the discussion with Amod - cash group concept is used in GL
	 where F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
 
		f.year_flag_desc
		,f.year_flag
		,f.period_flag_desc
		,f.EY_period
		,f.coa_id					-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,F.ey_account_type
		,F.ey_account_sub_type
		,F.ey_account_class
		,F.ey_account_sub_class
		,F.gl_account_name
		,F.gl_account_cd
		,F.ey_gl_account_name
		,F.ey_account_group_I
		,F.user_listing_id			-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,F.preparer_ref
		,f.department
		,f.approver_department
		,f.approver_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,f.bu_group
		--,f.bu_REF
		--,f.segment1_group
		--,f.segment1_ref
		--,f.segment2_group
		--,f.segment2_ref 
		--,f.source_group
		--,f.source_ref

		,bu.bu_group
		,bu.bu_REF 
		,bu.bu_cd
		,s1.ey_segment_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_group 
		,s2.ey_segment_ref  
		,src.source_group 
		,src.source_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		,f.sys_manual_ind
		,f.journal_type
		,f.functional_curr_cd
		,f.reporting_amount_curr_cd
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.source_id
		,f.segment1_id
		,f.segment2_id
		,f.approved_by_id

	UNION
		SELECT  
			
			CASE WHEN pp.year_flag = 'CY' THEN 'Current'
				WHEN pp.year_flag = 'PY' THEN 'Prior'
				WHEN pp.year_flag = 'SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc END
			AS [Accounting period]
			,pp.period_flag_desc AS [Accounting sub period]
			,fc.fiscal_period_cd AS [Fiscal period]
			,coa.coa_id					AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,coa.ey_account_type AS [Account Type]
			,coa.ey_account_sub_type AS [Account Sub-type]
			,coa.ey_account_class AS [Account Class] 
			,coa.ey_account_sub_class AS [Account Sub-class]
			,coa.gl_account_name AS [GL Account Name]
			,coa.gl_account_cd AS [GL Account Cd]
			,coa.ey_gl_account_name AS [GL Account] 
			,coa.ey_account_group_I AS [Account Group]
			,0 AS [Preparer ID]													-- [Manish]23Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Preparer]
			,'N/A for balances' AS [Preparer department]
			,'N/A for balances' AS [Approver department]
			,'N/A for balances' AS [Approver]
			,bu.bu_group AS [Business unit group]
			,bu.bu_REF AS [Business unit]
			,bu.bu_cd AS [Business unit code] 
			,s1.ey_segment_group AS [Segment 1 group]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_group AS [Segment 2 group]
			,s2.ey_segment_ref  AS [Segment 2]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
			,'N/A for balances' AS [Source group]
			,'N/A for balances' AS [Source]
			,'N/A for balances'		AS [EY system manual indicator]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Journal type]
			,tb.functional_curr_cd AS [Functional Currency Code]
			,tb.reporting_curr_cd AS [Reporting currency code]
			,'Beginning balance' AS [Source Type]

			,tb.reporting_beginning_balance  AS [Net reporting amount]
			,0.0 AS [Net reporting amount credit]
			,0.0 AS [Net reporting amount debit]
			,tb.functional_beginning_balance  AS [Net functional amount]
			,0.0 AS [Net functional amount credit]
			,0.0 AS [Net functional amount debit]
			-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
			,0 AS [Source id]
			,tb.segment1_id AS [segment1 id]
			,tb.segment2_id AS [segment2 id]
			,0 AS [Approver ID]
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
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
							)
		and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd

	UNION
		
		SELECT  
			
			CASE WHEN pp.year_flag = 'CY' THEN 'Current'
				WHEN pp.year_flag = 'PY' THEN 'Prior'
				WHEN pp.year_flag = 'SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc END
			AS [Accounting period]
			,pp.period_flag_desc AS [Accounting sub period]
			,fc.fiscal_period_cd AS [Fiscal period]
			,coa.coa_id					AS [Chart of account ID]				-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,coa.ey_account_type AS [Account Type]
			,coa.ey_account_sub_type AS [Account Sub-type]
			,coa.ey_account_class AS [Account Class] 
			,coa.ey_account_sub_class AS [Account Sub-class]
			,coa.gl_account_name AS [GL Account Name]
			,coa.gl_account_cd AS [GL Account Cd]
			,coa.ey_gl_account_name AS [GL Account] 
			,coa.ey_account_group_I AS [Account Group]
			,0 AS 	[Preparer ID]												-- [Manish]23Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Preparer]
			,'N/A for balances' AS [Preparer department]
			,'N/A for balances' AS [Approver department]
			,'N/A for balances' AS [Approver]
			,bu.bu_group AS [Business unit group]
			,bu.bu_REF AS [Business unit]
			,bu.bu_cd AS [Business unit code]
			,s1.ey_segment_group AS [Segment 1 group]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_group AS [Segment 2 group]
			,s2.ey_segment_ref  AS [Segment 2]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
			,'N/A for balances' AS [Source group]
			,'N/A for balances' AS [Source]
			,'N/A for balances'		AS [EY system manual indicator]				-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [Journal type]
			,tb.functional_curr_cd AS [Functional Currency Code]
			,tb.reporting_curr_cd AS [Reporting currency code]
			,'Ending balance' AS [Source Type]

			,TB.reporting_ending_balance  AS [Net reporting amount]
			,0.0 AS [Net reporting amount credit]
			,0.0 AS [Net reporting amount debit]
			,tb.functional_ending_balance AS [Net functional amount]
			,0.0 AS [Net functional amount credit]
			,0.0 AS [Net functional amount debit]
			-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
			,0 AS [Source id]
			,tb.segment1_id AS [segment1 id]
			,tb.segment2_id AS [segment2 id]
			,0 AS [Approver ID]
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
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								)
		and  tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd */

GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL008_JE_Search]')) Drop VIEW [dbo].[VW_GL008_JE_Search]
GO

CREATE	VIEW	[dbo].[VW_GL008_JE_Search]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from GL_008_JE_Search
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL008_JE_Search]
History:		
V2			20141009		MSH		Table reference change - performance improvements
************************************************************************************************************************************************/
	SELECT 
		 FT_GL.Journal_entry_id AS [Journal Entry Id]
		,FT_GL.Journal_entry_line AS [Journal Entry Line]
		,FT_GL.Journal_entry_description AS [Journal Entry Header Description]
		,FT_GL.Journal_entry_type AS [Journal Entry Type]
		,FT_GL.Journal_line_description as [Journal Entry Line Desciption]
		,ul.preparer_ref as   [Preparer]
		,ul.department as  [Preparer department]
		,SL.source_ref  as [Source]
		,SL.source_group  as  [Source group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business unit group]
		,SG1.ey_segment_group as  [Segment 1 group]
		,SG2.ey_segment_group as  [Segment 2 group]
		,SG1.ey_segment_ref as  [Segment 1]
		,SG2.ey_segment_ref as  [Segment 2]
		,PP.period_flag_desc as  [Accounting sub period]
		,FT_GL.ey_period as  [Fiscal period]
		,CASE WHEN FT_GL.year_flag = 'CY' THEN 'Current'
			WHEN FT_GL.year_flag = 'PY' THEN 'Prior'
			WHEN FT_GL.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc 
		END  as [Accounting period]
	
	FROM dbo.GL_008_JE_Search FT_GL
	INNER JOIN dbo.Parameters_period PP on PP.period_flag = FT_GL.period_flag AND PP.year_flag = FT_GL.year_flag
	LEFT OUTER JOIN dbo.v_User_listing ul on ul.user_listing_id = FT_GL.user_listing_id 
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on FT_GL.bu_id = bu.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing SL on FT_GL.source_id = SL.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing SG1 on SG1.ey_segment_id = FT_GL.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing SG2 on SG2.ey_segment_id = FT_GL.segment2_id
	
GO

  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL008_JE_Search_Amount]')) Drop VIEW [dbo].[VW_GL008_JE_Search_Amount]
GO

CREATE	VIEW	[dbo].[VW_GL008_JE_Search_Amount]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Flat JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL008_JE_Search_Amount]
History:		
V2			20141009		MSH		Table reference change - performance improvements
************************************************************************************************************************************************/

	SELECT  
		Journal_entry_id  AS [Journal Entry Id]
		,Journal_entry_line  AS [Journal Entry Line]
		,Journal_entry_description  AS [Journal Entry Description]
		,Journal_entry_type  AS [Journal Entry Type]
		,Reporting_amount  AS [Reporting Amount]
		,Functional_amount AS [Functional Amount]
 		,ul.preparer_ref as   [Preparer]
		,ul.department as  [Preparer department]
		,SL.source_ref  as [Source]
		,SL.source_group  as  [Source group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business unit group]
		,SG1.ey_segment_group as  [Segment 1 group]
		,SG2.ey_segment_group as  [Segment 2 group]
		,SG1.ey_segment_ref as  [Segment 1]
		,SG2.ey_segment_ref as  [Segment 2]
		,PP.period_flag_desc as  [Accounting sub period]
		,FT_GL.ey_period as  [Fiscal period]
		,CASE WHEN FT_GL.year_flag = 'CY' THEN 'Current'
			WHEN FT_GL.year_flag = 'PY' THEN 'Prior'
			WHEN FT_GL.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc 
		END  as [Accounting period]
	
	FROM dbo.GL_008_JE_Search FT_GL
	INNER JOIN dbo.Parameters_period PP on PP.period_flag = FT_GL.period_flag AND PP.year_flag = FT_GL.year_flag
	LEFT OUTER JOIN dbo.v_User_listing ul on ul.user_listing_id = FT_GL.user_listing_id 
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on FT_GL.bu_id = bu.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing SL on FT_GL.source_id = SL.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing SG1 on SG1.ey_segment_id = FT_GL.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing SG2 on SG2.ey_segment_id = FT_GL.segment2_id
	
GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL008_JE_Search_Description]')) Drop VIEW [dbo].[VW_GL008_JE_Search_Description]
GO

CREATE	VIEW	[dbo].[VW_GL008_JE_Search_Description]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Flat JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL008_JE_Search_Description]
History:		
V2			20141009		MSH		Table reference change - performance improvements
************************************************************************************************************************************************/
	SELECT 
		Journal_entry_id AS [Journal Entry Id] 
		,Journal_entry_line  AS [Journal Entry Line]
		,Journal_line_description  AS [Journal Line Description]  -- added by prabakar on july 28
		,Journal_entry_description  AS [Journal Entry Description]
		,Journal_entry_type AS [Journal Entry Type]
		,ul.preparer_ref as   [Preparer]
		,ul.department as  [Preparer department]
		,SL.source_ref  as [Source]
		,SL.source_group  as  [Source group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business unit group]
		,SG1.ey_segment_group as  [Segment 1 group]
		,SG2.ey_segment_group as  [Segment 2 group]
		,SG1.ey_segment_ref as  [Segment 1]
		,SG2.ey_segment_ref as  [Segment 2]
		,PP.period_flag_desc as  [Accounting sub period]
		,FT_GL.ey_period as  [Fiscal period]
		,CASE WHEN FT_GL.year_flag = 'CY' THEN 'Current'
			WHEN FT_GL.year_flag = 'PY' THEN 'Prior'
			WHEN FT_GL.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc 
		END  as [Accounting period]
	
	FROM dbo.GL_008_JE_Search FT_GL
	INNER JOIN dbo.Parameters_period PP on PP.period_flag = FT_GL.period_flag AND PP.year_flag = FT_GL.year_flag
	LEFT OUTER JOIN dbo.v_User_listing ul on ul.user_listing_id = FT_GL.user_listing_id 
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on FT_GL.bu_id = bu.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing SL on FT_GL.source_id = SL.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing SG1 on SG1.ey_segment_id = FT_GL.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing SG2 on SG2.ey_segment_id = FT_GL.segment2_id
	
GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL010_Gross_Margin]')) Drop VIEW [dbo].[VW_GL010_Gross_Margin] 
GO

CREATE	VIEW	[dbo].[VW_GL010_Gross_Margin]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL010_Gross_Margin]
History:		
************************************************************************************************************************************************/
	Select 
		C.ey_account_type AS [Account Type]
		,C.ey_account_sub_type AS [Account Sub-type]
		,C.ey_account_class AS [Account Class] 
		,C.ey_account_sub_class AS [Account Sub-class] 
		,C.gl_account_name AS [GL Account Name]
		,C.gl_account_cd AS [GL Account Cd]
		,C.ey_gl_account_name AS [GL Account] 
		,C.ey_account_group_I as [Account Group]

		,F.year_flag as [Year flag]
		,F.period_flag as [Period flag]
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag = 'PY' THEN 'Prior' 
			WHEN pp.year_flag = 'SP' THEN 'Subsequent' 
			ELSE pp.year_flag_desc END as  [Accounting period]
		,pp.period_flag_desc as  [Accounting sub period]
		,F.ey_period as  [Fiscal period]

		,Dp.preparer_ref AS [Preparer]
		,Dp.department as [Preparer department]
		,Dp1.department AS [Approver department]
		,Dp1.preparer_ref AS [Approver]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		,Src.source_ref AS [Source]
		--,Src.ey_source_group as  [Source group]
		,src.source_group as  [Source group]
		--,S1.segment_ref as [Segment 1]
		,s1.ey_segment_ref as [Segment 1]
		,S1.ey_segment_group as  [Segment 1 group] 
		--,S2.segment_ref as [Segment 2]
		,s2.ey_segment_ref as [Segment 2]
		,S2.ey_segment_group as  [Segment 2 group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
	
		,Bu.bu_group as  [Business unit group]
		,Bu.bu_ref as  [Business unit]

		--,F.sys_manual_ind as [Journal type]
		,F.journal_type as [Journal type]
	
		,F.reporting_amount_curr_cd as  [Reporting currency code]
		,F.functional_curr_cd AS [Functional Currency Code]
	
		,SUM(F.Net_reporting_amount) as  [Net reporting amount]
		,SUM (Case When c.ey_account_type = 'Revenue' THEN F.Net_reporting_amount ELSE 0 End) AS [Net reporting sales]
		,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.Net_reporting_amount ELSE 0 End) AS [Net reporting cost of sales]
		,SUM(F.Net_reporting_amount_credit) as  [Net reporting credit amount]
		,SUM(F.Net_reporting_amount_debit) as  [Net reporting debit amount]

		,SUM(F.Net_functional_amount) as  [Net functional amount]
		,SUM (Case When c.ey_account_type = 'Revenue' THEN F.Net_functional_amount ELSE 0 End) AS [Net functional sales]
		,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.Net_functional_amount ELSE 0 End) AS [Net functional cost of sales]
	
		,sum(F.Net_functional_amount_credit) as  [Net functional credit amount]  
		,sum(F.Net_functional_amount_debit) as  [Net functional debit amount]  	

		--,F.seg1_ref_id AS 'Segment 1 desc'  -- Need to map with segment1_listing
		--,F.seg2_ref_id AS 'Segment 2 desc' -- Need to map with segment2_listing
		--,sum(F.functional_amount) AS 'Amount in Functional Currency'
		--,SUM (Case When Pa.EY_GL_Account_group = 'Revenue' THEN F.functional_amount ELSE 0 End) AS 'Sales in Functional Currency'
		--,SUM (Case When Pa.EY_GL_Account_group = 'Cost of sales' THEN F.functional_amount ELSE 0 End) AS 'Cost of Sales in Functional Currency'

		/*COMMENTED AS PER DISCUSSION WITH SPOTFIRE 6-5
		--,sum(F.net_amount) AS 'Net Amount'
		--,SUM (Case When c.ey_account_type = 'Revenue' THEN F.[net_amount] ELSE 0 End) AS 'Sales'
		--,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.[net_amount] ELSE 0 End) AS 'Cost of Sales'
		--,SUM (Case When c.ey_account_type = 'Revenue' THEN F.Net_functional_amount ELSE 0 End) AS 'Sales in Functional Currency'
		--,SUM (Case When c.ey_account_sub_type = 'Cost of sales' THEN F.Net_functional_amount ELSE 0 End) AS 'Cost of Sales in Functional Currency'
		COMMENTED AS PER DISCUSSION WITH SPOTFIRE*/

	FROM dbo.FT_GL_Account F --dbo.Ft_JE_Amounts F
		INNER JOIN dbo.Dim_Chart_of_Accounts C ON F.coa_id = C.coa_id
		INNER JOIN dbo.Dim_Preparer Dp ON Dp.user_listing_id = F.user_listing_id
		INNER JOIN dbo.Dim_Preparer Dp1 ON Dp1.user_listing_id = F.approved_by_id
		INNER JOIN dbo.Parameters_period PP ON pp.year_flag = F.year_flag
				AND pp.period_flag	 = F.period_flag

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.dim_BU Bu ON F.bu_id = Bu.bu_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 ON S1.segment_id = F.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing s2 ON S2.segment_id = F.segment2_id
		--INNER JOIN dbo.dim_source_listing Src ON F.source_id = Src.source_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		--WHERE ey_gl_account_group IN ('Revenue','Cost of sales') 
  
	GROUP BY
		 C.ey_account_type
		,C.ey_account_sub_type
		,C.ey_account_class
		,C.ey_account_sub_class
		,C.gl_account_name
		,C.gl_account_cd
		,C.ey_gl_account_name 
		,c.ey_account_group_I
		,F.year_flag 
		,F.period_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,F.ey_period
		,Dp.preparer_ref
		,Dp.department
		,Dp1.department 
		,Dp1.preparer_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,Src.source_ref
		--,Src.ey_source_group
		,src.source_group
		,S1.ey_segment_group  
		,S2.ey_segment_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		--,S1.segment_ref
		--,S2.segment_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,Bu.bu_group
		,Bu.bu_ref 
		--,F.sys_manual_ind
		,f.journal_type
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd
		,pp.year_flag
GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL011_Relationship_Analyses]')) Drop VIEW [dbo].[VW_GL011_Relationship_Analyses] 
GO

CREATE	 VIEW [dbo].[VW_GL011_Relationship_Analyses]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL011_Relationship_Analyses]
History:		
************************************************************************************************************************************************/
	
	
	
	Select
		--PP.year_flag_desc AS 'Accounting period'
		CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,PP.Period_flag_desc AS [Accounting sub period]
		,F.year_flag as [Year flag]
		,F.period_flag as [Period flag]
		,F.ey_period AS [Fiscal period]
		,C.ey_account_type AS [Account Type]
		,C.ey_account_sub_type AS [Account Sub-type]
		,C.ey_account_class AS [Account Class] 
		,C.ey_account_sub_class AS [Account Sub-class] 
		,C.gl_account_name AS [GL Account Name]
		,C.gl_account_cd AS [GL Account Cd]
		,C.ey_gl_account_name AS [GL Account] 
		,c.ey_account_group_I as [Account Group]
		,Dp.preparer_ref AS [Preparer]
		,DP.department AS [Preparer department]
		,DP1.department AS [Approver department]
		,DP1.preparer_ref AS [Approver]

		,B.bu_group AS [Business unit group]
		,b.bu_ref AS [Business unit]

		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		--,src.ey_source_group AS [Source group]

		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,src.source_group AS [Source group]
		--Commented and added the dynamic view by prabakar on july 1st -- END
		,src.source_Ref AS [Source]
		--,f.sys_manual_ind AS 'Journal type'
		,f.journal_type AS [Journal type]
		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,f.functional_curr_cd AS   [Functional currency code]
	
		,sum(f.Net_reporting_amount) AS [Net reporting amount]
		,sum(f.Net_reporting_amount_credit) AS [Net reporting amount credit]
		,sum(f.Net_reporting_amount_debit) AS [Net reporting amount debit]
	
		,sum(f.Net_functional_amount) AS [Net functional amount]
		,sum(f.Net_functional_amount_credit) AS [Net functional amount credit]
		,sum(f.Net_functional_amount_debit) AS [Net functional amount debit]
		, 'Activity' AS [Source type]

		-- Added 3 columns: Amod Oak on 6-26-2013
		, NULL AS [Period end date]
		, NULL AS [Fiscal period sequence]
		, NULL AS [Fiscal period sequence end]


	FROM dbo.FT_GL_Account F --dbo.Ft_JE_Amounts F
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = f.year_flag
			AND PP.period_flag = f.period_flag
		INNER JOIN dbo.Dim_Preparer DP on DP.user_listing_id = f.user_listing_id
		LEFT OUTER JOIN dbo.Dim_Preparer DP1 on DP1.user_listing_id = f.approved_by_id
		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--INNER JOIN dbo.dim_BU B on B.bu_id = F.bu_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 on s1.segment_id = f.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing S2 on s2.segment_id = f.segment2_id
		--INNER JOIN dbo.dim_source_listing Src  on  Src.Source_Id = f.source_id
		LEFT OUTER  JOIN dbo.v_Business_unit_listing B on B.bu_id = F.bu_id
		LEFT OUTER  JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = f.segment1_id
		LEFT OUTER  JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = f.segment2_id
		LEFT OUTER  JOIN dbo.v_Source_listing Src  on  Src.Source_Id = f.source_id

		--Commented and added the dynamic view by prabakar on july 1st -- end
		INNER JOIN dbo.DIM_Chart_of_Accounts C on c.Coa_id = f.coa_id

	GROUP BY
  
		PP.year_flag_desc
		,PP.Period_flag_desc
		,F.year_flag
		,F.period_flag
		,F.ey_period
		,C.ey_account_type
		, C.ey_account_sub_type
		, C.ey_account_class
		, C.ey_account_sub_class
		, C.gl_account_name
		, C.gl_account_cd
		, C.ey_gl_account_name
		,c.ey_account_group_I
		,Dp.preparer_ref
		,DP.department
		,DP1.department
		,DP1.preparer_ref
		,B.bu_group
		,b.bu_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		--Commented and added the dynamic view by prabakar on july 1st -- BEGIN
		--,s1.segment_ref
		--,s2.segment_ref
		--,src.ey_source_group
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,src.source_group
		--Commented and added the dynamic view by prabakar on july 1st -- end
		,src.source_Ref
		--,f.sys_manual_ind
		,f.journal_type
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd

		/*
		Following UNION added by Amod Oak to reflect ending balances    
		*/

UNION

	SELECT	
	CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,pp.Period_flag_desc AS [Accounting sub period]
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,fc.fiscal_period_cd AS [Fiscal period]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class] 
		,coa.ey_account_sub_class AS [Account Sub-class] 
		,coa.gl_account_name AS [GL Account Name]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.ey_gl_account_name AS [GL Account] 
		,coa.ey_account_group_I as [Account Group]
		,'N/A for balances' AS [Preparer]
		,'N/A for balances'  AS [Preparer department]
		,'N/A for balances'  AS [Approver department]
		,'N/A for balances'  AS [Approver]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref AS [Business unit]

		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		--Commented and added the dynamic view by prabakar on july 1st -- BEGIN
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		--Commented and added the dynamic view by prabakar on july 1st -- end
		,'N/A for balances'  AS [Source group]
		,'N/A for balances'  AS [Source]
		
		,'N/A for balances'  AS [Journal type]
		,tb.reporting_curr_cd AS [Reporting currency code]
		,tb.functional_curr_cd AS   [Functional currency code]
	
		,tb.reporting_ending_balance AS [Net reporting amount]
		,0.0 AS [Net reporting amount credit]
		,0.0 AS [Net reporting amount debit]
	
		,tb.functional_ending_balance AS [Net functional amount]
		,0.0 AS [Net functional amount credit]
		,0.0 AS [Net functional amount debit]
		, 'Balance' AS [Source type]

		-- Added 3 columns: Amod Oak on 6-26-2013
		, pp.end_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]


		-- Changed FROM clause: Amod Oak on 6-26-2013
	FROM dbo.TrialBalance tb
		INNER JOIN DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			AND tb.bu_id = fc.bu_id
		INNER JOIN Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd

		--Commented and added the dynamic view by prabakar on july 1st -- begin
		--INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER  JOIN dbo.v_Business_unit_listing Bu on Bu.bu_id = tb.bu_id
		LEFT OUTER  JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER  JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		--Commented and added the dynamic view by prabakar on july 1st -- end
		where tb.ver_end_date_id IS NULL  -- Added by prabakar to pull the latest version of data on July 2nd
		AND 
		(
			(
				(pp.period_flag = 'IP' OR pp.period_flag = 'PIP') 
				--AND  fc.fiscal_period_seq <= pp.fiscal_period_seq_end 
			)
			OR 
			(
				(pp.period_flag = 'RP' OR pp.period_flag = 'PRP') 
				--AND fc.fiscal_period_seq <= pp.fiscal_period_seq_end 
				--AND fc.fiscal_period_seq > (
				--								SELECT MIN(pp1.fiscal_period_seq_end) 
				--								FROM dbo.Parameters_period pp1 
				--								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
				--								and pp1.year_flag = pp.year_flag
				--							)
			)
			OR (pp.period_flag = 'SP') --and fc.fiscal_period_seq < pp.fiscal_period_seq_end )
		)
		

GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL012T2_Date_Validation]')) Drop VIEW [dbo].[VW_GL012T2_Date_Validation]
GO

CREATE	VIEW	[dbo].[VW_GL012T2_Date_Validation]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from reporting table dbo.GL_012_Date_Validation
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL012T2_Date_Validation]
History:		
************************************************************************************************************************************************/

	SELECT
		DV.COA_ID							AS	[Coa Id]
		,DV.year_flag						AS	[Year flag]
		,DV.period_flag					AS	[Period flag]
		,CASE	WHEN DV.year_flag ='CY' THEN 'Current'
				WHEN DV.year_flag ='PY' THEN 'Prior'
				WHEN DV.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
				END AS [Accounting period]
		,pp.Period_flag_desc				AS	[Accounting sub period]
		,DV.ey_period						AS	[Fiscal period]
		,DV.entry_date						AS	[Entry Date]
		,DV.Effective_date					AS	[Effective Date]
		,DV.min_max_ent_eff_date			AS	[Min Max Date]
		,DV.category						AS	[Category]
		,DV.je_id_count					AS	[Count of JE]
		,DV.days_lag						AS	[Days Lag]
		,0		AS	[Days Entry After Effective]
		,src.Source_ref						AS	[Source]
		,src.Source_group					AS	[Source group]
		,UL.Preparer_ref					AS	[Preparer]
		,UL.department			AS	[Preparer department]
		,coa.gl_Account_cd					AS	[Account Code]
		,coa.ey_gl_account_name				AS	[GL Account]	
		,coa.ey_account_type					AS	[Account Type]
		,coa.ey_account_sub_type				AS	[Account Sub Type]
		,coa.ey_account_class				AS	[Account Class]
		,coa.ey_account_sub_class				AS	[Account Sub Class]
		,coa.ey_account_group_I				AS	[Account Group]
		,bu.bu_ref							AS	[Business Unit]
		,bu.bu_group						AS	[Business unit group]
		--,DV.sys_manual_ind					AS	[Journal Type]
		,DV.journal_type					AS	[Journal Type]
		,s1.ey_segment_ref					AS	[Segment 1]
		,s2.ey_segment_ref					AS	[Segment 2]
		,s1.ey_segment_group					AS	[Segment 1 group]
		,s2.ey_segment_group					AS	[Segment 2 group]
		,AUL.department			AS	[Approver department]
		,AUL.preparer_ref		AS	[Approver]
		,DV.functional_curr_cd				AS	[Functional Currency Code]
		,DV.reporting_amount_curr_cd		AS	[Reporting currency code]
		,DV.net_reporting_amount			AS	[Net reporting amount]
		,DV.net_reporting_amount_credit	AS	[Net reporting amount credit]
		,DV.net_reporting_amount_debit		AS	[Net reporting amount debit]
		,DV.net_functional_amount			AS	[Net functional amount]
		,DV.net_functional_credit_amount	AS	[Net functional amount credit]
		,DV.net_functional_debit_amount	AS	[Net functional amount debit]

	FROM	dbo.[GL_012_Date_Validation] DV
		INNER JOIN DBO.v_Chart_of_accounts  coa on COA.coa_id = DV.coa_id
		INNER JOIN dbo.Parameters_period	PP on PP.period_flag = DV.period_flag AND PP.year_flag = dv.year_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = dv.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = dv.approver_by_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = DV.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = DV.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = DV.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = DV.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL012T3_Date_Analysis]')) Drop VIEW [dbo].[VW_GL012T3_Date_Analysis] 
GO

CREATE VIEW [dbo].[VW_GL012T3_Date_Analysis]
--WITH SCHEMABINDING
AS

/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL012T3_Date_Analysis]
History:		
************************************************************************************************************************************************/

	SELECT
		--FJ.[je_id]  AS [Je Id]
		--,FJ.[je_line_id] AS [Je Line Id]
		NULL  AS [Je Id]
		,NULL AS [Je Line Id]

		,coa.gl_account_cd AS [Account Code]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_class AS [Account Class]
		,FJ.EY_period AS [Fiscal period]
		,FJ.year_flag AS [Year flag]
		,FJ.period_flag AS [Period flag]
		--,FJ.year_flag_desc  as [Accounting period]
		,CASE	WHEN FJ.year_flag ='CY' THEN 'Current'
				WHEN FJ.year_flag ='PY' THEN 'Prior'
				WHEN FJ.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc   
		END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,bu.bu_ref AS [Business unit]
		,bu.bu_group AS [Business unit group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.Source_ref AS [Source]
		,src.source_group AS [Source group]
		,FJ.journal_type AS [Journal type]
		,UL.preparer_ref as [Preparer]
		,UL.department AS [Preparer department]
		--,AUL.department AS [Approver department]
		--,AUL.preparer_ref AS [Approver]
		,NULL AS [Approver department]
		,NULL AS [Approver]

		,FJ.reporting_amount_curr_cd AS [Reporting currency code]
		,FJ.functional_curr_cd [Functional Currency Code]

		,FJ.net_reporting_amount AS [Net reporting amount]
		,FJ.Net_reporting_amount_credit AS [Net reporting amount credit]
		,FJ.Net_reporting_amount_debit   AS [Net reporting amount debit]
		,FJ.net_functional_amount  AS [Net functional amount]
		,FJ.Net_functional_amount_debit  AS [Net functional amount debit]
		,FJ.Net_functional_amount_credit AS [Net functional amount credit]

		----,FJ.adjusted_fiscal_period AS [Adjusted fiscal period]
		--(	SELECT  fc1.fiscal_period_cd 
		--	FROM dbo.v_Fiscal_calendar FC1 
		--	WHERE FJ.bu_id = FC1.bu_id 
		--		AND FJ.ENTRY_DATE BETWEEN FC1.fiscal_period_start AND FC1.fiscal_period_end
		--		and Fc1.adjustment_period = 'N'
		--) 
		, FC.fiscal_period_cd AS [Adjusted fiscal period]
		,EntCal.day_number_of_week   AS [Day number of week]
		,EntCal.day_of_week_desc AS [Day Of Week]
		,EFFCAL.day_number_of_month AS  [Day of month]  --(entyr id , but in flat_je its effective date)
		
		,Net_Amount as [Amount]
		,Net_Amount_Credit as [Amount_Credit]
		,Net_Amount_Debit as [Amount_Debit]
		,EntCal.calendar_date  AS [Calendar date]
		,cd.Sequence  AS [Sequence number]
		
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


	  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL012T4_Booking_Patterns]')) Drop VIEW [dbo].[VW_GL012T4_Booking_Patterns] 
GO

CREATE VIEW [dbo].[VW_GL012T4_Booking_Patterns]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL012T4_Booking_Patterns]
History:		
************************************************************************************************************************************************/

	
	SELECT
		--COUNT(FJ.je_id) as [JE COUNT]
		--,COUNT(FJ.[je_line_id]) AS [Line Count]

		SUM(FJ.COUNT_JE_ID) as [JE COUNT]
		,SUM(FJ.COUNT_JE_ID) AS [Line Count]

		,ROUND(SUM(FJ.[net_amount]),2) as [Amount]
		,COA.[ey_account_class] AS [Account Class]
		,COA.ey_gl_account_name AS [GL Account]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,FJ.bu_ref	as [Business Unit]
		--,FJ.bu_group AS [Business unit group]
		--,FJ.segment1_group AS [Segment 1 group]
		--,FJ.segment1_ref AS [Segment 1]
		--,FJ.segment2_group  AS [Segment 2 group]
		--,FJ.segment2_ref  AS [Segment 2]
		--,FJ.source_group AS [Source group]
		--,FJ.source_ref AS [Source]

		,bu.bu_ref	as [Business Unit]
		,bu.bu_group AS [Business unit group]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group  AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,FJ.year_flag_desc AS [Accounting period]
		,CASE	WHEN FJ.year_flag ='CY' THEN 'Current'
				WHEN FJ.year_flag ='PY' THEN 'Prior'
				WHEN FJ.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]

		,PP.period_flag_desc AS [Accounting sub period]
		,FJ.EY_period AS [Fiscal period]
		
		--,FJ.sys_manual_ind AS [Journal type]
		,FJ.journal_type AS [Journal type]
		,ul.department AS [Preparer department]
		,ul.preparer_ref as [Preparer]		
		,aul.department AS [Approver department]
		,aul.preparer_ref AS [Approver]
		,FJ.functional_curr_cd as [Functional Currency Code]
		,FJ.reporting_amount_curr_cd AS [Reporting currency code]

		,FJ.journal_type as [System Manual Indicator]

		--,ROUND(SUM(FJ.functional_amount),2) AS [Functional Amount]
		--,ROUND(SUM(FJ.functional_credit_amount),2) AS [Functional Amount Credit]
		--,ROUND(SUM(FJ.functional_debit_amount),2) AS [Functional Amount Debit]
		
		,FJ.reversal_ind AS [Reversal indicator flag]  -- changed by Amod
		,CASE WHEN FJ.reversal_ind='Y' THEN 'Reversal' 
			WHEN FJ.reversal_ind='N' THEN 'Non-Reversal' 
			ELSE 'None' 
		END AS [Reversal Indicator]

		
		
		,SUM(FJ.NET_reporting_amount) AS [Net reporting amount]
		,SUM(FJ.NET_reporting_amount_credit) AS [Net reporting amount credit]
		,SUM(FJ.NET_reporting_amount_debit) AS [Net reporting amount debit]
		
		,SUM(FJ.NET_functional_amount) AS [Net functional amount]
		,SUM(FJ.NET_functional_amount_credit) AS [Net functional amount credit]
		,SUM(FJ.NET_functional_amount_debit) AS [Net functional amount debit]

		
	FROM dbo.FT_GL_Account FJ--dbo.FLAT_JE FJ
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = FJ.coa_id and coa.bu_id = FJ.bu_id
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = fj.year_flag and PP.period_flag = FJ.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on ul.user_listing_id =FJ.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on Aul.user_listing_id = FJ.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fJ.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fJ.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fJ.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fJ.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */		
	--where FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		COA.ey_account_class
		,COA.ey_gl_account_name 
		
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,FJ.bu_ref
		--,FJ.bu_group
		--,FJ.segment1_ref
		--,FJ.segment2_ref
		--,FJ.segment1_group
		--,FJ.segment2_group
		--,FJ.Source_ref
		--,FJ.source_group
		
		,bu.bu_ref
		,bu.bu_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,src.Source_ref 
		,src.source_group 
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,FJ.year_flag
		,fj.period_flag
		,PP.year_flag_desc 
		,PP.period_flag_desc 
		,FJ.EY_period
		--,FJ.sys_man_ind
		,FJ.journal_type
		,ul.department 
		,ul.preparer_ref 
		,aul.department 
		,aul.preparer_ref 
		,FJ.functional_curr_cd 
		,FJ.reporting_amount_curr_cd
		
		,FJ.reversal_ind
		
GO  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL013T1_Back_Postings1]')) Drop VIEW [dbo].[VW_GL013T1_Back_Postings1] 
GO

CREATE	VIEW	[dbo].[VW_GL013T1_Back_Postings1]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL013T1_Back_Postings1]
History:		
************************************************************************************************************************************************/

	SELECT
		fj.coa_id AS [Coa Id]
		,fj.ey_account_type AS [Account Type]
		,fj.ey_account_sub_type AS [Account Sub-type]
		,fj.ey_account_class AS [Account Class]
		,fj.ey_account_sub_class AS [Account Sub-class]
		,fj.gl_account_cd AS [GL Account Cd]
		,fj.gl_account_name AS [GL Account Name]
		,fj.ey_gl_account_name	 AS [GL Account] 
		,fj.bu_id AS [BU Id] 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,fj.bu_ref AS [Business unit] 
		--,fj.bu_group AS [Business unit group] 
		--,fj.segment1_id AS [Segment 1 Id] 
		--,fj.segment1_ref AS [Segment 1] 
		--,fj.segment1_group AS [Segment 1 group] 
		--,fj.segment2_id AS [Segment 2 Id] 
		--,fj.segment2_ref AS [Segment 2] 
		--,fj.segment2_group AS [Segment 2 group] 
		,bu.bu_ref AS [Business unit] 
		,bu.bu_group AS [Business unit group] 
		,fj.segment1_id AS [Segment 1 Id] 
		,s1.ey_segment_ref AS [Segment 1] 
		,s1.ey_segment_group AS [Segment 1 group] 
		,fj.segment2_id AS [Segment 2 Id] 
		,s2.ey_segment_ref AS [Segment 2] 
		,s2.ey_segment_group AS [Segment 2 group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */

		,fj.functional_curr_cd AS [Functional Currency Code] 
		,fj.reporting_amount_curr_cd AS [Reporting currency code] 
		,fj.period_flag  AS [Period flag] 
		,fj.year_flag AS [Year flag] 
		,CASE WHEN fj.year_flag = 'CY' THEN 'Current'	
			WHEN fj.year_flag = 'PY' THEN 'Prior'
			WHEN fj.year_flag = 'SP' THEN 'Subsequent'
			ELSE fj.year_flag_Desc 
		END AS [Accounting period] 
		,fj.period_flag_desc AS [Accounting sub period]
		,SUM(functional_amount) AS [Net functional amount]
		,SUM(reporting_amount) AS [Net reporting amount]
		,fj.ver_end_date_id AS [Version end date Id]
		,fj.ver_desc AS [Version description]
		,'Backposting activity' AS [Source type]
	FROM dbo.flat_je fj 
	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
		--LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
	/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

	WHERE fj.period_flag = 'IP'
	AND fj.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
	GROUP BY  
		fj.coa_id
		,fj.gl_account_cd
		,fj.gl_account_name
		,fj.ey_gl_account_name
		,fj.bu_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,fj.bu_ref
		--,fj.bu_group
		--,fj.segment1_id
		--,fj.segment1_ref
		--,fj.segment1_group
		--,fj.segment2_id
		--,fj.segment2_ref
		--,fj.segment2_group

		,bu.bu_ref
		,bu.bu_group 
		,fj.segment1_id 
		,s1.ey_segment_ref 
		,s1.ey_segment_group 
		,fj.segment2_id 
		,s2.ey_segment_ref 
		,s2.ey_segment_group 

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,fj.functional_curr_cd
		,fj.reporting_amount_curr_cd
		,fj.period_flag 
		,fj.year_flag 
		,fj.year_flag_desc
		,fj.ver_end_date_id
		,fj.ver_desc
		,fj.ey_account_type 
		,fj.ey_account_sub_type 
		,fj.ey_account_class 
		,fj.ey_account_sub_class 
		,period_flag_desc
		
	UNION

	SELECT 
		tb.coa_id AS [Coa Id] 
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Cd] 
		,coa.gl_account_name AS [GL Account Name] 
		,coa.ey_gl_account_name AS [GL Account] 
		,tb.bu_id AS [BU Id] 
		,bu.bu_ref AS [Business unit] 
		,bu.bu_group AS [Business unit group] 
		,tb.segment1_id AS [Segment 1 Id] 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,s1.segment_ref AS [Segment 1] 
		,s1.ey_segment_ref  AS [Segment 1]
		,s1.ey_segment_group AS [Segment 1 group] 
		,tb.segment2_id AS [Segment 2 Id] 
		--,s2.segment_ref AS [Segment 2] 
		,s2.ey_segment_ref AS [Segment 2] 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,s2.ey_segment_group AS [Segment 2 group] 
		,tb.functional_curr_cd AS [Functional Currency Code] 
		,tb.reporting_curr_cd AS [Reporting currency code] 
		,pp.period_flag  AS [Period flag] 
		,pp.year_flag  AS [Year flag] 
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag = 'PY' THEN 'Prior'
			WHEN pp.year_flag = 'SP' THEN 'Subsequent'
		ELSE pp.year_flag_desc 
		END AS [Accounting period] 
		,pp.period_flag_desc AS [Accounting sub period]
		,tb.functional_beginning_balance +  ag.net_functional_amount as [Net functional amount]
		,tb.reporting_beginning_balance + ag.net_reporting_amount as [Net reporting amount]
		,NULL AS [Version end date Id]
		,NULL AS [Version description]
		,'Interim as posted' AS [Source type]
	FROM dbo.TrialBalance tb
		FULL OUTER JOIN 
		(
			SELECT 
				fj.coa_id
				,fj.gl_account_cd
				,fj.gl_account_name
				,fj.ey_gl_account_name
				,fj.bu_id
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				--,fj.bu_ref AS [Business unit] 
				--,fj.bu_group AS [Business unit group] 
				--,fj.segment1_id AS [Segment 1 Id] 
				--,fj.segment1_ref AS [Segment 1] 
				--,fj.segment1_group AS [Segment 1 group] 
				--,fj.segment2_id AS [Segment 2 Id] 
				--,fj.segment2_ref AS [Segment 2] 
				--,fj.segment2_group AS [Segment 2 group] 
				,bu.bu_ref AS [Business unit] 
				,bu.bu_group AS [Business unit group] 
				,fj.segment1_id AS [Segment 1 Id] 
				,s1.ey_segment_ref AS [Segment 1] 
				,s1.ey_segment_group AS [Segment 1 group] 
				,fj.segment2_id AS [Segment 2 Id] 
				,s2.ey_segment_ref AS [Segment 2] 
				,s2.ey_segment_group AS [Segment 2 group]
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				,fj.functional_curr_cd
				,fj.reporting_amount_curr_cd
				,fj.period_flag 
				,fj.year_flag 
				,fj.year_flag_desc
				,fj.ver_end_date_id
				,fj.ver_desc
				,SUM(functional_amount) AS net_functional_amount
				,SUM(reporting_amount) AS net_reporting_amount
			FROM dbo.flat_je fj
				/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
				LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
				--LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
				LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
				LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
				/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
			WHERE fj.period_flag = 'IP'
			AND fj.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
			GROUP BY  
				fj.coa_id
				,fj.gl_account_cd
				,fj.gl_account_name
				,fj.ey_gl_account_name
				,fj.bu_id
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
				--,fj.bu_ref
				--,fj.bu_group
				--,fj.segment1_id
				--,fj.segment1_ref
				--,fj.segment1_group
				--,fj.segment2_id
				--,fj.segment2_ref
				--,fj.segment2_group

				,bu.bu_ref
				,bu.bu_group 
				,fj.segment1_id 
				,s1.ey_segment_ref 
				,s1.ey_segment_group 
				,fj.segment2_id 
				,s2.ey_segment_ref 
				,s2.ey_segment_group 
				/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
				,fj.functional_curr_cd
				,fj.reporting_amount_curr_cd
				,fj.period_flag 
				,fj.year_flag 
				,fj.year_flag_desc
				,fj.ver_end_date_id
				,fj.ver_desc
			) ag ON ag.coa_id = tb.coa_id
			AND ag.bu_id = tb.bu_id
			-- Since Possible that Segment info may be be null in TrialBalance -- prabakar
			--AND ag.segment1_id = tb.segment1_id
			--AND ag.segment2_id = tb.segment2_id
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
			AND fc.fiscal_year_cd = pp.fiscal_year_cd
		
		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.dim_bu bu ON tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = tb.segment2_id
		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

		
	WHERE pp.period_flag = 'IP'
	AND tb.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
	UNION

	SELECT 
		tb.coa_id AS [Coa Id] 
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class]
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Cd] 
		,coa.gl_account_name AS [GL Account Name] 
		,coa.ey_gl_account_name AS [GL Account] 
		,tb.bu_id AS [BU Id] 
		,bu.bu_ref AS [Business unit] 
		,bu.bu_group AS [Business unit group] 
		,tb.segment1_id AS [Segment 1 Id]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		--,s1.segment_ref AS [Segment 1] 
		,s1.ey_segment_ref AS [Segment 1] 
		,s1.ey_segment_group AS [Segment 1 group] 
		,tb.segment2_id AS [Segment 2 Id] 
		--,s2.segment_ref AS [Segment 2] 
		,s2.ey_segment_ref AS [Segment 2] 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		,s2.ey_segment_group AS [Segment 2 group] 
		,tb.functional_curr_cd AS [Functional Currency Code] 
		,tb.reporting_curr_cd AS [Reporting currency code] 
		,pp.period_flag  AS [Period flag] 
		,pp.year_flag  AS [Year flag] 
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag = 'PY' THEN 'Prior'
			WHEN pp.year_flag = 'SP' THEN 'Subsequent'
		ELSE pp.year_flag_desc END AS [Accounting period] 
		,pp.period_flag_desc AS [Accounting sub period]
		,tb.functional_ending_balance AS [Net functional amount]
		,tb.reporting_ending_balance AS [Net reporting amount]
		,NULL AS [Version end date Id]
		,NULL AS [Version description]
		,'Interim as shown' AS [Source type]
	FROM dbo.TrialBalance tb
		
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
			AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.dim_bu bu ON tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id

		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = tb.segment2_id
		/* Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
	WHERE pp.period_flag = 'IP'
	AND tb.ver_end_date_id  IS NULL -- Added by prabakar on july 2nd
	
GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL013T1_Back_Postings2]')) Drop VIEW [dbo].[VW_GL013T1_Back_Postings2] 
GO

CREATE VIEW [dbo].[VW_GL013T1_Back_Postings2]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL013T1_Back_Postings2]
History:		
************************************************************************************************************************************************/
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
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[VW_GL015T1_Cutoff_Analysis]')) DROP VIEW [dbo].[VW_GL015T1_Cutoff_Analysis]
GO

CREATE VIEW [dbo].[VW_GL015T1_Cutoff_Analysis]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		2
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL015T1_Cutoff_Analysis]
History:		Replaced the old view with new one select with union of a cutoff analysis
************************************************************************************************************************************************/
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

	
GO

  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL016T2_Non_Balanced_JE]')) Drop VIEW [dbo].[VW_GL016T2_Non_Balanced_JE] 
GO

CREATE VIEW [dbo].[VW_GL016T2_Non_Balanced_JE]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL016T2_Non_Balanced_JE]
History:		
************************************************************************************************************************************************/
	SELECT 
		je_id as [JE Id]
		,year_flag_desc AS [Accounting period]
		,COUNT(je_id) AS [Number of journal entries]
	FROM  
		(
			SELECT     je_id,SUM(Net_reporting_amount) AS Net_Amount,pp.year_flag_desc
			FROM          dbo.Ft_JE_Amounts f  --dbo.FLAT_JE
			INNER JOIN dbo.Parameters_period	 PP ON PP.year_flag = f.year_flag and pp.period_flag = f.period_flag
			--WHERE ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
			GROUP BY je_id,pp.year_flag_desc
			HAVING      (SUM(ROUND(Net_reporting_amount,2))<> 0)
		) AS sub1
	
	GROUP BY 
		year_flag_desc
		,je_id
GO
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL016T2_Zero_Balance_GL]')) Drop VIEW [dbo].[VW_GL016T2_Zero_Balance_GL] 
GO

CREATE VIEW [dbo].[VW_GL016T2_Zero_Balance_GL]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL016T2_Zero_Balance_GL]
History:		
************************************************************************************************************************************************/

	SELECT 
		fj.coa_id AS [Coa Id] 
		,coa.gl_account_cd AS [GL account code]
		,CASE WHEN fj.year_flag = 'CY' THEN 'Current'
			WHEN fj.year_flag = 'PY' THEN 'Prior'
			WHEN fj.year_flag = 'SP' THEN 'Subsequent' 
			ELSE pp.year_flag_desc
		END	AS [Accounting period]
		,NULL AS [Functional beginning balance]
		,NULL AS [Functional ending balance]
		,NULL AS [Reporting beginning balance]
		,NULL AS [Reporting ending balance]
		,'Journal entries with GL accounts not in trial balance' AS [Type]
		, NULL AS 'FPS'
	FROM dbo.FT_GL_Account FJ--dbo.flat_je fj
		INNER JOIN  dbo.v_Chart_of_accounts coa  on coa.coa_id = fj.coa_id
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and pp.year_flag = fj.year_flag
	WHERE gl_account_cd NOT IN  (
									SELECT DISTINCT coa.gl_account_cd
									FROM dbo.trialbalance tb
											INNER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.coa_id = tb.coa_id
											WHERE TB.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
								) 
		--AND FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	
	UNION

		SELECT 
			tb.coa_id AS [Coa Id]
			,coa.gl_account_cd AS [GL account code]
			,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
				WHEN pp.year_flag = 'PY' THEN 'Prior'
				WHEN pp.year_flag = 'SP' THEN 'Subsequent' 
			END	AS [Accounting period]
			,ROUND(tb.functional_beginning_balance,2) AS [Functional beginning balance]
			,ROUND(tb.functional_ending_balance,2) AS [Functional ending balance]
			,ROUND(tb.reporting_beginning_balance,2) AS [Reporting beginning balance]
			,ROUND(tb.reporting_ending_balance,2) AS [Reporting ending balance]
			,'Active GL accounts with no balance' AS [Type]
			,fc.fiscal_period_seq AS 'FPS'
		FROM dbo.TrialBalance tb 
			INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd
			WHERE  fc.fiscal_period_seq = (
											SELECT MAX(pp1.fiscal_period_seq_end) 
											FROM dbo.Parameters_period pp1 
											WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
											and pp1.year_flag = pp.year_flag  -- Added by Prabakar on August 19 2014
										)
			AND	( (ROUND(functional_beginning_balance,2) = 0 AND ROUND(functional_ending_balance,2) = 0)
					OR (ROUND(reporting_beginning_balance,2) = 0 AND ROUND(reporting_ending_balance,2) = 0)	)
			AND tb.coa_id IN 
				(SELECT DISTINCT fj.coa_id FROM dbo.FT_GL_Account FJ--dbo.flat_je fj
					--WHERE FJ.ver_end_date_id is null
				) -- Added by prabakar to pull the latest version of data on July 2nd
			AND TB.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd	
			

GO  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T1_Transactions_By_Preparer]')) Drop VIEW [dbo].VW_GL017T1_Transactions_By_Preparer
GO

CREATE VIEW [dbo].[VW_GL017T1_Transactions_By_Preparer]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T1_Transactions_By_Preparer]
History:		
************************************************************************************************************************************************/

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


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T2_Change_in_Preparers]')) Drop VIEW [dbo].[VW_GL017T2_Change_in_Preparers] 
GO

CREATE VIEW [dbo].[VW_GL017T2_Change_in_Preparers]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from GL_017_Change_in_Preparers
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T2_Change_in_Preparers]
History:		
************************************************************************************************************************************************/

	SELECT 
		cp.year_flag_desc AS [Accounting period]
		,cp.period_flag_desc AS [Accounting sub period]
		,cp.year_flag AS [Year flag]
		,cp.period_flag AS [Period Flag]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,bu_group AS [Business unit group]
		--,bu_ref AS [Business unit]
		--,segment1_ref AS [Segement 1]
		--,segment2_ref AS [Segement 2]
		--,segment1_group AS [Segment 1 group]
		--,segment2_group AS [Segment 2 group]
		--,source_group AS [Source group]
		--,Source_ref AS [Source]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref AS [Business unit]
		,s1.ey_segment_ref AS [Segement 1]
		,s2.ey_segment_ref AS [Segement 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.source_group AS [Source group]
		,src.Source_ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

		,cp.Ey_period AS [Fiscal period]
		
		--,sys_manual_ind AS [Journal type]
		,cp.Journal_type AS [Journal type]
		,cp.preparer_ref AS [Preparer]
		,cp.department AS [Preparer department]
		,cp.reporting_amount_curr_cd		as	[Reporting currency code]
		,cp.functional_curr_cd		as	[Functional currency code]
		,cp.Category  AS [Category]

   FROM [dbo].GL_017_Change_in_Preparers CP
   /*  added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = cp.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = cp.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = cp.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = cp.segment2_id
	/*  Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T2_Change_In_Preparers_Common]')) 
	Drop VIEW [dbo].[VW_GL017T2_Change_In_Preparers_Common] 
GO

CREATE VIEW [dbo].[VW_GL017T2_Change_In_Preparers_Common]
AS

/**********************************************************************************************************************************************
Description:	View for fetching data from Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T2_Change_In_Preparers_Common]
History:		
************************************************************************************************************************************************/
Select 
		
		--PP.year_flag_desc	-- AS 	[Accounting period]
		CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [year_flag_desc]

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

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		
		,F.sys_man_ind		-- AS 	[Journal type]
		,f.journal_type
		,Dp.preparer_ref  -- AS  [Preparer]
		,Dp.department		-- AS 	[Preparer department]
		--,Dp1.department		-- AS 	[Approver department]
		--,Dp1.Preparer_Ref		-- AS 	[Approver]
		,F.reporting_amount_curr_cd		-- AS 	[Reporting currency code]
		,F.functional_curr_cd		-- AS 	[Functional currency code]
		,'Common' AS [Category]
	FROM dbo.FT_GL_Account F -- dbo.Ft_JE_Amounts F

		INNER JOIN dbo.Parameters_period PP on PP.year_flag  = f.year_flag and PP.period_flag = f.period_flag
		INNER JOIN dbo.Dim_Preparer DP on DP.user_listing_id = f.user_listing_id 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.Dim_BU Bu on bu.bu_id = f.bu_id
		--INNER JOIN dbo.DIM_Source_listing  src on src.Source_Id = f.source_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 on s1.segment_id = f.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing S2 on s2.segment_id = f.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--INNER JOIN dbo.Dim_Preparer dp1 on DP1.user_listing_id = f.approved_by_id
	--WHERE F.year_flag in ('CY', 'PY')
	WHERE F.user_listing_id IN (Select fl.user_listing_id from dbo.FT_GL_Account fl where fl.year_flag='PY') and F.year_flag='CY'
 
GO


  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T2_Change_In_Preparers_Inactive]')) Drop VIEW [dbo].[VW_GL017T2_Change_In_Preparers_Inactive]
GO

CREATE VIEW [dbo].[VW_GL017T2_Change_In_Preparers_Inactive]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T2_Change_In_Preparers_Inactive]
History:		
************************************************************************************************************************************************/

	SELECT 
		--PP.year_flag_desc	-- AS 	[Accounting period]
		CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [year_flag_desc]
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
		--,S1.ey_segment_ref	 AS segment1_ref	--[Segement 1]
		--,S2.ey_segment_ref	 AS segment2_ref--	[Segement 2]
		--,S1.ey_segment_group AS segment1_group	-- AS 	[Segment 1 group]
		--,S2.ey_segment_group AS segment2_group			-- AS 	[Segment 2 group]
		--,Src.source_group		-- AS 	[Source group]
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
		 ,'Inactive' AS [Category]
  
 FROM dbo.FT_GL_Account F--dbo.Ft_JE_Amounts F
		INNER JOIN dbo.Parameters_period PP on PP.year_flag  = f.year_flag and PP.period_flag = f.period_flag
		INNER JOIN dbo.Dim_Preparer DP on DP.user_listing_id = f.user_listing_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.Dim_BU Bu on bu.bu_id = f.bu_id
		--INNER JOIN dbo.DIM_Source_listing  src on src.Source_Id = f.source_id
		--INNER JOIN dbo.Dim_Segment01_listing S1 on s1.segment_id = f.segment1_id
		--INNER JOIN dbo.Dim_Segment02_listing S2 on s2.segment_id = f.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		 
		--INNER JOIN dbo.Dim_Preparer dp1 on DP1.user_listing_id = f.approved_by_id
 WHERE DP.active_ind<>'A'


GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T2_Change_In_Preparers_New]')) Drop VIEW [dbo].[VW_GL017T2_Change_In_Preparers_New]
GO

CREATE VIEW [dbo].[VW_GL017T2_Change_In_Preparers_New]
AS

/**********************************************************************************************************************************************
Description:	View for fetching data from ft_gl_account
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T2_Change_In_Preparers_New]
History:		
************************************************************************************************************************************************/

	Select 
		
		--PP.year_flag_desc	-- AS 	[Accounting period]
		CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [year_flag_desc]
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

 
GO


  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T2_JE_by_Relationship]')) Drop VIEW [dbo].[VW_GL017T2_JE_by_Relationship]
GO

CREATE VIEW [dbo].[VW_GL017T2_JE_by_Relationship]
AS

/**********************************************************************************************************************************************
Description:	View for fetching data from Flat_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T2_JE_by_Relationship]
History:		
************************************************************************************************************************************************/

	SELECT 
		--year_flag_desc	AS	[Accounting period]
		CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,pp.period_flag_desc	AS	[Accounting sub period]
		,F.year_flag	AS	[Year flag]
		,F.period_flag as	[Period Flag]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,F.bu_group	AS	[Business unit group]
		--,F.bu_ref	AS	[Business unit]
		--,F.segment1_ref	AS	[Segement 1]
		--,F.segment2_ref	AS	[Segement 2]
		--,F.segment1_group AS	[Segment 1 group]
		--,F.segment2_group 	AS	[Segment 2 group]
		--,F.source_group		AS	[Source group]
		--,F.Source_ref		AS	[Source]
		,bu.bu_group	AS	[Business unit group]
		,bu.bu_ref	AS	[Business unit]
		,s1.ey_segment_ref	AS	[Segement 1]
		,s2.ey_segment_ref	AS	[Segement 2]
		,s1.ey_segment_group AS	[Segment 1 group]
		,s2.ey_segment_group 	AS	[Segment 2 group]
		,src.source_group		AS	[Source group]
		,src.Source_ref		AS	[Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		,F.Ey_period		AS	[Fiscal period]
		--,F.sys_manual_ind		AS	[Journal type]
		,f.journal_type AS	[Journal type]
		,ul.preparer_ref AS [Preparer]
		,ul.department		AS	[Preparer department]
		--,F.approver_department		AS	[Approver department]
		--,F.approver_ref		AS	[Approver]
		,F.reporting_amount_curr_cd		AS	[Reporting currency code]
		,F.functional_curr_cd		AS	[Functional currency code]
		,sum(f.count_je_id) as [JE_Id_Count]
		--,COUNT(F.je_id) AS [JE_Id_Count]
		--,F.[audit_year]

	FROM dbo.FT_GL_Account F--dbo.Flat_JE F
	INNER JOIN dbo.Parameters_period PP on PP.year_flag  = f.year_flag AND PP.period_flag = F.period_flag
	LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = f.user_listing_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id
		--WHERE F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	GROUP BY
		pp.year_flag_desc
		,pp.period_flag_desc
		,F.year_flag
		,F.period_flag
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,F.bu_group
		--,F.bu_ref
		--,F.segment1_ref
		--,F.segment2_ref
		--,F.segment1_group
		--,F.segment2_group
		--,F.source_group
		--,F.Source_ref
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref	
		,s2.ey_segment_ref	
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group	
		,src.Source_ref		
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		,F.Ey_period
		--,F.sys_manual_ind
		,f.journal_type
		,ul.preparer_ref
		,ul.department
		--,F.approver_department
		--,F.approver_ref
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd

GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T3_Transactions_By_Approver]')) Drop VIEW [dbo].[VW_GL017T3_Transactions_By_Approver]
GO

CREATE VIEW [dbo].[VW_GL017T3_Transactions_By_Approver]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Flat_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL017T3_Transactions_By_Approver]
History:		
************************************************************************************************************************************************/
	Select 
		F.ey_period AS [Fiscal Period]
		--,F.sys_manual_ind AS [Journal Type] 
		,F.journal_type AS [Journal Type] 
		--, F.ey_account_type AS [Account Type]
		--, F.ey_account_sub_type AS [Account Sub-type]
		--, F.ey_account_class AS [Account Class]
		--, F.ey_account_sub_class AS [Account Sub-class]
		--, F.gl_account_cd AS [Account Code]
		--, F.ey_gl_account_name AS [GL Account]
		--,F.ey_account_group_I	as 	[Account group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--,F.segment1_group AS [Segment 1 Group]
		--,F.segment2_group AS [Segment 2 Group]
		--,F.source_group AS [Source group]
		--,F.source_ref AS [Source]
		--,F.bu_ref AS [Business Unit]
		--,F.bu_group AS [Business Unit Group]
		--,F.segment1_ref AS [Segment 1]
		--,F.segment2_ref AS [Segment 2]

		,s1.ey_segment_group AS [Segment 1 Group]
		,s2.ey_segment_group AS [Segment 2 Group]
		,src.source_group AS [Source group]
		,src.source_ref AS [Source]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business Unit Group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */		
		--,F.transaction_type_group_desc as [Transaction type group]
		--,F.transaction_type as [Transaction type]

		,UL.preparer_ref AS [Preparer]
		,UL.department AS [Preparer department]
		,AUL.preparer_ref AS [Approver]
		,AUL.department as [Approver department]
		
		,F.year_flag as [Year flag]
		,F.period_flag as [Period flag]
		--,F.year_flag_desc as [Accounting period]
		,CASE	WHEN F.year_flag ='CY' THEN 'Current'
				WHEN F.year_flag ='PY' THEN 'Prior'
				WHEN F.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc 
		END AS [Accounting period]

		,PP.period_flag_desc as [Accounting sub period]
		,F.reporting_amount_curr_cd		as	[Reporting currency code]
		,F.functional_curr_cd		as	[Functional currency code]

		,SUM(F.net_reporting_amount_debit) AS [Credit Amount]
		,SUM(F.net_reporting_amount_debit) AS [Debit Amount]
		,ABS(SUM(F.net_reporting_amount_debit))+ABS(SUM(F.net_reporting_amount_debit)) AS [Net Amount]  -- added round function by prabakartr may 19th
		,ABS(SUM(F.net_functional_amount_credit))+ABS(SUM(F.net_functional_amount_debit)) AS [Functional Amount] -- added functional_amount by Ashish May 20th
		
		--, count(F.je_id) AS [Count of JE ID]
		--, count(distinct F.user_listing_id) AS [Count of distinct Preparers]
		--, count(F.je_line_id) AS [Count of JE Line ID]
		

	FROM dbo.FT_GL_Account F --dbo.Flat_JE F
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--where F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY
		F.ey_period
		--,F.sys_man_ind
		,F.journal_type
		
		,s1.ey_segment_group
		,s2.ey_segment_group
		,src.source_group 
		,src.source_ref 
		,bu.bu_ref 
		,bu.bu_group 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,F.transaction_type_group_desc
		--,F.transaction_type
		
		,UL.preparer_ref 
		,UL.department 
		,AUL.preparer_ref
		,AUL.department
		
		,F.year_flag
		,F.period_flag
		,PP.year_flag_desc
		,PP.period_flag_desc
		,F.reporting_amount_curr_cd
		,F.functional_curr_cd

GO		  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL017T3_Transactions_By_Relationship]')) Drop VIEW [dbo].[VW_GL017T3_Transactions_By_Relationship] else print 'could not drop detail view'
GO

CREATE VIEW [dbo].[VW_GL017T3_Transactions_By_Relationship]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling data from Shared_AP_activity_details table
Script Date:	08/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[VW_GL017T3_Transactions_By_Relationship]
History:		
V1				08/05/2013   	MSH		CREATED
************************************************************************************************************************************************/


	SELECT  
		full_result.gl_account_group as [Account Group]
		,CASE	WHEN full_result.year_flag ='CY' THEN 'Current'
					WHEN full_result.year_flag ='PY' THEN 'Prior'
					WHEN full_result.year_flag ='SP' THEN 'Subsequent'
					ELSE PP.year_flag_desc 
		END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,DP.preparer_ref AS [Preparer]
		,DP.department AS [Preparer department]
		,full_result.journal_type as [Journal Type]
		,full_result.EY_period as [Fiscal period] -- added by prabkar on 6/14 as requested by Jonny
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		
		,s1.ey_segment_group AS [Segment 1 Group]
		,s2.ey_segment_group AS [Segment 2 Group]
		,b.bu_ref AS [Business Unit]
		,b.bu_group AS [Business Unit Group]
		
		,src.source_group  AS [Source group]
				
		,src.source_ref AS [Source]
		,full_result.sum_of_amount AS [Amount]
		,full_result.sum_of_func_amount AS [Functional Amount]
		,full_result.count_je_id AS  [Number of Postings]
		,full_result.reporting_amount_curr_cd		as	[Reporting currency code]
		,full_result.functional_curr_cd		as	[Functional currency code]
		
	
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

GO
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL018T1_Net_Income]')) Drop VIEW [dbo].[VW_GL018T1_Net_Income] 
GO

CREATE VIEW [dbo].[VW_GL018T1_Net_Income]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL018T1_Net_Income]
History:		
************************************************************************************************************************************************/

	SELECT
		
		COA.ey_account_type AS [Account Type]
		,COA.ey_account_class AS [Account Class]

		/* Below 4 columns wasn't presented in the original view any reason ??? */
		--,f.ey_account_sub_type AS [Account Sub-type]
		--,f.ey_account_sub_class AS [Account Sub-class]
		--,f.gl_account_cd AS [GL Account]
		--,f.gl_account_name AS [GL Account Name]

		,COA.ey_account_group_I	as	[Account group]
		,f.ey_period AS [Fiscal period]
		--,f.year_flag_desc AS [Accounting period]
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]

		,PP.period_flag_desc AS [Accounting sub period]
		,f.year_flag as [Year flag]
		,f.period_flag as [Period flag]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,f.bu_group AS [Business unit group]
		--,f.bu_ref as [Business Unit]
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_ref AS [Segment 2]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment2_group AS [Segment 2 group]
		--,f.source_group AS [Source group]
		--,f.source_ref as [Source]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.source_group AS [Source group]
		,src.source_ref as [Source]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		,UL.preparer_ref AS [Preparer]
		,UL.department AS [Preparer department]
		,AUL.department AS [Approver department]
		,AUL.preparer_ref AS [Approver]
		
		--,f.sys_manual_ind as [Journal type]
		,f.journal_type as [Journal type]
		
		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,f.functional_curr_cd AS [Functional currency code]
		--,SUM(CASE WHEN f.ey_account_type = 'Revenue' THEN f.reporting_amount ELSE 0 END) AS [Net reporting income]
		--,SUM(CASE WHEN f.ey_account_type = 'Revenue' THEN f.functional_amount ELSE 0 END) AS [Net functional income]

		,ROUND(SUM(CASE WHEN COA.ey_account_type = 'Revenue' THEN f.net_reporting_amount ELSE 0 END),2) 
			- ROUND(SUM(CASE WHEN COA.ey_account_type = 'Expenses' THEN f.net_reporting_amount ELSE 0 END),2) AS [Net reporting income]
		,ROUND(SUM(CASE WHEN COA.ey_account_type = 'Revenue' THEN f.net_functional_amount ELSE 0 END),2) 
			- ROUND(SUM(CASE WHEN COA.ey_account_type = 'Expenses' THEN f.net_functional_amount ELSE 0 END),2) AS [Net functional income]

	FROM dbo.FT_GL_Account F --dbo.FLAT_JE f
		INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = F.coa_id AND COA.bu_id = F.bu_id
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND pp.period_flag = f.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = f.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on UL.user_listing_id = f.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
	WHERE f.year_flag IN ('CY','PY')  --WHERE f.audit_period != 'Subsequent' -- based on the new CDM - updated by Prabakar 
	--and F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		coa.ey_account_type
		,coa.ey_account_class
		,f.ey_period
		,PP.year_flag_desc
		,PP.period_flag_desc
		,f.year_flag
		,f.period_flag
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,f.bu_group
		--,f.bu_ref
		--,f.segment1_ref
		--,f.segment2_ref
		--,f.segment1_group
		--,f.segment2_group
		--,f.source_group
		--,f.source_ref
		,bu.bu_group 
		,bu.bu_ref 
		,s1.ey_segment_ref 
		,s2.ey_segment_ref 
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,src.source_group 
		,src.source_ref 

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		,UL.preparer_ref
		,UL.department
		,AUL.department
		,AUL.preparer_ref
		
		--,f.sys_manual_ind
		,F.journal_type
		,COA.ey_account_group_I
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd

GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL018T1_Overview]')) Drop VIEW [dbo].[VW_GL018T1_Overview] 
GO

CREATE VIEW [dbo].[VW_GL018T1_Overview]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL018T1_Overview]
History:		
************************************************************************************************************************************************/
	SELECT
		
		coa.ey_account_type AS [Account Type]
		,coa.ey_account_class AS [Account Class]
		
		--,f.ey_account_sub_type AS [Account Sub-type]
		--,f.ey_account_sub_class AS [Account Sub-class]
		--,f.gl_account_cd AS [GL Account]
		--,f.gl_account_name AS [GL Account Name]

		,coa.ey_account_group_I AS [Account group]
		,f.ey_period AS [Fiscal period]
		--,f.year_flag_desc AS [Accounting period]
		,CASE	WHEN f.year_flag ='CY' THEN 'Current'
				WHEN f.year_flag ='PY' THEN 'Prior'
				WHEN f.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc 
		END AS [Accounting period]

		,PP.period_flag_desc AS [Accounting sub period]
		,f.year_flag as [Year flag]
		,f.period_flag as [Period flag]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,f.bu_group AS [Business unit group]
		--,f.bu_ref as [Business Unit]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		,ul.preparer_ref AS [Preparer]
		,ul.department AS [Preparer department]
		,aul.department AS [Approver department]
		,aul.preparer_ref AS [Approver]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		--,f.segment1_ref AS [Segment 1]
		--,f.segment2_ref AS [Segment 2]
		--,f.segment1_group AS [Segment 1 group]
		--,f.segment2_group AS [Segment 2 group]
		--,f.source_group AS [Source group]
		--,f.source_ref as [Source]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,src.source_group AS [Source group]
		,src.source_ref as [Source]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		--,f.sys_manual_ind as [Journal type]
		,f.journal_type as [Journal type]
		,f.reporting_amount_curr_cd AS [Reporting currency code]
		,f.functional_curr_cd AS [Functional currency code]	
	
		,ROUND(SUM (f.net_reporting_amount),2) AS [Net reporting amount]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_reporting_amount ELSE 0 END),2) 
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_reporting_amount ELSE 0 END),2) AS [Reporting margin]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_reporting_amount ELSE 0 END),2) 
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_reporting_amount ELSE 0 END),2) AS [Reporting net income]
	
		,ROUND(SUM (f.net_functional_amount),2) AS [Net functional amount]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_functional_amount ELSE 0 END),2) 
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_functional_amount ELSE 0 END),2) AS [Functional margin]
		,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN f.net_functional_amount ELSE 0 END),2) 
			+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN f.net_functional_amount ELSE 0 END),2) AS [Functional net income]
		, 'Activity' AS [Source Type]
	FROM dbo.FT_GL_Account F --dbo.FLAT_JE f
		INNER JOIN dbo.v_Chart_of_accounts coa ON coa.coa_id = F.coa_id and coa.bu_id = f.bu_id
		INNER JOIN dbo.Parameters_period PP on pp.year_flag = f.year_flag and PP.period_flag = F.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL ON AUL.user_listing_id = F.approved_by_id
	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
	WHERE f.year_flag IN ('CY','PY') --WHERE f.audit_period != 'Subsequent' -- based on the new CDM - updated by Prabakar 
	--and F.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		coa.ey_account_type
		,coa.ey_account_class
		,f.ey_period
		,PP.year_flag_desc
		,PP.period_flag_desc
		,f.year_flag
		,f.period_flag
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,f.bu_group
		--,f.bu_ref
		,bu.bu_group
		,bu.bu_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,UL.preparer_ref
		,UL.department
		,AUL.department
		,AUL.preparer_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,f.segment1_ref
		--,f.segment2_ref
		--,f.segment1_group
		--,f.segment2_group
		--,f.source_group
		--,f.source_ref
		,s1.ey_segment_ref 
		,s2.ey_segment_ref
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,src.source_group 
		,src.source_ref 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,f.sys_manual_ind
		,f.journal_type
		,COA.ey_account_group_I
		,f.reporting_amount_curr_cd
		,f.functional_curr_cd

	UNION

		SELECT 
			coa.ey_account_type AS [Account Type]
			,coa.ey_account_class AS [Account Class]
		
			--,f.ey_account_sub_type AS [Account Sub-type]
			--,f.ey_account_sub_class AS [Account Sub-class]
			--,f.gl_account_cd AS [GL Account]
			--,f.gl_account_name AS [GL Account Name]

			,coa.ey_account_group_I AS [Account group]
			,fc.fiscal_period_cd AS [Fiscal period]
			--,f.year_flag_desc AS [Accounting period]
			,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
					WHEN pp.year_flag ='PY' THEN 'Prior'
					WHEN pp.year_flag ='SP' THEN 'Subsequent'
					ELSE pp.year_flag_desc 
			END AS [Accounting period]

			,pp.period_flag_desc AS [Accounting sub period]
			,pp.year_flag as [Year flag]
			,pp.period_flag as [Period flag]
			,bu.bu_group AS [Business unit group]
			,bu.bu_ref as [Business Unit]
			,'N/A for balances' AS [Preparer]
			,'N/A for balances' AS [Preparer department]
			,'N/A for balances' AS [Approver department]
			,'N/A for balances' AS [Approver]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
			--,s1.segment_ref AS [Segment 1]
			--,s2.segment_ref AS [Segment 2]
			,s1.ey_segment_ref AS [Segment 1]
			,s2.ey_segment_ref AS [Segment 2]
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
			,s1.ey_segment_group AS [Segment 1 group]
			,s2.ey_segment_group AS [Segment 2 group]
			,'N/A for balances' AS [Source group]
			,'N/A for balances' as [Source]
			--,f.sys_manual_ind as [Journal type]
			,'N/A for balances' as [Journal type]
			,tb.reporting_curr_cd AS [Reporting currency code]
			,tb.functional_curr_cd AS [Functional currency code]	
			
			,ROUND(SUM (tb.reporting_ending_balance),2) AS [Net reporting amount]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.reporting_ending_balance ELSE 0 END),2) 
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.reporting_ending_balance ELSE 0 END),2) AS [Reporting margin]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.reporting_ending_balance ELSE 0 END),2) 
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.reporting_ending_balance ELSE 0 END),2) AS [Reporting net income]
	
			,ROUND(SUM (tb.functional_ending_balance),2) AS [Net functional amount]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.functional_ending_balance ELSE 0 END),2) 
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.functional_ending_balance ELSE 0 END),2) AS [Functional margin]
			,ROUND(SUM(CASE WHEN coa.ey_account_type = 'Revenue' THEN tb.functional_ending_balance ELSE 0 END),2) 
				+ ROUND(SUM(CASE WHEN coa.ey_account_type = 'Expenses' THEN tb.functional_ending_balance ELSE 0 END),2) AS [Functional net income]
			, 'Ending balance' AS [Source Type]
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

		WHERE fc.fiscal_period_seq IN (
											SELECT MAX(pp1.fiscal_period_seq_end) 
											FROM dbo.Parameters_period pp1 
											WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd and pp1.year_flag=pp.year_flag
							)
		AND pp.year_flag IN ('CY','PY')
		and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
		GROUP BY 
			coa.ey_account_type
			,coa.ey_account_class
			,fc.fiscal_period_cd
			,pp.year_flag_desc
			,pp.period_flag_desc
			,pp.year_flag
			,pp.period_flag
			,bu.bu_group
			,bu.bu_ref
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
			--,s1.segment_ref
			--,s2.segment_ref
			,s1.ey_segment_ref
			,s2.ey_segment_ref
			/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
			,s1.ey_segment_group
			,s2.ey_segment_group
			,coa.ey_account_group_I
			,tb.reporting_curr_cd
			,tb.functional_curr_cd


GO


  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VW_GL_Amount_By_Dr_Cr]')) Drop VIEW [dbo].[VW_GL_Amount_By_Dr_Cr] 
GO

CREATE	VIEW	[dbo].[VW_GL_Amount_By_Dr_Cr]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[VW_GL_Amount_By_Dr_Cr]
History:		
************************************************************************************************************************************************/
SELECT 
	COA.ey_account_type AS [Account Type]
	,COA.ey_account_sub_type AS [Account Sub-type]
	,COA.ey_account_class AS [Account Class]
	,COA.ey_account_sub_class AS [Account Sub-class]
	,COA.gl_account_cd AS [GL Account Cd]
	,COA.gl_account_name AS [GL Account Name]
	,COA.ey_account_group_I   AS [Account group]
	,COA.ey_account_group_II AS [Account sub group]
	,COA.ey_gl_account_name AS [GL Account]
	,FT_GL.[dr_cr_ind]  AS [Indicator]
	,ul.preparer_ref as   [Preparer]
	,ul.department as  [Preparer department]
	,SL.source_ref  as [Source]
	,SL.source_group  as  [Source group]
	,bu.bu_ref AS [Business Unit]
	,bu.bu_group AS [Business unit group]
	,SG1.ey_segment_group as  [Segment 1 group]
	,SG2.ey_segment_group as  [Segment 2 group]
	,SG1.ey_segment_ref as  [Segment 1]
	,SG2.ey_segment_ref as  [Segment 2]

	,FT_GL.year_flag as [Year flag]
	,FT_GL.period_flag as [Period flag]
	
	,CASE WHEN FT_GL.year_flag = 'CY' THEN 'Current'
			WHEN FT_GL.year_flag = 'PY' THEN 'Prior'
			WHEN FT_GL.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc 
		END  as [Accounting period]
	,PP.period_flag_desc as  [Accounting sub period]
	,FT_GL.ey_period as  [Fiscal period]
	
	
	,FT_GL.Sys_man_ind  AS [System Manual Indicator]
	--,FT_GL.sys_manual_ind as 'Journal type'
	,FT_GL.journal_type as [Journal type]
	,FT_GL.reporting_amount_curr_cd as [Reporting currency code]

	,FT_GL.functional_curr_cd AS [Functional Currency Code]
	,SUM(FT_GL.net_amount) AS [Net Amount]
	--,FT_GL.functional_amount  AS [Functional Amount]
	,SUM(FT_GL.net_reporting_amount) as [Net reporting amount]
	,SUM(FT_GL.net_reporting_amount_credit) as [Net reporting credit amount]
	,SUM(FT_GL.net_reporting_amount_debit) as [Net reporting debit amount]
	,SUM(FT_GL.net_functional_amount) as [Net functional amount]
	,SUM(FT_GL.net_functional_amount_credit) as [Net functional credit amount]
	,SUM(FT_GL.net_functional_amount_debit) as [Net functional debit amount]
	
FROM dbo.FT_GL_Account FT_GL 
	INNER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = FT_GL.coa_id and COA.bu_id = FT_GL.bu_id
	LEFT OUTER JOIN dbo.Parameters_period PP on PP.period_flag = FT_GL.period_flag AND PP.year_flag = FT_GL.year_flag
	LEFT OUTER JOIN dbo.v_User_listing ul on ul.user_listing_id = FT_GL.user_listing_id 
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on FT_GL.bu_id = bu.bu_id
	LEFT OUTER JOIN dbo.v_Source_listing SL on FT_GL.source_id = SL.source_id
	LEFT OUTER JOIN dbo.v_Segment01_listing SG1 on SG1.ey_segment_id = FT_GL.segment1_id
	LEFT OUTER JOIN dbo.v_Segment02_listing SG2 on SG2.ey_segment_id = FT_GL.segment2_id
GROUP by
	COA.ey_account_type
	,COA.ey_account_sub_type 
	,COA.ey_account_class 
	,COA.ey_account_sub_class 
	,COA.gl_account_cd 
	,COA.gl_account_name 
	,COA.ey_account_group_I  
	,COA.ey_account_group_II 
	,COA.ey_gl_account_name 
	,FT_GL.[dr_cr_ind]	
	,UL.preparer_ref  
	,UL.department  
	,SL.source_ref  
	,SL.source_group  
	,bu.bu_ref 
	,bu.bu_group 
	,SG1.ey_segment_group 
	,SG2.ey_segment_group 
	,SG1.ey_segment_ref 
	,SG2.ey_segment_ref 

	,FT_GL.year_flag 
	,FT_GL.period_flag
	
	,PP.year_flag_desc 
	,PP.period_flag_desc 
	,FT_GL.ey_period 
	
	
	,FT_GL.Sys_man_ind  
	
	,FT_GL.journal_type 
	,FT_GL.reporting_amount_curr_cd 

	,FT_GL.functional_curr_cd 
GO  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V_Flat_Journal_Entry]')) Drop VIEW [dbo].[V_Flat_Journal_Entry]
GO

CREATE VIEW [dbo].[V_Flat_Journal_Entry]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Vendor_master
Script Date:	09/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[V_Flat_Journal_Entry]
History:		
V1				09/05/2013   	MSH		CREATED
v2				09/17/2014		RJN		Added row_id for tagging
************************************************************************************************************************************************/


	SELECT 
		Je_id+'-'+je_line_id as [Row_id],
		[je_id]				as [Journal entry ID]
		,FJ.[je_line_id]				as [Journal entry line ID]
		,FJ.[je_line_desc]			as [Journal entry line description]
		,FJ.[je_header_desc]			as [Journal entry header description]
		,FJ.[dr_cr_ind]				as [Debit or credit indicator]
		,FJ.[amount]					as [Amount]
		,FJ.[amount_debit]			as [Amount debit]
		,FJ.[amount_credit]			as [Amount credit]
		,FJ.[amount_curr_cd]			as [Amount currency code]
		,FJ.[ey_je_id]				as [EY journal entry ID]
		,FJ.[activity]				as [Activity]
		,FJ.[coa_id]					as [Chart of account ID]
		,FJ.[period_id]				as [Period ID]	
		,FJ.[bu_id]					as [Business unit ID]
		,FJ.[gl_account_cd]			as [GL account code]
		,FJ.[gl_subacct_cd]			as [GL sub-account code]
		,FJ.[gl_account_name]		as [GL account name]
		,FJ.[gl_subacct_name]		as [GL sub-account name]
		,FJ.[ey_gl_account_name]		as [GL account]
		,FJ.[consolidation_account]	as [Consolidation name]	
		,FJ.[ey_account_type]		as [EY account type]
		,FJ.[ey_account_sub_type]	as [EY account sub-type]
		,FJ.[ey_account_class]		as [EY account class]
		,FJ.[ey_cash_activity]		as [EY cash activity]
		,FJ.[ey_account_sub_class]	as [EY account sub-class]
		,FJ.[ey_index]				as [EY index]
		,FJ.[ey_sub_index]			as [EY sub-index]
		,FJ.[source_id]				as [Source ID]
		--,FJ.[source_cd]				as [Source code]
		--,FJ.[source_desc]			as [Source description]
		--,FJ.[source_ref]				as [Source]
		,src.[source_cd]			as [Source code]
		,src.[source_desc]			as [Source description]
		,src.[source_ref]				as [Source] -- ,src.[source_desc]-- fixed by prabakar on July 2nd since its refer to source_desc
		,FJ.[sys_manual_ind]			as [System manual indicator]
		,FJ.[sys_manual_ind_src]		as [System manual indicator source]
		,FJ.[sys_manual_ind_usr]		as [System manual indicator user]
		,FJ.[user_listing_id]		as [User listing ID]
		,FJ.[client_user_id]			as [Client user ID]
		,FJ.[preparer_ref]			as [Preparer]
		,FJ.[first_name]				as [Preparer first name]
		,FJ.[last_name]				as [Preparer last name]
		,FJ.[full_name]				as [Preparer full name]
		,FJ.[department]				as [Preparer department]
		,FJ.[role_resp]				as [Preparer role]
		,FJ.[title]					as [Preparer title]
		,FJ.[active_ind]				as [Active indicator]
		--,FJ.[bu_cd]					as [Business unit code]
		--,FJ.[bu_desc]				as [Business unit description]
		--,FJ.[bu_ref]					as [Business unit]
		--,FJ.[bu_group]				as [Business unit group]
		,bu.[bu_cd]					as [Business unit code]
		,bu.[bu_desc]				as [Business unit description]
		,bu.[bu_ref]					as [Business unit]
		,bu.[bu_group]				as [Business unit group]

		,FJ.[fiscal_period_cd]		as [Fiscal period code]
		,FJ.[fiscal_period_desc]		as [Fiscal period description]
		,FJ.[fiscal_period_start]	as [Fiscal period start]
		,FJ.[fiscal_period_end]		as [Fiscal period end]
		,FJ.[fiscal_quarter_start]	as [Fiscal quarter start]
		,FJ.[fiscal_quarter_end]		as [Fiscal quarter end]
		,FJ.[fiscal_year_start]		as [Fiscal year start]
		,FJ.[fiscal_year_end]		as [Fiscal year end]
		,FJ.[EY_fiscal_year]			as [EY fiscal year]
		,FJ.[EY_quarter]				as [EY quarter]
		,FJ.[EY_period]				as [Fiscal period]
		,FJ.[Entry_Date]				as [Entry date]
		,FJ.[Day_of_week]			as [Day of week]
		,FJ.[Effective_Date]			as [Effective date]
		,FJ.[Lag_Date]				as [Lag date]
		-- Commented and added the below piece of code to show the Accounting period based on the year_flag -- July 1st
		--Changes Begin
		--,FJ.year_flag_desc			as [Accounting period]
		,CASE WHEN year_flag = 'CY' THEN 'Current'	
						WHEN year_flag = 'PY' THEN 'Prior'
						WHEN year_flag = 'SP' THEN 'Subsequent'
						ELSE year_flag_desc 
					END	AS [Accounting period]
		-- Changes End
		,FJ.period_flag_desc			as [Accounting sub period]
		,FJ.[system_load_date]		as [System load date]
		--,FJ.[segment1_ref]					as [Segment 1]
		--,FJ.[segment2_ref]					as [Segment 2]
		,s1.[ey_segment_ref]					as [Segment 1]
		,s2.[ey_segment_ref]					as [Segment 2]

		,FJ.[functional_curr_cd]		as [Functional currency code]
		,FJ.[functional_amount]		as [Functional amount]
		,FJ.[functional_debit_amount]   as [Functional debit amount]
		,FJ.[functional_credit_amount]  as [Functional credit amount]
		,FJ.[reversal_ind]			   as [Reversal indicator] 
		,FJ.[reporting_amount]		   as [Reporting amount]
		,FJ.[reporting_amount_curr_cd]  as [Reporting currency code]
		,FJ.[reporting_amount_debit]   as [Reporting debit amount]
		,FJ.[reporting_amount_credit]  as [Reporting credit amount]
		,FJ.[approver_department]	   as [Approver department]
		,FJ.[approver_ref]			   as [Approver]
		,FJ.[approved_by_id]			   as [Approver ID]
		--,FJ.[business_unit_group]	   as [Business unit group]
		--,FJ.[segment1_group]		   as [Segment 1 group]
		--,FJ.[segment2_group]		   as [Segment 2 group]
		--,FJ.[source_group]			   as [Source group]
		,s1.[ey_segment_group]		   as [Segment 1 group]
		,s2.[ey_segment_group]		   as [Segment 2 group]
		,src.[source_group]			   as [Source group]
		
		,FJ.[journal_type]		   as [Journal type]  -- Remove the column Journal Type from FLAT_JE
		,FJ.[year_flag]		  as [Year flag]
		,FJ.[period_flag]	as [Period flag]
		--,FJ.segment1_desc	as [Segment 1 desc]
		--,FJ.segment2_desc	as [Segment2_desc]
		,s1.segment_desc	as [Segment 1 desc]
		,s2.segment_desc	as [Segment2_desc]
		,FJ.segment2_id  as [Segment 2 id]  -- Updated from Segment 2 from Segment 1 on July 11 by prabakar tr
		,FJ.segment1_id  as [Segment 1 id]	-- Added from Segment 1 on July 11 by prabakar tr

		,'' as 'Accounting period end date'--year_flag_date
		,'' as 'Accounting subperiod end date' --period_flag_date
		,FJ.year_end_date                                   AS            [Year end date]
		,FJ.year_flag_desc                                  AS            [Year flag description]
		,''                                        AS            [period end date]
		,FJ.period_flag_desc                                AS            [period flag description]

		,FJ.functional_impact_to_assets as [Functional Journal impact to assets]
		,FJ.functional_impact_to_liabilities as [Functional Journal impact to liabilities]
		,FJ.functional_impact_to_equity as [Functional Journal impact to equity]
		,FJ.functional_impact_to_revenue as [Functional Journal impact to revenue]
		,FJ.functional_impact_to_expenses as [Functional Journal impact to expenses]

		,FJ.reporting_impact_to_assets as [Reporting Journal impact to assets]
		,FJ.reporting_impact_to_liabilities as [Reporting Journal impact to liabilities]
		,FJ.reporting_impact_to_equity as [Reporting Journal impact to equity]
		,FJ.reporting_impact_to_revenue as [Reporting Journal impact to revenue]
		,FJ.reporting_impact_to_expenses as [Reporting Journal impact to expenses]

		,'' as 'Audit period'
		,'' as 'Audit year'
		,'' as 'Business unit code hierarchy'
		,'' as 'Business unit description hierarchy'
		,'' as 'Business unit reference'
		,'' as 'Cash group'
		,'' as 'Interim period'
		,'' as 'Random number'
		,ey_subledger_type as [Ey subledger type]
		,ey_AR_type as [Ey AR type]
		,ey_AP_type as [Ey AP type]
		,ey_reconciliation_GL_group as [Ey reconciliation GL group] 
		,TT.ey_trans_type as [Transaction type group] --added by Rajan 29th July 2014
		,TT.transaction_type_ref as [Transaction type] --added by Rajan 29th July 2014

  FROM [dbo].[FLAT_JE] FJ
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = FJ.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = FJ.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
		LEFT OUTER JOIN		 dbo.v_Transaction_type TT	ON	FJ.transaction_type_id = TT.transaction_type_id --added by Rajan 29th July 2014
	where fj.ver_end_date_id IS NULL -- Added by prabakar on July 2nd to bring latest version of data


GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_GL_Balance_Sheet_GL001]')) Drop VIEW [dbo].[v_GL_Balance_Sheet_GL001]
GO

CREATE	VIEW	[dbo].[v_GL_Balance_Sheet_GL001]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Trialbalance
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_GL_Balance_Sheet_GL001]
History:		
************************************************************************************************************************************************/

SELECT 
		GL.coa_id as [COA Id]
		,GL.period_id as [Period Id]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class	  AS [Account Class]
		,coa.ey_account_sub_class	  AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Code]
		,coa.gl_account_name AS [GL Account Name]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I AS [Account Group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group as [Business unit group]
		
		,S1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]

			
		,GL.year_flag as [Year flag]
		,GL.period_flag as [Period flag]
		,GL.Accounting_period  AS [Accounting period]

		,GL.Accounting_sub_period AS [Accounting sub period]
		,GL.[YEAR] AS [Year]
		,GL.[Fiscal_period] AS [Fiscal period]
		
		,src.source_group AS [Source group]
		,src.Source_Ref AS [Source]
		

		,GL.journal_type AS [Journal type]
		,dp.department AS [Preparer department]
		,dp.preparer_Ref AS [Preparer]

		,dp1.department AS [Approver department]
		,dp1.preparer_ref AS [Approver]
		,GL.Functional_Currency_Code  AS  [Functional Currency Code]
		,GL.Reporting_currency_code  AS  [Reporting currency code]
		,GL.Net_reporting_amount  AS  [Net reporting amount]
		,GL.Net_reporting_amount_credit  AS  [Net reporting amount credit]
		,GL.Net_reporting_amount_debit  AS  [Net reporting amount debit]
		,GL.Net_reporting_amount_current  AS  [Net reporting amount current]
		,GL.Net_reporting_amount_credit_current  AS  [Net reporting amount credit current]
		,GL.Net_reporting_amount_debit_current  AS  [Net reporting amount debit current]
		,GL.Net_reporting_amount_interim  AS  [Net reporting amount interim]
		,GL.Net_reporting_amount_credit_interim  AS  [Net reporting amount credit interim]
		,GL.Net_reporting_amount_debit_interim  AS  [Net reporting amount debit interim]
		,GL.Net_reporting_amount_prior  AS  [Net reporting amount prior]
		,GL.Net_reporting_amount_credit_prior  AS  [Net reporting amount credit prior]
		,GL.Net_reporting_amount_debit_prior  AS  [Net reporting amount debit prior]
		,GL.Net_functional_amount  AS  [Net functional amount]
		,GL.Net_functional_amount_credit  AS  [Net functional amount credit]
		,GL.Net_functional_amount_debit  AS  [Net functional amount debit]
		,GL.Net_functional_amount_current  AS  [Net functional amount current]
		,GL.Net_functional_amount_credit_current  AS  [Net functional amount credit current]
		,GL.Net_functional_amount_debit_current  AS  [Net functional amount debit current]
		,GL.Net_functional_amount_interim  AS  [Net functional amount interim]
		,GL.Net_functional_amount_credit_interim  AS  [Net functional amount credit interim]
		,GL.Net_functional_amount_debit_interim  AS  [Net functional amount debit interim]
		,GL.Net_functional_amount_prior  AS  [Net functional amount prior]
		,GL.Net_functional_amount_credit_prior  AS  [Net functional amount credit prior]
		,GL.Net_functional_amount_debit_prior  AS  [Net functional amount debit prior]
		,GL.Source_type  AS  [Source type]
		,GL.Period_end_date  AS  [Period end date]
		,GL.Fiscal_period_sequence  AS  [Fiscal period sequence]
		,GL.Fiscal_period_sequence_end  AS  [Fiscal period sequence end]


	FROM dbo.[GL_001_Balance_Sheet] GL (NOLOCK) 
		LEFT OUTER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.Coa_id = GL.coa_id
			AND coa.Coa_id = GL.coa_id
		LEFT OUTER JOIN dbo.Dim_Preparer dp	on dp.user_listing_id = GL.user_listing_id
		LEFT OUTER JOIN dbo.Dim_Preparer dp1	on dp1.user_listing_id = GL.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = GL.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = GL.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = GL.Segment_1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = GL.Segment_2_id

	

GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_Calendar_seq_date]')) Drop VIEW [dbo].v_IL_Calendar_seq_date
GO

CREATE VIEW [dbo].v_IL_Calendar_seq_date
--WITH SCHEMABINDING
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from DIM_Calendar_seq_date
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_Calendar_seq_date]
History:		
************************************************************************************************************************************************/

	SELECT   
		Calendar_date as [Calendar date]
		,Sequence as [Sequence]
	FROM         dbo.DIM_Calendar_seq_date 

GO

  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL001_Balance_Validation]')) Drop VIEW [dbo].[v_IL_GL001_Balance_Validation]
GO

CREATE	VIEW	[dbo].[v_IL_GL001_Balance_Validation]
AS
/**********************************************************************************************************************************************
Description:	View for validating the trial balances by account types
Script Date:	19/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_GL001_Balance_Validation]
History:		
************************************************************************************************************************************************/

	SELECT 
		coa.ey_account_type AS [Account Type]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group as [Business unit group]

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
	
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
			WHEN pp.year_flag ='PY' THEN 'Prior'
			WHEN pp.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc END AS [Accounting period]
		,pp.period_flag_desc AS [Accounting sub period]
		,pp.fiscal_period_seq_end AS [Fiscal period sequence end]
		,tb.reporting_curr_cd AS [Reporting currency code]
		,tb.functional_curr_cd AS [Functional currency code]

		,SUM(tb.reporting_ending_balance) AS [Net reporting ending balance]
		,SUM(tb.functional_ending_balance) AS [Net functional ending balance]
	FROM  dbo.TrialBalance tb
			
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

	where tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		coa.ey_account_type 
	
		,bu.bu_ref 
		,bu.bu_group 

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		--,s1.segment_ref
		--,s2.segment_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,s1.ey_segment_group 
		,s2.ey_segment_group
	
		,pp.year_flag 
		,pp.period_flag 
		,pp.year_flag_desc 
		,pp.period_flag_desc
		,pp.fiscal_period_seq_end
		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 

GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL002_Income_Statement]')) Drop VIEW [dbo].[v_IL_GL002_Income_Statement] 
GO

CREATE VIEW [dbo].[v_IL_GL002_Income_Statement]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Trialbalance
Script Date:	19/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	 [dbo].[v_IL_GL002_Income_Statement]
History:		
************************************************************************************************************************************************/
	
	SELECT 
		GL.COA_Id AS [COA Id]
		,GL.Period_Id AS [Period Id]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class	  AS [Account Class]
		,coa.ey_account_sub_class	  AS [Account Sub-class]
		,coa.gl_account_cd AS [GL Account Code]
		,coa.gl_account_name AS [GL Account Name]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I AS [Account Group]
		,BU.bu_ref AS [Business Unit]
		,BU.bu_group AS [Business unit group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,GL.Year_flag AS [Year flag]
		,GL.Period_flag AS [Period flag]
		,GL.Accounting_period AS [Accounting period]
		,GL.Accounting_sub_period AS [Accounting sub period]
		,GL.[Year] AS [Year]
		,GL.Fiscal_period AS [Fiscal period]
		,SRC.Source_group AS [Source group]
		,SRC.[source_ref] AS [Source]
		,GL.Journal_type AS [Journal type]
		,DP.department AS [Preparer department]
		,DP.preparer_ref AS [Preparer]
		,DP1.department AS [Approver department]
		,DP1.preparer_ref AS [Approver]
		,GL.Functional_Currency_Code AS [Functional Currency Code]
		,GL.Reporting_currency_code AS [Reporting currency code]
		,GL.Net_reporting_amount AS [Net reporting amount]
		,GL.Net_reporting_amount_credit AS [Net reporting amount credit]
		,GL.Net_reporting_amount_debit AS [Net reporting amount debit]
		,GL.Net_reporting_amount_current AS [Net reporting amount current]
		,GL.Net_reporting_amount_credit_current AS [Net reporting amount credit current]
		,GL.Net_reporting_amount_debit_current AS [Net reporting amount debit current]
		,GL.Net_reporting_amount_interim AS [Net reporting amount interim]
		,GL.Net_reporting_amount_credit_interim AS [Net reporting amount credit interim]
		,GL.Net_reporting_amount_debit_interim AS [Net reporting amount debit interim]
		,GL.Net_reporting_amount_prior AS [Net reporting amount prior]
		,GL.Net_reporting_amount_credit_prior AS [Net reporting amount credit prior]
		,GL.Net_reporting_amount_debit_prior AS [Net reporting amount debit prior]
		,GL.Net_functional_amount AS [Net functional amount]
		,GL.Net_functional_amount_credit AS [Net functional amount credit]
		,GL.Net_functional_amount_debit AS [Net functional amount debit]
		,GL.Net_functional_amount_current AS [Net functional amount current]
		,GL.Net_functional_amount_credit_current AS [Net functional amount credit current]
		,GL.Net_functional_amount_debit_current AS [Net functional amount debit current]
		,GL.Net_functional_amount_interim AS [Net functional amount interim]
		,GL.Net_functional_amount_credit_interim AS [Net functional amount credit interim]
		,GL.Net_functional_amount_debit_interim AS [Net functional amount debit interim]
		,GL.Net_functional_amount_prior AS [Net functional amount prior]
		,GL.Net_functional_amount_credit_prior AS [Net functional amount credit prior]
		,GL.Net_functional_amount_debit_prior AS [Net functional amount debit prior]
		,GL.Source_type AS [Source type]
		,GL.Period_end_date AS [Period end date]

	FROM dbo.[GL_002_Income_Statement] GL 
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = GL.COA_Id
		LEFT OUTER JOIN dbo.v_User_listing dp on dp.user_listing_id = gl.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing dp1 on dp1.user_listing_id = gl.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = GL.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing Src on src.source_id = GL.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = GL.segment_1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = GL.segment_2_id

		--INNER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.Coa_id = GL.coa_id
		--	AND coa.Coa_id = GL.coa_id
		--LEFT OUTER JOIN dbo.Dim_Preparer dp	on dp.user_listing_id = GL.user_listing_id
		--LEFT OUTER JOIN dbo.Dim_Preparer dp1	on dp1.user_listing_id = GL.approved_by_id
GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL006_Journal_summary_for_correlation]')) Drop VIEW [dbo].[v_IL_GL006_Journal_summary_for_correlation]
GO

CREATE VIEW [dbo].[v_IL_GL006_Journal_summary_for_correlation]
AS
/**********************************************************************************************************************************************
Description:	View creation for aggregating Journal Entires at COA and BU level
Script Date:	11/06/2013
Created By:		PRM
Version:		1
Sample Command:	SELECT	*	FROM	[v_IL_GL006_Journal_summary_for_correlation]
History:		
V1				11/06/2013   	PRM		CREATED
Comment : Removed -- Source,Accounting sub period, Period flag, Segment 1 group,Segment 2 group,Segment 1,Segment 2, Source group,Journal Type, Ey Period as
		Tim Comments on		Aug 4 2014
************************************************************************************************************************************************/

SELECT
					TB.coa_id			[COA Id]					
						--,TB.bu_id								
					,COA.ey_account_type						AS	[Account Type]
					,COA.ey_account_sub_type					AS	[Account Sub-type]
					,COA.ey_account_class					AS	[Account Class]
					,COA.ey_account_sub_class				AS	[Account Sub-class]
					,COA.ey_account_group_I					AS	[EY account group I]
					,COA.gl_account_name						AS	[GL Account Name]
					,COA.gl_account_cd						AS	[Account Code]
					,COA.ey_gl_account_name					AS	[GL Account]
					,bu.bu_ref								AS	[Business unit]
					,bu.bu_group							AS	[Business unit group]
					
					,PP.year_flag [Year Flag]

					,CASE WHEN PP.year_flag = 'CY' THEN 'Current'	
						WHEN PP.year_flag = 'PY' THEN 'Prior'
						WHEN PP.year_flag = 'SP' THEN 'Subsequent'
						ELSE pp.year_flag_desc 
					END	AS [Accounting period]--PP.year_flag_desc [Accounting period]

						--,TB.balance_curr_cd	
						-- Changed the reference column since begining and ending is referred as functional begin and ending in RDM -- by prabakar july 1st begin
						--,TB.beginning_balance					
						--,TB.ending_balance	
					,TB.functional_ending_balance - TB.functional_beginning_balance [Functional amount]
					,TB.reporting_ending_balance - TB.reporting_beginning_balance	[Reporting amount] 
						
					,TB.functional_beginning_balance					[Functional beginning balance]
					,TB.functional_ending_balance						[Functional ending balance]	
					-- Changed the reference column since begining and ending is referred as functional begin and ending in RDM -- by prabakar july 1st end									
					--,TB.reporting_curr_cd					
					,TB.reporting_beginning_balance						[Reporting beginning balance]
					,TB.reporting_ending_balance						[Reporting ending balance]
						
	FROM				 [dbo].[Trialbalance] TB --[dbo].[Trial_balance] TB -- Changed by prabakar on july 1st to refer the rdm table instead cdm
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	LEFT OUTER JOIN		 [dbo].[Gregorian_calendar] GC			ON		TB.trial_balance_end_date_id = GC.date_id
	--Joining condition is updated and commented the exisitng condition by Prabakar on July 30th as per Conversation with TIM -- BEGIN
	INNER JOIN			 [dbo].[Parameters_period] PP			ON	FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag = 'RP'
																	--GC.calendar_date = PP.year_end_date
																	--AND FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	--AND PP.end_date = PP.year_end_date
																	--AND PP.year_flag = 'CY'
	LEFT OUTER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = TB.coa_id AND COA.bu_id = TB.bu_id
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = TB.bu_id				
	--Joining condition is updated and commented the exisitng condition by Prabakar on July 30th as per Conversation with TIM -- END
	WHERE tb.ver_end_date_id IS NULL


/*WITH Trial_balance_CTE
AS
(
	SELECT
						 TB.coa_id								
						,TB.bu_id								

						--,TB.balance_curr_cd	
						-- Changed the reference column since begining and ending is referred as functional begin and ending in RDM -- by prabakar july 1st begin
						--,TB.beginning_balance					
						--,TB.ending_balance	
						,TB.functional_beginning_balance					
						,TB.functional_ending_balance
						-- Changed the reference column since begining and ending is referred as functional begin and ending in RDM -- by prabakar july 1st end									
						--,TB.reporting_curr_cd					
						,TB.reporting_beginning_balance	
						,TB.reporting_ending_balance
						
	FROM				 [dbo].[Trialbalance] TB --[dbo].[Trial_balance] TB -- Changed by prabakar on july 1st to refer the rdm table instead cdm
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	LEFT OUTER JOIN		 [dbo].[Gregorian_calendar] GC			ON		TB.trial_balance_end_date_id = GC.date_id
	--Joining condition is updated and commented the exisitng condition by Prabakar on July 30th as per Conversation with TIM -- BEGIN
	INNER JOIN			 [dbo].[Parameters_period] PP			ON	FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag = 'RP'
																	--GC.calendar_date = PP.year_end_date
																	--AND FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	--AND PP.end_date = PP.year_end_date
																	--AND PP.year_flag = 'CY'
	--Joining condition is updated and commented the exisitng condition by Prabakar on July 30th as per Conversation with TIM -- END
	WHERE tb.ver_end_date_id IS NULL


		
)
SELECT
					 FT.coa_id								AS	[COA Id]
					,COA.ey_account_type						AS	[Account Type]
					,COA.ey_account_sub_type					AS	[Account Sub-type]
					,COA.ey_account_class					AS	[Account Class]
					,COA.ey_account_sub_class				AS	[Account Sub-class]
					,COA.ey_account_group_I					AS	[EY account group I]
					,COA.gl_account_name						AS	[GL Account Name]
					,COA.gl_account_cd						AS	[Account Code]
					,COA.ey_gl_account_name					AS	[GL Account]
					
					,bu.bu_ref								AS	[Business unit]
					,bu.bu_group							AS	[Business unit group]
					,FT.year_flag							AS	[Year Flag]
					,CASE WHEN FT.year_flag = 'CY' THEN 'Current'	
						WHEN FT.year_flag = 'PY' THEN 'Prior'
						WHEN FT.year_flag = 'SP' THEN 'Subsequent'
						ELSE pp.year_flag_desc 
					END	AS [Accounting period]
					
										
					,SUM(FT.net_functional_amount)				AS	[Functional amount] -- Updated the existing column with correct column name
					,SUM(FT.net_reporting_amount)				AS	[Reporting amount] -- Updated the existing column with correct column name
					-- Changed the reference column since it's changed in above CTE  -- by prabakar july 1st begin
					--,MIN(TB.beginning_balance)				AS	[Functional beginning balance]				
					--,MIN(TB.ending_balance)					AS	[Functional ending balance]	
					,MIN(TB.functional_beginning_balance)				AS	[Functional beginning balance]				
					,MIN(TB.functional_ending_balance)					AS	[Functional ending balance]		
					-- Changed the reference column since it's changed in above CTE  -- by prabakar july 1st end
					,MIN(TB.reporting_beginning_balance)	AS	[Reporting beginning balance]
					,MIN(TB.reporting_ending_balance)		AS	[Reporting ending balance]

	FROM	dbo.FT_GL_Account	FT ----dbo.FLAT_JE FJ -- removed the dependency on the flat_je and brought up the second level agg table for performance by prabakar on july 30
					LEFT OUTER JOIN		 Trial_balance_CTE	TB		ON		FT.coa_id = TB.coa_id
													AND	FT.bu_id = TB.bu_id
					-- Added below 2 joining conditions by prabakar on july 30
					LEFT OUTER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = FT.coa_id AND COA.bu_id = FT.bu_id
					LEFT OUTER JOIN dbo.Parameters_period PP on PP.period_flag = FT.period_flag AND pp.year_flag = FT.year_flag
				
					-- added below column to support the dynamic view changes by prabkar on july 1st -- begin
					LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = FT.bu_id
					--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = FT.segment1_id
					--LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = FT.segment2_id
					--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = FT.source_id
					--LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = FT.user_listing_id 
					-- added below column to support the dynamic view changes by prabkar on july 1st -- end
WHERE				 FT.year_flag = 'CY'
			--and FT.ver_end_date_id IS NULL -- its already restriced while loading to ft_je_amounts
GROUP BY
					FT.year_flag
					,FT.coa_id
					,coa.ey_account_type 
					,coa.ey_account_sub_type 
					,coa.ey_account_class 
					,coa.ey_account_sub_class 
					,COA.ey_account_group_I
					,coa.gl_account_name 
					,coa.gl_account_cd 
					,coa.ey_gl_account_name 
					,bu.bu_ref
					,bu.bu_group
					,PP.year_flag_desc 
				*/  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL007_Significant_Acct]')) Drop VIEW [dbo].[v_IL_GL007_Significant_Acct] 
GO

CREATE	VIEW	[dbo].[v_IL_GL007_Significant_Acct]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from FLAT_JE
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_GL007_Significant_Acct] where  [source type] <> 'Activity'
History:		original view has changed on Aug 4 2014
************************************************************************************************************************************************/
	

	SELECT 
		s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref  AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		,coa.ey_account_class as [Account Class]
		,coa.ey_account_sub_class as [Account Sub-class]
		,coa.gl_account_cd as [GL code]
		,coa.gl_account_name as [GL account name]
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_gl_account_name AS [GL Account]
		,coa.ey_account_group_I as [Account group]
		,bu.bu_ref AS [Business Unit]
		,bu.bu_group AS [Business Unit Group]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_group END AS [Source group]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_ref END AS [Source]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.preparer_ref END AS [Preparer]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.department END AS [Preparer department]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.department END AS [Approver department]
		,CASE WHEN FJ.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.preparer_ref END  AS [Approver]

		,CASE WHEN FJ.year_flag = 'CY' THEN 'Current'	
			WHEN FJ.year_flag = 'PY' THEN 'Prior'
			WHEN FJ.year_flag = 'SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END	AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]	
		,fj.year_flag AS [Year flag]
		,fj.period_flag  AS [Period flag]
		,FJ.EY_period as [Fiscal period]	
		,fj.journal_type AS [Journal type]
		,fj.reporting_curr_cd AS [Reporting currency code]
		,fj.functional_curr_cd AS [Functional currency code]
		,source_type as [Source Type]


		,current_amount AS [Current Amount]
		,prior_amount AS [Prior Amount]
		,count_of_je_line_items  as [# of JE Line Items]
		,count_of_manual_je_lines  as [# of Manual JE Lines]
		,manual_amount as [Manual Amount ($)]
		,manual_functional_amount as [Manual Functional Amount]
		,count_ofdistinct_preparers  as [# of Distinct Preparers]
		,total_debit_activity  as [Total Debit Activity]
		,largest_line_item as [Largest Line Item]
		,largest_functional_line_item AS [Largest functional line item]
		,total_credit_activity  as [Total Credit Activity]
		,net_reporting_amount  AS [Net reporting amount]
		,net_reporting_amount_credit AS [Net reporting amount credit]
		,net_reporting_amount_debit AS [Net reporting amount debit]
		,net_functional_amount AS [Net functional amount]
		,net_functional_amount_credit AS [Net functional amount credit]
		,net_functional_amount_debit AS [Net functional amount debit]
		,functional_ending_balance  AS [Functional ending balance]
		,reporting_ending_balance AS [Reporting ending balance]
		,net_functional_amount_current AS [Net functional amount current]
		,net_functional_amount_prior AS [Net functional amount prior]
		,net_reporting_amount_current AS [Net reporting amount current]
		,net_reporting_amount_prior AS [Net reporting amount prior]

	FROM dbo.[GL_007_Significant_Acct] FJ  
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.Parameters_period pp on pp.year_flag = fj.year_flag and PP.period_flag = fj.period_flag
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = fj.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = FJ.approved_by_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = fj.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = fj.segment2_id
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL016T1_Balance_by_GL]')) Drop VIEW [dbo].[v_IL_GL016T1_Balance_by_GL] 
GO

CREATE VIEW [dbo].[v_IL_GL016T1_Balance_by_GL]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Flat_JE
Script Date:	08/21/2014
Created By:		AO
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_GL016T1_Balance_by_GL] WHERE [source type] <> 'Activity' 
History:		V1		AO		Created
************************************************************************************************************************************************/
	
	Select 
	
		CASE WHEN f.year_flag = 'CY' THEN 'Current'
			WHEN f.year_flag ='PY' THEN 'Prior'
			WHEN f.year_flag ='SP' THEN 'Subsequent'
			ELSE PP.year_flag_desc END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,PP.year_flag  AS [Year flag]
		,PP.period_flag   AS [Period flag]
		,f.EY_period AS [Fiscal period]
		,f.coa_id	AS [Chart of account ID]				
		,coa.ey_account_type AS [Account Type]
		,coa.ey_account_sub_type AS [Account Sub-type]
		,coa.ey_account_class AS [Account Class] 
		,coa.ey_account_sub_class AS [Account Sub-class]
		,coa.gl_account_name AS [GL Account Name]
		,coa.gl_account_cd AS [GL Account Cd]
		,coa.ey_gl_account_name AS [GL Account] 
		,coa.ey_account_group_I AS [Account Group]
		,ISNULL(F.user_listing_id,0)	AS		[Preparer ID]							
		
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.preparer_ref END AS [Preparer]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE UL.department END AS [Preparer department]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.department END AS [Approver department]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE AUL.preparer_ref END  AS [Approver]
		
		,bu.bu_group AS [Business unit group]
		,bu.bu_REF AS [Business unit]
		,bu.bu_cd AS [Business unit code]
		,s1.ey_segment_group AS [Segment 1 group]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_group AS [Segment 2 group]
		,s2.ey_segment_ref  AS [Segment 2]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_group END AS [Source group]
		,CASE WHEN f.source_type <> 'Activity'  THEN 'N/A for balances' ELSE src.source_ref END AS [Source]
		
		,f.sys_man_ind AS [EY system manual indicator]					
		,f.journal_type AS [Journal type]
		,f.functional_curr_cd AS [Functional Currency Code]
		,f.reporting_curr_cd AS [Reporting currency code]

		,F.source_type AS [Source Type]
		

		,f.net_reporting_amount AS [Net reporting amount]
		,f.net_reporting_amount_credit AS [Net reporting amount credit]
		,f.net_reporting_amount_debit AS [Net reporting amount debit]

		,f.net_functional_amount AS [Net functional amount]
		,f.net_functional_amount_credit AS [Net functional amount credit]
		,f.net_functional_amount_debit AS [Net functional amount debit]
	
		
		,ISNULL(f.source_id,0) AS [Source id]
		,ISNULL(f.segment1_id,0) AS [segment1 id]
		,ISNULL(f.segment2_id,0) AS [segment2 id]
		,ISNULL(f.approved_by_id,0) AS [Approver ID]

	FROM dbo.GL_016_Balance_by_GL F
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id and coa.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_User_listing UL on UL.user_listing_id = F.user_listing_id
		LEFT OUTER JOIN dbo.v_User_listing AUL on AUL.user_listing_id = F.approved_by_id
		LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
					
		LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = f.source_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = f.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = f.segment2_id

	
GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL016_Missing_info]')) Drop VIEW [dbo].[v_IL_GL016_Missing_info] else print 'could not drop detail view'
GO

CREATE VIEW [dbo].[v_IL_GL016_Missing_info]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling data from Shared_AP_activity_details table
Script Date:	08/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_IL_GL016_Missing_info]
History:		
V1				08/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

	SELECT  
		je_id AS [Journal entry ID] 
		,je_line_id AS [Journal entry line ID] 
		,je_line_desc AS [Journal entry line description] 
		,je_header_desc AS [Journal entry header description] 
		,gl_account_cd AS [GL account code] 
		,gl_subacct_name AS [GL sub-account name] 
		,ey_gl_account_name AS [GL account] 
		,ey_account_type AS [EY account type] 
		,ey_account_sub_type AS [EY account sub-type] 
		,ey_account_class AS [EY account class] 
		,source_id AS [Source ID] 
		,user_listing_id AS [User listing ID] 
		,client_user_id AS [Client user ID] 
		,preparer_ref AS [Preparer] 
		,department AS [Preparer department] 
		,first_name AS [Preparer first name] 
		,role_resp AS [Preparer role] 
		,bu_id AS [Business unit ID] 
		,year_flag_desc AS [Accounting period] 
		,period_flag_desc AS [Accounting sub period] 
		,approver_department AS [Approver department] 
		,approver_ref AS [Approver] 
		,approved_by_id AS [Approver ID] 
		,journal_type AS [Journal type] 
		,year_flag AS [Year flag] 
		,period_flag AS [Period flag] 
		,segment1_id AS [Segment 1 id] 
		,segment2_id AS [Segment 2 id] 

		--,source_cd AS [Source code] 
		--,source_desc AS [Source description] 
		--,source_ref AS [Source] 
		--,bu_cd AS [Business unit code] 
		--,bu_desc AS [Business unit description] 
		--,bu_ref AS [Business unit] 
		--,bu_group AS [Business unit group] 
		--,segment1_ref AS [Segment 1] 
		--,segment2_ref AS [Segment 2] 
		--,segment1_group AS [Segment 1 group] 
		--,segment2_group AS [Segment 2 group] 
		--,source_group AS [Source group] 
		--,segment1_desc AS [Segment 1 desc] 
		--,segment2_desc AS [Segment2_desc] 


		,'' AS [Source code] 
		,'' AS [Source description] 
		,'' AS [Source] 
		,'' AS [Business unit code] 
		,'' AS [Business unit description] 
		,'' AS [Business unit] 
		,'' AS [Business unit group] 
		,'' AS [Segment 1] 
		,'' AS [Segment 2] 
		,'' AS [Segment 1 group] 
		,'' AS [Segment 2 group] 
		,'' AS [Source group] 
		,'' AS [Segment 1 desc] 
		,'' AS [Segment2_desc] 
	FROM dbo.FLAT_JE 
	
	WHERE  
		(je_line_desc IS NULL
		OR je_header_desc IS NULL
		OR gl_account_cd IS NULL
		OR client_user_id IS NULL
		OR department IS NULL
		OR role_resp IS NULL
		OR bu_id IS NULL
		OR approver_department IS NULL
		OR approver_ref IS NULL
		--OR segment1_group IS NULL
		--OR segment2_group IS NULL
		--OR source_group IS NULL
		--OR segment1_desc IS NULL
		--OR segment2_desc IS NULL
		--OR source_cd IS NULL
		--OR bu_cd IS NULL
		--OR bu_group IS NULL
		--OR segment1_ref IS NULL
		--OR segment2_ref IS NULL
		)
		and ver_end_date_id is null -- added by prabakar
GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL018_KPIs_unpivot]')) Drop VIEW [dbo].[v_IL_GL018_KPIs_unpivot] 
GO

CREATE	VIEW	[dbo].[v_IL_GL018_KPIs_unpivot]
AS
/**********************************************************************************************************************************************
Description:	View for fetching data from Trialbalance
Script Date:	19/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_GL018_KPIs_unpivot]
History:		
************************************************************************************************************************************************/
	SELECT 
		Source_ID     AS     [Source ID]
		,Source_Cd     AS     [Source Cd]
		,Source_Desc     AS     [Source Desc]
		--,Source_Ref     AS     [Source Ref]
		,preparer_ref     AS     [Preparer]
		,Preparer_Name     AS     [Preparer Name]
		,Preparer_department     AS     [Preparer department]
		,Source_group     AS     [Source group]
		,Source_Ref     AS     [Source]
		--,bu_id     AS     [BU]
		,Journal_Type     AS     [Journal Type]
		,Segment1_Group     AS     [Segment 1 Group]
		,Segment2_Group     AS     [Segment 2 Group]
		,Segment1_ref     AS     [Segment 1]
		,Segment2_ref     AS     [Segment 2]
		,bu_ref     AS     [Business Unit]
		,bu_group     AS     [Business Unit Group]
		,Year_flag_desc     AS     [Accounting period]
		,period_flag_desc    AS     [Accounting sub period]
		,ey_period     AS     [Fiscal period]
		,Ratio_type     AS     [Ratio type]
		,Ratio     AS     [Ratio]
		,Amount     AS     [Amount]
		,Multiplier     AS     [Multiplier]

	FROM dbo.GL_018_KPIs_unpivot

GO  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL018_KPI_filters]')) Drop VIEW [dbo].[v_IL_GL018_KPI_filters] 
GO

CREATE VIEW [dbo].[v_IL_GL018_KPI_filters]
AS
/**********************************************************************************************************************************************
Description:	View for KPI Ratio calculations
Script Date:	06/25/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_GL018_KPI_filters]
History:		
************************************************************************************************************************************************/
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
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_GL018_KPI_Overview]')) Drop VIEW [dbo].[v_IL_GL018_KPI_Overview] 
GO

CREATE VIEW [dbo].[v_IL_GL018_KPI_Overview]
AS
/**********************************************************************************************************************************************
Description:	View for KPI Ratio calculations
Script Date:	06/25/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_IL_GL018_KPI_Overview]
History:		
************************************************************************************************************************************************/
	
	SELECT 
		coa.ey_account_type AS 'Category'
		--,fj.fiscal_period_cd AS [Fiscal period]
		,fj.ey_period AS [Fiscal period]
		,CASE	WHEN fj.year_flag ='CY' THEN 'Current'
				WHEN fj.year_flag ='PY' THEN 'Prior'
				WHEN fj.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc 
		END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,fj.year_flag as [Year flag]
		,fj.period_flag as [Period flag]

		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group AS [Business unit group]
		--,fj.bu_ref as [Business Unit]
		--,fj.segment1_ref AS [Segment 1]
		--,fj.segment2_ref AS [Segment 2]
		--,fj.segment1_group AS [Segment 1 group]
		--,fj.segment2_group AS [Segment 2 group]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		
		--,src.source_group AS [Source group]
		--,src.source_ref	AS [Source]
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end

		,fj.reporting_amount_curr_cd AS [Reporting currency code]
		,fj.functional_curr_cd AS [Functional currency code]	
		,ROUND(SUM (fj.net_reporting_amount),2) AS [Net reporting amount]
		,ROUND(SUM (fj.net_functional_amount),2) AS [Net functional amount]
		, 'Activity' AS [Source Type]
		, pp.end_date AS [Period end date]
		, NULL AS [Fiscal period sequence]
		, NULL AS [Fiscal period sequence end]
		, NULL AS [Adjustment period]
	FROM dbo.FT_GL_Account FJ --FLAT_JE fj
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and PP.year_flag = FJ.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = FJ.bu_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = Fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = Fj.segment2_id
		--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = fj.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE fj.year_flag IN ('CY','PY')
	--and FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		coa.ey_account_type 
		,fj.ey_period
		,fj.year_flag
		,pp.year_flag_desc 
		,pp.period_flag_desc 
		
		,fj.period_flag 
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group 
		--,fj.bu_ref 
		--,fj.segment1_ref 
		--,fj.segment2_ref 
		--,fj.segment1_group 
		--,fj.segment2_group 
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		
		--,src.source_group
		--,src.source_ref
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end

		,fj.reporting_amount_curr_cd 
		,fj.functional_curr_cd 
		,PP.end_date

	UNION

	SELECT 
		coa.ey_account_sub_type AS 'Category'
		,fj.ey_period AS [Fiscal period]
		,CASE	WHEN fj.year_flag ='CY' THEN 'Current'
				WHEN fj.year_flag ='PY' THEN 'Prior'
				WHEN fj.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,fj.year_flag as [Year flag]
		,fj.period_flag as [Period flag]
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group AS [Business unit group]
		--,fj.bu_ref as [Business Unit]
		--,fj.segment1_ref AS [Segment 1]
		--,fj.segment2_ref AS [Segment 2]
		--,fj.segment1_group AS [Segment 1 group]
		--,fj.segment2_group AS [Segment 2 group]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		
		--,src.source_group AS [Source group]
		--,src.source_ref	AS [Source]
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd AS [Reporting currency code]
		,fj.functional_curr_cd AS [Functional currency code]	
		,ROUND(SUM (fj.net_reporting_amount),2) AS [Net reporting amount]
		,ROUND(SUM (fj.net_functional_amount),2) AS [Net functional amount]
		, 'Activity' AS [Source Type]
		, pp.end_date AS [Period end date]
		, NULL AS [Fiscal period sequence]
		, NULL AS [Fiscal period sequence end]
		, NULL AS [Adjustment period]
	FROM dbo.FT_GL_Account FJ --FLAT_JE fj
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and PP.year_flag = FJ.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = FJ.bu_id
	-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = Fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = Fj.segment2_id
		--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = fj.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE fj.year_flag IN ('CY','PY')
	--and FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		coa.ey_account_sub_type 
		,fj.ey_period
		
		,fj.year_flag
		,fj.period_flag 
		
		,pp.year_flag_desc 
		,PP.period_flag_desc 
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group 
		--,fj.bu_ref 
		--,fj.segment1_ref 
		--,fj.segment2_ref 
		--,fj.segment1_group 
		--,fj.segment2_group 
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		
		--,src.source_group
		--,src.source_ref
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd 
		,fj.functional_curr_cd 
		,pp.end_date 

		UNION

		SELECT 
		coa.ey_account_group_I AS 'Category'
		,fj.ey_period AS [Fiscal period]
		,CASE	WHEN fj.year_flag ='CY' THEN 'Current'
				WHEN fj.year_flag ='PY' THEN 'Prior'
				WHEN fj.year_flag ='SP' THEN 'Subsequent'
				ELSE PP.year_flag_desc 
		END AS [Accounting period]
		,PP.period_flag_desc AS [Accounting sub period]
		,fj.year_flag as [Year flag]
		,fj.period_flag as [Period flag]
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group AS [Business unit group]
		--,fj.bu_ref as [Business Unit]
		--,fj.segment1_ref AS [Segment 1]
		--,fj.segment2_ref AS [Segment 2]
		--,fj.segment1_group AS [Segment 1 group]
		--,fj.segment2_group AS [Segment 2 group]

		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		
		--,src.source_group AS [Source group]
		--,src.source_ref	AS [Source]
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd AS [Reporting currency code]
		,fj.functional_curr_cd AS [Functional currency code]	
		,ROUND(SUM (fj.net_reporting_amount),2) AS [Net reporting amount]
		,ROUND(SUM (fj.net_functional_amount),2) AS [Net functional amount]
		, 'Activity' AS [Source Type]
		, pp.end_date AS [Period end date]
		, NULL AS [Fiscal period sequence]
		, NULL AS [Fiscal period sequence end]
		, NULL AS [Adjustment period]
	FROM dbo.FT_GL_Account FJ --FLAT_JE fj
		INNER JOIN dbo.Parameters_period PP on pp.period_flag = fj.period_flag and PP.year_flag = FJ.year_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = fj.coa_id and coa.bu_id = FJ.bu_id
	-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july begin
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = fj.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = Fj.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = Fj.segment2_id
		--LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = fj.source_id
		-- Added below dynamic views to pull bu,segment, source by prabakar on 1st july end
	WHERE fj.year_flag IN ('CY','PY')
	--and FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		coa.ey_account_group_I 
		,fj.ey_period
		,fj.year_flag
		,pp.year_flag_desc 
		,PP.period_flag_desc 
		
		,fj.period_flag 
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- begin
		--,fj.bu_group 
		--,fj.bu_ref 
		--,fj.segment1_ref 
		--,fj.segment2_ref 
		--,fj.segment1_group 
		--,fj.segment2_group 
		,bu.bu_group
		,bu.bu_ref
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		,s1.ey_segment_group
		,s2.ey_segment_group
		
		--,src.source_group
		--,src.source_ref
		--Commented and Added by prabakar on july 1st to pull bu,segment,soruce from dynamic view -- end
		,fj.reporting_amount_curr_cd 
		,fj.functional_curr_cd 
		,pp.end_date 
	
	UNION

	SELECT 
		coa.ey_account_type AS 'Category'
		,fc.fiscal_period_cd AS [Fiscal period]
		,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,pp.period_flag_desc AS [Accounting sub period]
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		--,'N/A Balances' AS [Source group]
		--,'N/A Balances'	AS [Source]

		,tb.reporting_curr_cd AS [Reporting currency code]
		,tb.functional_curr_cd AS [Functional currency code]	
		,ROUND(SUM (tb.reporting_ending_balance),2) AS [Net reporting amount]
		,ROUND(SUM (tb.functional_ending_balance),2) AS [Net functional amount]
		, 'Balance' AS [Source Type]
		, pp.END_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]
		, fc.adjustment_period AS [Adjustment period]
	FROM dbo.TrialBalance tb
		
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		--	AND fc.fiscal_period_seq = pp.fiscal_period_seq_end

		-- commented and added table by prabakar on july 1st to refer rdm table -- begin
		--INNER JOIN  dbo.dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		-- commented and added table by prabakar on july 1st to refer rdm table -- end
	WHERE pp.year_flag IN ('CY','PY')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--AND fc.fiscal_period_seq = (
	--						SELECT MAX(pp1.fiscal_period_seq_end) 
	--						FROM dbo.Parameters_period pp1 
	--						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--					)
	GROUP BY 
		coa.ey_account_type
		,fc.fiscal_period_cd
		,pp.year_flag
		,pp.year_flag_desc 
		,pp.period_flag_desc 
		,pp.period_flag 
		,bu.bu_group 
		,bu.bu_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 
		, pp.END_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 
		, fc.adjustment_period 
		
	UNION
	
	SELECT 
		coa.ey_account_sub_type AS 'Category'
		,fc.fiscal_period_cd AS [Fiscal period]
		,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,pp.period_flag_desc AS [Accounting sub period]
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]
		--,'N/A Balances' AS [Source group]
		--,'N/A Balances'	AS [Source]

		,tb.reporting_curr_cd AS [Reporting currency code]
		,tb.functional_curr_cd AS [Functional currency code]	
		,ROUND(SUM (tb.reporting_ending_balance),2) AS [Net reporting amount]
		,ROUND(SUM (tb.functional_ending_balance),2) AS [Net functional amount]
		, 'Balance' AS [Source Type]
		, pp.END_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]
		, fc.adjustment_period AS [Adjustment period]
	FROM dbo.TrialBalance tb
				
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		--	AND fc.fiscal_period_seq = pp.fiscal_period_seq_end
		-- commented and added table by prabakar on july 1st to refer rdm table -- begin
		--INNER JOIN  dbo.dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		-- commented and added table by prabakar on july 1st to refer rdm table -- end
	WHERE pp.year_flag IN ('CY','PY')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--AND fc.fiscal_period_seq = (
	--						SELECT MAX(pp1.fiscal_period_seq_end) 
	--						FROM dbo.Parameters_period pp1 
	--						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--					)
	GROUP BY 
		coa.ey_account_sub_type
		,fc.fiscal_period_cd
		,pp.year_flag
		,pp.year_flag_desc 
		,pp.period_flag_desc 
		,pp.period_flag 
		,bu.bu_group 
		,bu.bu_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 
		, pp.END_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 
		, fc.adjustment_period 

	UNION

		SELECT 
		coa.ey_account_group_I AS 'Category'
		,fc.fiscal_period_cd AS [Fiscal period]
		,CASE	WHEN pp.year_flag ='CY' THEN 'Current'
				WHEN pp.year_flag ='PY' THEN 'Prior'
				WHEN pp.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]
		,pp.period_flag_desc AS [Accounting sub period]
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,bu.bu_group AS [Business unit group]
		,bu.bu_ref as [Business Unit]
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref AS [Segment 1]
		--,s2.segment_ref AS [Segment 2]
		,s1.ey_segment_ref AS [Segment 1]
		,s2.ey_segment_ref AS [Segment 2]
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group AS [Segment 1 group]
		,s2.ey_segment_group AS [Segment 2 group]

		--,'N/A Balances' AS [Source group]
		--,'N/A Balances'	AS [Source]

		,tb.reporting_curr_cd AS [Reporting currency code]
		,tb.functional_curr_cd AS [Functional currency code]	
		,ROUND(SUM (tb.reporting_ending_balance),2) AS [Net reporting amount]
		,ROUND(SUM (tb.functional_ending_balance),2) AS [Net functional amount]
		, 'Balance' AS [Source Type]
		, pp.END_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]
		, fc.adjustment_period AS [Adjustment period]
	FROM dbo.TrialBalance tb
		
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		--	AND fc.fiscal_period_seq = pp.fiscal_period_seq_end

		-- commented and added table by prabakar on july 1st to refer rdm table -- begin
		--INNER JOIN  dbo.dim_bu bu on tb.bu_id = bu.bu_id
		--LEFT OUTER JOIN  dbo.Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		--LEFT OUTER JOIN  dbo.Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = tb.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing S2 on s2.ey_segment_id = tb.segment2_id
		-- commented and added table by prabakar on july 1st to refer rdm table -- end

	WHERE pp.year_flag IN ('CY','PY')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--AND fc.fiscal_period_seq = (
	--						SELECT MAX(pp1.fiscal_period_seq_end) 
	--						FROM dbo.Parameters_period pp1 
	--						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--					)
	GROUP BY 
		coa.ey_account_group_I
		,fc.fiscal_period_cd
		,pp.year_flag
		,pp.year_flag_desc 
		,pp.period_flag_desc 
		,pp.period_flag 
		,bu.bu_group 
		,bu.bu_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- begin
		--,s1.segment_ref 
		--,s2.segment_ref 
		,s1.ey_segment_ref
		,s2.ey_segment_ref
		-- commented and added column by prabakar on july 1st to refer rdm table -- end
		,s1.ey_segment_group 
		,s2.ey_segment_group 
		,tb.reporting_curr_cd 
		,tb.functional_curr_cd 
		, pp.END_date 
		, fc.fiscal_period_seq 
		, pp.fiscal_period_seq_END 
		, fc.adjustment_period 

GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_IL_Shared_GL_filters]')) Drop VIEW [dbo].[v_IL_Shared_GL_filters] 
GO
CREATE VIEW [dbo].[v_IL_Shared_GL_filters]
AS
/**********************************************************************************************************************************************
Description:	View to present data for all global filters
Script Date:	17/07/2014
Created By:		TRP
Version:		1
Sample Command:	SELECT	*	FROM	[v_IL_Shared_GL_filters]
History:		
V1				17/07/2014   	TRP		CREATED
************************************************************************************************************************************************/

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
	LEFT OUTER JOIN		 [dbo].[Parameters_period] PP	ON	JE.period_flag = PP.period_flag
	LEFT OUTER JOIN		 dbo.v_User_listing PRP			ON	JE.user_listing_id = PRP.user_listing_id
	LEFT OUTER JOIN		 dbo.v_User_listing ARP			ON	JE.approved_by_id = ARP.user_listing_id
	LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1 ON	JE.segment1_id = SL1.ey_segment_id
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2 ON	JE.segment2_id = SL2.ey_segment_id
	LEFT OUTER JOIN		[dbo].v_Source_listing	SL		ON  JE.source_id = SL.source_id
	LEFT OUTER JOIN		[dbo].v_Chart_of_accounts COA		ON  JE.coa_id = COA.coa_id
	
	--WHERE JE.ver_end_date_id IS NULL  
GO -- new file   
  
