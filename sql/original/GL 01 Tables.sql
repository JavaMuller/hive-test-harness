/**********************************************************************************************************************************************
Description:	Table creation for [DIM_Calendar_seq_date]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[DIM_Calendar_seq_date]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIM_Calendar_seq_date]')) Drop TABLE [dbo].[DIM_Calendar_seq_date]
Go

	CREATE TABLE [dbo].[DIM_Calendar_seq_date]
	(
		Calendar_date DATETIME NULL
		,Sequence INT NULL
	)



GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [FT_GL_Account]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[FT_GL_Account]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FT_GL_Account]')) Drop TABLE [dbo].[FT_GL_Account]

CREATE TABLE [dbo].[FT_GL_Account](
	[coa_id] [int] NOT NULL,
	[period_id] [int] NOT NULL,
	[bu_id] [int] NOT NULL,
	[source_id] [int] NOT NULL,
	[segment1_id] [int] NULL,
	[segment2_id] [int] NULL, 
	[user_listing_id] [int] NULL,
	[approved_by_id] [int] NULL,
	[ey_period] [nvarchar](50) NULL,
	[year_flag] [nvarchar](4) NULL,
	[period_flag] [nvarchar](4) NULL,
	[dr_cr_ind] [char](1) NULL,
	[reversal_ind] [char](1) NULL,
	[Sys_man_ind] [char](1) NULL, 
	[journal_type] [nvarchar](25) NULL,
	[entry_date_id] [int] NULL,
	[effective_date_id] [int] NULL,
	[amount_curr_cd] [nvarchar](50) NULL,
	[reporting_amount_curr_cd] [nvarchar](50) NULL,
	[functional_curr_cd] [nvarchar](50) NULL,
	[net_amount] [float] NULL,
	[net_amount_credit] [float] NULL,
	[net_amount_debit] [float] NULL,
	[net_reporting_amount] [float] NULL,
	[net_reporting_amount_debit] [float] NULL,
	[net_reporting_amount_credit] [float] NULL,
	[net_functional_amount] [float] NULL,
	[net_functional_amount_debit] [float] NULL,
	[net_functional_amount_credit] [float] NULL,
	[count_je_id] INT NULL
	
) ON [PRIMARY]
GO


	--[account_type] [nvarchar](100) NULL,
	--[account_sub_type] [nvarchar](100) NULL,
	--[account_class] [nvarchar](100) NULL,
	--[account_sub_class] [nvarchar](100) NULL,
	--[gl_account_cd] [nvarchar](100) NOT NULL,
	--[gl_account_name] [nvarchar](100) NULL,
	--[ey_gl_account_name] [nvarchar](200) NULL,
	--[ey_account_group_I]  [nvarchar](100) NULL,
	--[ey_account_group_II]  [nvarchar](100) NULL, 

	--[preparer_ref] [nvarchar](200) NULL,
	--[preparer_department] [nvarchar](100) NULL,
	--[approver_Ref] [nvarchar](104) NULL,
	--[approver_department] [nvarchar](100) NULL,
	--[year_flag_desc] [nvarchar](200) NULL,
	--[period_flag_desc] [nvarchar](200) NULL,  
GO -- new file   
  
/**********************************************************************************************************************************************
Description:	Table creation for Ft_JE_Amounts
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	Ft_JE_Amounts
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ft_JE_Amounts]')) Drop TABLE [dbo].[Ft_JE_Amounts]


CREATE TABLE [dbo].[Ft_JE_Amounts]
(
					 [je_id]							[nvarchar](200)			NOT NULL
					,[coa_id]							[int]					NOT NULL
					,[period_id]						[int]					NOT NULL
					,[bu_id]							[int]					NOT NULL
					,[source_id]						[int]					NOT NULL
					,[user_listing_id]					[int]						NULL
					,[approved_by_id]					[int]						NULL
					,[segment1_id]						[int]						NULL
					,[segment2_id]						[int]						NULL
					,[dr_cr_ind]						[char](1)					NULL
					,[reversal_ind]						[char](1)					NULL
					,[sys_manual_ind]					[char](1)					NULL
					,Journal_type 					[nvarchar](25)				 NULL
					,[year_flag]						[char](50)					NULL
					,[period_flag]						[char](50)					NULL
					,[ey_period]						[nvarchar](200)				NULL
					,[entry_date_id]					[int]						NULL
					,[effective_date_id]				[int]						NULL
					,[Net_amount]						[float]						NULL
					,[Net_amount_debit]					[float]						NULL
					,[Net_amount_credit]				[float]						NULL
					,[amount_curr_cd]					[nvarchar](50)				NULL
					,[Net_reporting_amount]				[float]						NULL
					,[Net_reporting_amount_debit]		[float]						NULL
					,[Net_reporting_amount_credit]		[float]						NULL
					,[reporting_amount_curr_cd]			[nvarchar](50)				NULL
					,[Net_functional_amount]			[float]						NULL
					,[Net_functional_debit_amount]		[float]						NULL
					,[Net_functional_credit_amount]		[float]						NULL
					,[functional_amount_curr_cd]		[nvarchar](50)				NULL
					,[count_je_id]						INT							NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_001_Balance_Sheet]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_001_Balance_Sheet]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_001_Balance_Sheet]')) Drop TABLE [dbo].[GL_001_Balance_Sheet]


CREATE TABLE [dbo].[GL_001_Balance_Sheet](
	
		COA_Id INT NULL
		,Period_Id INT NULL
		,Bu_id INT NULL
		,Segment_1_id INT NULL
		,Segment_2_id  INT NULL
		,Source_id INT NULL
		,user_listing_id INT NULL
		,approved_by_id INT NULL
		,Year_flag nvarchar(50) NULL
		,Period_flag  nvarchar(50) NULL
		,Accounting_period nvarchar(100) NULL
		,Accounting_sub_period nvarchar(100) NULL
		,[Year] nvarchar(100) NULL
		,Fiscal_period nvarchar(100) NULL
		,Journal_type nvarchar(25) NULL
		,Functional_Currency_Code nvarchar(50) NULL
		,Reporting_currency_code nvarchar(50) NULL
		,Net_reporting_amount float NULL
		,Net_reporting_amount_credit float NULL
		,Net_reporting_amount_debit float NULL
		,Net_reporting_amount_current float NULL
		,Net_reporting_amount_credit_current float NULL
		,Net_reporting_amount_debit_current float NULL
		,Net_reporting_amount_interim float NULL
		,Net_reporting_amount_credit_interim float NULL
		,Net_reporting_amount_debit_interim float NULL
		,Net_reporting_amount_prior float NULL
		,Net_reporting_amount_credit_prior float NULL
		,Net_reporting_amount_debit_prior float NULL
		,Net_functional_amount float NULL
		,Net_functional_amount_credit float NULL
		,Net_functional_amount_debit float NULL
		,Net_functional_amount_current float NULL
		,Net_functional_amount_credit_current float NULL
		,Net_functional_amount_debit_current float NULL
		,Net_functional_amount_interim float NULL
		,Net_functional_amount_credit_interim float NULL
		,Net_functional_amount_debit_interim float NULL
		,Net_functional_amount_prior float NULL
		,Net_functional_amount_credit_prior float NULL
		,Net_functional_amount_debit_prior float NULL
		,Source_type varchar(17) NULL
		,Period_end_date DATE NULL
		,Fiscal_period_sequence INT NULL
		,Fiscal_period_sequence_end INT NULL


) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_002_Income_Statement]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_002_Income_Statement]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_002_Income_Statement]')) Drop TABLE [dbo].[GL_002_Income_Statement]


CREATE TABLE [dbo].[GL_002_Income_Statement](
	
	COA_Id INT NULL
	,Period_Id INT NULL
	,BU_ID INT NULL
	,Segment_1_id INT NULL
	,Segment_2_id INT NULL
	,Source_id INT NULL
	,user_listing_id INT NULL
	,approved_by_id INT NULL
	,Year_flag nvarchar(50) NULL
	,Period_flag nvarchar(50) NULL
	,Accounting_period nvarchar(100) NULL
	,Accounting_sub_period nvarchar(100) NULL
	,[Year]  nvarchar(100) NULL
	,Fiscal_period nvarchar(100) NULL
	,Journal_type nvarchar(25) NULL
	,Functional_Currency_Code nvarchar(50) NULL
	,Reporting_currency_code nvarchar(50) NULL
	,Net_reporting_amount FLOAT NULL
	,Net_reporting_amount_credit FLOAT NULL
	,Net_reporting_amount_debit FLOAT NULL
	,Net_reporting_amount_current FLOAT NULL
	,Net_reporting_amount_credit_current FLOAT NULL
	,Net_reporting_amount_debit_current FLOAT NULL
	,Net_reporting_amount_interim FLOAT NULL
	,Net_reporting_amount_credit_interim FLOAT NULL
	,Net_reporting_amount_debit_interim FLOAT NULL
	,Net_reporting_amount_prior FLOAT NULL
	,Net_reporting_amount_credit_prior FLOAT NULL
	,Net_reporting_amount_debit_prior FLOAT NULL
	,Net_functional_amount FLOAT NULL
	,Net_functional_amount_credit FLOAT NULL
	,Net_functional_amount_debit FLOAT NULL
	,Net_functional_amount_current FLOAT NULL
	,Net_functional_amount_credit_current FLOAT NULL
	,Net_functional_amount_debit_current FLOAT NULL
	,Net_functional_amount_interim FLOAT NULL
	,Net_functional_amount_credit_interim FLOAT NULL
	,Net_functional_amount_debit_interim FLOAT NULL
	,Net_functional_amount_prior FLOAT NULL
	,Net_functional_amount_credit_prior FLOAT NULL
	,Net_functional_amount_debit_prior FLOAT NULL
	,Source_type VARCHAR(17) NULL
	,Period_end_date DATE NULL

) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_004_Cashflow_Analysis]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_004_Cashflow_Analysis]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_004_Cashflow_Analysis]')) Drop TABLE [dbo].[GL_004_Cashflow_Analysis]


CREATE TABLE [dbo].[GL_004_Cashflow_Analysis](
	coa_id INT NULL,
	bu_id INT NULL,
	source_id INT NULL,
	segment1_id INT NULL,
	segment2_id INT NULL,
	user_listing_id INT NULL,
	approved_by_id INT NULL,
	year_flag NVARCHAR(3) NULL,
	period_flag NVARCHAR(3) NULL,
	ey_period NVARCHAR(16) NULL,
	sys_man_ind NVARCHAR(25) NULL,
	journal_type NVARCHAR(25) NULL,
	functional_curr_cd NVARCHAR(25) NULL,
	reporting_curr_cd NVARCHAR(25) NULL,
	source_type  NVARCHAR(25) NULL,
	net_reporting_amount FLOAT NULL,
	net_reporting_amount_credit FLOAT NULL,
	net_reporting_amount_debit FLOAT NULL,
	net_functional_amount FLOAT NULL,
	net_functional_amount_credit FLOAT NULL,
	net_functional_amount_debit FLOAT NULL

) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_005_Agg_GL_Account]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_005_Agg_GL_Account]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_005_Agg_GL_Account]')) Drop TABLE [dbo].[GL_005_Agg_GL_Account]


CREATE TABLE [dbo].[GL_005_Agg_GL_Account](
	[coa_id] [int] NOT NULL,
	[account_type] [nvarchar](100) NULL,
	[account_sub_type] [nvarchar](100) NULL,
	[account_class] [nvarchar](100) NULL,
	[account_sub_class] [nvarchar](100) NULL,
	[gl_account_cd] [nvarchar](100) NOT NULL,
	[gl_account_name] [nvarchar](100) NULL,
	[ey_gl_account_name] [nvarchar](200) NULL,
	[period_id] [int] NOT NULL,
	[year_flag] [nvarchar](4) NULL,
	[period_flag] [nvarchar](4) NULL,
	[ey_period] [nvarchar](50) NULL,
	[year_flag_desc] [nvarchar](200) NULL,
	[period_flag_desc] [nvarchar](200) NULL,
	[bu_id] [int] NOT NULL,
	[source_id] [int] NOT NULL, 
	[segment1_id] [int] NULL,
	[segment2_id] [int] NULL, 
	/* Removed below columns since its has to pull dyanmically from cdm views by prabakar on july 1st  -- begin */
	--[bu_ref] [nvarchar](250) NULL,
	--[bu_group] [nvarchar](250) NULL,
	--[source_ref] [nvarchar](200) NULL,
	--[source_group] [nvarchar](250) NULL,
	--[segment1_ref] [nvarchar](250) NULL,
	--[segment1_group] [nvarchar](250) NULL,
	--[segment2_ref] [nvarchar](250) NULL,
	--[segment2_group] [nvarchar](250) NULL,
	/* Removed below columns since its has to pull dyanmically from cdm views by prabakar on july 1st  -- end */
	
	[user_listing_id] [int] NOT NULL,
	[preparer_ref] [nvarchar](200) NULL,
	[Preparer_department] [nvarchar](100) NULL,
	[approved_by_id] [int] NULL,
	[Approver_Ref] [nvarchar](104) NULL,
	[Approver_department] [nvarchar](100) NULL,
	[dr_cr_ind] [char](1) NULL,
	[reversal_ind] [char](1) NULL,
	[Sys_man_ind] [char](1) NULL,
	[entry_date_id] [int] NULL,
	[effective_date_id] [int] NULL,
	[amount_curr_cd] [nvarchar](50) NULL,
	[reporting_amount_curr_cd] [nvarchar](50) NULL,
	[functional_curr_cd] [nvarchar](50) NULL,
	[Net_amount] [float] NULL,
	[Net_amount_credit] [float] NULL,
	[Net_amount_debit] [float] NULL,
	[Net_reporting_amount] [float] NULL,
	[Net_reporting_amount_debit] [float] NULL,
	[Net_reporting_amount_credit] [float] NULL,
	[functional_amount] [float] NULL,
	[functional_debit_amount] [float] NULL,
	[functional_credit_amount] [float] NULL,
	[journal_type] [nvarchar](25) NULL
) ON [PRIMARY]
GO




  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_007_Significant_Acct]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_007_Significant_Acct]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_007_Significant_Acct]')) Drop TABLE [dbo].[GL_007_Significant_Acct]


