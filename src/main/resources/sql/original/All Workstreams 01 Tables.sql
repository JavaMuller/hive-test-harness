/**************************************************************************** 
Description:	Customer master parameter Table for using full names of country and currency codes  
Script Date:	18/06/2013 
Created By:		MSH
*******************************************************************************/


-- *******************************************************************************
-- Country_currency_mapping Table for using full names of country and currency codes  
-- *******************************************************************************

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country_currency_mapping]')) Drop TABLE [dbo].[Country_currency_mapping]

CREATE TABLE [dbo].[Country_currency_mapping]
(

	 country_cd									NVARCHAR(10)		NULL		
	,country									NVARCHAR(200)		NULL		
	,currency_cd								NVARCHAR(10)		NULL		
	,currency									NVARCHAR(200)		NULL		

)
GO
  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_BU]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_BU]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_BU]')) Drop TABLE [dbo].[Dim_BU]



CREATE TABLE [dbo].[Dim_BU]
(
					 [bu_id]						[int]					NOT	NULL
					,[bu_cd]						[nvarchar](50)				NULL
					,[bu_desc]						[nvarchar](200)				NULL
					,[bu_ref]						[nvarchar](250)				NULL
					,[bu_group]						[nvarchar](200)				NULL
					,[ver_start_date_id]			[int]						NULL
					,[ver_end_date_id]				[int]						NULL
					,[ver_desc]						[nvarchar](200)				NULL


) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [DIM_Chart_of_Accounts]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[DIM_Chart_of_Accounts]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DIM_Chart_of_Accounts]')) Drop TABLE [dbo].[DIM_Chart_of_Accounts]


CREATE TABLE [dbo].[DIM_Chart_of_Accounts]
(
					 [Coa_id]									[int]				NOT		NULL
					,[bu_id]									[int]						NULL
					,[coa_effective_date_id]					[int]						NULL
					,[gl_account_cd]							[nvarchar](200)				NULL
					,[gl_subacct_cd]							[nvarchar](200)				NULL
					,[gl_account_name]							[nvarchar](200)				NULL
					,[gl_subacct_name]							[nvarchar](200)				NULL
					,[consolidation_account]					[nvarchar](200)				NULL
					,[ey_gl_account_name]						[nvarchar](400)				NULL
					,[ey_account_type]							[nvarchar](200)				NULL
					,[ey_account_sub_type]						[nvarchar](200)				NULL
					,[ey_account_class]							[nvarchar](200)				NULL
					,[ey_account_sub_class]						[nvarchar](200)				NULL
					,[ey_account_group_I]						[nvarchar](200)				NULL
					,[ey_account_group_II]						[nvarchar](200)				NULL
					,[ey_cash_activity]							[nvarchar](200)				NULL
					,[ey_index]									[nvarchar](200)				NULL
					,[ey_sub_index]								[nvarchar](200)				NULL
					,[created_by_id]							[int]						NULL
					,[created_date_id]							[int]						NULL
					,[created_time_id]							[int]						NULL
					,[last_modified_by_id]						[int]						NULL
					,[last_modified_date_id]					[int]						NULL
					,[ver_desc]									[nvarchar](200)				NULL
					,[ver_start_date_id]						[int]						NULL
					,[ver_end_date_id]							[int]						NULL
	
) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Dates]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Dates]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Dates]')) Drop TABLE [dbo].[Dim_Dates]


CREATE TABLE [dbo].[Dim_Dates]
(
				 [calendar_date]				[datetime]					NULL
				,[date_id]						[int]					NOT	NULL
				,[month_id]						[int]						NULL
				,[month_desc]					[nvarchar](100)				NULL
				,[quarter_id]					[int]						NULL
				,[quarter_desc]					[nvarchar](100)				NULL
				,[year_id]						[int]						NULL
				,[day_number_of_week]			[int]						NULL
				,[day_of_week_desc]				[nvarchar](100)				NULL
				,[day_number_of_month]			[int]						NULL
				,[day_number_of_year]			[int]						NULL
				,[week_number_of_year]			[int]						NULL
	
) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Fiscal_calendar]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Fiscal_calendar]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Fiscal_calendar]')) Drop TABLE [dbo].[Dim_Fiscal_calendar]


