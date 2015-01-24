
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Insert_RDM_Refresh_Log]')) Drop PROC [dbo].[PROC_Insert_RDM_Refresh_Log]
GO

CREATE PROC [dbo].[PROC_Insert_RDM_Refresh_Log]
(
	 @data_refresh_counter	INT
	,@executable_name		NVARCHAR(400)
	,@event_status			NVARCHAR(100)
	,@error_msg				NVARCHAR(MAX)
)
AS
/**********************************************************************************************************************************************
Description:	PROC to insert RDM refresh status row into RDM_Refresh_Log table
Script Date:	14/06/2013 
Created By:		MSH
Version:		2
Sample Command:	[dbo].[PROC_Insert_RDM_Refresh_Log]		 @data_refresh_counter	 = 1
														,@executable_name		 = 'PROC_Refresh_Data_All_Workstream'	
														,@event_status			 = 'START'
														,@error_msg				 = NULL	
History:		
V3				09/04/2014		MSH		UPDATED as part of new approach of executing (through SSIS) and changes done for execution control logic and logging 
V2				25/03/2014		FJL		Updated to include comment header
V1				14/06/2013   	MSH		CREATED
************************************************************************************************************************************************/
BEGIN

	-- IF calling for inserting start info, "DECIDE" if this SP needs to be called
	IF @event_status = 'START'
	BEGIN
			UPDATE		 [dbo].[RDM_Refresh_Log]
			SET			 event_status			= @event_status
						,event_date_time		= GETDATE()
			WHERE		 data_refresh_counter	= @data_refresh_counter
					AND	 executable_name		= @executable_name
	END


	IF	(		@event_status = 'COMPLETED'	
			AND	EXISTS (SELECT 1 
						FROM		[dbo].[RDM_Refresh_Log]
						WHERE		data_refresh_counter	= @data_refresh_counter 
								AND executable_name			= @executable_name 
								AND event_status			= 'START')
		)
	BEGIN
		INSERT INTO		 [dbo].[RDM_Refresh_Log]
		(
						 data_refresh_counter	
						,stream_name			
						,test_name	
						,executable_name			
						,event_status			
						,event_date_time		
						,error_msg
		)
		SELECT		TOP 1	
						 @data_refresh_counter	
						,stream_name	
						,test_name			
						,@executable_name			
						,@event_status	+ CASE WHEN @error_msg IS NOT NULL THEN ' WITH ERROR' ELSE '' END		
						,GETDATE()			
						,@error_msg
		FROM			 [dbo].[RDM_Refresh_Log]
		WHERE			 data_refresh_counter	= @data_refresh_counter 
					AND  executable_name		= @executable_name 
					AND  event_status			= 'START'
	END
END


  
GO -- new file   
  

IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Insert_RDM_Refresh_parameters]')) DROP PROC [dbo].[PROC_Insert_RDM_Refresh_parameters]
GO
	
CREATE PROC [dbo].[PROC_Insert_RDM_Refresh_parameters]
(
	 @data_refresh_counter		INT				= NULL			OUTPUT
	,@refresh_stream			NVARCHAR(50)	= 'ALL'		
	,@startup_point				NVARCHAR(100)	= 'START'	
	,@sp_list					NVARCHAR(500)	= NULL		
	,@old_data_refresh_counter	INT				= NULL	
	,@level						INT				= NULL
)
AS
/**********************************************************************************************************************************************
Description:	PROC to insert data into RDM Refresh parameters - container table; it also insert event steps to be executed in RDM_refresh_log
Script Date:	09/04/2014
Created By:		MSH
Version:		1
Sample Command:	

DECLARE @data_refresh_counter_OUT AS INT
EXEC	[dbo].[PROC_Insert_RDM_Refresh_parameters]	 @refresh_stream			= 'ALL'
													,@startup_point				= 'PENDING_WITH_NO_ERROR'
													,@sp_list					= 'PROC_Refresh_Data_O2C_RR41, PROC_Refresh_Data_Analysis_reconciliation'
													,@old_data_refresh_counter	= 4
													,@level						= 3
													,@data_refresh_counter		= @data_refresh_counter_OUT	OUTPUT
SELECT @data_refresh_counter_OUT
History:		
V1				09/04/2014 		MSH		CREATED		
************************************************************************************************************************************************/
BEGIN
	IF @refresh_stream				= ''	SET @refresh_stream				=	 'ALL'		
	IF @startup_point				= ''	SET @startup_point				=	 'START'	
	IF @sp_list						= ''	SET @sp_list					=	 NULL
	IF @old_data_refresh_counter	= 0		SET @old_data_refresh_counter	=	 NULL
	IF @level						= 0		SET @level						=	 NULL


	SELECT			 @data_refresh_counter = MAX(data_refresh_counter)
	FROM
	(
		SELECT		 ISNULL(MAX(data_refresh_counter), 0) + 1 AS data_refresh_counter
		FROM		 [dbo].[RDM_Refresh_Log]
		UNION
		SELECT		 ISNULL(MAX(data_refresh_counter), 0) + 1 AS data_refresh_counter
		FROM		 [dbo].[RDM_Refresh_Parameters]
	) TAB

	SELECT @old_data_refresh_counter = COALESCE(@old_data_refresh_counter, MAX(data_refresh_counter), 0) FROM dbo.RDM_Refresh_parameters

	INSERT INTO		 [dbo].[RDM_Refresh_Parameters]
	(
					 data_refresh_counter		
					,refresh_stream				
					,startup_point				
					,sp_name					
					,old_data_refresh_counter	
					,event_date_time		
					,level	
	)
	SELECT
					 @data_refresh_counter
					,@refresh_stream			
					,@startup_point				
					,@sp_list					
					,@old_data_refresh_counter
					,GETDATE()
					,@level



	--DECLARE
	-- @data_refresh_counter		INT				
	--,@old_data_refresh_counter	INT				

	--SET @data_refresh_counter		 = 9
	--SET @old_data_refresh_counter	 = 4


	-- DEFINE HOW MANY SP WERE IDENTIFIED FOR OLD RDM REFRESH (REFERENCED) AND HOW MANY OF THEM WERE COMPLETED, PENDING OR MARKED WITH ERROR
	;WITH decision_helper_OLD_RUN_CTE (sp_name, event_status)
	AS
	(
		SELECT
						 RR_Log.executable_name		AS sp_name
						,CASE 
								WHEN COUNT(CASE	WHEN RR_Log.event_status = 'COMPLETED WITH ERROR' THEN 1 END) > 0		THEN 'COMPLETED WITH ERROR'
								WHEN COUNT(CASE	WHEN RR_Log.event_status = 'COMPLETED' THEN 1 END) > 0					THEN 'COMPLETED'
								WHEN COUNT(1) = 1																		THEN 'PENDING'
						 END						AS event_status
		FROM			 [dbo].[RDM_Refresh_Log] RR_Log			
		WHERE			 RR_Log.data_refresh_counter = @old_data_refresh_counter
		GROUP BY		 RR_Log.executable_name
	)
	-- DEFINE HOW MANY SP ARE IDENTIFIED FOR BASED ON STREAM, LEVEL AND SP LIST PARAMETER 
	,decision_helper_NEW_RUN_CTE (sp_name, refresh_stream, is_stream_checked, is_sp_name_in_list, SP_status_in_prev_run, startup_point)
	AS
	(
		SELECT
						 RR_Exec.sp_name
						,RR_Exec.refresh_stream
						,CASE	WHEN	(RR_Param.refresh_stream = 'ALL' OR	CHARINDEX(RR_Param.refresh_stream, RR_Exec.refresh_stream, 1) <> 0 OR	CHARINDEX('ALL', RR_Exec.refresh_stream, 1) <> 0)	
									AND ISNULL(RR_Param.level, RR_Exec.level) <= RR_Exec.level
								THEN	1
								ELSE	0
						 END					AS is_stream_checked
						,CASE	WHEN	CHARINDEX(RR_Exec.sp_name, RR_Param.sp_name, 1) <> 0
								THEN	1
								ELSE	0
						 END					AS is_sp_name_in_list
						,dh_old.event_status	AS SP_status_in_prev_run
						,RR_Param.startup_point
		FROM			 [dbo].[RDM_Refresh_Executables] RR_Exec
		LEFT OUTER JOIN	 decision_helper_OLD_RUN_CTE dh_old			ON		dh_old.sp_name = RR_Exec.sp_name
		LEFT OUTER JOIN	 [dbo].[RDM_Refresh_Parameters]	RR_Param	ON		RR_Param.data_refresh_counter = @data_refresh_counter
	)
	-- FINALLY INSERT SPs TO BE EXECUTED BASED ON STARTUP POINT AND RIGHT COMBINATIONS IDENTIFIED ABOVE
	INSERT INTO		 [dbo].[RDM_Refresh_Log]
	(
					 data_refresh_counter	
					,stream_name			
					,executable_name			
					,event_status			
	)
	SELECT 
					 @data_refresh_counter		AS data_refresh_counter	
					,dh_new.refresh_stream		AS stream_name			
					,dh_new.sp_name				AS executable_name		
					,'NOT STARTED'				AS event_status			

					--,dh_new.*
	FROM			 decision_helper_NEW_RUN_CTE dh_new
	WHERE			 dh_new.is_stream_checked = 1
				AND	(		
							dh_new.startup_point = 'START'
						OR (dh_new.startup_point = 'PENDING_ALL'			AND	dh_new.SP_status_in_prev_run <> 'COMPLETED' )
						OR (dh_new.startup_point = 'PENDING_WITH_ERROR'		AND	dh_new.SP_status_in_prev_run =  'COMPLETED WITH ERROR' )
						OR (dh_new.startup_point = 'PENDING_WITH_NO_ERROR'	AND	dh_new.SP_status_in_prev_run =  'PENDING')
						OR (dh_new.startup_point = 'PENDING_SP_LIST'		AND	dh_new.SP_status_in_prev_run =  'PENDING'	AND	dh_new.is_sp_name_in_list = 1)
						OR (dh_new.startup_point = 'PENDING_EXCEPT_SP_LIST'	AND	dh_new.SP_status_in_prev_run =  'PENDING'	AND	dh_new.is_sp_name_in_list = 0)
						OR (dh_new.startup_point = 'ONLY_SP_LIST'			AND	dh_new.is_sp_name_in_list = 1)
					)

END
GO
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Parameter_Load_Cleanup]')) Drop PROC [dbo].[PROC_Parameter_Load_Cleanup]
GO