CREATE TABLE [dbo].[GL_007_Significant_Acct](
	
		coa_id INT NULL
		,bu_id INT NULL
		,source_id INT NULL
		,segment1_id INT NULL
		,segment2_id INT NULL
		,user_listing_id INT NULL
		,approved_by_id INT NULL
		,year_flag NVARCHAR(25) NULL
		,period_flag NVARCHAR(25) NULL
		,EY_period  NVARCHAR(50) NULL
		,journal_type NVARCHAR(25) NULL
		,reporting_curr_cd NVARCHAR(25) NULL
		,functional_curr_cd  NVARCHAR(25) NULL
		,source_type NVARCHAR(25) NULL
		,current_amount FLOAT NULL
		,prior_amount FLOAT NULL
		,count_of_je_line_items INT NULL
		,count_of_manual_je_lines INT NULL
		,manual_amount FLOAT NULL 
		,manual_functional_amount FLOAT NULL
		,count_ofdistinct_preparers INT NULL
		,total_debit_activity  FLOAT NULL
		,largest_line_item FLOAT NULL
		,largest_functional_line_item FLOAT NULL
		,total_credit_activity FLOAT NULL
		,net_reporting_amount FLOAT NULL
		,net_reporting_amount_credit FLOAT NULL
		,net_reporting_amount_debit FLOAT NULL
		,net_functional_amount FLOAT NULL
		,net_functional_amount_credit FLOAT NULL
		,net_functional_amount_debit FLOAT NULL
		,functional_ending_balance FLOAT NULL
		,reporting_ending_balance FLOAT NULL
		,net_functional_amount_current FLOAT NULL
		,net_functional_amount_prior FLOAT NULL
		,net_reporting_amount_current FLOAT NULL
		,net_reporting_amount_prior FLOAT NULL

) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_008_JE_Search]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_008_JE_Search]
History:		
V2			20141009		MSH		Table reference change - performance improvements
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_008_JE_Search]')) Drop TABLE [dbo].[GL_008_JE_Search]