CREATE TABLE [dbo].[Dim_Fiscal_calendar]
(
					 [period_id]					[int]			NOT		NULL
					,[bu_id]						[int]					NULL
					,[fiscal_period_cd]				[nvarchar](50)			NULL
					,[fiscal_period_desc]			[nvarchar](100)			NULL
					,[fiscal_period_start]			[nvarchar](50)			NULL
					,[fiscal_period_end]			[nvarchar](50)			NULL
					,[fiscal_quarter_cd]			[nvarchar](50)			NULL
					,[fiscal_quarter_desc]			[nvarchar](100)			NULL
					,[fiscal_quarter_start]			[nvarchar](50)			NULL
					,[fiscal_quarter_end]			[nvarchar](50)			NULL
					,[fiscal_year_cd]				[nvarchar](50)			NULL
					,[fiscal_year_desc]				[nvarchar](100)			NULL
					,[fiscal_year_start]			[nvarchar](50)			NULL
					,[fiscal_year_end]				[nvarchar](50)			NULL
					,[adjustment_period]			[nvarchar](1)			NULL
					,[engagement_id]				[uniqueidentifier]		NULL
					,[fiscal_period_seq]			[int]					NULL
					,[ver_start_date_id]			[int]					NULL
					,[ver_end_date_id]				[int]					NULL
					,[ver_desc]						[nvarchar](200)			NULL
		
) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Preparer]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Preparer]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Preparer]')) Drop TABLE [dbo].[Dim_Preparer]


CREATE TABLE [dbo].[Dim_Preparer]
(
					 [user_listing_id]					[int]					NOT	NULL
					,[client_user_id]					[nvarchar](25)				NULL
					,[first_name]						[nvarchar](100)				NULL
					,[last_name]						[nvarchar](100)				NULL
					,[full_name]						[nvarchar](100)				NULL
					,[preparer_ref]						[nvarchar](200)				NULL
					,[department]						[nvarchar](100)				NULL
					,[title]							[nvarchar](100)				NULL
					,[role_resp]						[nvarchar](100)				NULL
					,[sys_manual_ind]					[char](1)					NULL
					,[active_ind]						[char](1)					NULL
					,[active_ind_change_date_id]		[int]						NULL
					,[created_by_id]					[int]						NULL
					,[created_date_id]					[int]						NULL
					,[created_time_id]					[int]						NULL
					,[last_modified_by_id]				[int]						NULL
					,[last_modified_date_id]			[int]						NULL
					,[ver_start_date_id]				[int]						NULL
					,[ver_end_date_id]					[int]						NULL
	
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Segment01_listing]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Segment01_listing]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Segment01_listing]')) Drop TABLE [dbo].[Dim_Segment01_listing]


CREATE TABLE [dbo].[Dim_Segment01_listing]
(
			 [segment_id]			[int]					NOT NULL
			,[engagement_id]		[uniqueidentifier]		NULL
			,[segment_cd]			[nvarchar](25)			NULL
			,[segment_desc]			[nvarchar](100)			NULL
			,[segment_ref]			[nvarchar](125)			NULL
			,[ey_segment_group]		[nvarchar](100)			NULL
			,[ver_start_date_id]	[int]					NOT NULL
			,[ver_end_date_id]		[int]					NULL
			,[ver_desc]				[nvarchar](100)			NULL

) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Segment02_listing]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Segment02_listing]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Segment02_listing]')) Drop TABLE [dbo].[Dim_Segment02_listing]


CREATE TABLE [dbo].[Dim_Segment02_listing]
(
				 [segment_id]				[int]						NOT NULL
				,[engagement_id]			[uniqueidentifier]			NULL
				,[segment_cd]				[nvarchar](25)				NULL
				,[segment_desc]				[nvarchar](100)				NULL
				,[segment_ref]				[nvarchar](125)				NULL
				,[ey_segment_group]			[nvarchar](100)				NULL
				,[ver_start_date_id]		[int]						NOT NULL
				,[ver_end_date_id]			[int]						NULL
				,[ver_desc]					[nvarchar](100)				NULL
) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Source_listing]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Source_listing]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Source_listing]')) Drop TABLE [dbo].[Dim_Source_listing]

CREATE TABLE [dbo].[Dim_Source_listing]
(
					 [Source_Id]						[int]					NOT	NULL
					,[source_cd]						[nvarchar](25)				NULL
					,[source_desc]						[nvarchar](100)				NULL
					,[erp_subledger_module]				[nvarchar](100)				NULL
					,[bus_process_major]				[nvarchar](100)				NULL
					,[bus_process_minor]				[nvarchar](100)				NULL
					,[source_ref]						[nvarchar](200)				NULL
					,[sys_manual_ind]					[char](1)					NULL
					,[ver_start_date_id]				[int]						NULL
					,[ver_end_date_id]					[int]						NULL
					,[ver_desc]							[nvarchar](100)				NULL
					,[ey_source_group]					[nvarchar](200)				NULL

	
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [Dim_Transaction_Type]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[Dim_Transaction_Type]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dim_Transaction_Type]')) Drop TABLE [dbo].[Dim_Transaction_Type]