CREATE PROC [dbo].[PROC_Parameter_Load_Cleanup]
AS
/**********************************************************************************************************************************************
Description:	PROC to insert RDM refresh status row into RDM_Refresh_Log table
Script Date:	04/07/2014 
Created By:		MSH
Version:		1
Sample Command:	[dbo].[PROC_Parameter_Load_Cleanup]		
History:		
V4				20141003		MSH		query changed to update ey_sub_ledger in Chart_of_accounts table for performance improvement
V3				20140815		MSH		Code corrected to pull relavent bu_id based on period end code and period end date check
V2				20140807		MSH		Added [EY_COMMA] and NULLIF checks in COA update and added update statement to use "Third party" as default for related party
V1				04/07/2014    	MSH		CREATED
************************************************************************************************************************************************/
BEGIN

	INSERT INTO		 [dbo].[RDM_Refresh_Log]
	(
					 data_refresh_counter	
					,stream_name			
					,test_name	
					,executable_name			
					,event_status			
					,event_date_time		
					,error_msg
	)
	SELECT			 0
					,'PARAMETER POPULATION'
					,'PARAMETER POPULATION'
					,'PROC_Parameter_Load_Cleanup'
					,'START'
					,GETDATE()
					,NULL

	-- STEP #1: Update Chart_of_accounts
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: Update Chart_of_accounts ' + CONVERT(NVARCHAR, GETDATE(), 109)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Parameters_COA]'))	
	BEGIN
		
		UPDATE COA
		SET				 COA.ey_account_group_I		= NULLIF(NULLIF(REPLACE(P_COA.ey_gl_account_group_I , '[EY_COMMA]', ','), 'NULL'), '')
						,COA.ey_account_group_II	= NULLIF(NULLIF(REPLACE(P_COA.ey_gl_account_group_II, '[EY_COMMA]', ','), 'NULL'), '')
		FROM			 [dbo].[Chart_of_accounts] COA
		INNER JOIN		 [dbo].[Business_unit_listing] BU			ON		COA.bu_id = BU.bu_id
		INNER JOIN		 [dbo].[Temp_Parameters_COA] P_COA			ON		COA.gl_account_cd = P_COA.gl_account_cd
																		AND	BU.bu_cd = P_COA.bu_cd

		DROP TABLE [dbo].[Temp_Parameters_COA]
	END

	-- STEP #2: Update Customer_master
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #2: Update Customer_master ' + CONVERT(NVARCHAR, GETDATE(), 109)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Parameters_RPCustomer]'))	
	BEGIN

		UPDATE CM
		SET				 CM.ey_related_party	= NULLIF(P_CUST.ey_related_party, 'NULL')
		FROM			 [dbo].[Customer_master] CM
		INNER JOIN		 [dbo].[Temp_Parameters_RPCustomer] P_CUST		ON		CM.customer_account_cd = P_CUST.customer_cd

		UPDATE [dbo].[Customer_master] SET ey_related_party = 'Third party' WHERE ISNULL(ey_related_party, '') = ''

		DROP TABLE [dbo].[Temp_Parameters_RPCustomer]
	END

	-- STEP #3: Update Vendor_master
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #3: Update Vendor_master ' + CONVERT(NVARCHAR, GETDATE(), 109)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Parameters_RPVendor]'))	
	BEGIN

		UPDATE VM
		SET				 VM.ey_related_party	= NULLIF(P_VENDOR.ey_related_party, 'NULL')
		FROM			 [dbo].[Vendor_master] VM
		INNER JOIN		 [dbo].[Temp_Parameters_RPVendor] P_VENDOR		ON		VM.vendor_account_cd = P_VENDOR.vendor_cd

		UPDATE [dbo].[Vendor_master] SET ey_related_party = 'Third party' WHERE ISNULL(ey_related_party, '') = ''

		DROP TABLE [dbo].[Temp_Parameters_RPVendor]
	END

	-- STEP #4: Update Parameters_engagement
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #4: Update Parameters_engagement ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE dbo.Parameters_engagement SET	 engagement_id = (SELECT TOP 1 engagement_id FROM dbo.Journal_entries)
											
	UPDATE dbo.Parameters_engagement SET	 bu_id_for_dates =	(
																	SELECT			 MAX(bu_id) 
																	FROM			 dbo.Fiscal_calendar FC
																	LEFT OUTER JOIN	 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id	= FC.fiscal_period_end
																	CROSS JOIN		 dbo.Parameters_engagement PE
																	WHERE			 (		DATEDIFF(D, GC_P_END.calendar_date, PE.audit_period_end_date) = 0
																						AND	FC.fiscal_period_cd = PE.audit_period_end_period_cd)
																				OR	 (		DATEDIFF(D, GC_P_END.calendar_date, PE.interim_period_end_date) = 0
																						AND FC.fiscal_period_cd = PE.interim_period_end_period_cd)
																)

	-- STEP #5: Update Parameters_period
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #5: Update Parameters_period ' + CONVERT(NVARCHAR, GETDATE(), 109)
	
	EXEC PROC_Refresh_Parameters_period


	-- STEP #6: Update Chart_of_accounts for ey_sub_ledger column from AP
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #6: Update Chart_of_accounts for ey_sub_ledger column from AP ' + CONVERT(NVARCHAR, GETDATE(), 109)
	
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP_activity]'))	
	BEGIN

		DECLARE @AP_FLAG TABLE (coa_id INT)
		INSERT INTO @AP_FLAG		
		SELECT DISTINCT
						 coa_id
		FROM			 dbo.[AP_activity] WITH(NOLOCK)
		UNION
		SELECT DISTINCT
						 coa_id
		FROM			 dbo.[AP_open_transactions] WITH(NOLOCK)
		
		UPDATE			 Chart_of_accounts
		SET				 ey_sub_ledger = 'AP'
		FROM			 Chart_of_accounts 
		WHERE 			 coa_id in (SELECT coa_id FROM @AP_FLAG)


	END

	-- STEP #7: Update Chart_of_accounts for ey_sub_ledger column from AR
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #7: Update Chart_of_accounts for ey_sub_ledger column from AR ' + CONVERT(NVARCHAR, GETDATE(), 109)
	
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AR_activity]'))	
	BEGIN

		DECLARE @AR_FLAG TABLE (coa_id INT)
		INSERT INTO @AR_FLAG		
		SELECT DISTINCT
						 coa_id
		FROM			 dbo.[AR_activity] WITH(NOLOCK)
		UNION
		SELECT DISTINCT
						 coa_id
		FROM			 dbo.[AR_open_transactions] WITH(NOLOCK)
		
		UPDATE			 Chart_of_accounts
		SET				 ey_sub_ledger = 'AR'
		FROM			 Chart_of_accounts 
		WHERE 			 coa_id in (SELECT coa_id FROM @AR_FLAG)
	END	


	-- STEP #8: Update [Source_listing]
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #8: Update [Source_listing] ' + CONVERT(NVARCHAR, GETDATE(), 109)


	UPDATE SL
	SET				 SL.ey_source_group	= NULLIF(P_SL.ey_source_group, 'NULL')
	FROM			 [dbo].[Source_listing] SL
	INNER JOIN		 [dbo].[Parameters_Source_listing] P_SL		ON		SL.source_cd = P_SL.source_cd



	-- STEP #9: Update Segment01_listing 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #9: Update Segment01_listing ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE S
	SET			 S.EY_SEGMENT_GROUP = T.EY_SEGMENT_GROUP 
	FROM		 SEGMENT01_LISTING S 
	INNER JOIN	 TEMP_SEGMENT01_LISTING T		ON		S.SEGMENT_CD = T.SEGMENT_CD
	
	TRUNCATE TABLE TEMP_SEGMENT01_LISTING

	-- STEP #10: Update Segment02_listing 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #10: Update Segment02_listing ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE S
	SET			 S.EY_SEGMENT_GROUP = T.EY_SEGMENT_GROUP 
	FROM		 SEGMENT02_LISTING S 
	INNER JOIN	 TEMP_SEGMENT02_LISTING T		ON		S.SEGMENT_CD = T.SEGMENT_CD
	
	TRUNCATE TABLE TEMP_SEGMENT02_LISTING

	-- STEP #11: Update Segment03_listing 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #11: Update Segment03_listing ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE S
	SET			 S.EY_SEGMENT_GROUP = T.EY_SEGMENT_GROUP 
	FROM		 SEGMENT03_LISTING S 
	INNER JOIN	 TEMP_SEGMENT03_LISTING T		ON		S.SEGMENT_CD = T.SEGMENT_CD
	
	TRUNCATE TABLE TEMP_SEGMENT03_LISTING

	-- STEP #12: Update Segment04_listing 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #12: Update Segment04_listing ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE S
	SET			 S.EY_SEGMENT_GROUP = T.EY_SEGMENT_GROUP 
	FROM		 SEGMENT04_LISTING S 
	INNER JOIN	 TEMP_SEGMENT04_LISTING T		ON		S.SEGMENT_CD = T.SEGMENT_CD
	
	TRUNCATE TABLE TEMP_SEGMENT04_LISTING

	-- STEP #13: Update Segment05_listing 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #13: Update Segment05_listing ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE S
	SET			 S.EY_SEGMENT_GROUP = T.EY_SEGMENT_GROUP 
	FROM		 SEGMENT05_LISTING S 
	INNER JOIN	 TEMP_SEGMENT05_LISTING T		ON		S.SEGMENT_CD = T.SEGMENT_CD
	
	TRUNCATE TABLE TEMP_SEGMENT05_LISTING

	-- STEP #14: Update TRANSACTION_TYPE 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #14: Update TRANSACTION_TYPE ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE S
	SET			 S.EY_TRANSACTION_TYPE = T.EY_TRANSACTION_TYPE 
	FROM		 TRANSACTION_TYPE S 
	INNER JOIN	 TEMP_TRANSACTION_TYPE T		ON		S.TRANSACTION_TYPE_CD = T.TRANSACTION_TYPE_CD
	
	TRUNCATE TABLE TEMP_TRANSACTION_TYPE

	-- STEP #14: Update BUSINESS_UNIT_LISTING
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #14: Update BUSINESS_UNIT_LISTING ' + CONVERT(NVARCHAR, GETDATE(), 109)

	UPDATE BU
	SET			 BU.bu_hier_01_cd = T.bu_hier_01_cd
				,BU.bu_hier_01_desc = T.bu_hier_01_desc
	FROM		 Business_unit_listing BU 
	INNER JOIN	 Temp_Business_unit_listing T	ON		BU.bu_cd = T.bu_cd
	
	TRUNCATE TABLE Temp_Business_unit_listing


	UPDATE [dbo].[Transaction_type]				SET EY_transaction_type	='EY empty'									WHERE ISNULL([transaction_type_cd], '') = ''
	UPDATE [dbo].[Chart_of_accounts]			SET ey_account_group_I	='EY empty'									WHERE ISNULL(ey_account_group_I, '') = ''
	UPDATE [dbo].[Chart_of_accounts]			SET ey_account_group_II	='EY empty'									WHERE ISNULL(ey_account_group_II, '') = ''
	UPDATE [dbo].[Business_unit_listing]		SET bu_hier_01_cd		='EY empty', bu_hier_01_desc = 'EY empty'	WHERE ISNULL(bu_hier_01_cd, '') = ''			-- changes reflect on view without RDM refresh
	UPDATE [dbo].[Segment01_listing]			SET ey_segment_group	='EY empty'									WHERE ISNULL(ey_segment_group, '') = ''			-- changes reflect on view without RDM refresh
	UPDATE [dbo].[Segment02_listing]			SET ey_segment_group	='EY empty'									WHERE ISNULL(ey_segment_group, '') = ''			-- changes reflect on view without RDM refresh
	UPDATE [dbo].[Segment03_listing]			SET ey_segment_group	='EY empty'									WHERE ISNULL(ey_segment_group, '') = ''			-- changes reflect on view without RDM refresh
	UPDATE [dbo].[Segment04_listing]			SET ey_segment_group	='EY empty'									WHERE ISNULL(ey_segment_group, '') = ''			-- changes reflect on view without RDM refresh
	UPDATE [dbo].[Segment05_listing]			SET ey_segment_group	='EY empty'									WHERE ISNULL(ey_segment_group, '') = ''			-- changes reflect on view without RDM refresh

	UPDATE [dbo].[Source_listing]				SET ey_source_group  ='EY empty'									WHERE ISNULL(ey_source_group, '') = ''


	INSERT INTO  [dbo].[Parameters_User_listing] (client_user_id, ey_sys_man_ident)
	SELECT		 UL.client_user_id
				,'Manual'
	FROM		 [dbo].[User_listing] UL
	WHERE		 UL.client_user_id NOT IN (SELECT client_user_id FROM [dbo].[Parameters_User_listing])


	INSERT INTO  [dbo].[Parameters_Source_listing] (source_cd, ey_source_group, ey_sys_man_ident)
	SELECT		 UL.source_cd
				,'EY empty'
				,'Manual'
	FROM		 [dbo].[Source_listing] UL
	WHERE		 UL.source_cd NOT IN (SELECT source_cd FROM [dbo].[Parameters_Source_listing])

	UPDATE [dbo].[Parameters_User_listing]		SET ey_sys_man_ident ='Manual'										WHERE ISNULL(ey_sys_man_ident, '') = ''
	UPDATE [dbo].[Parameters_Source_listing]	SET ey_source_group = 'EY empty', ey_sys_man_ident = 'Manual'		WHERE ISNULL(ey_sys_man_ident, '') = ''			-- changes reflect on view without RDM refresh





	INSERT INTO		 [dbo].[RDM_Refresh_Log]
	(
					 data_refresh_counter	
					,stream_name			
					,test_name	
					,executable_name			
					,event_status			
					,event_date_time		
					,error_msg
	)
	SELECT			 0
					,'PARAMETER POPULATION'
					,'PARAMETER POPULATION'
					,'PROC_Parameter_Load_Cleanup'
					,'COMPLETED'
					,GETDATE()
					,NULL