CREATE TABLE [dbo].[GL_008_JE_Search](
	
	Journal_entry_id nvarchar(100) null
	,Journal_entry_line nvarchar(100) null
	,Journal_entry_description nvarchar(250) null
	,Journal_entry_type nvarchar(25) null
	,Reporting_amount float null
	,Functional_amount float null
	,Journal_line_description nvarchar(250) null
	,Year_flag	nvarchar(25) NULL
	,Period_flag	nvarchar(25)NULL
	,Bu_id	Int	NULL
	,Segment1_id	Int	 NULL
	,Segment2_id	Int	 NULL
	,Source_id	Int	NULL
	,User_listing_id	Int	 NULL
	,Journal_type	nvarchar(25) NULL
	,ey_period nvarchar(100) NULL

) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_008_JE_Search_Amount]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_008_JE_Search_Amount]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_008_JE_Search_Amount]')) Drop TABLE [dbo].[GL_008_JE_Search_Amount]


CREATE TABLE [dbo].[GL_008_JE_Search_Amount](
	
	Journal_entry_id nvarchar(100) null
	,Journal_entry_line nvarchar(100) null
	,Journal_entry_description nvarchar(250) null
	,Journal_entry_type nvarchar(25) null
	,Reporting_amount float null
	,Functional_amount float null
	 
) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_008_JE_Search_Description]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_008_JE_Search_Description]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_008_JE_Search_Description]')) Drop TABLE [dbo].[GL_008_JE_Search_Description]