CREATE TABLE [dbo].[Dim_Transaction_Type]
(
				 [transaction_type_id]					[int]							NOT NULL
				,[transaction_type_cd]					[nvarchar](25)					NOT NULL
				,[bu_id]								[int]							NOT NULL
				,[engagement_id]						[uniqueidentifier]				NOT NULL
				,[transaction_type_desc]				[nvarchar](100)					NULL
				,[transaction_type_group_desc]			[nvarchar](100)					NULL
				,[EY_transaction_type]					[nvarchar](25)					NULL
				,[entry_by_id]							[int]							NULL
				,[entry_date_id]						[int]							NOT NULL
				,[entry_time_id]						[int]							NOT NULL
				,[last_modified_by_id]					[int]							NOT NULL
				,[last_modified_date_id]				[int]							NOT NULL
				,[ver_start_date_id]					[int]							NOT NULL
				,[ver_end_date_id]						[int]							NULL
				,[ver_desc]								[nvarchar](100)					NULL
				,[transaction_type_ref]					[nvarchar](125)					NULL
) ON [PRIMARY]

GO


  
GO -- new file   
  

/**********************************************************************************************************************************************
Description:	Table creation for [FLAT_JE]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[FLAT_JE]
History:		
************************************************************************************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FLAT_JE]')) Drop TABLE [dbo].[FLAT_JE]



CREATE TABLE [dbo].[FLAT_JE]
(
	 ID												BIGINT IDENTITY(1,1)
	,[je_id]										[nvarchar](100)							NOT NULL
	,[je_line_id]									[nvarchar](100)							NOT NULL
	,[je_line_desc]									[nvarchar](250)							NULL
	,[je_header_desc]								[nvarchar](250)							NULL
	,[dr_cr_ind]									[char](1)								NULL
	,[coa_id]										[int]									NOT NULL
	,[period_id]									[int]									NOT NULL
	,[bu_id]										[int]									NOT NULL
	,[source_id]									[int]									NOT NULL
	,[segment1_id]									[int]									NULL
	,[segment2_id]									[int]									NULL
	--- Added for Feature purpose and populated from Journal Entires
	,[segment3_id]									[int]									NULL
	,[segment4_id]									[int]									NULL
	,[segment5_id]									[int]									NULL

	,[ey_je_id]										[nvarchar](100)							NULL
	,[activity]										[nvarchar](100)							NULL
	,[approved_by_id]								[int]									NULL
	,[transaction_type_id]							[int]									NOT NULL
	,[reversal_ind]									[char](1)								NULL
	,[sys_manual_ind]								[char](1)								NULL
	,[year_flag]									[nvarchar](25)							NULL
	,[period_flag]									[nvarchar](25)							NULL
	,[year_flag_desc]								[nvarchar](10)							NULL
	,[period_flag_desc]								[nvarchar](100)							NULL
	,[year_end_date]								[date]									NULL
	,[period_end_date]								[date]									NULL
	,[gl_account_cd]								[nvarchar](200)							NULL
	,[gl_subacct_cd]								[nvarchar](200)							NULL
	,[gl_account_name]								[nvarchar](200)							NULL
	,[gl_subacct_name]								[nvarchar](200)							NULL
	,[ey_gl_account_name]							[nvarchar](200)							NULL
	,[consolidation_account]						[nvarchar](200)							NULL
	,[ey_account_type]								[nvarchar](200)							NULL
	,[ey_account_sub_type]							[nvarchar](200)							NULL
	,[ey_account_class]								[nvarchar](200)							NULL
	,[ey_cash_activity]								[nvarchar](200)							NULL
	,[ey_account_sub_class]							[nvarchar](200)							NULL
	,[ey_index]										[nvarchar](200)							NULL
	,[ey_sub_index]									[nvarchar](200)							NULL
	,[ey_account_group_I]							[nvarchar](200)							NULL
	,[ey_account_group_II]							[nvarchar](200)							NULL
	,[sys_manual_ind_src]							[char](1)								NULL
	,[sys_manual_ind_usr]							[char](1)								NULL
	,[user_listing_id]								[int]									NULL
	,[client_user_id]								[nvarchar](25)							NULL
	,[preparer_ref]									[nvarchar](200)							NULL
	,[first_name]									[nvarchar](100)							NULL
	,[last_name]									[nvarchar](100)							NULL
	,[full_name]									[nvarchar](100)							NULL
	,[department]									[nvarchar](100)							NULL
	,[role_resp]									[nvarchar](100)							NULL
	,[title]										[nvarchar](100)							NULL
	,[active_ind]									[char](1)								NULL
	-- commented below columns since it has to pull from cdm dyanmic view instead of storing by prabakar on july 01 -- begin
	--,[source_cd]									[nvarchar](25)							NULL
	--,[source_desc]									[nvarchar](100)							NULL
	--,[source_ref]									[nvarchar](200)							NULL
	--,[source_group]									[nvarchar](200)							NULL
	--,[segment1_desc]								[nvarchar](100)							NULL
	--,[segment2_desc]								[nvarchar](100)							NULL
	--,[segment1_group]								[nvarchar](100)							NULL
	--,[segment2_group]								[nvarchar](100)							NULL
	--,[segment1_ref]									[nvarchar](125)							NULL
	--,[segment2_ref]									[nvarchar](125)							NULL
	--,[bu_cd]										[nvarchar](50)							NULL
	--,[bu_desc]										[nvarchar](200)							NULL
	--,[bu_ref]										[nvarchar](250)							NULL
	--,[bu_group]										[nvarchar](200)							NULL
	-- commented below columns since it has to pull from cdm dyanmic view instead of storing by prabakar on july 01 -- end
	,[transaction_type_group_desc]					[nvarchar](100)							NULL
	,[transaction_type]								[nvarchar](25)							NULL
	,[fiscal_period_cd]								[nvarchar](50)							NOT NULL
	,[fiscal_period_desc]							[nvarchar](100)							NULL
	,[fiscal_period_start]							[nvarchar](50)							NOT NULL
	,[fiscal_period_end]							[nvarchar](50)							NOT NULL
	,[fiscal_quarter_start]							[nvarchar](50)							NULL
	,[fiscal_quarter_end]							[nvarchar](50)							NULL
	,[fiscal_year_start]							[nvarchar](50)							NULL
	,[fiscal_year_end]								[nvarchar](50)							NULL
	,[EY_fiscal_year]								[nvarchar](100)							NULL
	,[EY_quarter]									[nvarchar](100)							NULL
	,[EY_period]									[nvarchar](100)							NULL
	,[Entry_Date]									[datetime]								NULL
	,[Day_of_week]									[nvarchar](25)							NULL
	,[Effective_Date]								[datetime]								NULL
	,[Lag_Date]										[int]									NULL
	,[exchange_rate]								[float]									NOT NULL
	,[local_exchange_rate]							[float]									NOT NULL
	,[reporting_exchange_rate]						[float]									NOT NULL
	,[effective_date_id]							[int]									NOT NULL
	,[entry_date_id]								[int]									NOT NULL
	,[functional_curr_cd]							[nvarchar](25)							NOT NULL
	,[functional_amount]							[float]									NOT NULL
	,[functional_debit_amount]						[float]									NOT NULL
	,[functional_credit_amount]						[float]									NOT NULL
	,[amount]										[float]									NOT NULL
	,[amount_debit]									[float]									NOT NULL
	,[amount_credit]								[float]									NOT NULL
	,[amount_curr_cd]								[nvarchar](25)							NOT NULL
	,[reporting_amount]								[float]									NOT NULL
	,[reporting_amount_curr_cd]						[nvarchar](25)							NOT NULL
	,[reporting_amount_debit]						[float]									NOT NULL
	,[reporting_amount_credit]						[float]									NOT NULL
	,[engagement_id]								[uniqueidentifier]						NOT NULL
	,[entry_time_id]								[int]									NOT NULL
	,[last_modified_by_id]							[int]									NOT NULL
	,[last_modified_date_id]						[int]									NOT NULL
	,[approved_by_date_id]							[int]									NOT NULL
	,[reversal_je_id]								[nvarchar](100)							NULL
	,[GL_clearing_document]							[nvarchar](100)							NULL
	,[GL_clearing_date_id]							[int]									NOT NULL
	,[ver_start_date_id]							[int]									NOT NULL
	,[ver_end_date_id]								[int]									NULL
	,[ver_desc]										[nvarchar](100)							NULL
	,[day_number_of_week]							[int]									NULL
	,[day_number_of_month]							[int]									NULL
	,journal_type									[nvarchar](25)							NULL
	,[system_load_date]								[datetime]								NOT NULL
	,[approver_department]							[nvarchar](250)							NULL
	,[approver_ref]									[nvarchar](250)							NULL
						
	,reporting_impact_to_assets						[float]									NULL
	,reporting_impact_to_equity 						[float]									NULL
	,reporting_impact_to_expenses 						[float]									NULL
	,reporting_impact_to_liabilities 						[float]									NULL
	,reporting_impact_to_revenue 						[float]									NULL
	,functional_impact_to_assets 						[float]									NULL
	,functional_impact_to_equity 						[float]									NULL
	,functional_impact_to_expenses 						[float]									NULL
	,functional_impact_to_liabilities 						[float]									NULL
	,functional_impact_to_revenue 						[float]									NULL
	-- Added below 4 by Prabakar as per the Tim Requirement to have for PTP and OTC -- Begin	
	,ey_subledger_type							[nvarchar](30)							NULL				
	,ey_AR_type									[nvarchar](30)							NULL
	,ey_AP_type									[nvarchar](30)							NULL
	,ey_reconciliation_GL_group					[nvarchar](30)							NULL
	-- Added below 4 by Prabakar as per the Tim Requirement to have for PTP and OTC -- end
	,Adjusted_fiscal_period						NVARCHAR(50)							NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


  
GO -- new file   
  
/**************************************************************************** 
Description:	parameter Table for aging bands
Script Date:	09/07/2013 
Created By:		MSH
*******************************************************************************/