END


  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_RDM_Parameter_Load_Setup]')) Drop PROC [dbo].[PROC_RDM_Parameter_Load_Setup]
GO

CREATE PROC [dbo].[PROC_RDM_Parameter_Load_Setup]
AS
/**********************************************************************************************************************************************
Description:	PROC to insert RDM refresh status row into RDM_Refresh_Log table
Script Date:	04/07/2014 
Created By:		MSH
Version:		1
Sample Command:	[dbo].[PROC_RDM_Parameter_Load_Setup]		
History:		
V1				04/07/2014    	MSH		CREATED
************************************************************************************************************************************************/
BEGIN

	INSERT INTO		 [dbo].[RDM_Refresh_Log]
	(
					 data_refresh_counter	
					,stream_name			
					,test_name	
					,executable_name			
					,event_status			
					,event_date_time		
					,error_msg
	)
	SELECT			 0
					,'PARAMETER POPULATION'
					,'PARAMETER POPULATION'
					,'PROC_RDM_Parameter_Load_Setup'
					,'START'
					,GETDATE()
					,NULL

	TRUNCATE TABLE [dbo].[Country_currency_mapping]
	TRUNCATE TABLE [dbo].[parameters_aging_bands]
	TRUNCATE TABLE [dbo].[Parameters_engagement]
	TRUNCATE TABLE [dbo].[Parameters_Source_listing]
	TRUNCATE TABLE [dbo].[Parameters_User_listing]

	--TRUNCATE TABLE [dbo].[RDM_Refresh_executables]
	UPDATE Transaction_type SET EY_transaction_type=NULL
	UPDATE Chart_of_accounts SET ey_account_group_I=NULL,ey_account_group_II=NULL


	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Parameters_COA]'))	DROP TABLE [dbo].[Temp_Parameters_COA]
	CREATE TABLE	 [dbo].[Temp_Parameters_COA]
	(
			 bu_cd					NVARCHAR(25)	NULL
			,gl_account_cd			NVARCHAR(100)	NULL
			,ey_gl_account_group_I	NVARCHAR(100)	NULL
			,ey_gl_account_group_II	NVARCHAR(100)	NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Parameters_RPCustomer]'))	DROP TABLE [dbo].[Temp_Parameters_RPCustomer]
	CREATE TABLE	 [dbo].[Temp_Parameters_RPCustomer]
	(
			 customer_cd			NVARCHAR(100)	NULL
			,ey_related_party		NVARCHAR(100)	NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Parameters_RPVendor]'))	DROP TABLE [dbo].[Temp_Parameters_RPVendor]
	CREATE TABLE	 [dbo].[Temp_Parameters_RPVendor]
	(
			 vendor_cd				NVARCHAR(100)	NULL
			,ey_related_party		NVARCHAR(100)	NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Segment01_listing]'))	DROP TABLE [dbo].[Temp_Segment01_listing]
	CREATE TABLE	 [dbo].[Temp_Segment01_listing]
	(
			  [segment_cd]		 NVARCHAR(50) NULL,
			  [ey_segment_group] NVARCHAR(200) NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Segment02_listing]'))	DROP TABLE [dbo].[Temp_Segment02_listing]
	CREATE TABLE	 [dbo].[Temp_Segment02_listing]
	(
			  [segment_cd]		 NVARCHAR(50) NULL,
			  [ey_segment_group] NVARCHAR(200) NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Segment03_listing]'))	DROP TABLE [dbo].[Temp_Segment03_listing]
	CREATE TABLE	 [dbo].[Temp_Segment03_listing]
	(
			  [segment_cd]		 NVARCHAR(50) NULL,
			  [ey_segment_group] NVARCHAR(200) NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Segment04_listing]'))	DROP TABLE [dbo].[Temp_Segment04_listing]
	CREATE TABLE	 [dbo].[Temp_Segment04_listing]
	(
			  [segment_cd]		 NVARCHAR(50) NULL,
			  [ey_segment_group] NVARCHAR(200) NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Segment05_listing]'))	DROP TABLE [dbo].[Temp_Segment05_listing]
	CREATE TABLE	 [dbo].[Temp_Segment05_listing]
	(
			  [segment_cd]		 NVARCHAR(50) NULL,
			  [ey_segment_group] NVARCHAR(200) NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Transaction_Type]'))	DROP TABLE [dbo].[Temp_Transaction_Type]
	CREATE TABLE	 [dbo].[Temp_Transaction_Type]
	(
			  [transaction_type_cd]		 NVARCHAR(100) NULL,
			  [EY_transaction_type]      NVARCHAR(100) NULL
	)

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Business_unit_listing]'))	DROP TABLE [dbo].[Temp_Business_unit_listing]
	CREATE TABLE	 [dbo].[Temp_Business_unit_listing]
	(
			  [bu_cd]				NVARCHAR(50) NULL,
			  [bu_hier_01_cd]		NVARCHAR(50) NULL,
			  [bu_hier_01_desc]		NVARCHAR(200) NULL
	)


	INSERT INTO		 [dbo].[RDM_Refresh_Log]
	(
					 data_refresh_counter	
					,stream_name			
					,test_name	
					,executable_name			
					,event_status			
					,event_date_time		
					,error_msg
	)
	SELECT			 0
					,'PARAMETER POPULATION'
					,'PARAMETER POPULATION'
					,'PROC_RDM_Parameter_Load_Setup'
					,'COMPLETED'
					,GETDATE()
					,NULL
END


  
GO -- new file   
  
IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE object_id = OBJECT_ID(N'[dbo].[PROC_RDM_Refresh_Executables]')) DROP PROC [dbo].[PROC_RDM_Refresh_Executables]
GO
	