CREATE TABLE [dbo].[GL_008_JE_Search_Description](
	
	Journal_entry_id nvarchar(100) null
	,Journal_entry_line nvarchar(100) null
	,Journal_line_description nvarchar(250) null
	,Journal_entry_description nvarchar(250) null
	,Journal_entry_type nvarchar(25) null

) ON [PRIMARY]
GO
  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_012_Date_Analysis]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_012_Date_Analysis]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_012_Date_Analysis]')) Drop TABLE [dbo].[GL_012_Date_Analysis]

CREATE TABLE [dbo].GL_012_Date_Analysis
(
	Je_Id	nvarchar(100) NULL
	,Je_Line_Id	nvarchar(100) NULL
	,Account_Code	nvarchar(200) NULL
	,GL_Account	nvarchar(200) NULL
	,Account_Class	nvarchar(200) NULL
	,Fiscal_period	nvarchar(100) NULL
	,Year_flag	nvarchar(25) NULL
	,Period_flag	nvarchar(25)NULL
	,Bu_id	Int	NULL
	,Segment1_id	Int	 NULL
	,Segment2_id	Int	 NULL
	,Source_id	Int	NULL
	,User_listing_id	Int	 NULL
	,Approver_by_id	Int	 NULL
	,Journal_type	nvarchar(25) NULL
	,Adjusted_fiscal_period	nvarchar(50) NULL
	,Day_number_of_week	int	 NULL
	,Day_Of_Week	nvarchar(50) NULL
	,Day_of_month	int	 NULL
	,Calendar_date	datetime NULL	
	,Sequence_number	int	 NULL
	,Reporting_currency_code	nvarchar(50) NULL
	,Functional_Currency_Code	nvarchar(50)NULL
	,Net_reporting_amount	float	NULL
	,Net_reporting_amount_credit	float	 NULL
	,Net_reporting_amount_debit	float	NULL
	,Net_functional_amount	float	 NULL
	,Net_functional_amount_debit	float NULL	
	,Net_functional_amount_credit	float NULL
	,Net_Amount	float	NULL
	,Net_Amount_Credit	float	 NULL
	,Net_Amount_Debit	float	NULL

) ON [PRIMARY]
GO  
GO -- new file   
  