-- *******************************************************************************
-- Dummy parameter Table for engagement level parameters including Audit Period Info. 
-- *******************************************************************************

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[parameters_aging_bands]')) Drop TABLE [dbo].[parameters_aging_bands]

CREATE TABLE [dbo].[parameters_aging_bands]
(
	 band			 						INT					NULL		
	,ey_band_threshold_lower				INT					NULL
)
GO
  
GO -- new file   
  
/**************************************************************************** 
Description:	Parameter Table for Audit Period Info. 
Script Date:	28/05/2013 
Created By:		MSH
History:
V1				28/05/2013	MSH		Created
V2				19/08/2013	MSH		Renamed table to remove - Dummy
*******************************************************************************/


-- *******************************************************************************
-- Parameter Table for engagement level parameters including Audit Period Info. 
-- *******************************************************************************

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parameters_engagement]')) Drop TABLE [dbo].[Parameters_engagement]

CREATE TABLE [dbo].[Parameters_engagement]
(
	 engagement_id							UNIQUEIDENTIFIER	NULL
	,planning_materiality					NVARCHAR(50)		NULL
	,tolerable_error 						INT					NULL		
	,sad_thresholds							INT					NULL
	,current_year_cd						NVARCHAR(100)		NULL
	,audit_period_end_period_cd				NVARCHAR(100)		NULL
	,interim_period_end_period_cd			NVARCHAR(100)		NULL
	,prior_year_cd							NVARCHAR(100)		NULL
	,comparative_period_end_period_cd		NVARCHAR(100)		NULL
	,receivables_ey_class					NVARCHAR(100)		NULL
	,AR_aged_debt_threshold					INT					NULL
	,AR_aging_basis							NVARCHAR(50)		NULL
	,AP_aging_basis							NVARCHAR(50)		NULL
	,bu_id_for_dates						INT					NULL
	,Segment_selection1						VARCHAR(50)			NULL
	,Segment_selection2						VARCHAR(50)			NULL
	,prior_period_start_date				DATE				NULL
	,prior_period_end_date					DATE				NULL
	,comparative_period_end_date			DATE				NULL
	,audit_period_start_date				DATE				NULL
	,audit_period_end_date					DATE				NULL
	,interim_period_end_date				DATE				NULL
	,system_manual_indicator_option			NVARCHAR(50)		NULL
)
GO
  