CREATE PROC [dbo].[PROC_RDM_Refresh_Executables]
AS
/**********************************************************************************************************************************************
Description:	PROC to set data refresh executables
Script Date:	25/04/2014
Created By:		CGP
Version:		1
Sample Command:	

History:
V2				25/06/2014 		MSH		UPDATED to have list of latest P2P stored procedures for release 3
V1				25/04/2014 		CGP		CREATED		
************************************************************************************************************************************************/
BEGIN

	-- Data in this table is used as lookup for decision control logic to decide if a SP needs to be executed or not

	TRUNCATE TABLE [dbo].[RDM_Refresh_Executables]

	INSERT INTO [dbo].[RDM_Refresh_Executables]
	(Sequence, sp_name, refresh_stream, level)
	--SELECT 1, 'PROC_Refresh_Parameters_period',												'ALL WORKSTREAM',					1 UNION ALL

	SELECT 2, 'PROC_Refresh_Vendor_Details',												'PTP',								2 UNION ALL
	SELECT 3, 'PROC_Refresh_Data_Shared_AP_activity_details',								'PTP',								2 UNION ALL
	SELECT 4, 'PROC_Refresh_Data_Shared_AP_open_transactions_details',						'PTP',								2 UNION ALL
	SELECT 5, 'PROC_Refresh_Data_Shared_AP_goods_receipt',									'PTP',								2 UNION ALL
	SELECT 6, 'PROC_Refresh_Data_Shared_AP_purchase_order',									'PTP',								2 UNION ALL
	SELECT 7, 'PROC_Refresh_Data_Shared_AP_matching',										'PTP',								2 UNION ALL
	SELECT 8, 'PROC_Refresh_Data_Shared_AP_purchase_invoice_line_details',					'PTP',								2 UNION ALL

	SELECT 9, 'PROC_Refresh_Data_Shared_AP_activity_summary_by_filters',					'PTP',								3 UNION ALL
	SELECT 10,'PROC_Refresh_Data_Shared_AP_activity_summary_by_filters_FX',					'PTP',								3 UNION ALL
	SELECT 11,'PROC_Refresh_Data_Shared_AP_activity_summary_by_filters_source',				'PTP',								3 UNION ALL
	SELECT 12, 'PROC_Refresh_Data_Shared_AP_open_transactions_summary_by_filters',			'PTP',								3 UNION ALL
	SELECT 13, 'PROC_Refresh_Data_Shared_AP_open_transactions_summary_by_filters_FX',		'PTP',								3 UNION ALL
	SELECT 14, 'PROC_Refresh_Data_Shared_AP_invoice_near_period_end_by_period',				'PTP',								3 UNION ALL
	SELECT 15, 'PROC_Refresh_Data_Shared_AP_sod_analysis',									'PTP',								3 UNION ALL
	SELECT 16, 'PROC_Refresh_Data_Shared_AP_balance',										'PTP',								3 UNION ALL
	SELECT 17, 'PROC_Refresh_Data_Shared_AP_goods_receipt_summary_by_filters',				'PTP',								3 UNION ALL
	SELECT 18, 'PROC_Refresh_Data_Shared_AP_purchase_order_summary_by_filters',				'PTP',								3 UNION ALL
	SELECT 19, 'PROC_Refresh_Data_AP_PP015_subsequent_clearing_summary',					'PTP',								3 UNION ALL

	SELECT 101, 'PROC_Refresh_Data_RDM_GL_Dim_BU',											'ALL WORKSTREAM',					1 UNION ALL
	SELECT 102, 'PROC_Refresh_Data_RDM_GL_DIM_Chart_of_Accounts',							'ALL WORKSTREAM',					1 UNION ALL
	--SELECT 103, 'PROC_Refresh_Data_RDM_GL_Dim_Currency_xref',								'ALL WORKSTREAM',					1 UNION ALL
	SELECT 104, 'PROC_Refresh_Data_RDM_GL_Dim_Dates',										'ALL WORKSTREAM',					1 UNION ALL
	SELECT 105, 'PROC_Refresh_Data_RDM_GL_Dim_Fiscal_calendar',								'ALL WORKSTREAM',					1 UNION ALL
	SELECT 106, 'PROC_Refresh_Data_RDM_GL_Dim_Preparer',									'ALL WORKSTREAM',					1 UNION ALL
	SELECT 107, 'PROC_Refresh_Data_RDM_GL_Dim_Segment01_listing',							'ALL WORKSTREAM',					1 UNION ALL
	SELECT 108, 'PROC_Refresh_Data_RDM_GL_Dim_Segment02_listing',							'ALL WORKSTREAM',					1 UNION ALL
	SELECT 109, 'PROC_Refresh_Data_RDM_GL_Dim_Source_listing',								'ALL WORKSTREAM',					1 UNION ALL
	SELECT 110, 'PROC_Refresh_Data_RDM_GL_Dim_Transaction_Type',							'ALL WORKSTREAM',					1 UNION ALL

	--SELECT 111, 'PROC_Refresh_Data_RDM_GL_FLAT_JE',											'GL',								2 UNION ALL		-- commented as its being called in SSIS differently now

	SELECT 112, 'PROC_Refresh_Data_RDM_GL_Ft_JE_Amounts',									'GL',								3 UNION ALL
	SELECT 113, 'PROC_Refresh_Data_RDM_GL_Trialbalance',									'GL',								3 UNION ALL
	SELECT 114, 'PROC_Refresh_Data_FT_GL_Account',											'GL',								4 UNION ALL
	SELECT 115, 'PROC_Refresh_Data_GL_001_Balance_Sheet',									'GL',								5 UNION ALL
	SELECT 116, 'PROC_Refresh_Data_GL_002_Income_Statement',								'GL',								5 UNION ALL
	SELECT 117, 'PROC_Refresh_Data_GL_007_Significant_Acct',								'GL',								5 UNION ALL
	--SELECT 118, 'PROC_Refresh_Data_GL_008_JE_Search',										'GL',								5 UNION ALL
	--SELECT 119, 'PROC_Refresh_Data_GL_008_JE_Search_Amount',								'GL',								5 UNION ALL
	--SELECT 120, 'PROC_Refresh_Data_GL_008_JE_Search_Description',							'GL',								5 UNION ALL
	--SELECT 121, 'PROC_Refresh_Data_GL012_Date_Analysis',									'GL',								6 UNION ALL
	SELECT 122, 'PROC_Refresh_Data_GL012_Date_Validation',									'GL',								6 UNION ALL
	SELECT 123, 'PROC_Refresh_Load_GL012_Seq_Day_of_month',									'GL',								5 UNION ALL
	SELECT 124, 'PROC_Refresh_Data_GL016_Balance_By_GL',									'GL',								5 UNION ALL
	SELECT 125, 'PROC_Refresh_Data_GL016_Stats_blanks',										'GL',								5 UNION ALL
	SELECT 126, 'PROC_Refresh_Data_GL016_Stats_totals',										'GL',								5 UNION ALL
	SELECT 127, 'PROC_Refresh_Data_GL017_Change_in_Preparers',								'GL',								5 UNION ALL
	SELECT 128, 'PROC_Refresh_Data_GL_004_Cashflow_Analysis',								'GL',								5 UNION ALL

	SELECT 201, 'PROC_Refresh_Customer_details',											'OTC',								2 UNION ALL
	SELECT 202, 'PROC_Refresh_Data_Shared_AR_activity_details',								'OTC',								2 UNION ALL
	--SELECT 203, 'PROC_Refresh_Data_Shared_AR_open_transactions_details',					'OTC',								2 UNION ALL
	SELECT 204, 'PROC_Refresh_Data_Shared_AR_goods_despatch',								'OTC',								2 UNION ALL
	--SELECT 205, 'PROC_Refresh_Data_Shared_AR_sales_order',									'OTC',								2 UNION ALL
	--SELECT 206, 'PROC_Refresh_Data_Shared_AR_sales_invoice_line_details',					'OTC',								2 UNION ALL
	SELECT 207, 'PROC_Refresh_Data_Shared_AR_matching',										'OTC',								2 UNION ALL

	SELECT 208, 'PROC_Refresh_Data_Shared_AR_activity_summary_by_filters',					'OTC',								3 UNION ALL
	SELECT 209, 'PROC_Refresh_Data_Shared_AR_activity_summary_by_filters_FX',				'OTC',								3 UNION ALL
	SELECT 210, 'PROC_Refresh_Data_Shared_AR_activity_summary_by_filters_source',			'OTC',								3 UNION ALL
	SELECT 211, 'PROC_Refresh_Data_Shared_AR_open_transactions_summary_by_filters',			'OTC',								3 UNION ALL
	SELECT 212, 'PROC_Refresh_Data_Shared_AR_open_transactions_summary_by_filters_FX',		'OTC',								3 UNION ALL
	SELECT 213, 'PROC_Refresh_Data_Shared_AR_invoice_near_period_end_by_period',			'OTC',								3 UNION ALL
	SELECT 214, 'PROC_Refresh_Data_Shared_AR_sod_analysis',									'OTC',								3 UNION ALL
	SELECT 215, 'PROC_Refresh_Data_Shared_AR_balance',										'OTC',								3 UNION ALL
	SELECT 216, 'PROC_Refresh_Data_Shared_AR_goods_despatch_summary_by_filters',			'OTC',								3 UNION ALL
	SELECT 217, 'PROC_Refresh_Data_Shared_AR_sales_order_summary_by_filters',				'OTC',								3 UNION ALL
	SELECT 218, 'PROC_Refresh_Data_AR_RR009_subsequent_clearing_summary',					'OTC',								3 


	UPDATE		[dbo].[RDM_Refresh_Executables]
	SET			sp_id = OBJECT_ID(sp_name)

END
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_BU')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_BU
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_BU
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into Dim_BU
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_BU
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].[dim_bu] 

	INSERT INTO [dbo].[dim_bu] 
	(
		[bu_id],
		[bu_cd],
		[bu_desc],
		[bu_ref],
		[bu_group],
		ver_start_date_id,
		ver_end_date_id,
		ver_desc
	)
	SELECT 
		[bu_id],
		[bu_cd],
		[bu_desc],
		[bu_cd]+' - '+[bu_desc],
		bu_hier_01_desc, -- is reffered as buisness unit group as per the discussion had with manish.
		ver_start_date_id,
		ver_end_date_id,
		ver_desc
	FROM [dbo].[Business_Unit_listing]


END 
GO


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_DIM_Chart_of_Accounts')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_DIM_Chart_of_Accounts
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_DIM_Chart_of_Accounts
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[DIM_Chart_of_Accounts]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_DIM_Chart_of_Accounts
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].[DIM_Chart_of_Accounts] 

	INSERT INTO [dbo].[DIM_Chart_of_Accounts] 
	(
		[Coa_id],
		[Bu_id],
		[coa_effective_date_id],
		[gl_account_cd],
		[gl_subacct_cd],
		[gl_account_name],
		[gl_subacct_name],
		[consolidation_account],
		[ey_gl_account_name],
		[ey_account_type],
		[ey_account_sub_type],
		[ey_account_class],
		[ey_account_sub_class],
		ey_account_group_I,
		ey_account_group_II,
		[ey_cash_activity],
		[ey_index],
		[ey_sub_index],
		[created_by_id],
		[created_date_id],
		[created_time_id],
		[last_modified_by_id],
		[last_modified_date_id],
		[ver_desc],
		[ver_start_date_id],
		[ver_end_date_id]
	)
	SELECT [Coa_id],
		[Bu_id],
		[coa_effective_date_id],
		[gl_account_cd],
		[gl_subacct_cd],
		[gl_account_name],
		[gl_subacct_name],
		[consolidation_account],
		gl_account_cd + ' - ' + gl_account_name,
		[ey_account_type],
		[ey_account_sub_type],
		[ey_account_class],
		[ey_account_sub_class],
		ey_account_group_I,
		ey_account_group_II,
		[ey_cash_activity],
		[ey_index],
		[ey_sub_index],
		[created_by_id],
		[created_date_id],
		[created_time_id],
		[last_modified_by_id],
		[last_modified_date_id],
		[ver_desc],
		[ver_start_date_id],
		[ver_end_date_id]
	FROM [dbo].[Chart_of_accounts]
END
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Dates')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Dates
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Dates
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[Dim_Dates]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Dates
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].[Dim_Dates]

	INSERT INTO [dbo].[Dim_Dates]
	(
		[calendar_date],
		[date_id],
		[month_id],
		[month_desc],
		[quarter_id],
		[quarter_desc],
		[year_id],
		[day_number_of_week],
		[day_of_week_desc],
		[day_number_of_month],
		[day_number_of_year],
		[week_number_of_year]
		--[CY_Start_End],
		--[CYPY],
		--[Interim_Start_End],
		--[PY_Start_End],
		--[b_s_comp_Start_End],
		--[i_s_comp_Start_End],
		--[ver_start_date_id],
		--[ver_end_date_id],
		--[ver_desc]
	)
	SELECT 
		[calendar_date],
		[date_id],
		[month_id],
		[month_desc],
		[quarter_id],
		[quarter_desc],
		[year_id],
		[day_number_of_week],
		[day_of_week_desc],
		[day_number_of_month],
		[day_number_of_year],
		[week_number_of_year]
		--[CY_Start_End],
		--[CYPY],
		--[Interim_Start_End],
		--[PY_Start_End],
		--[b_s_comp_Start_End],
		--[i_s_comp_Start_End],
		--[ver_start_date_id],
		--[ver_end_date_id],
		--[ver_desc]
	FROM [dbo].[Gregorian_calendar]
END
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Fiscal_calendar')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Fiscal_calendar
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Fiscal_calendar
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[Dim_Fiscal_calendar]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Fiscal_calendar
History:                                
************************************************************************************************************************************************/