/**********************************************************************************************************************************************
Description:	Table creation for GL_012_Date_Validation
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	GL_012_Date_Validation
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_012_Date_Validation]')) Drop TABLE [dbo].[GL_012_Date_Validation]

CREATE TABLE [dbo].[GL_012_Date_Validation](
	[coa_id] [int] NULL,
	/*  Added below column to work with dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
	[bu_id] [int] NULL,
	[segment1_id] [int] NULL,
	[segment2_id] [int] NULL,
	[source_id] [int] NULL,
	[user_listing_id] INT NULL,
	[approver_by_id] INT NULL,
	/*  Added below column to work with dynamic views to bring the data of bu, segment, source by Prabakar -- end */		
	[year_flag] [nvarchar](25) NULL,
	[period_flag] [nvarchar](25) NULL,
	[ey_period] [nvarchar](100) NULL,
	[entry_date] [datetime] NULL,
	[Effective_date] [datetime] NULL,
	[min_max_ent_eff_date] [datetime] NULL,
	[category] [nvarchar](100) NULL,
	[je_id_count] [int] NULL,
	[days_lag] [int] NULL,
	[sys_manual_ind] [char](1) NULL,
	[journal_type] [nvarchar](25) NULL,
	[functional_curr_cd] [nvarchar](100) NULL,
	[reporting_amount_curr_cd] [nvarchar](100) NULL,
	[net_reporting_amount] [float] NULL,
	[net_reporting_amount_credit] [float] NULL,
	[net_reporting_amount_debit] [float] NULL,
	[net_functional_amount] [float] NULL,
	[net_functional_credit_amount] [float] NULL,
	[net_functional_debit_amount] [float] NULL,
	[net_amount] [float] NULL,
	[net_amount_credit] [float] NULL,
	[net_amount_debit] [float] NULL
	--[year_flag_desc] [nvarchar](100) NULL,
	--[period_flag_desc] [nvarchar](100) NULL,
	--[source_ref] [nvarchar](100) NULL,
	--[source_group] [nvarchar](100) NULL,
	--[preparer_ref] [nvarchar](200) NULL,
	--[preparer_department] [nvarchar](100) NULL,
	--[gl_account_cd] [nvarchar](100) NULL,
	--[ey_gl_account_name] [nvarchar](200) NULL,
	--[account_type] [nvarchar](100) NULL,
	--[account_sub_type] [nvarchar](100) NULL,
	--[ey_account_class] [nvarchar](100) NULL,
	--[account_sub_class] [nvarchar](100) NULL,
	--[ey_account_group_I] [nvarchar](100) NULL,
	--[bu_ref] [nvarchar](200) NULL,
	--[bu_group] [nvarchar](200) NULL,
	--[segment1_group] [nvarchar](100) NULL,
	--[segment2_group] [nvarchar](100) NULL,
	--[segment1_ref] [nvarchar](100) NULL,
	--[segment2_ref] [nvarchar](100) NULL,
	--[approver_department] [nvarchar](100) NULL,
	--[approver_ref] [nvarchar](100) NULL,
	--[max_effective_entry_diff] [int] NULL,
) ON [PRIMARY]
GO



  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_016_Balance_by_GL]