GO -- new file   
  
/************************************************************************************************************************************************
Description:	Tables to contain all periods definition and to be reference for description in all of the test data
Script Date:	06/08/2013 
Created By:		MSH
*************************************************************************************************************************************************/


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parameters_period]')) Drop TABLE [dbo].[Parameters_period]
GO

CREATE TABLE [dbo].[Parameters_period] (
	 year_flag					NVARCHAR(25)			NOT NULL
	,year_flag_desc				NVARCHAR(100)			NOT NULL
	,period_flag				NVARCHAR(25)			NOT NULL
	,period_flag_desc			NVARCHAR(100)			NOT NULL
	,fiscal_period_seq_start	INT						NULL
	,fiscal_period_seq_end		INT						NULL
	,fiscal_year_cd				NVARCHAR(100)			NULL
	,start_date					DATE					NULL
	,end_date					DATE					NULL
	,year_start_date			DATE					NULL
	,year_end_date				DATE					NULL
)
GO  
GO -- new file   
  
/**************************************************************************** 
Description:	parameter Table for source listing
Script Date:	09/07/2013 
Created By:		MSH
*******************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parameters_Source_listing]')) Drop TABLE [dbo].[Parameters_Source_listing]

CREATE TABLE [dbo].[Parameters_Source_listing]
(
	 source_cd		 						NVARCHAR(25)		NULL	
	,ey_source_group						NVARCHAR(100)		NULL		
	,ey_sys_man_ident						NVARCHAR(25)		NULL		
)
GO
  
GO -- new file   
  
/**************************************************************************** 
Description:	parameter Table for User listing
Script Date:	29/07/2013 
Created By:		MSH
*******************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Parameters_User_listing]')) Drop TABLE [dbo].[Parameters_User_listing]

CREATE TABLE [dbo].[Parameters_User_listing]
(
	 client_user_id		 					NVARCHAR(25)		NULL	
	,ey_sys_man_ident						NVARCHAR(25)		NULL		
)
GO
  
GO -- new file   
  
/**************************************************************************** 
Description:	Table to hold RDM refresh executables info (Mainly list of SPs)
Script Date:	07/04/2013 
Created By:		MSH
History:
V1				07/04/2013	MSH		Created
*******************************************************************************/