BEGIN

	
	TRUNCATE TABLE [dbo].[Dim_Fiscal_calendar]

	INSERT INTO [dbo].[Dim_Fiscal_calendar]
	(
		[period_id],
		[bu_id],
		[fiscal_period_cd],
		[fiscal_period_desc],
		[fiscal_period_start],
		[fiscal_period_end],
		[fiscal_quarter_cd],
		[fiscal_quarter_desc],
		[fiscal_quarter_start],
		[fiscal_quarter_end],
		[fiscal_year_cd],
		[fiscal_year_desc],
		[fiscal_year_start],
		[fiscal_year_end],
		[adjustment_period],
		[engagement_id],
		[fiscal_period_seq],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc]
		--[Audit_period] 
 	)
	SELECT 
		[period_id],
		[bu_id],
		[fiscal_period_cd],
		[fiscal_period_desc],
		[fiscal_period_start],
		[fiscal_period_end],
		[fiscal_quarter_cd],
		[fiscal_quarter_desc],
		[fiscal_quarter_start],
		[fiscal_quarter_end],
		[fiscal_year_cd],
		[fiscal_year_desc],
		[fiscal_year_start],
		[fiscal_year_end],
		[adjustment_period],
		[engagement_id],
		[fiscal_period_seq],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc]
		--[Audit_period]
	FROM [dbo].[Fiscal_calendar]


END
GO





/*
insert into [Dim_Fiscal_calendar] ([period_id],[fiscal_period_cd],
[fiscal_period_desc],[fiscal_period_start],[fiscal_period_end],
[fiscal_quarter_cd],[fiscal_quarter_desc],[fiscal_quarter_start],[fiscal_quarter_end],
[fiscal_year_cd],[fiscal_year_desc],[fiscal_year_start],[fiscal_year_end],[adjustment_period])
select [period_id],[fiscal_period_cd],[fiscal_period_desc],[fiscal_period_start],
[fiscal_period_end],[fiscal_quarter_cd],[fiscal_quarter_desc],[fiscal_quarter_start],

[fiscal_quarter_end],[fiscal_year_cd],[fiscal_year_desc],[fiscal_year_start],[fiscal_year_end],
[adjustment_period] from [dbo].[Fiscal_calendar]
*/

  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Preparer')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Preparer
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Preparer
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[Dim_Preparer]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Preparer
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE  [dbo].[Dim_Preparer]

	INSERT INTO [dbo].[Dim_Preparer]
	(
		[user_listing_id],
		[client_user_id],
		[first_name],
		[last_name],
		[full_name],
		[preparer_ref],
		[department],
		[title],
		[role_resp],
		[sys_manual_ind],
		[active_ind],
		[active_ind_change_date_id],
		[created_by_id],
		[created_date_id],
		[created_time_id],
		[last_modified_by_id],
		[last_modified_date_id],
		[ver_start_date_id],
		[ver_end_date_id]
		--[ver_descerp_subledger_module]
	)
	SELECT 
		[user_listing_id],
		[client_user_id],
		[first_name],
		[last_name],
		[full_name],
		[client_user_id] +' - '+ [full_name],
		[department],
		[title],
		[role_resp],
		[sys_manual_ind],
		[active_ind],
		[active_ind_change_date_id],
		[created_by_id],
		[created_date_id],
		[created_time_id],
		[last_modified_by_id],
		[last_modified_date_id],
		[ver_start_date_id],
		[ver_end_date_id]
		--[ver_descerp_subledger_module]
	FROM [dbo].[User_listing]
END
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment01_listing')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment01_listing
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment01_listing
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[Dim_Segment01_listing]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment01_listing
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].[Dim_Segment01_listing]

	INSERT INTO [dbo].[Dim_Segment01_listing]
	(	[segment_id],
		[engagement_id],
		[segment_cd],
		[segment_desc],
		[segment_ref],
		[ey_segment_group],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc]
	)
	SELECT [segment_id],
		[engagement_id],
		[segment_cd],
		[segment_desc],
		[segment_cd] + ' - ' + [segment_desc],
		[ey_segment_group],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc]
	FROM dbo.Segment01_listing
	--from dbo.Segment02_listing  load from segment 2 CDM table based on the Rubitech data.

END
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment02_listing')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment02_listing
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment02_listing
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[Dim_Segment02_listing]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Segment02_listing
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].[Dim_Segment02_listing]

	INSERT INTO [dbo].[Dim_Segment02_listing]
	(	[segment_id],
		[engagement_id],
		[segment_cd],
		[segment_desc],
		[segment_ref],
		[ey_segment_group],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc]
	)
	SELECT [segment_id],
		[engagement_id],
		[segment_cd],
		[segment_desc],
		[segment_cd] + ' - ' + [segment_desc],
		[ey_segment_group],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc]
	FROM dbo.Segment02_listing
	--FROM DBO.Segment05_listing  -- load data based on the Rubitech data on june 24th
END
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Source_listing')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Source_listing
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Source_listing
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].[Dim_Source_listing]
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Source_listing
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].[Dim_Source_listing] 

	INSERT INTO [dbo].[Dim_Source_listing] 
	(
		[Source_Id],
		[source_cd],
		[source_desc],
		[erp_subledger_module],
		[bus_process_major],
		[bus_process_minor],
		[source_ref],
		[sys_manual_ind],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc],
		ey_source_group
		--[source_group]
	)
	SELECT [Source_Id],
		[source_cd],
		[source_desc],
		[erp_subledger_module],
		[bus_process_major],
		[bus_process_minor],
		[source_cd] + ' - '+[source_cd],
		[sys_manual_ind],
		[ver_start_date_id],
		[ver_end_date_id],
		[ver_desc],
		ey_source_group
		
	FROM [dbo].[Source_listing]
END
GO

  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].PROC_Refresh_Data_RDM_GL_Dim_Transaction_Type')) Drop PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Transaction_Type
GO

CREATE PROCEDURE [dbo].PROC_Refresh_Data_RDM_GL_Dim_Transaction_Type
AS
/**********************************************************************************************************************************************
Description:        Procedure for inserting data into [dbo].Dim_Transaction_Type
Script Date:         17/06/2014
Created By:                        
Version:                               1
Sample Command:          EXEC [dbo].PROC_Refresh_Data_RDM_GL_Dim_Transaction_Type
History:                                
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE [dbo].Dim_Transaction_Type 
	
	INSERT INTO [dbo].Dim_Transaction_Type 
	(
		[transaction_type_id],
		[transaction_type_cd],
		[bu_id] ,
		[engagement_id] ,
		[transaction_type_desc] ,
		[transaction_type_group_desc] ,
		[EY_transaction_type] ,
		[entry_by_id] ,
		[entry_date_id] ,
		[entry_time_id] ,
		[last_modified_by_id] ,
		[last_modified_date_id] ,
		[ver_start_date_id] ,
		[ver_end_date_id] ,
		[ver_desc] ,
		[transaction_type_ref]
	)
	SELECT 
		[transaction_type_id],
		[transaction_type_cd],
		[bu_id] ,
		[engagement_id] ,
		[transaction_type_desc] ,
		[transaction_type_group_desc] ,
		[EY_transaction_type] ,
		[entry_by_id] ,
		[entry_date_id] ,
		[entry_time_id] ,
		[last_modified_by_id] ,
		[last_modified_date_id] ,
		[ver_start_date_id] ,
		[ver_end_date_id] ,
		[ver_desc] ,
		[transaction_type_cd] +' - '+[transaction_type_desc]
	FROM [dbo].Transaction_type


END 
GO


  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_RDM_GL_FLAT_JE]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_RDM_GL_FLAT_JE]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_RDM_GL_FLAT_JE] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for create and inserting data into [FLAT_JE]
Script Date:	17/06/2014
Created By:		
Version:		2
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_RDM_GL_FLAT_JE]
History:	
V3			20141009			MSH			Performance improvement steps 	
V2			20140820			MSH			Changed Inner join to Left outer join for DIM_Transaction_type table with JE (Fix for Prod issue raised by Thomas)
************************************************************************************************************************************************/