Script Date:	08/21/2014
Created By:		AO
Version:		1
Sample Command:	SELECT	*	FROM	[GL_016_Balance_by_GL]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_016_Balance_by_GL]')) Drop TABLE [dbo].[GL_016_Balance_by_GL]


CREATE TABLE [dbo].[GL_016_Balance_by_GL](
	coa_id INT NULL,
	bu_id INT NULL,
	source_id INT NULL,
	segment1_id INT NULL,
	segment2_id INT NULL,
	user_listing_id INT NULL,
	approved_by_id INT NULL,
	year_flag NVARCHAR(25) NULL,
	period_flag NVARCHAR(25) NULL,
	ey_period NVARCHAR(50) NULL,
	sys_man_ind NVARCHAR(25) NULL,
	journal_type NVARCHAR(25) NULL,
	functional_curr_cd NVARCHAR(50) NULL,
	reporting_curr_cd NVARCHAR(50) NULL,
	source_type  NVARCHAR(25) NULL,
	net_reporting_amount FLOAT NULL,
	net_reporting_amount_credit FLOAT NULL,
	net_reporting_amount_debit FLOAT NULL,
	net_functional_amount FLOAT NULL,
	net_functional_amount_credit FLOAT NULL,
	net_functional_amount_debit FLOAT NULL,
	
	--- fixing the prod issue
	period_id INT NULL,
	[ey_account_type] [nvarchar](100) NULL,
	[ey_account_sub_type] [nvarchar](100) NULL,
	[ey_account_class] [nvarchar](100) NULL,
	[ey_account_sub_class] [nvarchar](100) NULL,
	[gl_account_cd] [nvarchar](100) NULL,
	[gl_account_name] [nvarchar](100) NULL,
	[ey_gl_account_name] [nvarchar](200) NULL,
	[ey_account_group_I] [nvarchar](100) NULL,
	[bu_ref] [nvarchar](100) NULL,
	[bu_group] [nvarchar](100) NULL,
	[year_flag_desc] [nvarchar](100) NULL,
	[period_flag_desc] [nvarchar](100) NULL,
	[department] [nvarchar](100) NULL,
	[preparer_ref] [nvarchar](200) NULL,
	[source_ref] [nvarchar](200) NULL,
	[source_group] [nvarchar](200) NULL,
	[segment1_ref] [nvarchar](200) NULL,
	[segment2_ref] [nvarchar](200) NULL,
	[segment1_group] [nvarchar](200) NULL,
	[segment2_group] [nvarchar](200) NULL,
	[sys_manual_ind] [nvarchar](2) NULL,
	[trial_balance_start_date_id] [varchar](25) NULL,
	[trial_balance_end_date_id] [varchar](25) NULL,
	[Beginning_balance] [float] NULL,
	[Ending_balance] [float] NULL,
	[functional_beginning_balance] [float] NULL,
	[functional_ending_balance] [float] NULL,
	[reporting_beginning_balance] [float] NULL,
	[reporting_ending_balance] [float] NULL,
	[Calc_reporting_ending_bal] [float] NULL,
	[Diff_btw_calc_end_and_report_ending] [float] NULL,
	[Calc_functional_ending_bal] [float] NULL,
	[Diff_btw_calc_end_and_func_ending] [float] NULL,

	

) ON [PRIMARY]
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_016_Data_stats_blanks]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_016_Data_stats_blanks]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_016_Data_stats_blanks]')) Drop TABLE [dbo].[GL_016_Data_stats_blanks]
CREATE TABLE [dbo].[GL_016_Data_stats_blanks](
	[Metric_B] [nvarchar](250) NULL,
	[Metric_Count_B] [int] NULL,
	[Period_Type_B] [nvarchar](250) NULL,
	[Period_Flag] [nvarchar](50) NULL,
	[Column_Name] [nvarchar](250) NULL,
	[Start_Date] [nvarchar](250) NULL,
	[End_Date] [nvarchar](250) NULL
) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_016_Data_stats_totals]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_016_Data_stats_totals]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_016_Data_stats_totals]')) Drop TABLE [dbo].[GL_016_Data_stats_totals]