IF EXISTS  (SELECT * FROM SYS.OBJECTS WHERE object_id = OBJECT_ID(N'[dbo].[RDM_Refresh_Executables]'))  DROP TABLE [dbo].[RDM_Refresh_Executables]
GO

CREATE TABLE [dbo].[RDM_Refresh_Executables]
(
		 row_counter				INT				NOT NULL IDENTITY(1,1)
		,Sequence					INT				NULL
		,sp_name					NVARCHAR(500)	NOT NULL
		,sp_id						INT				NULL
		,refresh_stream				NVARCHAR(50)	NULL
		,level						INT				NULL
)
GO  
GO -- new file   
  
/**************************************************************************** 
Description:	Table to hold data refresh steps log
Script Date:	09/10/2013 
Created By:		MSH
History:
V1				09/10/2013 	MSH		Created
*******************************************************************************/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RDM_Refresh_Log]')) Drop TABLE [dbo].[RDM_Refresh_Log]
BEGIN
	CREATE TABLE	[dbo].[RDM_Refresh_Log]
	(
			 row_counter				INT				NOT NULL IDENTITY(1,1)
			,data_refresh_counter		INT				NOT NULL
			,stream_name				NVARCHAR(100)	NULL
			,test_name					NVARCHAR(200)	NULL
			,executable_name			NVARCHAR(200)	NULL
			,event_status				NVARCHAR(50)	NULL
			,event_date_time			DATETIME		NULL
			,error_msg					NVARCHAR(MAX)	NULL
	)
END
GO  
GO -- new file   
  
/**************************************************************************** 
Description:	Table to hold RDM refresh parameters info
Script Date:	28/10/2013 
Created By:		MSH
History:
V1				28/10/2013 	MSH		Created
*******************************************************************************/

IF NOT EXISTS  (SELECT * FROM SYS.OBJECTS WHERE object_id = OBJECT_ID(N'[dbo].[RDM_Refresh_Parameters]'))  
BEGIN
	CREATE TABLE [dbo].[RDM_Refresh_Parameters]
	(
			 row_counter				INT				NOT NULL IDENTITY(1,1)
			,data_refresh_counter		INT				NOT NULL
			,refresh_stream				NVARCHAR(50)	NULL
			,startup_point				NVARCHAR(100)	NULL
			,sp_name					NVARCHAR(500)	NULL
			,old_data_refresh_counter	INT				NULL
			,event_date_time			DATETIME		NULL
			,level						INT				NULL
	)
END
GO

IF NOT EXISTS  (SELECT * FROM SYS.COLUMNS WHERE Name = N'level' and object_id = OBJECT_ID(N'[dbo].[RDM_Refresh_Parameters]'))  
BEGIN
	ALTER	TABLE	[dbo].[RDM_Refresh_Parameters]
			ADD		level	INT		NULL
END
GO
  
GO -- new file   
  