BEGIN
	TRUNCATE TABLE dbo.FLAT_JE

	INSERT INTO dbo.FLAT_JE
	(
		je_id
		,je_line_id
		,je_line_desc
		,je_header_desc
		,dr_cr_ind
		,coa_id
		,period_id
		,bu_id
		,ey_je_id
		,activity
		,approved_by_id
		,transaction_type_id
		,reversal_ind
		,sys_manual_ind
		,year_flag
		,period_flag
		,year_flag_desc
		,period_flag_desc
		,year_end_date
		,period_end_date
		,gl_account_cd
		,gl_subacct_cd
		,gl_account_name
		,gl_subacct_name
		,ey_gl_account_name
		,consolidation_account
		,ey_account_type
		,ey_account_sub_type
		,ey_account_class
		,ey_cash_activity
		,ey_account_sub_class
		,ey_index
		,ey_sub_index
		,ey_account_group_I
		,ey_account_group_II
		,source_id
		--,source_cd
		--,source_desc
		--,source_ref
		,sys_manual_ind_src
		--,source_group
		,sys_manual_ind_usr
		,user_listing_id
		,client_user_id
		,preparer_ref
		,first_name
		,last_name
		,full_name
		,department
		,role_resp
		,title
		,active_ind
		,segment1_id
		,segment2_id
		/* added by prabakar for future purpose on June 25 -- begin */
		,segment3_id
		,segment4_id
		,segment5_id
		/* added by prabakar for future purpose on June 25 -- end */

		--,segment1_desc
		--,segment2_desc
		--,segment1_group
		--,segment2_group
		--,segment1_ref
		--,segment2_ref
		--,bu_cd
		--,bu_desc
		--,bu_ref
		--,bu_group
		,transaction_type_group_desc
		,transaction_type
		,fiscal_period_cd
		,fiscal_period_desc
		,fiscal_period_start
		,fiscal_period_end
		,fiscal_quarter_start
		,fiscal_quarter_end
		,fiscal_year_start
		,fiscal_year_end
		,EY_fiscal_year
		,EY_quarter
		,EY_period
		,Entry_Date
		,Day_of_week
		,Effective_Date
		,Lag_Date
		,exchange_rate
		,local_exchange_rate
		,reporting_exchange_rate
		,effective_date_id
		,entry_date_id
		,amount
		,amount_debit
		,amount_credit
		,amount_curr_cd
		,functional_curr_cd
		,functional_amount
		,functional_debit_amount
		,functional_credit_amount
		,reporting_amount
		,reporting_amount_curr_cd
		,reporting_amount_debit
		,reporting_amount_credit
		,engagement_id
		,entry_time_id
		,last_modified_by_id
		,last_modified_date_id
		,approved_by_date_id
		,reversal_je_id
		,GL_clearing_document
		,GL_clearing_date_id
		,ver_start_date_id
		,ver_end_date_id
		,ver_desc
		,day_number_of_week
		,day_number_of_month
		,journal_type
		,system_load_date
	)
		
	SELECT 
		je.je_id
		,je.je_line_id
		,je.je_line_desc
		,je.je_header_desc
		,je.dr_cr_ind
		,je.coa_id
		,je.period_id
		,je.bu_id
		,je.ey_je_id
		,je.activity
		,je.approved_by_id
		,je.transaction_type_id
		,je.reversal_ind
		--,sys_manual_ind= je.ey_sys_manual_ind -- Commented and added by prabakar as per discussion we had Manish on Aug 20th
		,sys_manual_ind = CASE WHEN ISNULL(SM_SRC.ey_sys_man_ident, SM_UL.ey_sys_man_ident)	IN ('Manual') THEN 'M'
								WHEN ISNULL(SM_SRC.ey_sys_man_ident, SM_UL.ey_sys_man_ident)	IN ('System') THEN 'S' 
								ELSE NULL
							END	

		,year_flag = pp.year_flag
		,period_flag = pp.period_flag
		-- commented this code due to populate the current, prior, subsquent value
		--,year_flag_desc = PP.year_flag_desc  -- Pulled from parameter period
		,CASE WHEN pp.year_flag = 'CY' THEN 'Current'
				WHEN pp.year_flag = 'PY' THEN 'Prior'
				WHEN pp.year_flag = 'SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS year_flag_desc
		,period_flag_desc = PP.period_flag_desc ---- Pulled from parameter period
		,year_end_date = pp.year_end_date
		,period_end_date =pp.end_date
		,coa.gl_account_cd
		,coa.gl_subacct_cd
		,coa.gl_account_name
		,coa.gl_subacct_name
		--,"ey_gl_account_name" = coa.gl_account_cd + ' - ' + coa.gl_account_name  -- tranformation needs to done in one place, bring from dim_coa table
		,coa.ey_gl_account_name 
		,coa.consolidation_account
		,coa.ey_account_type
		,coa.ey_account_sub_type
		,coa.ey_account_class
		,coa.ey_cash_activity
		,coa.ey_account_sub_class
		,coa.ey_index
		,coa.ey_sub_index
		,coa.ey_account_group_I
		,coa.ey_account_group_II

		,src.source_id
		/* All the bu Source column will go off since refer the business unit dynamic view to pull the latest information prabakar -- begin */
		--,src.source_cd
		--,src.source_desc
		--,source_concat = src.source_cd + ' - ' + src.source_desc  -- commented since concat and ref are the same
		--,source_ref = src.source_ref  src.source_cd + '-' + src.source_desc  -- tranformation needs to done in one place, bring from DIM
		--,src.source_ref  
		--,src.sys_manual_ind
		,src.sys_manual_ind as sys_manual_ind_src
		--,source_group = src.ey_source_group
		--,source_group = src.source_group
		
		/* All the Source reference column will go off since refer the business unit dynamic view to pull the latest information prabakar -- end */


		,usr.sys_manual_ind as sys_manual_ind_usr
		,usr.user_listing_id
		,usr.client_user_id
		--,preparer_ref = usr.client_user_id + '-' + usr.full_name  -- tranformation needs to done in one place, bring from dim_preparer table
		,usr.preparer_ref
		,usr.first_name
		,usr.last_name
		,usr.full_name
		,usr.department
		,usr.role_resp
		,usr.title
		,usr.active_ind
		/* Commented and added code by prabakar to consider the segment id dynamic from Segment 1 and segment 2 view June 25 -- begin */
		--,segment1_id=je.segment01
		--,segment2_id=je.segment02

		,segment1_id=SL1.ey_segment_id
		,segment2_id=SL2.ey_segment_id
		/* Commented and added code by prabakar to consider the segment id dynamic from Segment 1 and segment 2 view June 25 -- end */

		/* added by prabakar for future purpose on June 25 -- begin */
		,0	--segment3_id 
		,0	--segment4_id 
		,0	--segment5_id 
		/* added by prabakar for future purpose on June 25 -- end */

		/* All the below columns eventually go off since we are going to refer dynamically to pull the latest record but added for timebeing by prabakar -- begin */
		--,segment1_desc = s1.segment_desc
		--,segment2_desc = s2.segment_desc
		--,segment1_group = s1.ey_segment_group
		--,segment2_group = s2.ey_segment_group
		--,segment1_ref = s1.segment_ref
		--,segment2_ref = s2.segment_ref

		--,segment1_desc = sl1.segment_desc
		--,segment2_desc = sl2.segment_desc
		--,segment1_group = sl1.ey_segment_group
		--,segment2_group = sl2.ey_segment_group
		--,segment1_ref = sl1.ey_segment_ref
		--,segment2_ref =  sl2.ey_segment_ref

		/* All the below columns eventually go off since we are going to refer dynamically to pull the latest record but added for timebeing by prabakar -- end */	

		/* All the bu reference column will go off since refer the business unit dynamic view to pull the latest information prabakar -- begin */
		--,bu.bu_cd
		--,bu.bu_desc
		--,bu.bu_ref   -- should referred as business unit
		--,bu.bu_group
		/* All the bu reference column will go off since refer the business unit dynamic view to pull the latest information prabakar -- end */

		,TT.transaction_type_group_desc
		,transaction_type = TT.EY_transaction_type

		,fc.fiscal_period_cd
		,fc.fiscal_period_desc
		,fc.fiscal_period_start
		,fc.fiscal_period_end
		,fc.fiscal_quarter_start
		,fc.fiscal_quarter_end
		,fc.fiscal_year_start
		,fc.fiscal_year_end
		,fc.fiscal_year_desc AS EY_fiscal_year
		,fc.fiscal_quarter_desc AS EY_quarter
		,fc.fiscal_period_desc AS EY_period
		,EntCal.calendar_date AS Entry_Date
		,EntCal.day_of_week_desc AS Day_of_week
		,EffCal.calendar_date AS Effective_Date

		,DATEDIFF(DAY,EntCal.calendar_date,EffCal.calendar_date) AS Lag_Date

			/*--,"audit_period" =
			--	case 
			--		when (gc.calendar_date >= dd.audit_period_start_date and 
			--			  gc.calendar_date <= dd.audit_period_end_date) then 'Current'
			--		when (gc.calendar_date >= dd.comparative_period_start_date and 
			--			  gc.calendar_date <= dd.comparative_period_end_date) then 'Prior'	  
			--		when (gc.calendar_date > dd.audit_period_end_date) then 'Subsequent'  
			--		else 'None'
			--	end
			--,"interim_period" =
			--	case 
			--		when (dd.interim_period_end_date is null) then 'None'
			--		when (gc.calendar_date >= dd.interim_period_start_date and 
			--			  gc.calendar_date <= dd.interim_period_end_date) then 'Interim'
			--		when (gc.calendar_date > dd.interim_period_end_date and 
			--			  gc.calendar_date <= dd.current_year_end_date) then 'Rollforward'	  	  
			--		when (gc.calendar_date >= dd.comparative_period_start_date and
			--			  gc.calendar_date <= (select top 1 gc2.calendar_date
			--								   from audit_dates dd2
			--								   join fiscal_calendar fc2 on
			--										left(dd2.comparative_period_end_period_cd, 5) + right(dd2.interim_period_end_period_cd, 3) = fc2.fiscal_period_cd 
			--								   join gregorian_calendar gc2 on
			--										fc2.fiscal_period_end = gc2.date_id)) then 'Prior Interim'  
			--		else 'None'
			--	end
			--,"audit_year" =
			--	case 
			--		when (gc.calendar_date >= dd.current_year_start_date and 
			--			  gc.calendar_date <= dd.current_year_end_date) then 'Current'
			--		when (gc.calendar_date >= dd.prior_year_start_date and 
			--			  gc.calendar_date <= dd.prior_year_end_date) then 'Prior'	  
			--		when (gc.calendar_date > dd.current_year_end_date) then 'Subsequent'  
			--		else 'None'
			--	end
			--,je.segment01  
			--,je.segment02
			--,je.segment03
			--,je.segment04
			--,je.segment05*/
			
		,je.exchange_rate
		,je.local_exchange_rate
		,je.reporting_exchange_rate
		,je.effective_date_id
		,je.entry_date_id

		--Changed by Rajaan from amount columns to round of decimal 2 to avoid exponential  value created from CDM -- Begin
		,amount=ROUND(je.local_amount,2) 
		,amount_debit= ROUND(je.local_amount_debit,2)
		,amount_credit=ROUND(je.local_amount_credit,2)
		,amount_curr_cd =je.local_amount_curr_cd

		,functional_curr_cd=je.amount_curr_cd
		,functional_amount=ROUND(je.amount,2)
		,functional_debit_amount= ROUND(je.amount_debit,2)
		,functional_credit_amount=ROUND(je.amount_credit,2)

		,ROUND(je.reporting_amount,2)
		,je.reporting_amount_curr_cd
		,ROUND(je.reporting_amount_debit,2)
		,ROUND(je.reporting_amount_credit,2)
		--Changed by Rajaan from amount columns to round of decimal 2 to avoid exponential  value created from CDM -- end
		,je.engagement_id

		,je.entry_time_id
		,je.last_modified_by_id
		,je.last_modified_date_id
		,je.approved_by_date_id
		,je.reversal_je_id
		,je.GL_clearing_document
		,je.GL_clearing_date_id
		,je.ver_start_date_id
		,je.ver_end_date_id
		,je.ver_desc
		,EntCal.day_number_of_week  -- based on the entry id
		,EffCal.day_number_of_month  -- based on the effective id
		-- Added a new column Journal Type to describe Jounal Type indiacator by prabakar
		-- Commented and added by prabakar as per discussion we had Manish on Aug 20th
		--CASE WHEN je.ey_sys_manual_ind	IN ('U','M') THEN 'Manual' WHEN je.ey_sys_manual_ind IN ('S') THEN 'System' END	as [journal_type]
		,ISNULL(SM_SRC.ey_sys_man_ident, SM_UL.ey_sys_man_ident)   as [journal_type]
			,system_load_date = GETDATE()

		FROM dbo.Journal_entries je
			INNER JOIN DIM_Chart_of_Accounts coa ON je.coa_id = coa.coa_id
			INNER JOIN Dim_Preparer usr ON je.entry_by_id = usr.user_listing_id
			INNER JOIN Fiscal_calendar fc ON je.period_id = fc.period_id
			INNER JOIN Gregorian_calendar EntCal ON je.entry_date_id = EntCal.date_id
			INNER JOIN Gregorian_calendar EffCal ON je.effective_date_id = EffCal.date_id
			LEFT OUTER JOIN dbo.Dim_Transaction_type tt on tt.transaction_type_id = je.transaction_type_id
			LEFT OUTER JOIN v_Fiscal_calendar fc1 ON JE.period_id = fc1.period_id
			LEFT OUTER JOIN Parameters_period PP ON FC.fiscal_year_cd = PP.fiscal_year_cd
					AND FC.fiscal_period_seq BETWEEN PP.fiscal_period_seq_start AND PP.fiscal_period_seq_end

			/* Commented and Added by prabakar to consider the Bu, Segment and Source dynamic -- begin */
			--INNER JOIN DIM_Source_listing src ON je.source_id = src.source_id
			--INNER JOIN Dim_BU bu ON je.bu_id = bu.bu_id  -- changed from bu_ref_id
			--INNER JOIN dbo.Dim_Segment01_listing S1 on s1.segment_id = je.segment01  -- Refer DIM_SEGMENT1
			--INNER JOIN dbo.Dim_Segment02_listing s2 on s2.segment_id = je.segment02	---- Refer DIM_SEGMENT2

			LEFT OUTER JOIN	dbo.v_Source_listing src			ON		JE.source_id = src.source_id
			LEFT OUTER JOIN	dbo.v_Business_Unit_listing BU		ON		je.bu_id = BU.bu_id
			LEFT OUTER JOIN	 [dbo].[v_Segment01_listing] SL1	ON		je.Segment01 = SL1.Segment01
															OR	je.Segment02 = SL1.Segment02
															OR	je.Segment03 = SL1.Segment03
															OR	je.Segment04 = SL1.Segment04
															OR	je.Segment05 = SL1.Segment05
			LEFT OUTER JOIN	 [dbo].[v_Segment02_listing] SL2	ON		je.Segment01 = SL2.Segment01
															OR	je.Segment02 = SL2.Segment02
															OR	je.Segment03 = SL2.Segment03
															OR	je.Segment04 = SL2.Segment04
															OR	je.Segment05 = SL2.Segment05
			/* Commented and Added by prabakar to consider the Bu, Segment and Source dynamic -- end */
			LEFT OUTER JOIN  dbo.v_System_manual_idicator SM_SRC   ON         JE.source_id = SM_SRC.source_id
			LEFT OUTER JOIN  dbo.v_System_manual_idicator SM_UL    ON         JE.entry_by_id = SM_UL.user_listing_id


	print 'STEP #: Update FLAT_JE for Adjusted_fiscal_period BEGIN ' + CONVERT(NVARCHAR, GETDATE(), 109)
	UPDATE FJ
	SET			 Adjusted_fiscal_period = FC.fiscal_period_cd
	FROM		 dbo.FLAT_JE FJ 
	INNER JOIN	 dbo.v_Fiscal_calendar FC		ON		FJ.bu_id = FC.bu_id
													AND	FJ.Entry_date BETWEEN FC.fiscal_period_start AND FC.fiscal_period_end
	WHERE		 FC.adjustment_period = 'N'
	
	print 'STEP #: Update FLAT_JE for Adjusted_fiscal_period END ' + CONVERT(NVARCHAR, GETDATE(), 109)
	
	-- Update Approver Department, Approver Ref for FLAT JE
	UPDATE dbo.FLAT_JE	
	set approver_department	= dp.department
		,approver_ref = dp.Preparer_Ref
	from dbo.FLAT_JE JE 
		INNER JOIN dbo.Dim_Preparer dp
		ON JE.approved_by_id = dp.user_listing_id

	UPDATE JE
	set je.reporting_impact_to_assets =  j1.r_assets
		,je.reporting_impact_to_equity = j1.r_equity
		,je.reporting_impact_to_expenses =j1.r_expense
		,je.reporting_impact_to_liabilities = j1.r_liability
		,je.reporting_impact_to_revenue  = j1.r_revenue
		,je.functional_impact_to_assets  = j1.f_assest
		,je.functional_impact_to_equity  = j1.f_equity
		,je.functional_impact_to_expenses  = j1.f_expense
		,je.functional_impact_to_liabilities  = j1.f_liability
		,je.functional_impact_to_revenue  = j1.f_revenue
	FROM flat_je je inner join 	
		(	 
			select je_id 
				,sum( case when ey_account_type = 'Assets' then isnull(reporting_amount,0.0) else 0.0  end ) AS r_assets
				,sum( case when ey_account_type = 'Equity' then isnull(reporting_amount,0.0) else 0.0  end ) as r_equity
				,sum( case when ey_account_type = 'Expenses' then isnull(reporting_amount,0.0) else 0.0  end ) as r_expense
				,sum( case when ey_account_type = 'Liabilities' then isnull(reporting_amount,0.0) else 0.0  end ) as r_liability
				,sum( case when ey_account_type = 'Revenue' then isnull(reporting_amount,0.0) else 0.0  end ) as r_revenue
				,sum( case when ey_account_type = 'Assets' then isnull(functional_amount,0.0) else 0.0  end ) as f_assest
				,sum( case when ey_account_type = 'Equity' then isnull(functional_amount,0.0) else 0.0  end ) as f_equity
				,sum( case when ey_account_type = 'Liabilities' then isnull(functional_amount,0.0) else 0.0  end ) as f_liability
				,sum( case when ey_account_type = 'Expenses' then isnull(functional_amount,0.0) else 0.0  end ) as f_expense
				,sum( case when ey_account_type = 'Revenue' then isnull(functional_amount,0.0) else 0.0  end ) as f_revenue
			FROM dbo.flat_je J1 
			group by J1.JE_ID--, J1.ey_account_type
		)  j1
	on je.je_id = j1.je_id


	-- [MANISH - 11 July 2014] Below update statement added
	-- STEP #: Update FLAT_JE for ey_subledger, ey_AR_type, ey_AP_type and ey_reconciliation_GL_group
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #: Update FLAT_JE for ey_subledger, ey_AR_type, ey_AP_type and ey_reconciliation_GL_group ' + CONVERT(NVARCHAR, GETDATE(), 109)

	;WITH JE_LEVEL_CTE
	AS
	(
		SELECT
						 JE.je_id
						,CASE	WHEN ISNULL(MIN(COA.ey_sub_ledger), '') = ISNULL(MAX(COA.ey_sub_ledger), '')
								THEN MIN(COA.ey_sub_ledger) 
								ELSE 'BOTH' 
						 END																					AS [EY_SUB_LEDGER]
						,CASE	WHEN SUM(CASE WHEN JE.ey_account_type = 'Revenue' THEN 1 END) > 0 
								THEN 1 
								ELSE 0
						 END																					AS [REVENUE]
						,CASE	WHEN SUM(CASE WHEN JE.ey_account_type = 'Expenses' THEN 1 END) > 0 
								THEN 1 
								ELSE 0
						 END																					AS [EXPENSES]
						,CASE	WHEN SUM(CASE WHEN JE.ey_account_group_I = 'Cash'  OR JE.ey_account_group_II IN ('AR cash suspense','AP cash suspense') THEN 1 END) > 0 
								THEN 1 
								ELSE 0
						 END																					AS [CASH]
		FROM			 [dbo].[FLAT_JE] JE
		LEFT OUTER JOIN	 [dbo].[v_Chart_of_accounts] COA	ON COA.coa_id=JE.coa_id
		GROUP BY		 JE.je_id
	)
	UPDATE JE
	SET				 JE.ey_subledger_type	= JE_CTE.[EY_SUB_LEDGER]
					,JE.ey_AR_type =
					 (
						CASE 
							WHEN JE_CTE.[REVENUE] = 1 AND JE_CTE.[CASH] = 1		THEN 'Cash and Revenue'
							WHEN JE_CTE.[REVENUE] = 0 AND JE_CTE.[CASH] = 1		THEN 'Cash'
							WHEN JE_CTE.[REVENUE] = 1 AND JE_CTE.[CASH] = 0		THEN 'Revenue'
						END
					 ) 
					,JE.ey_AP_type = 
					(
						CASE
							WHEN JE_CTE.[EXPENSES] = 1 AND JE_CTE.[CASH] = 1	THEN 'Cash and Expenses'
							WHEN JE_CTE.[EXPENSES] = 0 AND JE_CTE.[CASH] = 1	THEN 'Cash'
							WHEN JE_CTE.[EXPENSES] = 1 AND JE_CTE.[CASH] = 0	THEN 'Expenses'
						END
					 ) 
					,JE.ey_reconciliation_GL_group =
					 (
						CASE
							WHEN JE.ey_account_type = 'Expenses' 				THEN 'Expenses'
							WHEN JE.ey_account_type = 'Revenue'					THEN 'Revenue'
							WHEN COA.ey_sub_ledger	= 'AP'						THEN 'AP subledger'
							WHEN COA.ey_sub_ledger	= 'AR'						THEN 'AR subledger'
							WHEN JE.ey_account_group_I = 'Cash'					THEN 'Cash'
							WHEN JE.ey_account_group_I = 'Sales tax'			THEN 'Sales tax'
							WHEN JE.ey_account_group_II = 'AP cash suspense'	THEN 'AP cash suspense'
							WHEN JE.ey_account_group_II = 'AR cash suspense'	THEN 'AR cash suspense'
							ELSE 'Other'
						END
					 ) 
	FROM			 [dbo].[FLAT_JE] JE
	INNER JOIN		 JE_LEVEL_CTE JE_CTE				ON		JE.je_id = JE_CTE.je_id
	LEFT OUTER JOIN	 [dbo].[v_Chart_of_accounts] COA	ON		COA.coa_id=JE.coa_id