CREATE TABLE [dbo].[GL_016_Data_stats_totals]
(
					 [Metric_T]					[nvarchar](250)				NULL
					,[Metric_Count_T]			[int]						NULL
					,[Period_Type_T]			[nvarchar](250)				NULL
) ON [PRIMARY]

GO


  
GO -- new file   
  
/**********************************************************************************************************************************************
Description:	Table creation for GL_017_Change_in_Preparers
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	GL_017_Change_in_Preparers
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_017_Change_in_Preparers]')) Drop TABLE [dbo].[GL_017_Change_in_Preparers]

CREATE TABLE [dbo].[GL_017_Change_in_Preparers](
	--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
	[bu_id] [int] NULL,
	[source_id] [int] NULL,
	[segment1_id][int] NULL,
	[segment2_id][int] NULL,
	--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 --end
	

	[year_flag_desc] [nvarchar](100) NULL,
	[period_flag_desc] [nvarchar](100) NULL,
	[year_flag] [nvarchar](25) NULL,
	[period_flag] [nvarchar](25) NULL,
	[bu_group] [nvarchar](200) NULL,
	[bu_ref] [nvarchar](200) NULL,
	[segment1_ref] [nvarchar](125) NULL,
	[segment2_ref] [nvarchar](125) NULL,
	[segment1_group] [nvarchar](100) NULL,
	[segment2_group] [nvarchar](100) NULL,
	[Ey_period] [nvarchar](50) NULL,
	[source_group] [nvarchar](200) NULL,
	[Source_ref] [nvarchar](200) NULL,
	[sys_manual_ind] [nvarchar](2) NULL,
	[Journal_type] [nvarchar](25) NULL,
	[preparer_ref] [nvarchar](200) NULL,
	[department] [nvarchar](100) NULL,
	[Category] [varchar](25) NULL, -- updated the length from 6 - 25
	[reporting_amount_curr_cd] [nvarchar](25) NULL,
	[functional_curr_cd] [nvarchar](25) NULL
) ON [PRIMARY]

GO




  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [GL_018_KPIs_unpivot]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[GL_018_KPIs_unpivot]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GL_018_KPIs_unpivot]')) Drop TABLE [dbo].[GL_018_KPIs_unpivot]


CREATE TABLE [dbo].[GL_018_KPIs_unpivot](
			
			[source_id] [int] NOT NULL,
			[source_ref] [nvarchar](200) NULL,
			[source_group] [nvarchar](250) NULL,
			[Source_Cd] [nvarchar](25) NULL,
			[Source_Desc] [nvarchar](100) NULL,
			--[bu_id] [int] NOT NULL,
			[bu_ref] [nvarchar](125) NULL,
			[bu_group] [nvarchar](125) NULL,
			[Preparer_Name] [nvarchar](200) NULL,
			[preparer_ref] [nvarchar](100) NULL,
			[Preparer_department] [nvarchar](100) NULL,
			[journal_type] [nvarchar](25) NULL,
			[segment1_ref] [nvarchar](250) NULL,
			[segment1_group] [nvarchar](250) NULL,
			[segment2_ref] [nvarchar](250) NULL,
			[segment2_group] [nvarchar](250) NULL,
			[year_flag_desc] [nvarchar](200) NULL,
			[period_flag_desc] [nvarchar](200) NULL,
			[ey_period] [nvarchar](50) NULL,
			[Ratio_type] [nvarchar](50) NULL,
			[Ratio] [nvarchar](50) NULL,
			[Amount] FLOAT NULL,
			[Multiplier] INT NULL
			
) ON [PRIMARY]
GO






  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [TrialBalance]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[TrialBalance]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrialBalance]')) Drop TABLE [dbo].[TrialBalance]


CREATE TABLE [dbo].[TrialBalance]
(
					 [coa_id]									[int]						NOT	NULL
					,[bu_id]									[int]						NOT	NULL
					,[period_id]								[int]						NOT	NULL
					,[segment1_id]								[int]							NULL
					,[segment2_id]								[int]							NULL
					,[engagement_id]							[nvarchar](100)					NULL
					,[trial_balance_start_date_id]				[int]							NULL
					,[trial_balance_end_date_id]				[int]							NULL
					,[functional_beginning_balance]				[float]							NULL
					,[functional_ending_balance]				[float]							NULL
					,[functional_curr_cd]						[nvarchar](8)					NULL
					,[beginning_balance]						[float]							NULL
					,[ending_balance]							[float]							NULL
					,[balance_curr_cd]							[nvarchar](8)					NULL
					,[reporting_beginning_balance]				[float]							NULL
					,[reporting_ending_balance]					[float]							NULL
					,[reporting_curr_cd]						[nvarchar](8)					NULL
					,[ver_start_date_id]						[int]							NULL
					,[ver_end_date_id]							[int]							NULL
					,[ver_desc]									[nvarchar](100)					NULL
) ON [PRIMARY]

GO


  
GO -- new file   
  
ALTER TABLE dbo.FLAT_JE ADD CONSTRAINT [PK_RDM_FLAT_JE_JE_LINE_ID] PRIMARY KEY CLUSTERED (je_id, je_line_id);
GO

IF EXISTS (SELECT * FROM SYS.sysindexes WHERE NAME = 'IX_FLAT_JE_Global_filters' ) DROP INDEX  IX_FLAT_JE_Global_filters ON dbo.FLAT_JE
GO

	CREATE NONCLUSTERED  INDEX [IX_FLAT_JE_Global_filters]   ON dbo.[FLAT_JE] (coa_id,period_id,bu_id,source_id,segment1_id,segment2_id,approved_by_id,year_flag,period_flag,user_listing_id)
	GO

IF EXISTS (SELECT * FROM SYS.sysindexes WHERE NAME = 'IX_FLAT_JE_Global_filters_partial1' ) DROP INDEX  IX_FLAT_JE_Global_filters_partial1 ON dbo.FLAT_JE
GO

	CREATE NONCLUSTERED  INDEX [IX_FLAT_JE_Global_filters_partial1]  ON dbo.[FLAT_JE] (coa_id,bu_id,source_id,segment1_id,segment2_id)
	GO


IF EXISTS (SELECT * FROM SYS.sysindexes WHERE NAME = 'IX_FT_JE_Amounts_Global_filters' ) DROP INDEX  IX_FT_JE_Amounts_Global_filters ON dbo.[FT_JE_Amounts]
GO

	CREATE NONCLUSTERED  INDEX [IX_FT_JE_Amounts_Global_filters] ON dbo.[FT_JE_Amounts] (coa_id,period_id,bu_id,source_id,user_listing_id,approved_by_id,segment1_id,segment2_id,year_flag,period_flag)
	GO

IF EXISTS (SELECT * FROM SYS.sysindexes WHERE NAME = 'IX_FT_GL_Account_coa_id_bu_id' ) DROP INDEX  IX_FT_GL_Account_coa_id_bu_id ON dbo.[FT_GL_ACCOUNT]
GO
	CREATE NONCLUSTERED  INDEX [IX_FT_GL_Account_coa_id_bu_id]                        ON dbo.[FT_GL_ACCOUNT]    (coa_id,bu_id)
	GO

IF EXISTS (SELECT * FROM SYS.sysindexes WHERE NAME = 'IX_FT_GL_Account_Global_filters_partial1' ) DROP INDEX  IX_FT_GL_Account_Global_filters_partial1 ON dbo.[FT_GL_ACCOUNT]
GO
	CREATE NONCLUSTERED  INDEX [IX_FT_GL_Account_Global_filters_partial1]      ON dbo.[FT_GL_ACCOUNT]    (coa_id,bu_id,source_id,segment1_id,segment2_id)
	GO


IF EXISTS (SELECT * FROM SYS.sysindexes WHERE NAME = 'IX_TrialBalance_Global_filters_partial1' ) DROP INDEX  IX_TrialBalance_Global_filters_partial1 ON dbo.[TrialBalance]
GO

	CREATE NONCLUSTERED  INDEX [IX_TrialBalance_Global_filters_partial1]  ON dbo.[TrialBalance]  (coa_id,bu_id,period_id,segment1_id,segment2_id)
	GO

  
GO -- new file   
  