END -- END OF PROCEUDRE  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Parameters_period]')) Drop PROC [dbo].[PROC_Refresh_Parameters_period]
GO
	
CREATE PROC [dbo].[PROC_Refresh_Parameters_period]
AS
/**********************************************************************************************************************************************
Description:	PROC to refresh dates for all periods for all engagements with parameters already set 
Script Date:	13/06/2013 
Created By:		MSH
Version:		2
Sample Command:	EXEC	[dbo].[PROC_Refresh_Parameters_period]
History:		
V1				13/06/2013  	MSH		CREATED
************************************************************************************************************************************************/
BEGIN

	TRUNCATE TABLE [dbo].[Parameters_period]


	INSERT INTO [dbo].[Parameters_period] (year_flag,year_flag_desc,period_flag,period_flag_desc) VALUES ('CY','Current period','IP','Interim period')
	INSERT INTO [dbo].[Parameters_period] (year_flag,year_flag_desc,period_flag,period_flag_desc) VALUES ('CY','Current period','RP','Rollforward period')
	INSERT INTO [dbo].[Parameters_period] (year_flag,year_flag_desc,period_flag,period_flag_desc) VALUES ('PY','Prior period','PIP','Prior interim period')
	INSERT INTO [dbo].[Parameters_period] (year_flag,year_flag_desc,period_flag,period_flag_desc) VALUES ('PY','Prior period','PRP','Prior rollforward period')
	INSERT INTO [dbo].[Parameters_period] (year_flag,year_flag_desc,period_flag,period_flag_desc) VALUES ('SP','Subsequent period','SP','Subsequent period')

	-- STEP #1: UPDATE for IP
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: UPDATE for IP ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH PERIOD_CTE
	AS
	(
		SELECT
						 1								AS	fiscal_period_seq_start
						,MAX(FC.fiscal_period_seq)		AS	fiscal_period_seq_end
						,MAX(PE.current_year_cd)		AS	fiscal_year_cd
						,MIN(GC_Y_START.calendar_date)	AS	fiscal_period_start_date
						,MAX(GC_P_END.calendar_date)	AS	fiscal_period_end_date
						,MIN(GC_Y_START.calendar_date)	AS	fiscal_year_start_date
						,MAX(GC_Y_END.calendar_date)	AS	fiscal_year_end_date

		FROM			 [dbo].[Parameters_engagement] PE
		INNER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		FC.fiscal_year_cd					= PE.current_year_cd
																	AND	FC.fiscal_period_cd					= PE.interim_period_end_period_cd
																	AND	ISNULL(PE.bu_id_for_dates,FC.bu_id) = FC.bu_id
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id					= FC.fiscal_period_end
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_START	ON		GC_Y_START.Date_id					= FC.fiscal_year_start
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_END	ON		GC_Y_END.Date_id					= FC.fiscal_year_end
	)
	UPDATE	PP
	SET				 PP.fiscal_period_seq_start = PERIOD.fiscal_period_seq_start
					,PP.fiscal_period_seq_end	= PERIOD.fiscal_period_seq_end
					,PP.fiscal_year_cd			= PERIOD.fiscal_year_cd
					,PP.start_date				= PERIOD.fiscal_year_start_date
					,PP.end_date				= PERIOD.fiscal_period_end_date
					,PP.year_start_date			= PERIOD.fiscal_year_start_date
					,PP.year_end_date			= PERIOD.fiscal_year_end_date
	FROM			 [dbo].[Parameters_period] PP
	CROSS JOIN		 PERIOD_CTE PERIOD
	WHERE			 PP.period_flag = 'IP'


	-- STEP #1: UPDATE for RP
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: UPDATE for RP ' + CONVERT(NVARCHAR, GETDATE(), 109)

	;WITH PERIOD_CTE
	AS
	(
		SELECT
						 MAX(PP.fiscal_period_seq_end) + 1			AS	fiscal_period_seq_start
						,MAX(FC.fiscal_period_seq)					AS	fiscal_period_seq_end
						,MAX(PE.current_year_cd)					AS	fiscal_year_cd
						,DATEADD(DD, 1, MAX(PP.end_date))			AS	fiscal_period_start_date
						,MAX(GC_P_END.calendar_date)				AS	fiscal_period_end_date
						,MIN(GC_Y_START.calendar_date)				AS	fiscal_year_start_date
						,MAX(GC_Y_END.calendar_date)				AS	fiscal_year_end_date

		FROM			 [dbo].[Parameters_engagement] PE
		INNER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		FC.fiscal_year_cd					= PE.current_year_cd
																	AND	FC.fiscal_period_cd					= PE.audit_period_end_period_cd
																	AND	ISNULL(PE.bu_id_for_dates,FC.bu_id) = FC.bu_id
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id					= FC.fiscal_period_end
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_START	ON		GC_Y_START.Date_id					= FC.fiscal_year_start
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_END	ON		GC_Y_END.Date_id					= FC.fiscal_year_end
		CROSS JOIN		 [dbo].[Parameters_period] PP
		WHERE			 PP.period_flag = 'IP'
	)
	UPDATE	PP
	SET				 PP.fiscal_period_seq_start = PERIOD.fiscal_period_seq_start
					,PP.fiscal_period_seq_end	= PERIOD.fiscal_period_seq_end
					,PP.fiscal_year_cd			= PERIOD.fiscal_year_cd
					,PP.start_date				= PERIOD.fiscal_period_start_date
					,PP.end_date				= PERIOD.fiscal_period_end_date
					,PP.year_start_date			= PERIOD.fiscal_year_start_date
					,PP.year_end_date			= PERIOD.fiscal_year_end_date
	FROM			 [dbo].[Parameters_period] PP
	CROSS JOIN		 PERIOD_CTE PERIOD
	WHERE			 PP.period_flag = 'RP'


	-- STEP #1: UPDATE for PIP
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: UPDATE for PIP ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH PERIOD_CTE
	AS
	(
		SELECT
						 1								AS	fiscal_period_seq_start
						,MAX(FC.fiscal_period_seq)		AS	fiscal_period_seq_end
						,MAX(PE.prior_year_cd)			AS	fiscal_year_cd
						,MIN(GC_Y_START.calendar_date)	AS	fiscal_period_start_date
						,MAX(GC_P_END.calendar_date)	AS	fiscal_period_end_date
						,MIN(GC_Y_START.calendar_date)	AS	fiscal_year_start_date
						,MAX(GC_Y_END.calendar_date)	AS	fiscal_year_end_date

		FROM			 [dbo].[Parameters_engagement] PE
		CROSS JOIN		 [dbo].[Parameters_period] PP
		INNER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		FC.fiscal_year_cd					= PE.prior_year_cd
																	AND	FC.fiscal_period_seq				= PP.fiscal_period_seq_end
																	AND	ISNULL(PE.bu_id_for_dates,FC.bu_id) = FC.bu_id
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id					= FC.fiscal_period_end
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_START	ON		GC_Y_START.Date_id					= FC.fiscal_year_start
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_END	ON		GC_Y_END.Date_id					= FC.fiscal_year_end
		WHERE			 PP.period_flag = 'IP'
	)
	UPDATE	PP
	SET				 PP.fiscal_period_seq_start = PERIOD.fiscal_period_seq_start
					,PP.fiscal_period_seq_end	= PERIOD.fiscal_period_seq_end
					,PP.fiscal_year_cd			= PERIOD.fiscal_year_cd
					,PP.start_date				= PERIOD.fiscal_year_start_date
					,PP.end_date				= PERIOD.fiscal_period_end_date
					,PP.year_start_date			= PERIOD.fiscal_year_start_date
					,PP.year_end_date			= PERIOD.fiscal_year_end_date
	FROM			 [dbo].[Parameters_period] PP
	CROSS JOIN		 PERIOD_CTE PERIOD
	WHERE			 PP.period_flag = 'PIP'


	-- STEP #1: UPDATE for PRP
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: UPDATE for PRP ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH PERIOD_CTE
	AS
	(
		SELECT
						 PP.fiscal_period_seq_end + 1			AS fiscal_period_seq_start
						,PP.fiscal_year_cd						AS fiscal_year_cd
						,DATEADD(DD, 1, PP.end_date)			AS fiscal_period_start_date
						,PP.year_start_date						AS fiscal_year_start_date
						,PP.year_end_date						AS fiscal_year_end_date

		FROM			 [dbo].[Parameters_period] PP
		WHERE			 PP.period_flag = 'PIP'
	)
	,
	END_DATE_CTE
	AS
	(
		SELECT
						 MAX(FC.fiscal_period_seq)					AS fiscal_period_seq_end
						,MAX(FC.fiscal_period_end)					AS fiscal_period_end
		FROM			 [dbo].[Parameters_engagement] PE
		CROSS JOIN		 [dbo].[Parameters_period] PP_IP
		CROSS JOIN		 [dbo].[Parameters_period] PP_RP
		INNER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		FC.fiscal_year_cd					= PE.prior_year_cd
																	AND	FC.fiscal_period_cd					= CASE	WHEN PP_IP.fiscal_period_seq_end = PP_RP.fiscal_period_seq_end
																													THEN FC.fiscal_period_cd
																													ELSE PE.comparative_period_end_period_cd
																											  END
																	AND	ISNULL(PE.bu_id_for_dates,FC.bu_id) = FC.bu_id
		WHERE			 PP_IP.period_flag = 'IP'
					AND	 PP_RP.period_flag = 'RP'

	)
	UPDATE	PP
	SET				 PP.fiscal_period_seq_start = PERIOD.fiscal_period_seq_start
					,PP.fiscal_period_seq_end	= END_DATE.fiscal_period_seq_end
					,PP.fiscal_year_cd			= PERIOD.fiscal_year_cd
					,PP.start_date				= PERIOD.fiscal_period_start_date
					,PP.end_date				= GC_P_END.calendar_date
					,PP.year_start_date			= PERIOD.fiscal_year_start_date
					,PP.year_end_date			= PERIOD.fiscal_year_end_date
	FROM			 [dbo].[Parameters_period] PP
	CROSS JOIN		 PERIOD_CTE PERIOD
	CROSS JOIN		 END_DATE_CTE END_DATE
	INNER JOIN		 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id = END_DATE.fiscal_period_end
	WHERE			 PP.period_flag = 'PRP'


	-- STEP #1: UPDATE for SP
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: UPDATE for SP ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH DECIDE_CTE
	AS
	(
		SELECT
						 CASE WHEN DATEADD(DD, 1, PP.end_date) > PP.year_end_date THEN 1 ELSE 0 END		AS SP_IN_NEXT_YEAR
		FROM			 [dbo].[Parameters_period] PP
		WHERE			 PP.period_flag = 'RP'
	)
	,PERIOD_CTE
	AS
	(
		SELECT 
						 0										AS SP_IN_NEXT_YEAR
						,MAX(PP.fiscal_period_seq_start)		AS fiscal_period_seq_start
						,MAX(FC.fiscal_period_seq)				AS fiscal_period_seq_end
						,MAX(PP.fiscal_year_cd)					AS fiscal_year_cd
						,MAX(PP.start_date)						AS fiscal_period_start_date
						,MAX(GC_P_END.calendar_date)			as fiscal_period_end_date
						,MAX(PP.year_start_date)				AS fiscal_year_start_date
						,MAX(PP.year_end_date)					AS fiscal_year_end_date

		FROM			 [dbo].[Parameters_period] PP
		CROSS JOIN		 [dbo].[Parameters_engagement] PE
		INNER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		FC.fiscal_year_cd					= PP.fiscal_year_cd
																	AND	ISNULL(PE.bu_id_for_dates,FC.bu_id) = FC.bu_id
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id = FC.fiscal_period_end
		WHERE			 PP.period_flag = 'RP'
		UNION ALL
		SELECT 
						 1										AS SP_IN_NEXT_YEAR
						,MIN(FC.fiscal_period_seq)				AS fiscal_period_seq_start
						,MAX(FC.fiscal_period_seq)				AS fiscal_period_seq_end
						,MAX(FC.fiscal_year_cd)					AS fiscal_year_cd
						,MIN(GC_Y_START.calendar_date)			AS fiscal_period_start_date
						,MAX(GC_P_END.calendar_date)			as fiscal_period_end_date
						,MIN(GC_Y_START.calendar_date)			AS fiscal_year_start_date
						,MAX(GC_Y_END.calendar_date)			AS fiscal_year_end_date

		FROM			 [dbo].[Parameters_engagement] PE
		INNER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		FC.fiscal_year_cd					= PE.current_year_cd + 1
																	AND	ISNULL(PE.bu_id_for_dates,FC.bu_id) = FC.bu_id
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_P_END	ON		GC_P_END.Date_id					= FC.fiscal_period_end
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_START	ON		GC_Y_START.Date_id					= FC.fiscal_year_start
		INNER JOIN		 [dbo].[Gregorian_calendar] GC_Y_END	ON		GC_Y_END.Date_id					= FC.fiscal_year_end
	)
	UPDATE	PP
	SET				 PP.fiscal_period_seq_start = PERIOD.fiscal_period_seq_start
					,PP.fiscal_period_seq_end	= PERIOD.fiscal_period_seq_end
					,PP.fiscal_year_cd			= PERIOD.fiscal_year_cd
					,PP.start_date				= PERIOD.fiscal_period_start_date
					,PP.end_date				= PERIOD.fiscal_period_end_date
					,PP.year_start_date			= PERIOD.fiscal_year_start_date
					,PP.year_end_date			= PERIOD.fiscal_year_end_date
	FROM			 [dbo].[Parameters_period] PP
	CROSS JOIN		 PERIOD_CTE PERIOD
	INNER JOIN		 DECIDE_CTE DECIDE		ON		PERIOD.SP_IN_NEXT_YEAR = DECIDE.SP_IN_NEXT_YEAR
	WHERE			 PP.period_flag = 'SP'





END  
GO -- new file   
  
