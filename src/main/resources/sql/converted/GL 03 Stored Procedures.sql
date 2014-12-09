IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FUNC_Get_Seq_Day_of_month]')) Drop FUNCTION [dbo].[FUNC_Get_Seq_Day_of_month]
GO

CREATE  FUNCTION  [dbo].[FUNC_Get_Seq_Day_of_month] 
(
	@seq_date datetime

)RETURNS INT
AS
/**********************************************************************************************************************************************
Description:	FUNCTION find the Sequnce number of date
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	SELECT [dbo].[FUNC_Get_Seq_Day_of_month] (GETDATE())
History:		
**********************************************************************************************************************************************/
BEGIN
	
	
	DECLARE @FirstDayMonth INT
			,@LastDayMonth INT
			,@DayOfWeek INT
			,@ConvertedDay INT
			,@DateAdjust INT
			,@DayName Char(10)
			,@ActualDay INT
			,@Day_Sequence_of_month INT

	SELECT @ActualDay = DAY(@seq_date)
	SELECT @FirstDayMonth = DAY(DATEADD(dd, -DAY(@seq_date) + 1, @seq_date))
	SELECT @LastDayMonth = DAY(DATEADD(dd, -DAY(DATEADD(mm, 1, @seq_date)), DATEADD(mm, 1, @seq_date)))
	
	SELECT @DayOfWeek = DATEPART(WEEKDAY,DATEADD(dd, -DAY(@seq_date) + 1, @seq_date))

	SELECT @DayName =  DATENAME(WEEKDAY,DATEADD(dd, -DAY(@seq_date) + 1, @seq_date)) 

	SELECT @DateAdjust =  CASE DATENAME(WEEKDAY,DATEADD(dd, -DAY(@seq_date) + 1, @seq_date)) 
			WHEN 'Monday' Then 7
			WHEN 'Tuesday' Then 1
			WHEN 'Wednesday' Then 2
			WHEN 'Thursday' Then 3
			WHEN 'Friday' Then 4
			WHEN 'Saturday' Then 5
			WHEN 'Sunday' Then 6
	END	

	-- changed the sequence start number from 1 to 0 -- by prabakar on July 22nd

	IF ( (@ActualDay + @DateAdjust) / 7.0 ) <=1 
		SELECT @Day_Sequence_of_month = 0
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 1 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 2
		SELECT @Day_Sequence_of_month = 1
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 2 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 3
		SELECT @Day_Sequence_of_month = 2
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 3 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 4
		SELECT @Day_Sequence_of_month = 3
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 4 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 5
		SELECT @Day_Sequence_of_month = 4
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 5 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 6
		SELECT @Day_Sequence_of_month = 5
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 6 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 7
		SELECT @Day_Sequence_of_month = 6
	ELSE IF ( (@ActualDay + @DateAdjust) / 7.0 ) > 7 and ( (@ActualDay + @DateAdjust) / 7.0 ) <= 8
		SELECT @Day_Sequence_of_month = 7

	--SELECT @FirstDayMonth ,@LastDayMonth ,@DayOfWeek ,@DateAdjust,@DayName
	--SELECT @Day_Sequence_of_month AS 'Sequence Day of Month'
	RETURN @Day_Sequence_of_month
END 


  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Get_GL012T2_Date_Validation]')) Drop PROC [dbo].[PROC_Get_GL012T2_Date_Validation]
GO

CREATE PROC [dbo].[PROC_Get_GL012T2_Date_Validation]
(
	@bu_unit_list_filter						NVARCHAR(MAX) = NULL
	,@segment_1_list_filter						NVARCHAR(MAX) = NULL
	,@segment_2_list_filter						NVARCHAR(MAX) = NULL
	,@fiscal_period_list_filter					NVARCHAR(MAX) = NULL
	,@source_list_filter						NVARCHAR(MAX) = NULL
	,@preparer_list_filter						NVARCHAR(MAX) = NULL
	,@journal_type_list_filter					NVARCHAR(MAX) = NULL
	,@gl_account_list_filter					NVARCHAR(MAX) = NULL					

)
AS
/**********************************************************************************************************************************************
Description:	SP to prepare select * from VW_GL012T2_Date_Validation
Script Date:	03/06/2014
Created By:		MSH
Version:		1
Sample Command:	EXEC	[dbo].[PROC_Get_GL012T2_Date_Validation]	NULL,NULL,NULL,NULL,NULL,NULL,NULL
				
				EXEC	[dbo].[PROC_Get_GL012T2_Date_Validation]
										@bu_unit_list_filter = '0030 - RT Romania'
										,@segment_1_list_filter = 'EY_EMPTY - EY_EMPTY'
										,@segment_2_list_filter = 'AFABN - EY_UNKNOWN (AFABN)'
										,@fiscal_period_list_filter ='2013-007'
										,@source_list_filter = 'AF - Afschrijv.boekingen'
										,@preparer_list_filter = 'ERIK - Mostert ERIK'
										,@journal_type_list_filter = 'Manual|system'
History:		
V1				07/14/2014  	Prabakar		CREATED
************************************************************************************************************************************************/
BEGIN
	
	
	DECLARE @xmlObj				XML

	
	SET @bu_unit_list_filter				= REPLACE(REPLACE(REPLACE(@bu_unit_list_filter, '''', ''),		'[', ''),		']', '')
	SET @segment_1_list_filter				= REPLACE(REPLACE(REPLACE(@segment_1_list_filter, '''', ''),		'[', ''),		']', '')
	SET @segment_2_list_filter				= REPLACE(REPLACE(REPLACE(@segment_2_list_filter, '''', ''),			'[', ''),		']', '')
	SET @fiscal_period_list_filter			= REPLACE(REPLACE(REPLACE(@fiscal_period_list_filter, '''', ''),		'[', ''),		']', '')
	SET @source_list_filter					= REPLACE(REPLACE(REPLACE(@source_list_filter, '''', ''),				'[', ''),		']', '')
	SET @preparer_list_filter				= REPLACE(REPLACE(REPLACE(@preparer_list_filter, '''', ''),					'[', ''),		']', '')
	SET @journal_type_list_filter			= REPLACE(REPLACE(REPLACE(@journal_type_list_filter, '''', ''),					'[', ''),		']', '')
	SET @gl_account_list_filter			= REPLACE(REPLACE(REPLACE(@gl_account_list_filter, '''', ''),					'[', ''),		']', '')

	--TODO: replace below logic with preparing temp table from comma separated input xml

	--BU Unit
	DECLARE @bu_unit_table		TABLE(bu_ref NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@bu_unit_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @bu_unit_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS bu_ref 
	FROM				 @xmlObj.nodes('/A') AS x(t) 


	--Segment 1 
	DECLARE @segment_1_table		TABLE(segment_ref NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@segment_1_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @segment_1_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS segment_ref 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	--Segment 2 
	DECLARE @segment_2_table		TABLE(segment_ref NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@segment_2_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @segment_2_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS segment_ref 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	--fiscal period

	DECLARE @fiscal_period_table		TABLE(ey_fiscal_period NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@fiscal_period_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @fiscal_period_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS ey_fiscal_period 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	-- Source
	DECLARE @source_table		TABLE(source_ref NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@source_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @source_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS source_ref 
	FROM				 @xmlObj.nodes('/A') AS x(t)

	-- preparer 
	DECLARE @preparer_table		TABLE(preparer_ref NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@preparer_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @preparer_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS preparer_ref 
	FROM				 @xmlObj.nodes('/A') AS x(t)
	
	-- Journal type 
	DECLARE @journal_type_table		TABLE(journal_type NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@journal_type_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @journal_type_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS journal_type
	FROM				 @xmlObj.nodes('/A') AS x(t)

	-- gl account 
	DECLARE @gl_account_table		TABLE(gl_account NVARCHAR(256)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@gl_account_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @gl_account_table             
	SELECT				 DISTINCT	
						 t.value('.', 'NVARCHAR(256)')	AS gl_account
	FROM				 @xmlObj.nodes('/A') AS x(t)

	IF (SELECT COUNT(1) FROM @bu_unit_table					) = 0	INSERT INTO	@bu_unit_table					SELECT NULL
	IF (SELECT COUNT(1) FROM @segment_1_table				) = 0	INSERT INTO	@segment_1_table				SELECT NULL
	IF (SELECT COUNT(1) FROM @segment_2_table				) = 0	INSERT INTO	@segment_2_table				SELECT NULL
	IF (SELECT COUNT(1) FROM @fiscal_period_table			) = 0	INSERT INTO	@fiscal_period_table			SELECT NULL
	IF (SELECT COUNT(1) FROM @source_table					) = 0	INSERT INTO	@source_table					SELECT NULL	
	IF (SELECT COUNT(1) FROM @preparer_table				) = 0	INSERT INTO	@preparer_table					SELECT NULL	
	IF (SELECT COUNT(1) FROM @journal_type_table			) = 0	INSERT INTO	@journal_type_table				SELECT NULL	
	IF (SELECT COUNT(1) FROM @gl_account_table				) = 0	INSERT INTO	@gl_account_table				SELECT NULL	

		
	--select 'bu unit',* from @bu_unit_table
	--select 'segment 1',* from @segment_1_table
	--select 'segment 2',* from @segment_2_table
	--select 'fiscal period',* from @fiscal_period_table
	--select 'source',* from @source_table
	--select 'preparer',* from @preparer_table
	--select 'journal type', * from @journal_type_table

	
	SELECT [Coa Id]
		,[Year flag]
		,[Period flag]
		,[Accounting period]
		,[Accounting sub period]
		,[Fiscal period]
		,[Entry Date]
		,[Effective Date]
		,[Min Max Date]
		,[Category]
		,[Count of JE]
		,[Days Lag]
		,[Days Entry After Effective]
		,[Source]
		,[Source group]
		,[Preparer]
		,[Preparer department]
		,[Account Code]
		,[GL Account]
		,[Account Type]
		,[Account Sub Type]
		,[Account Class]
		,[Account Sub Class]
		,[Account Group]
		,[Business Unit]
		,[Business unit group]
		,[Journal Type]
		,[Segment 1]
		,[Segment 2]
		,[Segment 1 group]
		,[Segment 2 group]
		,[Approver department]
		,[Approver]
		,[Functional Currency Code]
		,[Reporting currency code]
		,[Net reporting amount]
		,[Net reporting amount credit]
		,[Net reporting amount debit]
		,[Net functional amount]
		,[Net functional amount credit]
		,[Net functional amount debit]
	FROM VW_GL012T2_Date_Validation DV
		INNER JOIN 	@bu_unit_table bu	ON ISNULL(bu.bu_ref, dv.[Business Unit]) = DV.[Business Unit]
		INNER JOIN @segment_1_table seg1 ON ISNULL(seg1.segment_ref, DV.[Segment 1] ) = DV.[Segment 1]
		INNER JOIN @segment_2_table seg2		ON ISNULL(seg2.segment_ref,dv.[Segment 2]) = dv.[Segment 2]
		INNER JOIN @fiscal_period_table f_prd	ON ISNULL(f_prd.ey_fiscal_period , DV.[Fiscal period]) = DV.[Fiscal period]
		INNER JOIN @source_table src ON ISNULL(src.source_ref , DV.Source)=DV.Source
		INNER JOIN @preparer_table prp ON ISNULL(prp.preparer_ref, DV.Preparer) = DV.Preparer
		INNER JOIN @journal_type_table jt ON ISNULL(jt.journal_type, DV.[Journal Type]) = dv.[Journal Type]
		INNER JOIN @gl_account_table gl ON ISNULL(gl.gl_account, DV.[GL Account]) = DV.[GL Account]
	
	
END
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Get_Journal_details_for_cashflow]')) Drop PROC [dbo].[PROC_Get_Journal_details_for_cashflow]
GO

CREATE PROC [dbo].[PROC_Get_Journal_details_for_cashflow]
(
	 @coa_id_list_for_criteria1			VARCHAR(MAX)
	,@coa_id_list_filter				VARCHAR(MAX)
	,@bu_id_list_filter					VARCHAR(MAX)
	,@ey_segment_id_01_list_filter		VARCHAR(MAX)
	,@ey_segment_id_02_list_filter		VARCHAR(MAX)
	,@period_id_list_filter				VARCHAR(MAX)
	,@source_id_list_filter				VARCHAR(MAX)
	,@ey_sys_manual_ind_list_filter		VARCHAR(MAX)
	,@entry_by_id_list_filter			VARCHAR(MAX)
)
AS
/**********************************************************************************************************************************************
Description:	SP to prepare je summary based on coa grouping (criteria 1 and 2); to be called from SP dynamically
Script Date:	02/06/2014
Created By:		MSH
Version:		1
Sample Command:	EXEC	[dbo].[PROC_Get_Journal_details_for_cashflow]		 @coa_id_list_for_criteria1			= '19206|5034|16270'
																			,@coa_id_list_filter				= '19206|5034'
																			,@bu_id_list_filter					= ''
																			,@ey_segment_id_01_list_filter		= ''
																			,@ey_segment_id_02_list_filter		= ''
																			,@period_id_list_filter				= ''
																			,@source_id_list_filter				= ''
																			,@ey_sys_manual_ind_list_filter		= ''
																			,@entry_by_id_list_filter			= ''
History:		
V1				02/06/2014  	MSH		CREATED
************************************************************************************************************************************************/
BEGIN
	
	--DECLARE @coa_id_list_for_criteria1		VARCHAR(MAX)
	--DECLARE @coa_id_list_filter				VARCHAR(4000)
	--DECLARE @bu_id_list_filter				VARCHAR(4000)
	--DECLARE @ey_segment_id_01_list_filter		VARCHAR(4000)
	--DECLARE @ey_segment_id_02_list_filter		VARCHAR(4000)
	--DECLARE @period_id_list_filter			VARCHAR(4000)
	--DECLARE @source_id_list_filter			VARCHAR(4000)
	--DECLARE @ey_sys_manual_ind_list_filter	VARCHAR(4000)
	--DECLARE @entry_by_id_list_filter			VARCHAR(4000)


	--SET @coa_id_list_for_criteria1 = '16024,11484,4191,6222,3808'
	--SET @coa_id_list_filter			 = 
	--SET @bu_id_list_filter			 = 
	--SET @ey_segment_id_01_list_filter	 = 
	--SET @ey_segment_id_02_list_filter	 = 
	--SET @period_id_list_filter		 = 
	--SET @source_id_list_filter		 = 
	--SET @ey_sys_manual_ind_list_filter = 
	--SET @entry_by_id_list_filter		 = 
	
	-- STEP #1: Prepare a temp table from the comma separated coa for criteria
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: Prepare a temp table from the comma separated coa for criteria ' + CONVERT(NVARCHAR, GETDATE(), 109)

	SET @coa_id_list_for_criteria1		= REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria1, '''', ''),		'[', ''),		']', '')
	SET @coa_id_list_filter				= NULLIF(REPLACE(REPLACE(REPLACE(@coa_id_list_filter			, '''', ''),		'[', ''),		']', '')	, '')	
	SET @bu_id_list_filter				= NULLIF(REPLACE(REPLACE(REPLACE(@bu_id_list_filter				, '''', ''),		'[', ''),		']', '')	, '')
	SET @ey_segment_id_01_list_filter	= NULLIF(REPLACE(REPLACE(REPLACE(@ey_segment_id_01_list_filter	, '''', ''),		'[', ''),		']', '')	, '')
	SET @ey_segment_id_02_list_filter	= NULLIF(REPLACE(REPLACE(REPLACE(@ey_segment_id_02_list_filter	, '''', ''),		'[', ''),		']', '')	, '')
	SET @period_id_list_filter			= NULLIF(REPLACE(REPLACE(REPLACE(@period_id_list_filter			, '''', ''),		'[', ''),		']', '')	, '')
	SET @source_id_list_filter			= NULLIF(REPLACE(REPLACE(REPLACE(@source_id_list_filter			, '''', ''),		'[', ''),		']', '')	, '')
	SET @ey_sys_manual_ind_list_filter	= NULLIF(REPLACE(REPLACE(REPLACE(@ey_sys_manual_ind_list_filter	, '''', ''),		'[', ''),		']', '')	, '')
	SET @entry_by_id_list_filter		= NULLIF(REPLACE(REPLACE(REPLACE(@entry_by_id_list_filter		, '''', ''),		'[', ''),		']', '')	, '')



	--TODO: replace below logic with preparing temp table from comma separated input xml

	DECLARE @coa_id_table		TABLE(coa_id INT) 
	DECLARE @xmlObj				XML  

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria1,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 


	DECLARE @coa_id_filter_table		TABLE(coa_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @bu_id_filter_table		TABLE(bu_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@bu_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @bu_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @ey_segment_id_01_filter_table		TABLE(segment_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@ey_segment_id_01_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @ey_segment_id_01_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @ey_segment_id_02_filter_table		TABLE(segment_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@ey_segment_id_02_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @ey_segment_id_02_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @period_id_filter_table		TABLE(period_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@period_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @period_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @source_id_filter_table		TABLE(source_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@source_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @source_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @entry_by_id_filter_table		TABLE(entry_by_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@entry_by_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @entry_by_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	DECLARE @ey_sys_manual_ind_filter_table		TABLE(ey_sys_manual_ind NVARCHAR(20)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@ey_sys_manual_ind_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @ey_sys_manual_ind_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'nvarchar(20)')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	IF (SELECT COUNT(1) FROM @coa_id_filter_table			) = 0	INSERT INTO	@coa_id_filter_table			SELECT NULL
	IF (SELECT COUNT(1) FROM @bu_id_filter_table			) = 0	INSERT INTO	@bu_id_filter_table				SELECT NULL
	IF (SELECT COUNT(1) FROM @ey_segment_id_01_filter_table	) = 0	INSERT INTO	@ey_segment_id_01_filter_table	SELECT NULL
	IF (SELECT COUNT(1) FROM @ey_segment_id_02_filter_table	) = 0	INSERT INTO	@ey_segment_id_02_filter_table	SELECT NULL
	IF (SELECT COUNT(1) FROM @period_id_filter_table		) = 0	INSERT INTO	@period_id_filter_table			SELECT NULL
	IF (SELECT COUNT(1) FROM @source_id_filter_table		) = 0	INSERT INTO	@source_id_filter_table			SELECT NULL
	IF (SELECT COUNT(1) FROM @ey_sys_manual_ind_filter_table) = 0	INSERT INTO	@ey_sys_manual_ind_filter_table	SELECT NULL
	IF (SELECT COUNT(1) FROM @entry_by_id_filter_table		) = 0	INSERT INTO	@entry_by_id_filter_table		SELECT NULL	

	-- STEP #2: Prepare summary of JE activity, opening and closing balances based on the coa ids (input) 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #2: Prepare summary of JE activity, opening and closing balances based on the coa ids (input)  ' + CONVERT(NVARCHAR, GETDATE(), 109)

	/*
	;WITH CASH_JE_CTE
	AS
	(
		SELECT
							 JE.je_id								AS	je_id

		FROM				 dbo.Ft_JE_Amounts JE --dbo.FLAT_JE JE --Journal_entries JE -- replaced cdm table with rdm table by prabakar on july 1st 
		INNER JOIN			 @coa_id_table CI						ON		JE.coa_id = CI.coa_id
		--WHERE				 JE.ver_end_date_id IS NULL
		GROUP BY
							 JE.je_id
	)
	,*/

	;WITH JE_AGG_CTE
	AS
	(
		SELECT
							 JE.je_id																									AS	je_id
							,SUM( CASE WHEN COA.ey_account_type = 'Assets'		THEN	ISNULL(JE.NET_reporting_amount,0)	ELSE 0  END )	AS	reporting_impact_to_assets
							,SUM( CASE WHEN COA.ey_account_type = 'Equity'		THEN	ISNULL(JE.NET_reporting_amount,0)	ELSE 0  END )	AS	reporting_impact_to_equity
							,SUM( CASE WHEN COA.ey_account_type = 'Expenses'	THEN	ISNULL(JE.NET_reporting_amount,0)	ELSE 0  END )	AS	reporting_impact_to_expenses
							,SUM( CASE WHEN COA.ey_account_type = 'Liabilities' THEN	ISNULL(JE.NET_reporting_amount,0)	ELSE 0  END )	AS	reporting_impact_to_liabilities 
							,SUM( CASE WHEN COA.ey_account_type = 'Revenue'		THEN	ISNULL(JE.NET_reporting_amount,0)	ELSE 0  END )	AS	reporting_impact_to_revenue 
							-- changed by prabakar to refer the correct rdm column on july 1st  begin
							--,SUM( CASE WHEN COA.ey_account_type = 'Assets'		THEN	ISNULL(JE.amount,0)				ELSE 0  END )	AS	functional_impact_to_assets
							--,SUM( CASE WHEN COA.ey_account_type = 'Equity'		THEN	ISNULL(JE.amount,0)				ELSE 0  END )	AS	functional_impact_to_equity
							--,SUM( CASE WHEN COA.ey_account_type = 'Liabilities' THEN	ISNULL(JE.amount,0)				ELSE 0  END )	AS	functional_impact_to_liabilities
							--,SUM( CASE WHEN COA.ey_account_type = 'Expenses'	THEN	ISNULL(JE.amount,0)				ELSE 0  END )	AS	functional_impact_to_expenses
							--,SUM( CASE WHEN COA.ey_account_type = 'Revenue'		THEN	ISNULL(JE.amount,0)				ELSE 0  END )	AS	functional_impact_to_revenue

							,SUM( CASE WHEN COA.ey_account_type = 'Assets'		THEN	ISNULL(JE.NET_functional_amount,0)				ELSE 0  END )	AS	functional_impact_to_assets
							,SUM( CASE WHEN COA.ey_account_type = 'Equity'		THEN	ISNULL(JE.NET_functional_amount,0)				ELSE 0  END )	AS	functional_impact_to_equity
							,SUM( CASE WHEN COA.ey_account_type = 'Liabilities' THEN	ISNULL(JE.NET_functional_amount,0)				ELSE 0  END )	AS	functional_impact_to_liabilities
							,SUM( CASE WHEN COA.ey_account_type = 'Expenses'	THEN	ISNULL(JE.NET_functional_amount,0)				ELSE 0  END )	AS	functional_impact_to_expenses
							,SUM( CASE WHEN COA.ey_account_type = 'Revenue'		THEN	ISNULL(JE.NET_functional_amount,0)				ELSE 0  END )	AS	functional_impact_to_revenue
							-- changed by prabakar to refer the correct rdm column on july 1st  end
		FROM				 dbo.Ft_JE_Amounts JE -- dbo.FLAT_JE JE --Journal_entries JE -- replaced cdm table with rdm table by prabakar on july 1st 
		--INNER JOIN			 CASH_JE_CTE CASH_JE					ON		JE.je_id = CASH_JE.je_id
		
		INNER JOIN			@coa_id_table CASH_JE	ON		JE.coa_id = CASH_JE.coa_id

		LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		JE.coa_id = COA.coa_id AND JE.bu_id = COA.bu_id
		--WHERE				 JE.ver_end_date_id IS NULL
		GROUP BY			 JE.je_id
	)
	SELECT
						 JE.je_id											AS		[Journal entry ID]
						,JE.je_line_id										AS		[Journal entry line ID]
						,JE.je_line_desc									AS		[Journal entry line description]
						,JE.coa_id											AS		[Chart of accounts ID]
						,COA.gl_account_cd									AS		[GL account code]
						,COA.gl_account_name								AS		[GL account name]
						,COA.ey_account_type								AS		[EY account type]
						,COA.ey_account_sub_type							AS		[EY account sub type]
						,COA.ey_account_class								AS		[EY account class]
						,COA.ey_account_sub_class							AS		[EY account sub class]
						,BU.bu_cd											AS		[Business unit code]
						,BU.bu_ref											AS		[Business unit reference]
						,BU.bu_group										AS		[BU group]
						,JE.period_id										AS		[Period ID]
						,FC.fiscal_period_cd								AS		[Fiscal period code]
						,UL.client_ref										AS		[Client reference]
						,UL.full_name										AS		[Full name]
						,ul.preparer_ref									AS		[Preparer] -- added by prabakar on july 2nd
						,UL.department										AS		[Department]
						,SL.source_cd										AS		[Source code]
						,SL.source_ref										AS		[Source reference]
						,SL.source_group									AS		[Source group]
						,SL1.segment_cd										AS		[Segment 1 code]
						,SL1.ey_segment_group								AS		[Segment 1 group]
						,SL2.segment_cd										AS		[Segment 2 code]
						,SL2.ey_segment_group								AS		[Segment 2 group]
						,SL1.ey_segment_ref									AS		[Segment 1]
						,SL2.ey_segment_ref								AS		[Segment 2]
						-- changed by prabakar to refer the correct rdm column on july 1st  begin
						--,JE.ey_sys_manual_ind								AS		[EY system manual indicator]
						--,CASE	WHEN JE.ey_sys_manual_ind	IN ('U','M') 
						--		THEN 'Manual'
						--		WHEN JE.ey_sys_manual_ind IN ('S') 
						--		THEN 'System' 
						-- END												AS		[Journal type]
						,JE.sys_manual_ind								AS		[EY system manual indicator]
						,je.journal_type 									AS		[Journal type]
						-- changed by prabakar to refer the correct rdm column on july 1st  end
						,PP.year_end_date									AS		[Year end date]
						,PP.year_flag_desc									AS		[Year flag description]
						,PP.end_date										AS		[period end date]
						,PP.period_flag_desc								AS		[period flag description]
						,GC_ENTRY.calendar_date								AS		[Entry date]
						,GC_EFFECT.calendar_date							AS		[Effective date]
																											
						--Swapped the column as in RDM ending balance is functional ending balance column by prabakar on july 1st
						--,JE.amount_curr_cd									AS		[Functional currency]
						--,JE.amount											AS		[Functional Amount]
						,JE.functional_curr_cd									AS		[Functional currency]
						,JE.functional_amount											AS		[Functional Amount]
						--Swapped the column as in RDM ending balance is functional ending balance column by prabakar on july 1st															
						--,JE.amount_curr_cd									AS		[Reporting currency]   -- commented by prabakar on Jun 25th since it has to refer the reporting currency code
						,JE.reporting_amount_curr_cd AS [Reporting currency]
						,JE.reporting_amount								AS		[Reporting Amount]

						,JE_AGG.reporting_impact_to_assets					AS		[Reporting Journal impact to assets]
						,JE_AGG.reporting_impact_to_equity					AS		[Reporting Journal impact to equity]
						,JE_AGG.reporting_impact_to_expenses				AS		[Reporting Journal impact to expenses]
						,JE_AGG.reporting_impact_to_liabilities 			AS		[Reporting Journal impact to liabilities]
						,JE_AGG.reporting_impact_to_revenue 				AS		[Reporting Journal impact to revenue]
						,JE_AGG.functional_impact_to_assets					AS		[Functional Journal impact to assets]
						,JE_AGG.functional_impact_to_equity					AS		[Functional Journal impact to equity]
						,JE_AGG.functional_impact_to_liabilities			AS		[Functional Journal impact to expenses]
						,JE_AGG.functional_impact_to_expenses				AS		[Functional Journal impact to liabilities]
						,JE_AGG.functional_impact_to_revenue				AS		[Functional Journal impact to revenue]
						
						,'Activity'											AS		[Source type]
						,NULL												AS		[Criteria]
						,NULL												AS		[Category]
						,NULL												AS		[Category2]

	FROM				  dbo.FLAT_JE JE --Journal_entries JE -- replaced cdm table with rdm table by prabakar on july 1st 
	INNER JOIN			 JE_AGG_CTE JE_AGG									ON		JE.je_id = JE_AGG.je_id
	INNER JOIN			 @coa_id_filter_table FILTER_COA					ON		ISNULL(FILTER_COA.coa_id, JE.coa_id) = JE.coa_id
	INNER JOIN			 @bu_id_filter_table FILTER_BU						ON		ISNULL(FILTER_BU.bu_id, JE.bu_id) = JE.bu_id
-- below table were replaced to refere the dynamic columns by prabakar on july 1st begin
	LEFT OUTER JOIN		dbo.v_Segment01_listing SL1							ON SL1.ey_segment_id =JE.segment1_id
	LEFT OUTER JOIN		dbo.v_Segment01_listing SL2							ON SL2.ey_segment_id =JE.segment2_id
	/*LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1					ON		JE.Segment01 = SL1.Segment01
																				OR	JE.Segment02 = SL1.Segment02
																				OR	JE.Segment03 = SL1.Segment03
																				OR	JE.Segment04 = SL1.Segment04
																				OR	JE.Segment05 = SL1.Segment05
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2					ON		JE.Segment01 = SL2.Segment01
																				OR	JE.Segment02 = SL2.Segment02
																				OR	JE.Segment03 = SL2.Segment03
																				OR	JE.Segment04 = SL2.Segment04
																				OR	JE.Segment05 = SL2.Segment05*/
-- below table were replaced to refere the dynamic columns by prabakar on july 1st end
	INNER JOIN			 @ey_segment_id_01_filter_table FILTER_SEG01		ON		COALESCE(FILTER_SEG01.segment_id, SL1.ey_segment_id, '') = ISNULL(SL1.ey_segment_id, '')
	INNER JOIN			 @ey_segment_id_02_filter_table FILTER_SEG02		ON		COALESCE(FILTER_SEG02.segment_id, SL2.ey_segment_id, '') = ISNULL(SL2.ey_segment_id, '')
	INNER JOIN			 @period_id_filter_table FILTER_PERIOD				ON		ISNULL(FILTER_PERIOD.period_id, JE.period_id) = JE.period_id
	INNER JOIN			 @source_id_filter_table FILTER_SOURCE				ON		ISNULL(FILTER_SOURCE.source_id, JE.source_id) = JE.source_id
-- changed by prabakar to refer the correct rdm column on july 1st  begin
	--INNER JOIN			 @ey_sys_manual_ind_filter_table FILTER_SYS_MAN		ON		ISNULL(FILTER_SYS_MAN.ey_sys_manual_ind, JE.ey_sys_manual_ind) = JE.ey_sys_manual_ind
	--INNER JOIN			 @entry_by_id_filter_table	FILTER_ENT				ON		ISNULL(FILTER_ENT.entry_by_id, JE.entry_by_id) = JE.entry_by_id
	--INNER JOIN			 @ey_sys_manual_ind_filter_table FILTER_SYS_MAN		ON		ISNULL(FILTER_SYS_MAN.ey_sys_manual_ind, JE.sys_manual_ind) = JE.sys_manual_ind
	INNER JOIN			 @ey_sys_manual_ind_filter_table FILTER_SYS_MAN		ON		ISNULL(FILTER_SYS_MAN.ey_sys_manual_ind, JE.journal_type) = JE.journal_type  -- Updated by prabakar on July 9 according to SF input
	INNER JOIN			 @entry_by_id_filter_table	FILTER_ENT				ON		ISNULL(FILTER_ENT.entry_by_id, JE.user_listing_id) = JE.user_listing_id 
	-- changed by prabakar to refer the correct rdm column on july 1st  end
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA					ON		JE.coa_id = COA.coa_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU					ON		JE.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC						ON		JE.period_id = FC.period_id
	-- changed by prabakar to refer the correct rdm column on july 1st  begin
	--LEFT OUTER JOIN		 [dbo].[v_User_listing] UL							ON		JE.entry_by_id = UL.user_listing_id
	LEFT OUTER JOIN		 [dbo].[v_User_listing] UL							ON		JE.user_listing_id = UL.user_listing_id
	-- changed by prabakar to refer the correct rdm column on july 1st  end
	LEFT OUTER JOIN		 [dbo].[v_User_listing] UL_APP						ON		JE.approved_by_id = UL_APP.user_listing_id
	LEFT OUTER JOIN		 [dbo].[v_Source_listing] SL						ON		JE.source_id = SL.source_id
	LEFT OUTER JOIN		 [dbo].[Gregorian_calendar] GC_ENTRY				ON		JE.entry_date_id = GC_ENTRY.date_id
	LEFT OUTER JOIN		 [dbo].[Gregorian_calendar] GC_EFFECT				ON		JE.effective_date_id = GC_EFFECT.date_id
	LEFT OUTER JOIN		 [dbo].[Parameters_period]PP						ON		FC.fiscal_year_cd = PP.fiscal_year_cd
							 													AND	FC.fiscal_period_seq BETWEEN PP.fiscal_period_seq_start AND PP.fiscal_period_seq_end
	WHERE				 JE.ver_end_date_id IS NULL
END  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Get_Journal_details_for_correlation]')) Drop PROC [dbo].[PROC_Get_Journal_details_for_correlation]
GO

CREATE PROC [dbo].[PROC_Get_Journal_details_for_correlation]
(
	 @coa_id_list_for_criteria1		VARCHAR(MAX)
	,@coa_id_list_for_criteria2		VARCHAR(MAX)
	,@coa_id_list_for_criteria3		VARCHAR(MAX)		=		NULL
	,@coa_id_list_filter			VARCHAR(MAX)
	,@period_id_list_filter			VARCHAR(MAX)
	,@category_filter				VARCHAR(MAX)
)
AS
/**********************************************************************************************************************************************
Description:	SP to prepare je details based on coa grouping (criteria 1 and 2); to be called from SP dynamically
Script Date:	03/06/2014
Created By:		MSH
Version:		1
Sample Command:	EXEC	[dbo].[PROC_Get_Journal_details_for_correlation]		 @coa_id_list_for_criteria1 = '6432|16024|3751'
																				,@coa_id_list_for_criteria2 = '3954|11484|14309|6222|14240'
																				,@coa_id_list_for_criteria3	= '19773'
																				,@coa_id_list_filter		= '16024|3954'
																				,@period_id_list_filter		= '4475'
																				,@category_filter			= 'B'
History:		
V1				03/06/2014  	MSH		CREATED
V2				19/08/2014		GSS		Changed Chart_of_accounts to corressponding view
************************************************************************************************************************************************/
BEGIN
	
	--DECLARE @coa_id_list_for_criteria1		VARCHAR(4000)
	--DECLARE @coa_id_list_for_criteria2		VARCHAR(4000)
	--DECLARE @coa_id_list_for_criteria3		VARCHAR(4000)
	--DECLARE @coa_id_list_filter				VARCHAR(4000)
	--DECLARE @period_id_list_filter			VARCHAR(1000)
	--DECLARE @category_filter					VARCHAR(50)
	
	--SET @coa_id_list_for_criteria1	= '6432,16024,3751'
	--SET @coa_id_list_for_criteria2	= '3954,11484,14309,6222,14240'
	--SET @coa_id_list_for_criteria3	= '19773'
	--SET @coa_id_list_filter			= '16024,3954'
	--SET @period_id_list_filter		= '4475'
	--SET @category_filter				= 'B'

	-- STEP #1: Prepare temp tables from the comma separated coa for criteria and filters
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: Prepare temp tables from the comma separated coa for criteria and filters ' + CONVERT(NVARCHAR, GETDATE(), 109)

	SET @coa_id_list_for_criteria1	= REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria1, '''', ''),		'[', ''),		']', '')
	SET @coa_id_list_for_criteria2	= REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria2, '''', ''),		'[', ''),		']', '')
	SET @coa_id_list_for_criteria3	= REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria3, '''', ''),		'[', ''),		']', '')
	SET @coa_id_list_filter			= REPLACE(REPLACE(REPLACE(@coa_id_list_filter, '''', ''),				'[', ''),		']', '')
	SET @period_id_list_filter		= REPLACE(REPLACE(REPLACE(@period_id_list_filter, '''', ''),			'[', ''),		']', '')
	SET @category_filter			= REPLACE(REPLACE(REPLACE(@category_filter, '''', ''),					'[', ''),		']', '')


	--select @category_filter
	--select @period_id_list_filter
	--select @coa_id_list_filter
	--select @coa_id_list_for_criteria3
	--select @coa_id_list_for_criteria2
	--select @coa_id_list_for_criteria1

	--TODO: replace below logic with preparing temp table from comma separated input xml

	DECLARE @coa_id_table		TABLE(coa_id INT, criteria INT) 
	DECLARE @xmlObj				XML  

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria1,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
						,1						AS criteria
	FROM				 @xmlObj.nodes('/A') AS x(t) 
	where t.value('.', 'varchar(10)')	not like '%Empty%' -- Added by prabakar to ignore value (Empty) on OCT 13 2014

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria2,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
						,2						AS criteria
	FROM				 @xmlObj.nodes('/A') AS x(t) 
	where t.value('.', 'varchar(10)')	not like '%Empty%' -- Added by prabakar to ignore value (Empty) on OCT 13 2014

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria3,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
						,3						AS criteria
	FROM				 @xmlObj.nodes('/A') AS x(t) 
	where t.value('.', 'varchar(10)')	not like '%Empty%' -- Added by prabakar to ignore value (Empty) on OCT 13 2014

	DECLARE @coa_id_filter_table		TABLE(coa_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 
	where t.value('.', 'varchar(10)')	not like '%Empty%' -- Added by prabakar to ignore value (Empty) on OCT 13 2014

	DECLARE @period_id_filter_table		TABLE(period_id INT) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@period_id_list_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @period_id_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 
	where t.value('.', 'varchar(10)')	not like '%Empty%' -- Added by prabakar to ignore value (Empty) on OCT 13 2014
	
	-- Added the below piece of code by prabakar on June 30 to store the multiple value cateogry into cateogry table. -- Begin
	-- Also i had included the replace condtion of 'AF' to 'A' as per the below business code. 
	DECLARE @category_filter_table		TABLE(category VARCHAR(8)) 
	SELECT @xmlObj = CAST('<A>'+ REPLACE(@category_filter,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @category_filter_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 replace(t.value('.', 'varchar(8)'),'AF','A')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 
	where t.value('.', 'varchar(10)')	not like '%Empty%'  -- Added by prabakar to ignore value (Empty) on OCT 13 2014
	-- Fix End - June 30 by prabakar

	-- STEP #2: Prepare summary of JE activity, opening and closing balances based on the coa criteria (input) and derived category - A(JE only in criteria 1), B(JE in both 1&2), B(JE only in 2)
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #2: Prepare summary of JE activity, opening and closing balances based on the coa criteria (input) and derived category - A(JE only in criteria 1), B(JE in both 1&2), B(JE only in 2) ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH JE_CATEGORY_CTE
	AS
	(
		SELECT
							 JE_AGG.je_id
							,CASE	WHEN	@coa_id_list_for_criteria3 IS NULL THEN
										CASE	WHEN MIN(CI.criteria) <> MAX(CI.criteria)	THEN	'B'
												WHEN MIN(CI.criteria) = 1					THEN	'A'
												WHEN MIN(CI.criteria) = 2					THEN	'C'
										END	
									ELSE
										CASE	ISNULL(CASE WHEN COUNT(CASE WHEN criteria=1 THEN 1 END) > 0 THEN 1 END, 0) +
												ISNULL(CASE WHEN COUNT(CASE WHEN criteria=2 THEN 1 END) > 0 THEN 10 END, 0) +
												ISNULL(CASE WHEN COUNT(CASE WHEN criteria=3 THEN 1 END) > 0 THEN 100 END, 0)
												WHEN	001	THEN	'A'
												WHEN	011	THEN	'B'
												WHEN	111	THEN	'C'
												WHEN	110 THEN	'D'
												WHEN	010 THEN	'E'
												WHEN	100 THEN	'F'
												WHEN	101 THEN	'AF'
										END
								END		AS category
								-- [Manish: 01 Aug]changed reporting & functional amount to net reporting & functional amount for query opt -- start
								,SUM( CASE WHEN COA.ey_account_type = 'Assets'		THEN	ISNULL(JE_AGG.Net_reporting_amount,0)	ELSE 0  END ) AS reporting_impact_to_assets
								,SUM( CASE WHEN COA.ey_account_type = 'Equity'		THEN	ISNULL(JE_AGG.Net_reporting_amount,0)	ELSE 0  END ) AS reporting_impact_to_equity
								,SUM( CASE WHEN COA.ey_account_type = 'Expenses'	THEN	ISNULL(JE_AGG.Net_reporting_amount,0)	ELSE 0  END ) AS reporting_impact_to_expenses
								,SUM( CASE WHEN COA.ey_account_type = 'Liabilities' THEN	ISNULL(JE_AGG.Net_reporting_amount,0)	ELSE 0  END ) AS reporting_impact_to_liabilities 
								,SUM( CASE WHEN COA.ey_account_type = 'Revenue'		THEN	ISNULL(JE_AGG.Net_reporting_amount,0)	ELSE 0  END ) AS reporting_impact_to_revenue 
								,SUM( CASE WHEN COA.ey_account_type = 'Assets'		THEN	ISNULL(JE_AGG.Net_functional_amount,0)				ELSE 0  END ) AS functional_impact_to_assets
								,SUM( CASE WHEN COA.ey_account_type = 'Equity'		THEN	ISNULL(JE_AGG.Net_functional_amount,0)				ELSE 0  END ) AS functional_impact_to_equity
								,SUM( CASE WHEN COA.ey_account_type = 'Liabilities' THEN	ISNULL(JE_AGG.Net_functional_amount,0)				ELSE 0  END ) AS functional_impact_to_liabilities
								,SUM( CASE WHEN COA.ey_account_type = 'Expenses'	THEN	ISNULL(JE_AGG.Net_functional_amount,0)				ELSE 0  END ) AS functional_impact_to_expenses
								,SUM( CASE WHEN COA.ey_account_type = 'Revenue'		THEN	ISNULL(JE_AGG.Net_functional_amount,0)				ELSE 0  END ) AS functional_impact_to_revenue
								-- [Manish: 01 Aug]changed reporting & functional amount to net reporting & functional amount for query opt -- start

		-- [Manish: 01 Aug] changed FLAT_JE with [Ft_JE_Amounts] for query opt -- start						
		FROM				[dbo].[Ft_JE_Amounts] JE_AGG --[dbo].[Journal_entries] JE_AGG  -- Added by prabakar to refer rdm on july 1st
		LEFT OUTER JOIN		 @coa_id_table CI					ON		JE_AGG.coa_id = CI.coa_id
		LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		JE_AGG.coa_id = COA.coa_id and JE_AGG.bu_id = coa.bu_id
		WHERE				 JE_AGG.year_flag = 'CY' 
		GROUP BY			 JE_AGG.je_id
		HAVING				 MIN(CI.criteria) IS NOT NULL	
		-- [Manish: 01 Aug] changed FLAT_JE with [Ft_JE_Amounts] for query opt -- end						
	)
	SELECT
						 JE.je_id									AS		[Journal entry ID]
						,JE.je_line_id								AS		[Journal entry line ID]
						,JE.je_line_desc							AS		[Journal entry line description]
						,JE.coa_id									AS		[Chart of accounts ID]
						,JE.gl_account_cd							AS		[GL account code]
						,JE.gl_account_name							AS		[GL account name]
						,JE.ey_account_type							AS		[EY account type]
						,JE.ey_account_sub_type						AS		[EY account sub type]
						,JE.ey_account_class						AS		[EY account class]
						,JE.ey_account_sub_class					AS		[EY account sub class]
						,BU.bu_cd									AS		[Business unit code]
						,BU.bu_ref									AS		[Business unit reference]
						,BU.bu_group								AS		[BU group]
						,JE.period_id								AS		[Period ID]
						,JE.fiscal_period_cd						AS		[Fiscal period code]
					
						,UL.preparer_ref						AS		[Client reference]
						,UL.department							AS		[Department]
						,UL.full_name							AS		[Full name]

						,SL.source_cd								AS		[Source code]
						,SL.source_ref								AS		[Source reference]
						,SL.source_group							AS		[Source group]
						,SL1.segment_cd								AS		[Segment 1 code]
						,SL1.ey_segment_group						AS		[Segment 1 group]
						,SL2.segment_cd								AS		[Segment 2 code]
						,SL2.ey_segment_group						AS		[Segment 2 group]
						,SL1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]
						
						--,JE.ey_sys_manual_ind						AS		[EY system manual indicator]
						,JE.sys_manual_ind							AS		[EY system manual indicator]
						

						,PP.year_end_date					AS		[Year end date]
						,PP.year_flag_desc					AS		[Year flag description]
						,PP.end_date						AS		[period end date]
						,PP.period_flag_desc				AS		[period flag description]


						,JE.Entry_Date								AS		[Entry date]
						,JE.Effective_Date							AS		[Effective date]
																									
						-- commented and mapped to the right column from cmd to rdm table by prabakar on june 26 begin
						--,JE.amount_curr_cd							AS		[Functional currency]
						--,JE.amount									AS		[Functional Amount]
						--,JE.amount_curr_cd							AS		[Reporting currency]
						,JE.functional_curr_cd							AS		[Functional currency]
						,JE.functional_amount									AS		[Functional Amount]
						,JE.reporting_amount_curr_cd							AS		[Reporting currency]
						-- commented and mapped to the right column from cmd to rdm table by prabakar on june 26 end
						,JE.reporting_amount						AS		[Reporting Amount]

						,JE_CATE.reporting_impact_to_assets			AS		[Reporting Journal impact to assets]
						,JE_CATE.reporting_impact_to_equity			AS		[Reporting Journal impact to equity]
						,JE_CATE.reporting_impact_to_expenses		AS		[Reporting Journal impact to expenses]
						,JE_CATE.reporting_impact_to_liabilities 	AS		[Reporting Journal impact to liabilities]
						,JE_CATE.reporting_impact_to_revenue 		AS		[Reporting Journal impact to revenue]
						,JE_CATE.functional_impact_to_assets		AS		[Functional Journal impact to assets]
						,JE_CATE.functional_impact_to_equity		AS		[Functional Journal impact to equity]
						,JE_CATE.functional_impact_to_liabilities	AS		[Functional Journal impact to expenses]
						,JE_CATE.functional_impact_to_expenses		AS		[Functional Journal impact to liabilities]
						,JE_CATE.functional_impact_to_revenue		AS		[Functional Journal impact to revenue]
						
						,'Activity'									AS		[Source type]
						,CI.criteria								AS		[Criteria]
						,JE_CATE.category							AS		[Category]
						,CASE	WHEN JE_CATE.category = 'AF'
							THEN	'A'
							ELSE	JE_CATE.category
						 END										AS		[Category2]
						 --Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref, Accounting period  etc -- Begin 
						,SL1.ey_segment_ref							AS		[Segment 1]
						,sl2.ey_segment_ref							AS		[Segment 2]
						,PP.year_flag								AS		[Year flag]
						,PP.period_flag								AS		[Period flg]

						,PP.year_flag_desc							AS		[Accounting period]
						,PP.period_flag_desc						AS		[Accounting sub period]
						,JE.fiscal_period_desc						AS		[Fiscal period]
						,SL.source_ref								AS		[Source]
						,je.journal_type							AS		[Journal type]
						,UL.department								AS		[Preparer department]
						,UL.preparer_ref							AS		[Preparer]
						--Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref etc -- end

	FROM				 dbo.FLAT_JE JE-- Journal_entries JE
	INNER JOIN			 JE_CATEGORY_CTE JE_CATE				ON		JE.je_id = JE_CATE.je_id
	-- Commented the category condition and joined with newly created category filter table to bring category matches. 
	-- Added  by prabakar on june 30  begin			--AND JE_CATE.category = @category_filter
	INNER JOIN 			 @category_filter_table CAT				ON 		JE_CATE.category = CAT.category 
	-- Added  by prabakar on june 30  end
	INNER JOIN			 @coa_id_filter_table COA_FILTER		ON		JE.coa_id = COA_FILTER.coa_id
	INNER JOIN			 @period_id_filter_table PERIOD_FILTER	ON		JE.period_id = PERIOD_FILTER.period_id
	LEFT OUTER JOIN		 @coa_id_table CI						ON		JE.coa_id = CI.coa_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		JE.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Source_listing] SL			ON		JE.source_id = SL.source_id
	LEFT OUTER JOIN		 dbo.v_Segment01_listing SL1 on sl1.ey_segment_id = je.segment1_id
	LEFT OUTER JOIN		 dbo.v_Segment02_listing SL2 on sl2.ey_segment_id = je.segment2_id
	LEFT OUTER JOIN		dbo.v_User_listing UL ON UL.user_listing_id = je.user_listing_id
	LEFT OUTER JOIN		dbo.Parameters_period PP ON PP.year_flag = JE.year_flag AND PP.period_flag = JE.period_flag
	WHERE				 JE.ver_end_date_id IS NULL 
		AND JE.year_flag ='CY' -- Added by prabakar on Aug 5


END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Get_Journal_summary_for_cashflow]')) Drop PROC [dbo].[PROC_Get_Journal_summary_for_cashflow]
GO

CREATE PROC [dbo].[PROC_Get_Journal_summary_for_cashflow]
(
	 @coa_id_list_for_criteria1		VARCHAR(MAX)
)
AS
/**********************************************************************************************************************************************
Description:	SP to prepare je summary based on coa grouping (criteria 1 and 2); to be called from SP dynamically
Script Date:	02/06/2014
Created By:		MSH
Version:		1
Sample Command:	EXEC	[dbo].[PROC_Get_Journal_summary_for_cashflow]		 @coa_id_list_for_criteria1 = '3808'
History:		
V2				20141017		MSH		HOTFIX - Updated to correctly pull the balances for RP, PRP AND SP periods
V1				02/06/2014  	MSH		CREATED
************************************************************************************************************************************************/
BEGIN
	
	--DECLARE @coa_id_list_for_criteria1		VARCHAR(MAX)
	
	--SET @coa_id_list_for_criteria1 = '16024,11484,4191,6222,3808'
	
	-- STEP #1: Prepare a temp table from the comma separated coa for criteria
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: Prepare a temp table from the comma separated coa for criteria ' + CONVERT(NVARCHAR, GETDATE(), 109)

	SET @coa_id_list_for_criteria1 = REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria1, '''', ''),		'[', ''),		']', '')


	--TODO: replace below logic with preparing temp table from comma separated input xml

	DECLARE @coa_id_table		TABLE(coa_id INT) 
	DECLARE @xmlObj				XML  

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria1,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT
						 t.value('.', 'int')	AS inVal 
	FROM				 @xmlObj.nodes('/A') AS x(t) 



	-- STEP #2: Prepare summary of JE activity, beginning and ending balances based on the coa ids (input) 
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #2: Prepare summary of JE activity, beginning and ending balances based on the coa ids (input)  ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH CASH_JE_CTE
	AS
	(
		SELECT
							 --Distinct 
							 JE.je_id								AS		je_id

		FROM				 dbo.Ft_JE_Amounts JE--dbo.FLAT_JE JE --Journal_entries JE  -- changed by prabakar to refer rdm table on July 1st
		INNER JOIN			 @coa_id_table CI						ON		JE.coa_id = CI.coa_id
		--WHERE				 JE.ver_end_date_id IS NULL
		GROUP BY			 JE.je_id
	)
	,JE_AGG_CTE
	AS
	(
		SELECT
							 JE.coa_id													AS		coa_id
							,JE.bu_id													AS		bu_id
							,JE.period_id												AS		period_id
							
							,JE.user_listing_id												AS		entry_by_id
							
							,JE.approved_by_id											AS		approved_by_id
							,JE.source_id												AS		source_id
							,JE.segment1_id										AS		ey_segment_id_01
							
							,JE.segment2_id										AS		ey_segment_id_02
							
							
							,JE.journal_type										AS		ey_sys_manual_ind
							,JE.functional_amount_curr_cd											AS		functional_amount_curr_cd
							,sum(JE.net_functional_amount)													AS		functional_amount
							,sum(JE.net_functional_debit_amount)											AS		functional_amount_debit
							,sum(JE.net_functional_credit_amount)									AS		functional_amount_credit

							
							,JE.reporting_amount_curr_cd											AS		reporting_amount_curr_cd 
							,sum(JE.net_reporting_amount)								AS		reporting_amount
							,sum(JE.net_reporting_amount_debit)							AS		reporting_amount_debit
							,sum(JE.net_reporting_amount_credit)							AS		reporting_amount_credit


							-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --begin
							--,JE.entry_by_id												AS		entry_by_id
							-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --end
							--,SL1.segment_cd												AS		segment_cd_01
							--,SL2.segment_cd												AS		segment_cd_02
							--,SL1.ey_segment_group									AS		ey_segment_group_01
							--,SL2.ey_segment_group									AS		ey_segment_group_02
							--,SL1.ey_segment_ref										as		ey_segment_ref_01
							--,SL2.ey_segment_ref										as		ey_segment_ref_02
							-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --begin
							-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --end

							/*Code commented and added by prabakar on Jun 25th - it should refer to reporting amount_curr_cd instead of amount curr_cd */
							--,JE.amount_curr_cd											AS		reporting_amount_curr_cd 

		FROM				  dbo.Ft_JE_Amounts JE --dbo.FLAT_JE JE --Journal_entries JE  -- changed by prabakar to refer rdm table on July 1st
		INNER JOIN			 CASH_JE_CTE CASH_JE					ON		JE.je_id = CASH_JE.je_id
		LEFT OUTER JOIN		 @coa_id_table CI						ON		JE.coa_id = CI.coa_id
		--LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		JE.coa_id = COA.coa_id
		--LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON		sl1.ey_segment_id = je.segment1_id
		--LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON		sl2.ey_segment_id = je.segment2_id
	
		WHERE				 
			--JE.ver_end_date_id IS NULL AND	 
			CI.coa_id IS NULL
		GROUP BY
							 JE.coa_id
							,JE.bu_id
							,JE.period_id
							-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --begin
							--,JE.entry_by_id
							,je.user_listing_id
							,JE.approved_by_id
							,JE.source_id
							--,SL1.segment_cd
							--,SL2.segment_cd
							--,JE.ey_sys_manual_ind
							--,JE.sys_manual_ind
							,je.journal_type
							--,JE.amount_curr_cd
							,je.functional_amount_curr_cd
							-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --end
							,JE.reporting_amount_curr_cd
							,JE.segment1_id
							,JE.segment2_id
							--,SL1.ey_segment_id										
							--,SL1.ey_segment_group									
							--,SL2.ey_segment_id										
							--,SL2.ey_segment_group
							--,sl1.ey_segment_ref
							--,sl2.ey_segment_ref									
	)

	
	SELECT
						 JE.coa_id											AS		[Chart of accounts ID]
						,COA.gl_account_cd									AS		[GL account code]
						,COA.gl_account_name								AS		[GL account name]
						,COA.ey_gl_account_name								AS		[EY GL account name]
						,COA.ey_account_group_I								AS		[Account group]
						,COA.ey_account_type								AS		[EY account type]
						,COA.ey_account_sub_type							AS		[EY account sub type]
						,COA.ey_account_class								AS		[EY account class]
						,COA.ey_account_sub_class							AS		[EY account sub class]
						,JE.bu_id											AS		[Business unit ID]
						,BU.bu_cd											AS		[Business unit code]
						,BU.bu_ref											AS		[Business unit reference]
						,BU.bu_group										AS		[BU group]
						,JE.period_id										AS		[Period ID]
						,FC.fiscal_period_cd								AS		[Fiscal period code]
						,JE.entry_by_id										AS		[Preparer ID]
						,UL.client_ref										AS		[Preparer client reference]
						,UL.full_name										AS		[Preparer full name]
						,UL.preparer_ref										AS		[Preparer] -- Added by prabakar on july 2nd
						,UL.department										AS		[Preparer department]
						,JE.approved_by_id									AS		[Approver ID]
						,UL_APP.client_ref									AS		[Approver client reference]
						,UL_APP.full_name									AS		[Approver full name]
						,UL_APP.preparer_ref										AS		[Approver] -- Added by prabakar on july 2nd
						,UL_APP.department									AS		[Approver department]
						,JE.source_id										AS		[Source ID]
						,SL.source_cd										AS		[Source code]
						,SL.source_ref										AS		[Source reference]
						,SL.source_group									AS		[Source group]
						,JE.ey_segment_id_01								AS		[Segment 1 ID]
						,JE.ey_segment_id_02								AS		[Segment 2 ID]

						,SL1.segment_cd									AS		[Segment 1 code]
						,SL1.ey_segment_group								AS		[Segment 1 group]
						,SL2.segment_cd									AS		[Segment 2 code]
						,SL2.ey_segment_group								AS		[Segment 2 group]
						,SL1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]


						,JE.ey_sys_manual_ind								AS		[EY system manual indicator]
						--,CASE	WHEN JE.ey_sys_manual_ind	IN ('U','M') 
						--		THEN 'Manual'
						--		WHEN JE.ey_sys_manual_ind IN ('S') 
						--		THEN 'System' 
						-- END												AS		[Journal type]
						,JE.ey_sys_manual_ind AS		[Journal type]
						,PP.year_end_date									AS		[Year end date]
						,PP.year_flag_desc									AS		[Year flag description]
						,PP.end_date										AS		[period end date]
						,PP.period_flag_desc								AS		[period flag description]
																					
						,functional_amount_curr_cd							AS		[Functional currency]
						,functional_amount									AS		[Functional Amount]
						,functional_amount_debit							AS		[Net functional amount debit]
						,functional_amount_credit							AS		[Net functional amount credit]
																					
						,reporting_amount_curr_cd							AS		[Reporting currency]
						,reporting_amount									AS		[Reporting Amount]
						,reporting_amount_debit								AS		[Net reporting amount debit]
						,reporting_amount_credit							AS		[Net reporting amount credit]
																											
						,'Activity'											AS		[Source type]

	FROM				 JE_AGG_CTE JE
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		JE.coa_id = COA.coa_id AND JE.bu_id = COA.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		JE.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		JE.period_id = FC.period_id
	LEFT OUTER JOIN		 [dbo].[v_User_listing] UL				ON		JE.entry_by_id = UL.user_listing_id
	LEFT OUTER JOIN		 [dbo].[v_User_listing] UL_APP			ON		JE.approved_by_id = UL_APP.user_listing_id
	LEFT OUTER JOIN		 [dbo].[v_Source_listing] SL			ON		JE.source_id = SL.source_id
	LEFT OUTER JOIN		 [dbo].[Parameters_period]PP			ON		FC.fiscal_year_cd = PP.fiscal_year_cd
							 										AND	FC.fiscal_period_seq BETWEEN PP.fiscal_period_seq_start AND PP.fiscal_period_seq_end
	LEFT OUTER JOIN		dbo.v_Segment01_listing SL1			ON SL1.ey_segment_id = je.ey_segment_id_01
	LEFT OUTER JOIN		dbo.v_Segment01_listing SL2			ON SL2.ey_segment_id = je.ey_segment_id_02

	UNION ALL
		SELECT
						TB.coa_id											AS		[Chart of accounts ID]
						,COA.gl_account_cd									AS		[GL account code]
						,COA.gl_account_name								AS		[GL account name]
						,COA.ey_gl_account_name								AS		[EY GL account name]
						,''													AS		[Account group]
						,''													AS		[EY account type]
						,'beginning balance'									AS		[EY account sub type]
						,''													AS		[EY account class]
						,''													AS		[EY account sub class]
						,TB.bu_id											AS		[Business unit ID]
						,BU.bu_cd											AS		[Business unit code]
						,BU.bu_ref											AS		[Business unit reference]
						,BU.bu_group										AS		[BU group]
						,NULL												AS		[Period ID]
						,FC.fiscal_period_cd								AS		[Fiscal period code]
						,0													AS		[Preparer ID]
						,'N/A for balances'									AS		[Preparer reference]
						,'N/A for balances'									AS		[Preparer full name]
						,'N/A for balances'										AS		[Preparer] -- Added by prabakar on july 2nd
						,'N/A for balances'									AS		[Preparer department]
						,0													AS		[Approver ID]
						,'N/A for balances'									AS		[Approver client reference]
						,'N/A for balances'									AS		[Approver full name]
						,'N/A for balances'										AS		[Approver] -- Added by prabakar on july 2nd
						,'N/A for balances'									AS		[Approver department]
						,0													AS		[Source ID]
						,'N/A for balances'									AS		[Source code]
						,'N/A for balances'									AS		[Source reference]
						,'N/A for balances'									AS		[Source group]
						,SL1.ey_segment_id									AS		[Segment 1 ID]
						,SL2.ey_segment_id									AS		[Segment 2 ID] -- Id column got swap to match the order. by prabakar on Aug 12
						,SL1.segment_cd										AS		[Segment 1 code]
						,SL1.ey_segment_group								AS		[Segment 1 group]
						
						,SL2.segment_cd										AS		[Segment 2 code]
						,SL2.ey_segment_group								AS		[Segment 2 group]
						,sl1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]
						,NULL												AS		[EY system manual indicator]
						,'N/A for balances'									AS		[Journal type]
						,PP.year_end_date									AS		[Year end date]
						,PP.year_flag_desc									AS		[Year flag description]
						,PP.end_date										AS		[period end date]
						,PP.period_flag_desc								AS		[period flag description]
						-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --begin																					
						--,TB.balance_curr_cd									AS		[Functional currency]
						--,TB.beginning_balance								AS		[Functional Amount]
						,TB.functional_curr_cd									AS		[Functional currency]
						,TB.functional_beginning_balance								AS		[Functional Amount]
						-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --end
						,0													AS		[Net functional amount debit]
						,0													AS		[Net functional amount credit]
																					
						,TB.reporting_curr_cd								AS		[Reporting currency]
						,TB.reporting_beginning_balance						AS		[Reporting Amount]
						,0													AS		[Net reporting amount debit]
						,0													AS		[Net reporting amount credit]
																					
						,'Beginning balance'								AS		[Source type]

	FROM				 [dbo].[Trialbalance] TB --[dbo].[Trial_balance] TB-- changed by prabakar to refer rdm table on July 1st
	INNER JOIN			 @coa_id_table CI						ON		TB.coa_id = CI.coa_id
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	INNER JOIN			 [dbo].[Parameters_period] PP			ON		FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag IN ('RP', 'PRP', 'SP')
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		TB.coa_id = COA.coa_id AND TB.bu_id =COA.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		TB.bu_id = BU.bu_id
	-- changed by prabakar to refer rdm table on July 1st begin
	LEFT OUTER JOIN		dbo.v_Segment01_listing		SL1			ON		TB.segment1_id = sl1.ey_segment_id
	LEFT OUTER JOIN		dbo.v_Segment02_listing		SL2			ON		TB.segment2_id = sl2.ey_segment_id

	/*LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON		TB.Segment01 = SL1.Segment01
																	OR	TB.Segment02 = SL1.Segment02
																	OR	TB.Segment03 = SL1.Segment03
																	OR	TB.Segment04 = SL1.Segment04
																	OR	TB.Segment05 = SL1.Segment05
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON		TB.Segment01 = SL2.Segment01
																	OR	TB.Segment02 = SL2.Segment02
																	OR	TB.Segment03 = SL2.Segment03
																	OR	TB.Segment04 = SL2.Segment04
																	OR	TB.Segment05 = SL2.Segment05*/
	-- changed by prabakar to refer rdm table on July 1st end

	WHERE				 TB.ver_end_date_id IS NULL

	-- DATE/ PERIOD CONDITION
	UNION ALL
	SELECT
						 TB.coa_id											AS		[Chart of accounts ID]
						,COA.gl_account_cd									AS		[GL account code]
						,COA.gl_account_name								AS		[GL account name]
						,COA.ey_gl_account_name								AS		[EY GL account name]
						,''													AS		[Account group]
						,''													AS		[EY account type]
						,'ending balance'									AS		[EY account sub type]
						,''													AS		[EY account class]
						,''													AS		[EY account sub class]
						,TB.bu_id											AS		[Business unit ID]
						,BU.bu_cd											AS		[Business unit code]
						,BU.bu_ref											AS		[Business unit reference]
						,BU.bu_group										AS		[BU group]
						,NULL												AS		[Period ID]
						,FC.fiscal_period_cd								AS		[Fiscal period code]
						,0													AS		[Preparer ID]
						,'N/A for balances'									AS		[Preparer reference]
						,'N/A for balances'									AS		[Preparer full name]
						,'N/A for balances'										AS		[Preparer] -- Added by prabakar on july 2nd
						,'N/A for balances'									AS		[Preparer department]
						,0													AS		[Approver ID]
						,'N/A for balances'									AS		[Approver client reference]
						,'N/A for balances'									AS		[Approver full name]
						,'N/A for balances'										AS		[Approver] -- Added by prabakar on july 2nd
						,'N/A for balances'									AS		[Approver department]
						,0													AS		[Source ID]
						,'N/A for balances'									AS		[Source code]
						,'N/A for balances'									AS		[Source reference]
						,'N/A for balances'									AS		[Source group]
						,SL1.ey_segment_id									AS		[Segment 1 ID]
						,SL2.ey_segment_id									AS		[Segment 2 ID] -- Id column got swap to match the order. by prabakar on Aug 12
						,SL1.segment_cd										AS		[Segment 1 code]
						,SL1.ey_segment_group								AS		[Segment 1 group]
						
						,SL2.segment_cd										AS		[Segment 2 code]
						,SL2.ey_segment_group								AS		[Segment 2 group]
						,sl1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]
						,NULL												AS		[EY system manual indicator]
						,'N/A for balances'									AS		[Journal type]
						,PP.year_end_date									AS		[Year end date]
						,PP.year_flag_desc									AS		[Year flag description]
						,PP.end_date										AS		[period end date]
						,PP.period_flag_desc								AS		[period flag description]
						-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --begin														
						--,TB.balance_curr_cd									AS		[Functional currency]
						--,TB.ending_balance									AS		[Functional Amount]
						,TB.functional_curr_cd									AS		[Functional currency]
						,TB.functional_ending_balance									AS		[Functional Amount]
						-- commented and added the below column to refer the correct rdm columns by prabakar on july 1st --end

						,0													AS		[Net functional amount debit]
						,0													AS		[Net functional amount credit]
																					
						,TB.reporting_curr_cd								AS		[Reporting currency]
						,TB.reporting_ending_balance						AS		[Reporting Amount]
						,0													AS		[Net reporting amount debit]
						,0													AS		[Net reporting amount credit]
																					
						,'Ending balance'									AS		[Source type]
	FROM				 [dbo].[Trialbalance] TB --[dbo].[Trial_balance] TB-- changed by prabakar to refer rdm table on July 1st
	INNER JOIN			 @coa_id_table CI						ON		TB.coa_id = CI.coa_id
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	INNER JOIN			 [dbo].[Parameters_period] PP			ON		FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag IN ('RP', 'PRP', 'SP')
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		TB.coa_id = COA.coa_id AND TB.bu_id = COA.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		TB.bu_id = BU.bu_id
	-- changed by prabakar to refer rdm table on July 1st begin
	LEFT OUTER JOIN		dbo.v_Segment01_listing		SL1			ON		TB.segment1_id = sl1.ey_segment_id
	LEFT OUTER JOIN		dbo.v_Segment02_listing		SL2			ON		TB.segment2_id = sl2.ey_segment_id

	/*LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON		TB.Segment01 = SL1.Segment01
																	OR	TB.Segment02 = SL1.Segment02
																	OR	TB.Segment03 = SL1.Segment03
																	OR	TB.Segment04 = SL1.Segment04
																	OR	TB.Segment05 = SL1.Segment05
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON		TB.Segment01 = SL2.Segment01
																	OR	TB.Segment02 = SL2.Segment02
																	OR	TB.Segment03 = SL2.Segment03
																	OR	TB.Segment04 = SL2.Segment04
																	OR	TB.Segment05 = SL2.Segment05*/
	-- changed by prabakar to refer rdm table on July 1st end

	WHERE				 TB.ver_end_date_id IS NULL
	
END

-------------------------------------------------------------------------------------------------------------
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Get_Journal_summary_for_correlation]')) Drop PROC [dbo].[PROC_Get_Journal_summary_for_correlation]
GO

CREATE PROC [dbo].[PROC_Get_Journal_summary_for_correlation]
(
	 @coa_id_list_for_criteria1		VARCHAR(MAX)
	,@coa_id_list_for_criteria2		VARCHAR(MAX)
	,@coa_id_list_for_criteria3		VARCHAR(MAX)		=		NULL
)
AS
/**********************************************************************************************************************************************
Description:	SP to prepare je summary based on coa grouping (criteria 1 and 2); to be called from SP dynamically
Script Date:	02/06/2014
Created By:		MSH
Version:		1
Sample Command:	EXEC	[dbo].[PROC_Get_Journal_summary_for_correlation]		 @coa_id_list_for_criteria1 = '3808'
																				,@coa_id_list_for_criteria2 = '16129'
																				,@coa_id_list_for_criteria3 = '19773'
History:		
V2				20141010		MSH		beginning and ending balances should be pulled based on RP period rather than CY year
V1				02/06/2014  	MSH		Created
************************************************************************************************************************************************/
BEGIN
	
	--DECLARE @coa_id_list_for_criteria1		VARCHAR(MAX)
	--DECLARE @coa_id_list_for_criteria2		VARCHAR(MAX)
	--DECLARE @coa_id_list_for_criteria3		VARCHAR(MAX)
	
	--SET @coa_id_list_for_criteria1 = '16024,11484,4191,6222,3808'
	--SET @coa_id_list_for_criteria2 = '3812,19756,6432,4303,16129'
	--SET @coa_id_list_for_criteria3 = '19773'
	
	-- STEP #1: Prepare a temp table from the comma separated coa for criteria
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #1: Prepare a temp table from the comma separated coa for criteria ' + CONVERT(NVARCHAR, GETDATE(), 109)

	SET @coa_id_list_for_criteria1 = REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria1, '''', ''),		'[', ''),		']', '')
	SET @coa_id_list_for_criteria2 = REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria2, '''', ''),		'[', ''),		']', '')
	SET @coa_id_list_for_criteria3 = REPLACE(REPLACE(REPLACE(@coa_id_list_for_criteria3, '''', ''),		'[', ''),		']', '')


	--TODO: replace below logic with preparing temp table from comma separated input xml

	DECLARE @coa_id_table		TABLE(coa_id INT, criteria INT) 
	DECLARE @xmlObj				XML  

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria1,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
						,1						AS criteria
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria2,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
						,2						AS criteria
	FROM				 @xmlObj.nodes('/A') AS x(t) 

	SELECT @xmlObj = CAST('<A>'+ REPLACE(@coa_id_list_for_criteria3,'|','</A><A>')+ '</A>' AS XML) 

	INSERT INTO			 @coa_id_table             
	SELECT				 DISTINCT											--[MANISH - 20140707]: DISTINCT added to avoid duplicacy of data in resultset
						 t.value('.', 'int')	AS inVal 
						,3						AS criteria
	FROM				 @xmlObj.nodes('/A') AS x(t) 


	-- STEP #2: Prepare summary of JE activity, opening and closing balances based on the coa criteria (input) and derived category - A(JE only in criteria 1), B(JE in both 1&2), B(JE only in 2)
	----------------------------------------------------------------------------------------------------------------------- 
	print 'STEP #2: Prepare summary of JE activity, opening and closing balances based on the coa criteria (input) and derived category - A(JE only in criteria 1), B(JE in both 1&2), B(JE only in 2) ' + CONVERT(NVARCHAR, GETDATE(), 109)


	;WITH CATEGORY_SETUP_CTE
	AS
	(
		SELECT 'A' category, 'A' category2	UNION ALL
		SELECT 'B' category, 'B' category2	UNION ALL
		SELECT 'C' category, 'C' category2	UNION ALL
		SELECT 'C' category, 'B' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL UNION ALL
		SELECT 'C' category, 'D' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL UNION ALL
		SELECT 'D' category, 'D' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL UNION ALL
		SELECT 'E' category, 'E' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL UNION ALL
		SELECT 'F' category, 'F' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL UNION ALL
		SELECT 'AF' category, 'A' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL UNION ALL
		SELECT 'AF' category, 'F' category2	WHERE @coa_id_list_for_criteria3 IS NOT NULL 
	)
	,JE_CATEGORY_CTE
	AS
	(
		SELECT
							 JE_AGG.je_id
							,CASE	WHEN	@coa_id_list_for_criteria3 IS NULL THEN
										CASE	WHEN MIN(CI.criteria) <> MAX(CI.criteria)	THEN	'B'
												WHEN MIN(CI.criteria) = 1					THEN	'A'
												WHEN MIN(CI.criteria) = 2					THEN	'C'
										END	
									ELSE
										CASE	ISNULL(CASE WHEN COUNT(CASE WHEN CI.criteria=1 THEN 1 END) > 0 THEN 1 END, 0) +
												ISNULL(CASE WHEN COUNT(CASE WHEN CI.criteria=2 THEN 1 END) > 0 THEN 10 END, 0) +
												ISNULL(CASE WHEN COUNT(CASE WHEN CI.criteria=3 THEN 1 END) > 0 THEN 100 END, 0)
												WHEN	001	THEN	'A'
												WHEN	011	THEN	'B'
												WHEN	111	THEN	'C'
												WHEN	110 THEN	'D'
												WHEN	010 THEN	'E'
												WHEN	100 THEN	'F'
												WHEN	101 THEN	'AF'
										END
								END		AS category
						
		FROM				 [dbo].[Ft_JE_Amounts] JE_AGG --[dbo].[Journal_entries] JE_AGG  -- changed the cdm to rdm table by prabakar on july 1st		-- [MANISH 30/07]: FLAT_JE TO Ft_JE_Amounts
		
		--INNER JOIN			 v_Fiscal_calendar FC				ON		JE_AGG.period_id = FC.period_id
		--INNER JOIN			 Parameters_period PP				ON		FC.fiscal_year_cd = PP.fiscal_year_cd
		--					 										AND	FC.fiscal_period_seq BETWEEN PP.fiscal_period_seq_start AND PP.fiscal_period_seq_end
		--															AND PP.year_flag = 'CY'

		LEFT OUTER JOIN		 @coa_id_table CI					ON		JE_AGG.coa_id = CI.coa_id 
		WHERE				 CI.criteria IS NOT NULL	-- Added by prabakar to filter out Criteria not null	
							AND JE_AGG.year_flag = 'CY'		-- removed the existing condition on Fiscal Calendar and Parameter period and added condition directly to FT_JE_AMOUNT																				-- [MANISH 31/07]: FILTERD UNREQUIRED JEs
		GROUP BY			 JE_AGG.je_id
	)
	,JE_AGG_CTE
	AS
	(
		SELECT
							 JE.coa_id								AS		coa_id
							,JE.bu_id								AS		bu_id
							,JE.period_id							AS		period_id
							,JE.user_listing_id							AS		entry_by_id
							,JE.source_id							AS		source_id
							
							,JE.sys_manual_ind					AS		ey_sys_manual_ind
							,je.Journal_type					AS Journal_type
							,JE_CATE.category						AS		category
							,JE.functional_amount_curr_cd						AS		functional_amount_curr_cd										-- [MANISH 30/07]: FLAT_JE TO Ft_JE_Amounts
							,JE.reporting_amount_curr_cd						AS		reporting_amount_curr_cd							
							,SUM(JE.Net_reporting_amount)				AS		reporting_amount	
							,SUM(JE.Net_functional_amount)						AS		functional_amount												-- [MANISH 30/07]: FLAT_JE TO Ft_JE_Amounts
							,JE.segment1_id		as [segment1_id]
							,JE.segment2_id		as [segment2_id]
																				 
							--,SL1.ey_segment_ref							AS		[Segment_1_ref]
							--,SL2.ey_segment_ref							AS		[Segment_2_ref]
							--,SL1.segment_cd							AS		segment_cd_01
							--,SL1.ey_segment_group				AS		ey_segment_group_01
							--,SL2.segment_cd							AS		segment_cd_02
							--,SL2.ey_segment_group				AS		ey_segment_group_02


							--,JE.entry_by_id							AS		entry_by_id
							--commented and added the right column from RDM table by prabakar July 1st begin
							--,JE.amount_curr_cd						AS		functional_amount_curr_cd
							--,SUM(JE.amount)							AS		functional_amount
							--,JE.amount_curr_cd						AS		reporting_amount_curr_cd
							--commented and added the right column from RDM table by prabakar July 1st end
							--,JE.ey_sys_manual_ind					AS		ey_sys_manual_ind
							--,MAX(SL1.ey_segment_group)				AS		ey_segment_group_01
							--,MAX(SL2.ey_segment_group)				AS		ey_segment_group_02

		FROM				 [dbo].[Ft_JE_Amounts] JE --[dbo].[Journal_entries] JE  -- changed the cdm to rdm table by prabakar on july 1st				 -- [MANISH 30/07]: FLAT_JE TO Ft_JE_Amounts
		INNER JOIN			 JE_CATEGORY_CTE JE_CATE				ON		JE.je_id = JE_CATE.je_id
																		AND	JE_CATE.category IS NOT NULL				-- to restrict records with NULL category in resultset
		WHERE JE.year_flag = 'CY'  -- Added by prabakar to filter only Current year on Aug 5th

		/*
		LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON	JE.segment1_id = sl1.ey_segment_id	 --commented and added the right column from RDM table by prabakar july 1st end
																		--JE.Segment01 = SL1.Segment01
																		--OR	JE.Segment02 = SL1.Segment02
																		--OR	JE.Segment03 = SL1.Segment03
																		--OR	JE.Segment04 = SL1.Segment04
																		--OR	JE.Segment05 = SL1.Segment05
		LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON	JE.segment2_id = sl2.ey_segment_id	--commented and added the right column from RDM table by prabakar july 1st end
																		--JE.Segment01 = SL2.Segment01
																		--OR	JE.Segment02 = SL2.Segment02
																		--OR	JE.Segment03 = SL2.Segment03
																		--OR	JE.Segment04 = SL2.Segment04
																		--OR	JE.Segment05 = SL2.Segment05
																		*/
		--where JE.ver_end_date_id is null -- Added by prabakar to pull the latest version of records on july 2nd
		GROUP BY																																		  -- [MANISH 30/07]: FLAT_JE TO Ft_JE_Amounts
							 JE.coa_id
							,JE.bu_id
							,JE.period_id
							,je.user_listing_id
							,JE.source_id
							,je.sys_manual_ind
							,JE.Journal_type
							,JE_CATE.category
							,JE.functional_amount_curr_cd--commented and added the right column from RDM table by prabakar july 1st							-- [MANISH 30/07]: FLAT_JE TO Ft_JE_Amounts
							,JE.reporting_amount_curr_cd
							,je.segment1_id
							,je.segment2_id
							--,SL1.segment_cd
							--,SL2.segment_cd
							--,SL1.ey_segment_ref
							--,SL2.ey_segment_ref
							--,SL1.ey_segment_group
							--,SL2.ey_segment_group

							--,JE.entry_by_id  --commented and added the right column from RDM table by prabakar july 1st
							--,JE.ey_sys_manual_ind --commented and added the right column from RDM table by prabakar july 1st
	)

	--Removed to avoid taking time by prabakar on aug 5th
	--,COA_CTE
	--AS
	--(
	--	SELECT
	--			DISTINCT	 JE.coa_id
	--	FROM				 JE_AGG_CTE JE
	--)
	SELECT
						 JE.coa_id								AS		[Chart of accounts ID]
						,COA.gl_account_cd						AS		[GL account code]
						,COA.gl_account_name					AS		[GL account name]
						,COA.ey_gl_account_name					AS		[EY GL account name]
						,COA.ey_account_type					AS		[EY account type]
						,COA.ey_account_sub_type				AS		[EY account sub type]
						,COA.ey_account_class					AS		[EY account class]
						,COA.ey_account_sub_class				AS		[EY account sub class]
						,BU.bu_cd								AS		[Business unit code]
						,BU.bu_ref								AS		[Business unit reference]
						,BU.bu_group							AS		[BU group]
						,JE.period_id							AS		[Period ID]
						,FC.fiscal_period_cd					AS		[Fiscal period code]
						,UL.client_ref							AS		[Client reference]
						,UL.full_name							AS		[Full name]
						,UL.department							AS		[Department]
						,SL.source_cd							AS		[Source code]
						,SL.source_ref							AS		[Source reference]
						,SL.source_group						AS		[Source group]
						,SL1.segment_cd						AS		[Segment 1 code]
						,SL1.ey_segment_group					AS		[Segment 1 group]
						,SL1.segment_cd						AS		[Segment 2 code]
						,SL1.ey_segment_group					AS		[Segment 2 group]
						,JE.ey_sys_manual_ind					AS		[EY system manual indicator]
						,PP.year_end_date						AS		[Year end date]
						,PP.year_flag_desc						AS		[Year flag description]
						,PP.end_date							AS		[period end date]
						,PP.period_flag_desc					AS		[period flag description]
																		
						,functional_amount_curr_cd				AS		[Functional currency]
						,functional_amount						AS		[Functional Amount]
																		
						,reporting_amount_curr_cd				AS		[Reporting currency]
						,reporting_amount						AS		[Reporting Amount]
																		
						,'Activity'								AS		[Source type]
						,CI.criteria							AS		[Criteria]
						,JE.category							AS		[Category]
						,CATE_SETUP.category2					AS		[Category2]
						 --Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref, Accounting period etc -- Begin 
						,SL1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]
						,PP.year_flag								AS		[Year flag]
						,PP.period_flag								AS		[Period flag]

						,CASE WHEN PP.year_flag = 'CY' THEN 'Current'	
								WHEN PP.year_flag = 'PY' THEN 'Prior'
								WHEN PP.year_flag = 'SP' THEN 'Subsequent'
								ELSE PP.year_flag_desc 
							END										AS		[Accounting period]
						,PP.period_flag_desc						AS		[Accounting sub period]
						,fc.fiscal_period_desc 						AS		[Fiscal period]
						,SL.source_ref								AS		[Source]
						--,CASE WHEN je.ey_sys_manual_ind	IN ('U','M') THEN 'Manual'
						--		WHEN je.ey_sys_manual_ind IN ('S') THEN 'System' END	AS		[Journal type]
						,JE.Journal_type AS		[Journal type]
						,UL.department								AS		[Preparer department]
						,UL.client_ref								AS		[Preparer]
						,BU.bu_ref									AS		[Business unit]
						,BU.bu_group								AS		[Business unit group]
						--Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref -- end
	FROM				 JE_AGG_CTE JE
	INNER JOIN			 CATEGORY_SETUP_CTE CATE_SETUP			ON		JE.category = CATE_SETUP.category		-- Will create duplocate rows per defined setup in CTE
	LEFT OUTER JOIN		 @coa_id_table CI						ON		JE.coa_id = CI.coa_id
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		JE.coa_id = COA.coa_id AND JE.bu_id = coa.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		JE.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		JE.period_id = FC.period_id
	LEFT OUTER JOIN		 [dbo].[v_User_listing] UL				ON		JE.entry_by_id = UL.user_listing_id
	LEFT OUTER JOIN		 [dbo].[v_Source_listing] SL			ON		JE.source_id = SL.source_id
	LEFT OUTER JOIN		 [dbo].[Parameters_period]PP			ON		FC.fiscal_year_cd = PP.fiscal_year_cd
							 										AND	FC.fiscal_period_seq BETWEEN PP.fiscal_period_seq_start AND PP.fiscal_period_seq_end
	
	LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON	JE.segment1_id = sl1.ey_segment_id
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON	JE.segment2_id = SL2.ey_segment_id
	--WHERE				 CI.criteria IS NOT NULL -- ADDED BY PRABAKAR

	UNION ALL
	SELECT
						TB.coa_id								AS		[Chart of accounts ID]
						,COA.gl_account_cd						AS		[GL account code]
						,COA.gl_account_name					AS		[GL account name]
						,COA.ey_gl_account_name					AS		[EY GL account name]
						,COA.ey_account_type					AS		[EY account type]
						,COA.ey_account_sub_type				AS		[EY account sub type]
						,COA.ey_account_class					AS		[EY account class]
						,COA.ey_account_sub_class				AS		[EY account sub class]
						,BU.bu_cd								AS		[Business unit code]
						,BU.bu_ref								AS		[Business unit reference]
						,BU.bu_group							AS		[BU group]
						,NULL									AS		[Period ID]
						,NULL									AS		[Fiscal period code]
						,NULL									AS		[Client reference]
						,NULL									AS		[Full name]
						,NULL									AS		[Department]
						,NULL									AS		[Source code]
						,NULL									AS		[Source reference]
						,NULL									AS		[Source group]
						,SL1.segment_cd							AS		[Segment 1 code]
						,SL1.ey_segment_group					AS		[Segment 1 group]
						,SL2.segment_cd							AS		[Segment 2 code]
						,SL2.ey_segment_group					AS		[Segment 2 group]
						,NULL									AS		[EY system manual indicator]
						,PP.year_end_date						AS		[Year end date]
						,PP.year_flag_desc						AS		[Year flag description]
						,PP.end_date							AS		[period end date]
						,PP.period_flag_desc					AS		[period flag description]
																								
						--commented and added the right column from RDM table by prabakar june 26 begin																			
						--,TB.balance_curr_cd						AS		[Functional currency]
						--,TB.beginning_balance					AS		[Functional Amount]
						,TB.functional_curr_cd						AS		[Functional currency]
						,TB.functional_beginning_balance			AS		[Functional Amount]
						--commented and added the right column from RDM table by prabakar june 26 end		
																		
						,TB.reporting_curr_cd					AS		[Reporting currency]
						,TB.reporting_beginning_balance			AS		[Reporting Amount]
																		
						,'Beginning balance'					AS		[Source type]
						,CI.criteria							AS		[Criteria]
						,NULL									AS		[Category]
						,NULL									AS		[Category2]
						 --Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref, Accounting period -- Begin 
						,SL1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]
						,PP.year_flag								AS		[Year flag]
						,PP.period_flag								AS		[Period flag]

						,CASE WHEN PP.year_flag = 'CY' THEN 'Current'	
								WHEN PP.year_flag = 'PY' THEN 'Prior'
								WHEN PP.year_flag = 'SP' THEN 'Subsequent'
								ELSE PP.year_flag_desc 
							END										AS		[Accounting period]
						,PP.period_flag_desc						AS		[Accounting sub period]
						,fc.fiscal_period_desc 						AS		[Fiscal period]
						,NULL										AS		[Source]
						,NULL											AS		[Journal type]
						,NULL										AS		[Preparer department]
						,NULL										AS		[Preparer]
						,BU.bu_ref									AS		[Business unit]
						,BU.bu_group								AS		[Business unit group]
						--Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref -- end
	FROM				dbo.TrialBalance TB --[dbo].[Trial_balance] TB -- changed the cdm to rdm table by prabakar on july 1st
	LEFT OUTER JOIN		 @coa_id_table CI						ON		TB.coa_id = CI.coa_id 
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	INNER JOIN			 [dbo].[Parameters_period] PP			ON		FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag = 'RP'
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		TB.coa_id = COA.coa_id --and tb.bu_id = coa.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		TB.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON	TB.segment1_id = sl1.ey_segment_id	 --commented and added the right column from RDM table by prabakar july 1st end	
																	--TB.Segment01 = SL1.Segment01
																	--OR	TB.Segment02 = SL1.Segment02
																	--OR	TB.Segment03 = SL1.Segment03
																	--OR	TB.Segment04 = SL1.Segment04
																	--OR	TB.Segment05 = SL1.Segment05
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON	TB.segment2_id = sl2.ey_segment_id	 --commented and added the right column from RDM table by prabakar july 1st end	
																	--TB.Segment01 = SL2.Segment01
																	--OR	TB.Segment02 = SL2.Segment02
																	--OR	TB.Segment03 = SL2.Segment03
																	--OR	TB.Segment04 = SL2.Segment04
																	--OR	TB.Segment05 = SL2.Segment05

	WHERE	TB.ver_end_date_id IS NULL
			AND	 TB.coa_id IN																	
						 (
							SELECT coa_id FROM JE_AGG_CTE where bu_id = tb.bu_id --COA_CTE 
						 )

	--AND CI.criteria IS NOT NULL -- ADDED BY PRABAKAR -- to restrict records with NULL category in resultset
	-- DATE/ PERIOD CONDITION
	UNION ALL
	SELECT
						 TB.coa_id								AS		[Chart of accounts ID]
						,COA.gl_account_cd						AS		[GL account code]
						,COA.gl_account_name					AS		[GL account name]
						,COA.ey_gl_account_name					AS		[EY GL account name]
						,COA.ey_account_type					AS		[EY account type]
						,COA.ey_account_sub_type				AS		[EY account sub type]
						,COA.ey_account_class					AS		[EY account class]
						,COA.ey_account_sub_class				AS		[EY account sub class]
						,BU.bu_cd								AS		[Business unit code]
						,BU.bu_ref								AS		[Business unit reference]
						,BU.bu_group							AS		[BU group]
						,NULL									AS		[Period ID]
						,NULL									AS		[Fiscal period code]
						,NULL									AS		[Client reference]
						,NULL									AS		[Full name]
						,NULL									AS		[Department]
						,NULL									AS		[Source code]
						,NULL									AS		[Source reference]
						,NULL									AS		[Source group]
						,SL1.segment_cd							AS		[Segment 1 code]
						,SL1.ey_segment_group					AS		[Segment 1 group]
						,SL2.segment_cd							AS		[Segment 2 code]
						,SL2.ey_segment_group					AS		[Segment 2 group]
						,NULL									AS		[EY system manual indicator]
						,PP.year_end_date						AS		[Year end date]
						,PP.year_flag_desc						AS		[Year flag description]
						,PP.end_date							AS		[period end date]
						,PP.period_flag_desc					AS		[period flag description]
																		
						--commented and added the right column from RDM table by prabakar june 26 begin																			
						--,TB.balance_curr_cd						AS		[Functional currency]
						--,TB.ending_balance					AS		[Functional Amount]
						,TB.functional_curr_cd						AS		[Functional currency]
						,TB.functional_ending_balance			AS		[Functional Amount]
						--commented and added the right column from RDM table by prabakar june 26 end		
																		
						,TB.reporting_curr_cd					AS		[Reporting currency]
						,TB.reporting_ending_balance			AS		[Reporting Amount]
																		
						,'Ending balance'						AS		[Source type]
						,CI.criteria							AS		[Criteria]
						,NULL									AS		[Category]
						,NULL									AS		[Category2]
						--Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref, Accounting period -- Begin 
						,SL1.ey_segment_ref							AS		[Segment 1]
						,SL2.ey_segment_ref							AS		[Segment 2]
						,PP.year_flag								AS		[Year flag]
						,PP.period_flag								AS		[Period flag]

						,CASE WHEN PP.year_flag = 'CY' THEN 'Current'	
								WHEN PP.year_flag = 'PY' THEN 'Prior'
								WHEN PP.year_flag = 'SP' THEN 'Subsequent'
								ELSE PP.year_flag_desc 
							END										AS		[Accounting period]
						,PP.period_flag_desc						AS		[Accounting sub period]
						,fc.fiscal_period_desc 						AS		[Fiscal period]
						,NULL										AS		[Source]
						,NULL											AS		[Journal type]
						,NULL										AS		[Preparer department]
						,NULL										AS		[Preparer]
						,BU.bu_ref									AS		[Business unit]
						,BU.bu_group								AS		[Business unit group]
						--Code Added by Prabakar on 1st July to bring the the global filter of Segment_ref -- end
	FROM				 dbo.TrialBalance TB --[dbo].[Trial_balance] TB -- changed the cdm to rdm table by prabakar on july 1st
		
	LEFT OUTER JOIN		 @coa_id_table CI						ON		TB.coa_id = CI.coa_id
	LEFT OUTER JOIN		 [dbo].[v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	INNER JOIN			 [dbo].[Parameters_period] PP			ON		FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag = 'RP'
	LEFT OUTER JOIN		 [dbo].[v_Chart_of_accounts] COA		ON		TB.coa_id = COA.coa_id and tb.bu_id = coa.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Business_Unit_listing] BU		ON		TB.bu_id = BU.bu_id
	LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON	TB.segment1_id = sl1.ey_segment_id	 --commented and added the right column from RDM table by prabakar july 1st end	
																	--TB.Segment01 = SL1.Segment01
																	--OR	TB.Segment02 = SL1.Segment02
																	--OR	TB.Segment03 = SL1.Segment03
																	--OR	TB.Segment04 = SL1.Segment04
																	--OR	TB.Segment05 = SL1.Segment05
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON	TB.segment2_id = sl2.ey_segment_id	 --commented and added the right column from RDM table by prabakar july 1st end	
																	--TB.Segment01 = SL2.Segment01
																	--OR	TB.Segment02 = SL2.Segment02
																	--OR	TB.Segment03 = SL2.Segment03
																	--OR	TB.Segment04 = SL2.Segment04
																	--OR	TB.Segment05 = SL2.Segment05
	WHERE	TB.ver_end_date_id IS NULL
			AND	 TB.coa_id IN																	-- to restrict records with NULL category in resultset
						 (
							SELECT coa_id FROM JE_AGG_CTE --COA_CTE 
							where bu_id = tb.bu_id
						 )
					

END

-------------------------------------------------------------------------------------------------------------
----QUERY TO FIND COA ID, PERIOD ID TO USE FOR CRIETRIA AND FILTERS
--SELECT * FROM journal_entries where je_id IN
--(
--	SELECT 
--	je_id
--	--,COUNT(DISTINCT coa_id)
--	FROM journal_entries 
--	where effective_date_id between 20130101 and 20131231
--	GROUP BY je_id
--	HAVING COUNT(DISTINCT coa_id) > 1
--)
--ORDER BY je_id  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_FT_GL_Account]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_FT_GL_Account]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_FT_GL_Account] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [FT_GL_Account]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_FT_GL_Account] 
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table FT_GL_Account and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE dbo.FT_GL_Account

	--INSERT INTO DBO.Agg_GL_Account 
	INSERT INTO dbo.FT_GL_Account
	(
		coa_id
		,period_id
		,bu_id
		,source_id
		,segment1_id
		,segment2_id
		,user_listing_id
		,approved_by_id
		--,account_type
		--,account_sub_type
		--,account_class
		--,account_sub_class
		--,gl_account_cd
		--,gl_account_name
		--,ey_gl_account_name
		--,ey_account_group_I
		--,ey_account_group_II
		,ey_period
		,year_flag
		,period_flag
		--,year_flag_desc
		--,period_flag_desc
		,dr_cr_ind
		,reversal_ind
		,sys_man_ind
		,journal_type
		,entry_date_id
		,effective_date_id
		--,preparer_ref
		--,preparer_department
		--,approver_ref
		--,approver_department
		,amount_curr_cd
		,reporting_amount_curr_cd
		,functional_curr_cd
		,net_amount
		,net_amount_debit
		,net_amount_credit
		,net_reporting_amount
		,net_reporting_amount_debit
		,net_reporting_amount_credit
		,net_functional_amount
		,net_functional_amount_debit
		,net_functional_amount_credit	
		,count_je_id	
	)
	SELECT 
		FT_JE.coa_id
		,FT_JE.period_id
		,FT_JE.bu_id
		,FT_JE.source_id
		,FT_JE.segment1_id
		,FT_JE.segment2_id
		,FT_JE.user_listing_id
		,FT_JE.approved_by_id

		--,ca.ey_account_type
		--,ca.ey_account_sub_type
		--,ca.ey_account_class
		--,ca.ey_account_sub_class
		--,ca.gl_account_cd
		--,ca.gl_account_name
		--,ca.ey_gl_account_name
		--,ca.ey_account_group_I
		--,ca.ey_account_group_II
		
		,FT_JE.ey_period
		,FT_JE.year_flag
		,FT_JE.period_flag
		
		--,CASE WHEN FT_JE.year_flag = 'CY' THEN 'Current'
		--	WHEN FT_JE.year_flag = 'PY' THEN 'Prior'
		--	WHEN FT_JE.year_flag = 'SP' THEN 'Subsequent'
		--	ELSE PP.year_flag_desc 
		--END AS year_flag_desc
		--,PP.period_flag_desc
		,FT_JE.dr_cr_ind
		,FT_JE.reversal_ind --ft_je.Rev_nr_ind
		,ft_je.sys_manual_ind--FT_JE.sys_man_ind
		,ft_je.journal_type 	
		,FT_JE.entry_date_id
		,FT_JE.effective_date_id

		--,DP.Preparer_Ref
		--,DP.department
		
		--,DPA.Preparer_Ref
		--,DPA.department
		
		,FT_JE.amount_curr_cd
		,FT_JE.reporting_amount_curr_cd
		,FT_JE.functional_amount_curr_cd --,FT_JE.functional_curr_cd
		--,Net_local_amount
		--,Net_local_amount_debit
		--,Net_local_amount_credit
		,SUM(FT_JE.Net_amount)
		,SUM(FT_JE.Net_amount_debit)
		,SUM(FT_JE.Net_amount_credit)
		,SUM(FT_JE.Net_reporting_amount)
		,SUM(FT_JE.Net_reporting_amount_debit)
		,SUM(FT_JE.Net_reporting_amount_credit)
		,SUM(FT_JE.Net_functional_amount)
		,SUM(FT_JE.Net_functional_debit_amount)
		,SUM(FT_JE.Net_functional_credit_amount)
		,sum(count_je_id)
	FROM	[dbo].Ft_JE_Amounts FT_JE
		
		--INNER JOIN [dbo].[DIM_Chart_of_Accounts] CA ON CA.coa_id	= FT_JE.Coa_id
		--LEFT OUTER JOIN [dbo].[Dim_Preparer] DP ON DP.user_listing_id  = FT_JE.user_listing_id
		--LEFT OUTER JOIN [dbo].[Dim_Preparer] DPA ON dpa.user_listing_id	= ft_je.approved_by_id
		--INNER JOIN [dbo].Parameters_period pp ON pp.period_flag	= ft_je.period_flag AND pp.year_flag	= 	FT_JE.year_flag	
		 
	GROUP BY
		FT_JE.coa_id
		,FT_JE.period_id
		,FT_JE.bu_id
		,FT_JE.source_id
		,FT_JE.segment1_id
		,FT_JE.segment2_id
		,FT_JE.user_listing_id
		,FT_JE.approved_by_id

		--,ca.ey_account_type
		--,ca.ey_account_sub_type
		--,ca.ey_account_class
		--,ca.ey_account_sub_class
		--,ca.gl_account_cd
		--,ca.gl_account_name
		--,ca.ey_gl_account_name
		--,ca.ey_account_group_I
		--,ca.ey_account_group_II

		,FT_JE.ey_period
		,FT_JE.year_flag
		,FT_JE.period_flag
		--,PP.year_flag_desc
		--,PP.period_flag_desc
		,FT_JE.dr_cr_ind
		,FT_JE.reversal_ind
		,ft_je.sys_manual_ind
		,ft_je.journal_type 	
		,FT_JE.entry_date_id
		,FT_JE.effective_date_id

		--,DP.Preparer_Ref
		--,DP.department
		
		--,DPA.Preparer_Ref
		--,DPA.department
		
		,FT_JE.amount_curr_cd
		,FT_JE.reporting_amount_curr_cd
		,FT_JE.functional_amount_curr_cd 

END  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PROC_Refresh_Data_GL012_Date_Analysis')) Drop PROC dbo.PROC_Refresh_Data_GL012_Date_Analysis
GO

CREATE PROCEDURE dbo.PROC_Refresh_Data_GL012_Date_Analysis
AS 
/**********************************************************************************************************************************************
Description:	PROC to insert into table GL_012_Date_Analysis
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC dbo.PROC_Refresh_Data_GL012_Date_Analysis
************************************************************************************************************************************************/
BEGIN

		TRUNCATE TABLE dbo.GL_012_Date_Analysis

		INSERT INTO dbo.GL_012_Date_Analysis
		(
			Je_Id
			,Je_Line_Id
			,Account_Code
			,GL_Account
			,Account_Class
			,Fiscal_period
			,Year_flag
			,Period_flag
			,Bu_id
			,Segment1_id
			,Segment2_id
			,Source_id
			,User_listing_id
			,Approver_by_id
			,Journal_type
			,Adjusted_fiscal_period
			,Day_number_of_week
			,Day_Of_Week
			,Day_of_month
			,Calendar_date
			,Sequence_number
			,Reporting_currency_code
			,Functional_Currency_Code
			,Net_reporting_amount
			,Net_reporting_amount_credit
			,Net_reporting_amount_debit
			,Net_functional_amount
			,Net_functional_amount_debit
			,Net_functional_amount_credit
			,Net_Amount
			,Net_Amount_Credit
			,Net_Amount_Debit
		)

	SELECT
		FJ.je_id
		,FJ.je_line_id
		,FJ.gl_account_cd
		,FJ.ey_gl_account_name
		,FJ.ey_account_class
		,FJ.EY_period
		,FJ.year_flag
		,FJ.period_flag
		,FJ.bu_id
		,FJ.segment1_id
		,FJ.segment2_id
		,FJ.Source_id
		,FJ.User_listing_id
		,FJ.approved_by_id
		,FJ.journal_type
		,(	SELECT top 1 fc1.fiscal_period_cd 
			FROM dbo.v_Fiscal_calendar FC1 
			WHERE FJ.bu_id = FC1.bu_id 
				AND FJ.ENTRY_DATE BETWEEN FC1.fiscal_period_start AND FC1.fiscal_period_end
		) AS [Adjusted_fiscal_period]
		,FJ.day_number_of_week
		,FJ.Day_of_week
		,FJ.day_number_of_month
		,cd.Calendar_date
		,cd.Sequence
		,FJ.reporting_amount_curr_cd
		,FJ.functional_curr_cd
		,SUM(FJ.reporting_amount) AS Net_reporting_amount
		,SUM(FJ.reporting_amount_credit) AS Net_reporting_amount_credit
		,SUM(FJ.reporting_amount_debit)   AS Net_reporting_amount_debit
		,SUM(FJ.functional_amount)  AS Net_functional_amount
		,SUM(FJ.functional_debit_amount)  AS Net_functional_amount_debit
		,SUM(FJ.functional_credit_amount) AS Net_functional_amount_credit
		,0 as Amount
		,0 as Amount_Credit
		,0 as Amount_Debit

	FROM dbo.FLAT_JE FJ INNER JOIN dbo.DIM_Calendar_seq_date cd ON fj.Entry_Date = cd.Calendar_date  --ON fj.Effective_Date = cd.Calendar_date -- changed from Effective(month) to entry (week) by prabakar on july 17
		INNER JOIN v_Fiscal_calendar FC ON FC.period_id = FJ.period_id AND FJ.bu_id = FC.bu_id
	WHERE FJ.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	GROUP BY 
		FJ.je_id
		,FJ.je_line_id
		,FJ.gl_account_cd
		,FJ.ey_gl_account_name
		,FJ.ey_account_class
		,FJ.EY_period
		,FJ.year_flag
		,FJ.period_flag
		,FJ.bu_id
		,FJ.segment1_id
		,FJ.segment2_id
		,FJ.Source_id
		,FJ.User_listing_id
		,FJ.approved_by_id
		,FJ.journal_type
		,FJ.ENTRY_DATE
		,FJ.day_number_of_week
		,FJ.Day_of_week
		,FJ.day_number_of_month
		,cd.Calendar_date
		,cd.Sequence
		,FJ.reporting_amount_curr_cd
		,FJ.functional_curr_cd
END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL012_Date_Validation]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL012_Date_Validation]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL012_Date_Validation] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL_012_Date_Validation]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL012_Date_Validation]
History:		
************************************************************************************************************************************************/
BEGIN

	TRUNCATE TABLE dbo.GL_012_Date_Validation 

	INSERT INTO  dbo.GL_012_Date_Validation 
	(
		coa_id
		,bu_id
		,segment1_id
		,segment2_id
		,source_id
		,user_listing_id
		,approver_by_id
		,year_flag
		,period_flag
		,ey_period
		,entry_date
		,Effective_date 
		,min_max_ent_eff_date 
		,category
		,je_id_count
		,days_lag
		,sys_manual_ind
		,journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
		,functional_curr_cd
		,reporting_amount_curr_cd
		,net_reporting_amount
		,net_reporting_amount_credit
		,net_reporting_amount_debit
		,net_functional_amount
		,net_functional_credit_amount
		,net_functional_debit_amount
		,net_amount 
		,net_amount_credit
		,net_amount_debit
		--,year_flag_desc
		--,period_flag_desc
		--,bu_ref
		--,bu_group
		--,segment1_group
		--,segment2_group
		--,segment1_ref
		--,segment2_ref
		--,preparer_ref
		--,preparer_department
		--,approver_department
		--,approver_ref
		--,gl_account_cd 
		--,ey_gl_account_name
		--,account_type
		--,account_sub_type
		--,ey_account_class
		--,account_sub_class
		--,ey_account_group_I
		--,max_effective_entry_diff
		--,source_ref 
		--,source_group
	)

	(	
		SELECT 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			,F.[ey_period] 
			--,F.[entry_date_id] 
			--,F.[effective_date_id] 
			--,min(F.[entry_date_id])
			,CONVERT (datetime,convert(varchar(24),f.entry_date_id),121)  
			,CONVERT (datetime,convert(varchar(24),f.effective_date_id),121)  
			,MIN(CONVERT (datetime,convert(varchar(24),f.entry_date_id),121)  )
			,'Min Entry Date' Category
			,SUM(F.COUNT_JE_ID) 
			 
			--,max(f.Lag_Date)
			,max(DATEDIFF(DAY,EntCal.calendar_date,EffCal.calendar_date) )AS Lag_Date
			
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			,sum(f.NET_reporting_amount)
			,sum(f.NET_reporting_amount_credit)
			,sum(f.NET_reporting_amount_debit)
			,sum(f.NET_functional_amount)
			,sum(f.NET_functional_amount_credit)
			,sum(f.NET_functional_amount_debit)
			,sum(F.[NET_amount]) 
			,sum(F.[NET_amount_credit]) 
			,sum(F.[NET_amount_debit])
			--,f.year_flag_desc
			--,CASE	WHEN f.year_flag ='CY' THEN 'Current'
			--	WHEN f.year_flag ='PY' THEN 'Prior'
			--	WHEN f.year_flag ='SP' THEN 'Subsequent'
			--	ELSE pp.year_flag_desc 
			--	END 
			--,pp.period_flag_desc
			--,ul.[preparer_ref]
			--,ul.department
			--,coa.gl_account_cd 
			--,coa.ey_gl_account_name
			--,coa.ey_account_type
			--,coa.ey_account_sub_type
			--,coa.ey_account_class
			--,coa.ey_account_sub_class
			--,coa.ey_account_group_I
			--,AUL.department
			--,AUL.preparer_ref
			--,DATEDIFF(day, max(F.[effective_date]), max(F.[entry_date])) 'Max Entry - Effective'
		FROM dbo.FT_GL_Account F --dbo.FLAT_JE F
			INNER JOIN DBO.Gregorian_calendar EntCal ON f.entry_date_id = EntCal.date_id
			INNER JOIN DBO.Gregorian_calendar EffCal ON f.effective_date_id = EffCal.date_id
			
			--INNER JOIN dbo.v_Chart_of_accounts COA on coa.coa_id = F.coa_id
			--LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
			
			--LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
			--LEFT OUTER JOIN dbo.v_User_listing aul on aul.user_listing_id = f.approved_by_id
		--WHERE f.ver_end_date_id IS NULL  -- Added by prabakar to bring latest version records only -- on July 2nd

		GROUP BY 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			,F.[ey_period] 
			,F.[entry_date_id] 
			,F.[effective_date_id] 
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			
			--,PP.year_flag_desc
			--,PP.period_flag_desc
			--,UL.[preparer_ref]
			--,UL.department
			--,COA.gl_account_cd 
			--,COA.ey_gl_account_name
			--,COA.ey_account_type
			--,COA.ey_account_sub_type
			--,COA.ey_account_class
			--,COA.ey_account_sub_class
			--,COA.ey_account_group_I
			--,AUL.department
			--,AUL.preparer_ref

		UNION 

		SELECT 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			,F.[ey_period] 
			
			--,F.[entry_date_id] 
			--,F.[effective_date_id] 
			--,max(F.[entry_date_id])

			,CONVERT (datetime,convert(varchar(24),f.entry_date_id),121)  
			,CONVERT (datetime,convert(varchar(24),f.effective_date_id),121)  
			,MAX(CONVERT (datetime,convert(varchar(24),f.entry_date_id),121)  )
			,'Max Entry Date' Category
			,SUM(F.[COUNT_JE_ID]) 
			
			--,max(f.Lag_Date)
			,max(DATEDIFF(DAY,EntCal.calendar_date,EffCal.calendar_date) )AS Lag_Date
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			,sum(f.NET_reporting_amount)
			,sum(f.NET_reporting_amount_credit)
			,sum(f.NET_reporting_amount_debit)
			,sum(f.NET_functional_amount)
			,sum(f.NET_functional_amount_credit)
			,sum(f.NET_functional_amount_debit)
			,sum(F.[NET_amount]) 
			,sum(F.[NET_amount_credit]) 
			,sum(F.[net_amount_debit]) 
			--,PP.year_flag_desc
			--,PP.period_flag_desc
			--,ul.[preparer_ref]
			--,UL.department
			--,coa.gl_account_cd 
			--,coa.ey_gl_account_name
			--,coa.ey_account_type
			--,coa.ey_account_sub_type
			--,coa.ey_account_class
			--,coa.ey_account_sub_class
			--,coa.ey_account_group_I
			--,aul.department
			--,aul.preparer_ref
		FROM dbo.FT_GL_Account F --dbo.FLAT_JE F
			INNER JOIN DBO.Gregorian_calendar EntCal ON f.entry_date_id = EntCal.date_id
			INNER JOIN DBO.Gregorian_calendar EffCal ON f.effective_date_id = EffCal.date_id
			--INNER JOIN dbo.v_Chart_of_accounts COA on coa.coa_id = F.coa_id
			--LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
			--LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
			--LEFT OUTER JOIN dbo.v_User_listing aul on aul.user_listing_id = f.approved_by_id
		--WHERE f.ver_end_date_id IS NULL  -- Added by prabakar to bring latest version records only -- on July 2nd
		GROUP BY 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			
			,F.[ey_period] 
			,F.[entry_date_id] 
			,F.[effective_date_id] 
			
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			--,pp.year_flag_desc
			--,pp.period_flag_desc
			--,ul.[preparer_ref]
			--,ul.department
			--,coa.gl_account_cd 
			--,coa.ey_gl_account_name
			--,coa.ey_account_type
			--,coa.ey_account_sub_type
			--,coa.ey_account_class
			--,coa.ey_account_sub_class
			--,coa.ey_account_group_I
			--,aul.department
			--,aul.preparer_ref
		UNION

		SELECT 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			,F.[ey_period] 
			--,F.[entry_date_id] 
			--,F.[effective_date_id] 
			--,min(F.[effective_date_id])

			,CONVERT (datetime,convert(varchar(24),f.entry_date_id),121)  
			,CONVERT (datetime,convert(varchar(24),f.effective_date_id),121)  
			,MIN(CONVERT (datetime,convert(varchar(24),f.effective_date_id),121)  )

			,'Min Effective Date' Category
			,sum(F.count_je_id) 
			
			--,max(f.Lag_Date)
			,max(DATEDIFF(DAY,EntCal.calendar_date,EffCal.calendar_date) )AS Lag_Date
			--,DATEDIFF(day, max(F.[effective_date]), max(F.[entry_date])) 'Max Entry - Effective'
			
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			,sum(f.net_reporting_amount)
			,sum(f.net_reporting_amount_credit)
			,sum(f.net_reporting_amount_debit)
			,sum(f.net_functional_amount)
			,sum(f.net_functional_amount_credit)
			,sum(f.net_functional_amount_debit)
			,sum(F.[net_amount]) 
			,sum(F.[net_amount_credit]) 
			,sum(F.[net_amount_debit])
			--,pp.year_flag_desc
			--,pp.period_flag_desc
			--,ul.[preparer_ref]
			--,ul.department
			--,coa.gl_account_cd 
			--,coa.ey_gl_account_name
			--,coa.ey_account_type
			--,coa.ey_account_sub_type
			--,coa.ey_account_class
			--,coa.ey_account_sub_class
			--,coa.ey_account_group_I
			--,aul.department
			--,aul.preparer_ref			
			
		FROM dbo.FT_GL_Account F --dbo.FLAT_JE F
			INNER JOIN DBO.Gregorian_calendar EntCal ON f.entry_date_id = EntCal.date_id
			INNER JOIN DBO.Gregorian_calendar EffCal ON f.effective_date_id = EffCal.date_id
			--INNER JOIN dbo.v_Chart_of_accounts COA on coa.coa_id = F.coa_id
			--LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
			--LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
			--LEFT OUTER JOIN dbo.v_User_listing aul on aul.user_listing_id = f.approved_by_id
		--WHERE f.ver_end_date_id IS NULL  -- Added by prabakar to bring latest version records only -- on July 2nd
		GROUP BY 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			
			,F.[ey_period] 
			,F.[entry_date_id] 
			,F.[effective_date_id] 
			
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			
			--,pp.year_flag_desc
			--,pp.period_flag_desc
			--,UL.[preparer_ref]
			--,UL.department
			--,coa.gl_account_cd 
			--,coa.ey_gl_account_name
			--,coa.ey_account_type
			--,coa.ey_account_sub_type
			--,coa.ey_account_class
			--,coa.ey_account_sub_class
			--,coa.ey_account_group_I
			--,AUL.department
			--,AUL.preparer_ref
		UNION

		SELECT 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			
			,F.[ey_period] 
			--,F.[entry_date_id] 
			--,F.[effective_date_id] 
			--,max(F.[effective_date_id])
			,CONVERT (datetime,convert(varchar(24),f.entry_date_id),121)  
			,CONVERT (datetime,convert(varchar(24),f.effective_date_id),121)  
			,MAX(CONVERT (datetime,convert(varchar(24),f.effective_date_id),121)  )

			,'Max Effective Date' Category
			,SUM(F.COUNT_JE_ID) 
			
			,max(DATEDIFF(DAY,EntCal.calendar_date,EffCal.calendar_date) )AS Lag_Date
			--,max(f.Lag_Date)
			--,DATEDIFF(day, max(F.[effective_date]), max(F.[entry_date])) 'Max Entry - Effective'
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd

			
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			,sum(f.net_reporting_amount)
			,sum(f.net_reporting_amount_credit)
			,sum(f.net_reporting_amount_debit)
			,sum(f.net_functional_amount)
			,sum(f.net_functional_amount_credit)
			,sum(f.net_functional_amount_debit)
			,sum(F.[NET_amount]) 
			,sum(F.[NET_amount_credit]) 
			,sum(F.[NET_amount_debit]) 
			--,UL.[preparer_ref]
			--,UL.department
			--,COA.gl_account_cd 
			--,COA.ey_gl_account_name
			--,COA.ey_account_type
			--,COA.ey_account_sub_type
			--,COA.ey_account_class
			--,COA.ey_account_sub_class
			--,COA.ey_account_group_I
			--,PP.year_flag_desc
			--,PP.period_flag_desc
			
			--,AUL.department
			--,AUL.preparer_ref

		FROM dbo.FT_GL_Account F --dbo.FLAT_JE F
			INNER JOIN DBO.Gregorian_calendar EntCal ON f.entry_date_id = EntCal.date_id
			INNER JOIN DBO.Gregorian_calendar EffCal ON f.effective_date_id = EffCal.date_id
			--INNER JOIN dbo.v_Chart_of_accounts COA on coa.coa_id = F.coa_id
			--LEFT OUTER JOIN dbo.Parameters_period PP on PP.year_flag = F.year_flag AND PP.period_flag = F.period_flag
			--LEFT OUTER JOIN dbo.v_User_listing UL ON UL.user_listing_id = F.user_listing_id
			--LEFT OUTER JOIN dbo.v_User_listing aul on aul.user_listing_id = f.approved_by_id
		--WHERE f.ver_end_date_id IS NULL  -- Added by prabakar to bring latest version records only -- on July 2nd
		GROUP BY 
			F.coa_id
			,f.bu_id
			,f.segment1_id
			,f.segment2_id
			,f.source_id
			,f.user_listing_id
			,f.approved_by_id
			,f.year_flag
			,f.period_flag
			
			,F.[ey_period] 
			,F.[entry_date_id] 
			,F.[effective_date_id] 
			
			,f.sys_man_ind
			,f.journal_type  -- added by prabakar to bring the journal type by prabakar on july 2nd
			
			,f.functional_curr_cd
			,f.reporting_amount_curr_cd
			
			--,PP.year_flag_desc
			--,PP.period_flag_desc
			--,AUL.department
			--,AUL.preparer_ref
			--,UL.[preparer_ref]
			--,UL.department
			--,coa.gl_account_cd 
			--,coa.ey_gl_account_name
			--,coa.ey_account_type
			--,coa.ey_account_sub_type
			--,coa.ey_account_class
			--,coa.ey_account_sub_class
			--,coa.ey_account_group_I
		)
END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL016_Balance_By_GL]')) Drop PROC [dbo].[PROC_Refresh_Data_GL016_Balance_By_GL]
GO

CREATE PROCEDURE [dbo].[PROC_Refresh_Data_GL016_Balance_By_GL]
AS 
/**********************************************************************************************************************************************
Description:	PROC to insert into table GL_016_Balance_By_GL
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL016_Balance_By_GL]
************************************************************************************************************************************************/
BEGIN

	TRUNCATE TABLE dbo.GL_016_Balance_by_GL

	--INSERT INTO DBO.GL_016_Balance_by_GL 
	INSERT INTO dbo.GL_016_Balance_by_GL
	(
		coa_id
		,bu_id
		,source_id
		,segment1_id
		,segment2_id
		,user_listing_id
		,approved_by_id
		,year_flag
		,period_flag
		,ey_period
		,sys_man_ind
		,journal_type
		,functional_curr_cd
		,reporting_curr_cd
		,source_type
		,net_reporting_amount
		,net_reporting_amount_credit
		,net_reporting_amount_debit
		,net_functional_amount
		,net_functional_amount_credit
		,net_functional_amount_debit
	)
	
	Select 
		f.coa_id				
		,f.bu_id
		,f.source_id 
		,f.segment1_id 
		,f.segment2_id 
		,F.user_listing_id	
		,f.approved_by_id 
	
		,f.year_flag
		,f.period_flag
		,f.EY_period  
		,f.Sys_man_ind 				
		,f.journal_type 
		,f.functional_curr_cd 
		,f.reporting_amount_curr_cd 

		,'Activity' AS [Source_Type]
		,SUM(f.net_reporting_amount) 
		,SUM(f.net_reporting_amount_credit) 
		,SUM(f.net_reporting_amount_debit) 

		,SUM(f.net_functional_amount) 
		,SUM(f.net_functional_amount_credit) 
		,SUM(f.net_functional_amount_debit) 

	
	FROM dbo.FT_GL_Account F
	GROUP BY
 		f.coa_id					
		,f.bu_id
		
		,f.source_id
		,f.segment1_id
		,f.segment2_id
		,F.user_listing_id		
		,f.approved_by_id
		,f.year_flag
		,f.period_flag
		,f.EY_period
		,f.sys_man_ind
		,f.journal_type
		,f.functional_curr_cd
		,f.reporting_amount_curr_cd

	UNION
		SELECT  
			tb.coa_id								
			,tb.bu_id
			,0 AS [Source_id]
			,tb.segment1_id 
			,tb.segment2_id 
			,0 AS [user_listing_id]	
			,0 AS [approved_by_id]
			,pp.year_flag
			,pp.period_flag
			,fc.fiscal_period_cd AS [ey_period]
			,'N/A for balances'		AS [sys_man_ind]					
			,'N/A for balances' AS  [journal_type]
			,tb.functional_curr_cd  
			,tb.reporting_curr_cd 
			,'Beginning balance' AS [Source_Type]
			,tb.reporting_beginning_balance  
			,0.0 AS [Net_reporting_amount_credit]
			,0.0 AS [Net_reporting_amount_debit]
			,tb.functional_beginning_balance  
			,0.0 AS [Net_functional_amount_credit]
			,0.0 AS [Net_functional_amount_debit]
		FROM dbo.TrialBalance tb
			
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd

		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end) 
								FROM dbo.Parameters_period pp1 
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								and pp1.year_flag=pp.year_flag  
							)
		and tb.ver_end_date_id is null 

	UNION
		
		SELECT  
			tb.coa_id							
			,tb.bu_id
			,0 AS [Source_id]
			,tb.segment1_id 
			,tb.segment2_id 
			,0 AS [user_listing_id]	
			,0 AS [approved_by_id]
			,pp.year_flag
			,pp.period_flag
			,fc.fiscal_period_cd AS [ey_period]
			,'N/A for balances'		AS [sys_man_ind]					
			,'N/A for balances' AS [journal_type]
			,tb.functional_curr_cd  
			,tb.reporting_curr_cd 
			,'Ending balance' AS [Source_Type]

			,TB.reporting_ending_balance  

			,0.0 AS [Net_reporting_amount_credit]
			,0.0 AS [Net_reporting_amount_debit]
			,tb.functional_ending_balance
			,0.0 AS [Net_functional_amount_credit]
			,0.0 AS [Net_functional_amount_debit]
			
		FROM dbo.TrialBalance tb
			

			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd
			
	
		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end) 
								FROM dbo.Parameters_period pp1 
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								and pp1.year_flag = pp.year_flag  
								)
		and  tb.ver_end_date_id is null 
	
END
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL016_Stats_blanks]')) Drop PROC [dbo].[PROC_Refresh_Data_GL016_Stats_blanks]
GO
CREATE PROC [dbo].[PROC_Refresh_Data_GL016_Stats_blanks]
AS
/**********************************************************************************************************************************************
Description:	GL016  
Script Date:	09/08/2013 
Created By:		PRABAKAR
Version:		1
Sample Command:	EXEC	[dbo].[PROC_Refresh_Data_GL016_Stats_blanks]
History:		
V1				06/19/2014  	TRP		CREATED
************************************************************************************************************************************************/
BEGIN
	

	TRUNCATE TABLE	GL_016_Data_stats_blanks

	INSERT INTO GL_016_Data_stats_blanks
	(
		Metric_B
		,Metric_Count_B
		,Period_Type_B
		,Period_Flag
		,Column_Name
		,[Start_Date]
		,End_Date
	)
	--[dbo].[Data_stats_blanks]
	SELECT b.Metric
		,b.[Count]
		,b.[Period Type]
		,b.[Period Flag]
		,b.[Column]
		,b.[Start Date]
		,b.[End Date] 
	FROM 
	(

		SELECT 
			'Blank Business Units' as [Metric],
			sum(count_je_id) [Count],--sum(count_je_id) [Count],-- [Count],
			pp.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'bu_cd' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY'
			AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			----and f.ver_end_date_id is null
		GROUP BY pp.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Business Units' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'bu_cd' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
			WHERE NOT EXISTS 
			(
				SELECT 
					'Blank Business Units' as [Metric],
					sum(count_je_id) [Count],-- [Count],
					pp.Year_flag_desc AS [Period Type],
					F.year_flag AS [Period Flag],
					'bu_cd' AS [Column],
					'year_start_date' AS [Start Date] ,
					'year_end_date' AS [End Date]
				FROM dbo.ft_gl_account f --dbo.flat_je f 
				INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
				LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
				WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
					AND pp.year_flag = 'CY'
					AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
				----and f.ver_end_date_id is null
				GROUP BY pp.Year_flag_desc
						,F.year_flag
			)

		UNION

		SELECT 
			'Blank Business Units' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			pp.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'bu_cd' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY'
			AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Business Units' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'bu_cd' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
			'Blank Business Units' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'bu_cd' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY'
				AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
			,F.year_flag
		)


		UNION
		

		SELECT 
			'Blank Business Units' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'bu_cd' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Business Units' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'bu_cd' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Business Units' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'bu_cd' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		
		SELECT 
			'Blank Business Units' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'bu_cd' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Business Units' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'bu_cd' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Business Units' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'bu_cd' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN dbo.v_Business_unit_listing bu ON bu.bu_id = f.bu_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL (bu.bu_cd,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag

		)

		UNION


		SELECT 
			'Blank Preparer' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'preparer_ref' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND ISNULL(ul.preparer_ref,'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			AND pp.year_flag = 'CY'
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Preparer' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'preparer_ref' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Preparer' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'preparer_ref' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
				AND pp.year_flag = 'CY'
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)


		UNION
		
		SELECT 
			'Blank Preparer' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'preparer_ref' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY'
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Preparer' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'preparer_ref' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Preparer' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'preparer_ref' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY'
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)


		UNION
		

		SELECT 
			'Blank Preparer' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'preparer_ref' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Preparer' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'preparer_ref' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Preparer' as [Metric],
				sum(count_je_id) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'preparer_ref' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		
		SELECT 
			'Blank Preparer' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'preparer_ref' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Preparer' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'preparer_ref' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Preparer' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'preparer_ref' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN v_User_listing UL on ul.user_listing_id = f.user_listing_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank Source' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'source_id' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f
		 INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY'
			AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Source' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'source_id' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Source' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'source_id' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY'
				AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		

		SELECT 
			'Blank Source' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'source_id' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY'
			AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Source' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'source_id' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Source' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'source_id' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY'
				AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Source' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'source_id' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f
		 INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Source' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'source_id' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Source' as [Metric],
				sum(count_je_id) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'source_id' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		
		SELECT 
			'Blank Source' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'source_id' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Source' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'source_id' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Source' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'source_id' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL([source_id],0) = 0
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)
	
		UNION

		SELECT 
			'Blank Period' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'year_flag_desc' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY'
			AND [period_id]  is NULL
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Period' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'year_flag_desc' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Period' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'year_flag_desc' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY'
				AND [period_id]  is NULL
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Period' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'year_flag_desc' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY'
			AND [period_id]  is NULL
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag
		
		UNION

		SELECT 'Blank Period' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'year_flag_desc' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Period' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'year_flag_desc' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY'
				AND [period_id]  is NULL
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		

		SELECT 
			'Blank Period' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'year_flag_desc' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND [period_id]  is NULL
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Period' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'year_flag_desc' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Period' as [Metric],
				sum(count_je_id) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'year_flag_desc' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND [period_id]  is NULL
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		

		SELECT 
			'Blank Period' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'year_flag_desc' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND [period_id]  is NULL
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Period' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'year_flag_desc' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Period' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'year_flag_desc' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND [period_id]  is NULL
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank Effective Date' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'Effective_Date' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Effective Date' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'Effective_Date' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Effective Date' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'Effective_Date' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL(effective_date_id,19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Effective Date' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'Effective_Date' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Effective Date' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'Effective_Date' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Effective Date' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'Effective_Date' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		

		SELECT 
			'Blank Effective Date' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'Effective_Date' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Effective Date' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'Effective_Date' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Effective Date' as [Metric],
				sum(count_je_id) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'Effective_Date' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		

		SELECT 
			'Blank Effective Date' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'Effective_Date' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Effective Date' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'Effective_Date' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Effective Date' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'Effective_Date' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL([effective_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION


		SELECT 
			'Blank Entry Date' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'Entry_Date' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL(entry_date_id,19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Entry Date' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'Entry_Date' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Entry Date' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'Entry_Date' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Entry Date' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'Entry_Date' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Entry Date' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'Entry_Date' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Entry Date' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'Entry_Date' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Entry Date' as [Metric],
			count('x') as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'Entry_Date' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag
	
		UNION

		SELECT 'Blank Entry Date' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'Entry_Date' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Entry Date' as [Metric],
				count('x') as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'Entry_Date' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		

		SELECT 
			'Blank Entry Date' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'Entry_Date' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Entry Date' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP'AS [Period Flag],
			'Entry_Date' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Entry Date' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'Entry_Date' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL([entry_date_id],19000101)  = 19000101
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag

		)

		UNION


		SELECT 
			'Blank GL Account' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'gl_account_cd' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f
		INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank GL Account' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'gl_account_cd' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'gl_account_cd' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank GL Account' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'gl_account_cd' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank GL Account' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'gl_account_cd' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'gl_account_cd' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank GL Account' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'gl_account_cd' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank GL Account' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'gl_account_cd' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account' as [Metric],
				sum(count_je_id) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'gl_account_cd' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		

		SELECT 
			'Blank GL Account' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'gl_account_cd' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP' 
			AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank GL Account' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'gl_account_cd' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'gl_account_cd' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN DBO.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP' 
				AND ISNULL(coa.[gl_account_cd],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		---check this prabakar
		SELECT 
			'Blank Journal Entries' as [Metric],
			count(1) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'je_header_desc' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Journal Entries' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'je_header_desc' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entries' as [Metric],
				count(1) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'je_header_desc' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Journal Entries' as [Metric],
			count(1) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'je_header_desc' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Journal Entries' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'je_header_desc' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entries' as [Metric],
				count(1) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'je_header_desc' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Journal Entries' as [Metric],
			count(1) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'je_header_desc' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION
		
		SELECT 'Blank Journal Entries' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'je_header_desc' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entries' as [Metric],
				count(1) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'je_header_desc' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)
		
		UNION

		SELECT 
			'Blank Journal Entries' as [Metric],
			count(1) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'je_header_desc' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP' 
			AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION
		
		SELECT 'Blank Journal Entries' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'je_header_desc' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entries' as [Metric],
				count(1) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'je_header_desc' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP' 
				AND ISNULL([je_header_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
	
		SELECT 
			'Blank Journal Entry Lines' as [Metric],
			count(1) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'je_line_desc' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag
		
		UNION

		SELECT 'Blank Journal Entry Lines' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'je_line_desc' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entry Lines' as [Metric],
				count(1)as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'je_line_desc' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Journal Entry Lines' as [Metric],
			count(1) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'je_line_desc' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag
		
		UNION

		SELECT 'Blank Journal Entry Lines' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'je_line_desc' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entry Lines' as [Metric],
				count(1)as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'je_line_desc' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Journal Entry Lines' as [Metric],
			count(1) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'je_line_desc' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag
		UNION

		SELECT 'Blank Journal Entry Lines' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'je_line_desc' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entry Lines' as [Metric],
				count(1) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'je_line_desc' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		
		SELECT 
			'Blank Journal Entry Lines' as [Metric],
			count(1) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'je_line_desc' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP' 
			AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Journal Entry Lines' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'je_line_desc' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Journal Entry Lines' as [Metric],
				count(1) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'je_line_desc' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.flat_je f
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP' 
				AND ISNULL([je_line_desc],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT') 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank Approver' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'approver_ref' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Approver' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'approver_ref' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Approver' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'approver_ref' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Approver' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'approver_ref' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION
	
		SELECT 'Blank Approver' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'approver_ref' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Approver' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'approver_ref' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION 

		SELECT 
			'Blank Approver' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'approver_ref' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Approver' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'approver_ref' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Approver' as [Metric],
				count('x') as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'approver_ref' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)
		
		UNION
		
		SELECT 
			'Blank Approver' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'approver_ref' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP' 
			AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag
		
		UNION

		SELECT 'Blank Approver' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'approver_ref' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Approver' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'approver_ref' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			LEFT OUTER JOIN	dbo.v_User_listing UL on ul.user_listing_id = f.approved_by_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP' 
				AND ISNULL(ul.[preparer_ref],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank GL Account Name' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'gl_account_name' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag
		UNION

		SELECT 'Blank GL Account Name' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'gl_account_name' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account Name' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'gl_account_name' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank GL Account Name' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'gl_account_name' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY' 
			AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank GL Account Name' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'gl_account_name' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account Name' as [Metric],
				sum(count_je_id) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'gl_account_name' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY' 
				AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank GL Account Name' as [Metric],
			sum(count_je_id) as [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'gl_account_name' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank GL Account Name' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'gl_account_name' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account Name' as [Metric],
				sum(count_je_id) as [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'gl_account_name' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		
		SELECT 
			'Blank GL Account Name' as [Metric],
			sum(count_je_id) as [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'gl_account_name' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP' 
			AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank GL Account Name' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'gl_account_name' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank GL Account Name' as [Metric],
				SUM(COUNT_JE_ID) as [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'gl_account_name' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			INNER JOIN dbo.v_Chart_of_accounts coa on coa.coa_id = f.coa_id
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP' 
				AND ISNULL(coa.[gl_account_name],'EY Unknown') IN ('EY Unknown', 'EY_Unknown', 'EY_EMPTY', 'EY_0000','EY_DEFAULT')
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag

		)

		UNION

		SELECT 
			'Blank Segment 1' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'segment1_id' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY'
			AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Segment 1' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'segment1_id' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 1' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'segment1_id' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY'
				AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank Segment 1' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'segment1_id' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY'
			AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
		,F.year_flag

		UNION

		SELECT 'Blank Segment 1' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'segment1_id' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 1' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'segment1_id' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY'
				AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION
		
		SELECT 
			'Blank Segment 1' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'segment1_id' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Segment 1' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'segment1_id' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 1' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'segment1_id' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag

		)

		UNION
		
		SELECT 
			'Blank Segment 1' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'segment1_id' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Segment 1' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'segment1_id' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 1' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'segment1_id' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL([segment1_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank Segment 2' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'segment2_id' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY'
			AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Segment 2' as [Metric], 
			0 AS [Count], 
			'Current' AS [Period Type], 
			'CY' AS [Period Flag],
			'segment2_id' AS [Column], 
			'year_start_date' AS [Start Date], 
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
		SELECT 
				'Blank Segment 2' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'segment2_id' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY'
				AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
			,F.year_flag
		)

		UNION

		SELECT 
			'Blank Segment 2' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'segment2_id' AS [Column],
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'PY'
			AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Segment 2' as [Metric], 
			0 AS [Count], 
			'Prior' AS [Period Type], 
			'PY' AS [Period Flag],
			'segment2_id' AS [Column], 
			'year_start_date' AS [Start Date] ,
			'year_end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 2' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'segment2_id' AS [Column],
				'year_start_date' AS [Start Date] ,
				'year_end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'PY'
				AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag
		)

		UNION

		SELECT 
			'Blank Segment 2' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.period_flag_desc AS [Period Type],
			F.Period_flag AS [Period Flag],
			'segment2_id' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'CY' 
			AND pp.period_flag = 'IP'
			AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.period_flag_desc
			,F.Period_flag

		UNION

		SELECT 'Blank Segment 2' as [Metric], 
			0 AS [Count], 
			'Interim Period' AS [Period Type], 
			'IP' AS [Period Flag],
			'segment2_id' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 2' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.period_flag_desc AS [Period Type],
				F.Period_flag AS [Period Flag],
				'segment2_id' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'CY' 
				AND pp.period_flag = 'IP'
				AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.period_flag_desc
				,F.Period_flag
		)

		UNION
		
		SELECT 
			'Blank Segment 2' as [Metric],
			sum(count_je_id) [Count],-- [Count],
			PP.Year_flag_desc AS [Period Type],
			F.year_flag AS [Period Flag],
			'segment2_id' AS [Column],
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		FROM dbo.ft_gl_account f --dbo.flat_je f 
		INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
		WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
			AND pp.year_flag = 'SP'
			AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
		GROUP BY PP.Year_flag_desc
			,F.year_flag

		UNION

		SELECT 'Blank Segment 2' as [Metric], 
			0 AS [Count], 
			'Subsequent' AS [Period Type], 
			'SP' AS [Period Flag],
			'segment2_id' AS [Column], 
			'start_date' AS [Start Date] ,
			'end_date' AS [End Date]
		WHERE NOT EXISTS 
		(
			SELECT 
				'Blank Segment 2' as [Metric],
				sum(count_je_id) [Count],-- [Count],
				PP.Year_flag_desc AS [Period Type],
				F.year_flag AS [Period Flag],
				'segment2_id' AS [Column],
				'start_date' AS [Start Date] ,
				'end_date' AS [End Date]
			FROM dbo.ft_gl_account f --dbo.flat_je f 
			INNER JOIN dbo.Parameters_period PP ON F.year_flag = pp.year_flag and f.period_flag = pp.period_flag
			WHERE convert(datetime, convert(varchar(24),f.effective_date_id),121) BETWEEN pp.start_date AND pp.end_date
				AND pp.year_flag = 'SP'
				AND ISNULL([segment2_id],0) = 0 
			--and f.ver_end_date_id is null
			GROUP BY PP.Year_flag_desc
				,F.year_flag

		)
	) b
END  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL016_Stats_totals]')) Drop PROC [dbo].[PROC_Refresh_Data_GL016_Stats_totals]
GO

CREATE PROCEDURE [dbo].[PROC_Refresh_Data_GL016_Stats_totals]
AS 
/**********************************************************************************************************************************************
Description:	PROC to create AND insert into table GL_016_Data_stats_totals
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL016_Stats_totals]
V2		20140806	MSH		Query/ logic changes for GL optimization
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE dbo.GL_016_Data_stats_totals


	;WITH JE_STAT_YEAR_CTE
	AS
	(
		SELECT 
						 COUNT (DISTINCT je.je_id)							AS [je_count]
						,COUNT (DISTINCT je.[bu_id])						AS [bu_count]
						,COUNT (DISTINCT je.[user_listing_id])				AS [preparer_count]
						,COUNT (DISTINCT je.[source_id])					AS [source_count]
						,COUNT (DISTINCT coa.[ey_account_type])				AS [ey_account_type_count]
						,COUNT (DISTINCT coa.[ey_account_sub_type])			AS [ey_account_sub_type_count]
						,COUNT (DISTINCT coa.[ey_account_class])			AS [ey_account_class_count]
						,COUNT (DISTINCT coa.[ey_account_sub_class])		AS [ey_account_sub_class_count]
						,COUNT (DISTINCT coa.[ey_gl_account_name])			AS [ey_gl_account_name_count]
						,COUNT (DISTINCT je.[approved_by_id])				AS [approver_ref_count]
						,COUNT (DISTINCT je.segment1_id)					AS [segment1_id_count]
						,COUNT (DISTINCT je.segment2_id)					AS [segment2_id_count]
						,pp.year_flag_desc									AS [period_type]
		FROM			 [dbo].[Ft_JE_Amounts] je 
		INNER JOIN 		 dbo.parameters_period pp		ON		je.period_flag = pp.period_flag
		LEFT OUTER JOIN	 dbo.v_Chart_of_accounts coa	ON		je.coa_id = coa.coa_id
		WHERE			 je.year_flag IN ('CY', 'PY', 'SP')
		GROUP BY		 PP.year_flag_desc
	)
	,JE_STAT_PERIOD_CTE
	AS
	(
		SELECT 
						 COUNT (DISTINCT je.je_id)							AS [je_count]
						,COUNT (DISTINCT je.[bu_id])						AS [bu_count]
						,COUNT (DISTINCT je.[user_listing_id])				AS [preparer_count]
						,COUNT (DISTINCT je.[source_id])					AS [source_count]
						,COUNT (DISTINCT coa.[ey_account_type])				AS [ey_account_type_count]
						,COUNT (DISTINCT coa.[ey_account_sub_type])			AS [ey_account_sub_type_count]
						,COUNT (DISTINCT coa.[ey_account_class])			AS [ey_account_class_count]
						,COUNT (DISTINCT coa.[ey_account_sub_class])		AS [ey_account_sub_class_count]
						,COUNT (DISTINCT coa.[ey_gl_account_name])			AS [ey_gl_account_name_count]
						,COUNT (DISTINCT je.[approved_by_id])				AS [approver_ref_count]
						,COUNT (DISTINCT je.segment1_id)					AS [segment1_id_count]
						,COUNT (DISTINCT je.segment2_id)					AS [segment2_id_count]
						,pp.period_flag_desc								AS [period_type]
		FROM			 [dbo].[Ft_JE_Amounts] je 
		INNER JOIN 		 dbo.parameters_period pp		ON		je.period_flag = pp.period_flag
		LEFT OUTER JOIN	 dbo.v_Chart_of_accounts coa	ON		je.coa_id = coa.coa_id
		WHERE			 pp.year_flag = 'CY'
				AND		 pp.period_flag = 'IP'
		GROUP BY		 pp.period_flag_desc
	)
	
	INSERT INTO dbo.GL_016_Data_stats_totals
	(
		 Metric_T
		,Metric_Count_T
		,Period_Type_T
		
	) --data_stats_totals

	SELECT 
				 'Journal Entries'			AS [metric]
				,JE.[je_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 
		
	UNION ALL

	SELECT 
				 'Journal Entries'			AS [metric]
				,JE.[je_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
	

	UNION ALL
			
	SELECT 
					 'Journal Entry Lines'								AS [metric]
					--,COUNT (je.je_line_id)								AS [je_line_count]
					,sum (je.count_je_id)								AS [je_line_count]
					,pp.year_flag_desc									AS [period_type]
	FROM			dbo.FT_GL_Account JE --[dbo].[Flat_JE] je 
	INNER JOIN 		 dbo.parameters_period pp		ON		je.period_flag = pp.period_flag
	LEFT OUTER JOIN	 dbo.v_Chart_of_accounts coa	ON		je.coa_id = coa.coa_id
	WHERE			 je.year_flag IN ('CY', 'PY', 'SP')
	GROUP BY		 PP.year_flag_desc

	UNION ALL

	SELECT 
					 'Journal Entry Lines'								AS [metric]
					--,COUNT (je.je_line_id)								AS [je_line_count]
					,sum (je.count_je_id)								AS [je_line_count]
					,pp.period_flag_desc								AS [period_type]
	FROM			dbo.FT_GL_Account JE --[dbo].[Flat_JE] je 
	INNER JOIN 		 dbo.parameters_period pp		ON		je.period_flag = pp.period_flag
	LEFT OUTER JOIN	 dbo.v_Chart_of_accounts coa	ON		je.coa_id = coa.coa_id
	WHERE			 pp.year_flag = 'CY'
				AND	 pp.period_flag = 'IP'
	GROUP BY		 pp.period_flag_desc
		
	UNION ALL

	SELECT 
				 'Business Units'			AS [metric]
				,JE.[bu_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Business Units'		AS [metric]
				,JE.[bu_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
		

	UNION ALL
		
	SELECT 
				 'Preparer'				AS [metric]
				,JE.[preparer_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Preparer'				AS [metric]
				,JE.[preparer_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
		
	UNION ALL
	
	SELECT 
				 'Sources'				AS [metric]
				,JE.[source_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Sources'						AS [metric]
				,JE.[source_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
		
	UNION ALL
	
	SELECT 
				 'Account Type'					AS [metric]
				,JE.[ey_account_type_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Account Type'					AS [metric]
				,JE.[ey_account_type_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 

	UNION ALL
	
	SELECT 
				 'Account Sub-type'				AS [metric]
				,JE.[ey_account_sub_type_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Account Sub-type'				AS [metric]
				,JE.[ey_account_sub_type_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
				
	UNION ALL
	
	SELECT 
				 'Account Class'					AS [metric]
				,JE.[ey_account_class_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Account Class'					AS [metric]
				,JE.[ey_account_class_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 

	UNION ALL
	
	SELECT 
				 'Account Sub-class'				AS [metric]
				,JE.[ey_account_sub_class_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Account Sub-class'				AS [metric]
				,JE.[ey_account_sub_class_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
	
	UNION ALL
	
	SELECT 
				 'GL Account'				AS [metric]
				,JE.[ey_gl_account_name_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'GL Account'				AS [metric]
				,JE.[ey_gl_account_name_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
	
	UNION ALL
	
	SELECT 
				 'Approver'				AS [metric]
				,JE.[approver_ref_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Approver'				AS [metric]
				,JE.[approver_ref_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
	
	UNION ALL
	
	SELECT 
				 'Segment 1'				AS [metric]
				,JE.[segment1_id_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Segment 1'				AS [metric]
				,JE.[segment1_id_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
	
	UNION ALL
	
	SELECT 
				 'Segment 2'				AS [metric]
				,JE.[segment2_id_count]
				,JE.[period_type]
	FROM		 JE_STAT_YEAR_CTE JE 

	UNION ALL

	SELECT 
				 'Segment 2'				AS [metric]
				,JE.[segment2_id_count]
				,JE.[period_type]
	FROM		 JE_STAT_PERIOD_CTE JE 
	
	
END

  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL017_Change_in_Preparers]')) Drop PROC [dbo].[PROC_Refresh_Data_GL017_Change_in_Preparers]
GO

CREATE PROCEDURE [dbo].[PROC_Refresh_Data_GL017_Change_in_Preparers]
AS 
/**********************************************************************************************************************************************
Description:	PROC to insert into table GL_017_Change_in_Preparers
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL017_Change_in_Preparers]
************************************************************************************************************************************************/
BEGIN

		TRUNCATE TABLE dbo.GL_017_Change_in_Preparers

		INSERT INTO dbo.GL_017_Change_in_Preparers
		(
		--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
			bu_id
			,source_id
			,segment1_id
			,segment2_id
		--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - end
			,year_flag_desc
			,period_flag_desc
			,year_flag
			,period_flag
			,Ey_period
		--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
			--,bu_group
			--,bu_ref
			--,segment1_ref
			--,segment2_ref
			--,segment1_group
			--,segment2_group
			--,source_group
			--,Source_ref
			--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - end
			,sys_manual_ind
			,Journal_type
			,preparer_ref
			,department
			,Category
			,reporting_amount_curr_cd
			,functional_curr_cd

		)
		SELECT 
		--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
			UALL.bu_id
			,UALL.source_id
			,UALL.segment1_id
			,UALL.segment2_id
			--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - end
			 ,CASE WHEN UALL.year_flag = 'CY' THEN 'Current' 
				 WHEN UALL.year_flag = 'PY' THEN 'Prior' 
				 WHEN UALL.year_flag = 'SP' THEN 'Subsequent' 
			 ELSE UALL.year_flag_desc END AS year_flag_desc
			,UALL.period_flag_desc
			,UALL.year_flag
			,UALL.period_flag
			,UALL.Ey_period
			--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
			--,UALL.bu_group
			--,UALL.bu_ref
			--,UALL.segment1_ref
			--,UALL.segment2_ref
			--,UALL.segment1_group
			--,UALL.segment2_group
			--,UALL.ey_source_group
			--,UALL.Source_ref
			--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - end
			,UALL.sys_man_ind 
			,UALL.journal_type
			,UALL.preparer_ref
			,UALL.department
			,UALL.Category
			,UALL.reporting_amount_curr_cd
			,UALL.functional_curr_cd 
		FROM 
		(
			SELECT 
				--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
				bu_id
				,source_id
				,segment1_id
				,segment2_id
				--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - end
				,year_flag_desc
				,period_flag_desc
				,year_flag
				,period_flag
				,Ey_period
				--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
				--,bu_group
				--,bu_ref
				--,segment1_ref
				--,segment2_ref
				--,segment1_group
				--,segment2_group
				--,ey_source_group
				--,Source_ref
				--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - end
				,sys_man_ind
				,journal_type
				,preparer_ref
				,department
				,Category
				,reporting_amount_curr_cd
				,functional_curr_cd

			FROM VW_GL017T2_Change_In_Preparers_New
			UNION
			SELECT 
			--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
				bu_id
				,source_id
				,segment1_id
				,segment2_id
				--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - end
				,year_flag_desc
				,period_flag_desc
				,year_flag
				,period_flag
				,Ey_period
				--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
				--,bu_group
				--,bu_ref
				--,segment1_ref
				--,segment2_ref
				--,segment1_group
				--,segment2_group
				--,ey_source_group
				--,Source_ref
				--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - end
				,sys_man_ind
				,journal_type
				,preparer_ref
				,department
				,Category
				,reporting_amount_curr_cd
				,functional_curr_cd
			FROM VW_GL017T2_Change_In_Preparers_Common
			UNION 
			SELECT 
			--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
				bu_id
				,source_id
				,segment1_id
				,segment2_id
				--- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - end
				,year_flag_desc
				,period_flag_desc
				,year_flag
				,period_flag
				,Ey_period
				--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
				--,bu_group
				--,bu_ref
				--,segment1_ref
				--,segment2_ref
				--,segment1_group
				--,segment2_group
				--,ey_source_group
				--,Source_ref
				--- commented by prabakar to have source, bu, segment to be dynamic on jun 26 - end
				,sys_man_ind
				,journal_type
				,preparer_ref
				,department
				,Category
				,reporting_amount_curr_cd
				,functional_curr_cd
			FROM VW_GL017T2_Change_In_Preparers_Inactive
		) UALL

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_001_Balance_Sheet]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_001_Balance_Sheet]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_001_Balance_Sheet] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [Ft_JE_Amounts]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_001_Balance_Sheet]
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table [GL_001_Balance_Sheet] and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE [GL_001_Balance_Sheet]

	
	INSERT INTO dbo.[GL_001_Balance_Sheet]
	(
		COA_Id
		,Period_Id
		,Bu_id
		,Segment_1_id
		,Segment_2_id
		,Source_id
		,user_listing_id
		,approved_by_id
		,Year_flag
		,Period_flag
		,Accounting_period
		,Accounting_sub_period
		,[Year]
		,Fiscal_period
		,Journal_type
		,Functional_Currency_Code
		,Reporting_currency_code
		,Net_reporting_amount
		,Net_reporting_amount_credit
		,Net_reporting_amount_debit
		,Net_reporting_amount_current
		,Net_reporting_amount_credit_current
		,Net_reporting_amount_debit_current
		,Net_reporting_amount_interim
		,Net_reporting_amount_credit_interim
		,Net_reporting_amount_debit_interim
		,Net_reporting_amount_prior
		,Net_reporting_amount_credit_prior
		,Net_reporting_amount_debit_prior
		,Net_functional_amount
		,Net_functional_amount_credit
		,Net_functional_amount_debit
		,Net_functional_amount_current
		,Net_functional_amount_credit_current
		,Net_functional_amount_debit_current
		,Net_functional_amount_interim
		,Net_functional_amount_credit_interim
		,Net_functional_amount_debit_interim
		,Net_functional_amount_prior
		,Net_functional_amount_credit_prior
		,Net_functional_amount_debit_prior
		,Source_type
		,Period_end_date
		,Fiscal_period_sequence
		,Fiscal_period_sequence_end
		
	)
	
	SELECT 
		ft.coa_id as [COA Id]
		,ft.period_id as [Period Id]
		,ft.bu_id
		,ft.segment1_id
		,ft.segment2_id
		,ft.Source_id
		,ft.user_listing_id
		,ft.approved_by_id

		--,coa.ey_account_type AS [Account Type]
		--,coa.ey_account_sub_type AS [Account Sub-type]
		--,coa.ey_account_class	  AS [Account Class]
		--,coa.ey_account_sub_class	  AS [Account Sub-class]
		--,coa.gl_account_cd AS [GL Account Code]
		--,coa.gl_account_name AS [GL Account Name]
		--,coa.ey_gl_account_name AS [GL Account]
		--,coa.ey_account_group_I AS [Account Group]
		--,bu.bu_ref AS [Business Unit]
		--,bu.bu_group as [Business unit group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	

		----,S1.segment_ref AS [Segment 1]
		----,s2.segment_ref AS [Segment 2]
		----,s1.ey_segment_group AS [Segment 1 group]
		----,s2.ey_segment_group AS [Segment 2 group]
		--,S1.ey_segment_ref AS [Segment 1]
		--,s2.ey_segment_ref AS [Segment 2]
		--,s1.ey_segment_group AS [Segment 1 group]
		--,s2.ey_segment_group AS [Segment 2 group]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- END */	
		,ft.year_flag as [Year flag]
		,ft.period_flag as [Period flag]
		,CASE	WHEN ft.year_flag ='CY' THEN 'Current'
				WHEN ft.year_flag ='PY' THEN 'Prior'
				WHEN ft.year_flag ='SP' THEN 'Subsequent'
				ELSE pp.year_flag_desc 
		END AS [Accounting period]

		,pp.period_flag_desc AS [Accounting sub period]
		,pp.fiscal_year_cd AS [Year]
		,ft.ey_period AS [Fiscal period]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	

		----,ds.ey_source_group AS [Source group]
		----,ds.Source_Ref AS [Source]
		--,src.source_group AS [Source group]
		--,src.Source_Ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

		,ft.journal_type AS [Journal type]
		--,dp.department AS [Preparer department]
		--,dp.preparer_Ref AS [Preparer]

		--,dp1.department AS [Approver department]
		--,dp1.preparer_ref AS [Approver]
	
		----,tb.trial_balance_start_date_id AS 'Trial Balance Start Date'
		----,tb.trial_balance_END_Date_id AS 'Trial Balance END Date'
		----,tb.Functional_beginning_balance AS 'Functional Beginning Balance'
		----,tb.Functional_ENDing_balance AS 'Functional ENDing Balance'
		,ft.functional_amount_curr_cd AS [Functional Currency Code]
		,ft.reporting_amount_curr_cd AS [Reporting currency code]

	
		----,0 AS 'Calculated ENDing Balance'
		----,0 AS 'Difference between calculated ENDing and ENDing'
	
		----,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		----,tb.reporting_ENDing_balance AS 'Reporting ENDing balance'

		,ROUND(SUM(ISNULL(ft.Net_reporting_amount,0)),2) AS [Net reporting amount]
		,ROUND(SUM(ISNULL(ft.Net_reporting_amount_credit,0)),2) AS [Net reporting amount credit]
		,ROUND(SUM(ISNULL(ft.Net_reporting_amount_debit,0)),2) AS [Net reporting amount debit]

		/* All condition below has been updated based on the discussion with Amod
			pp.year_flag_desc = 'Current ' is replaced with pp.year_flag = 'CY' 
			pp.year_flag_desc = 'Interim ' is replaced with PP.period_flag = 'IP'
			pp.year_flag_desc = 'Prior ' is replaced with  PP.year_flag ='PY' 
		*/

		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_reporting_amount ELSE 0 END) AS [Net reporting amount current] 
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_reporting_amount_credit ELSE 0 END) AS [Net reporting amount credit current]
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_reporting_amount_debit ELSE 0 END) AS [Net reporting amount debit current]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_reporting_amount ELSE 0 END) AS [Net reporting amount interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_reporting_amount_credit ELSE 0 END) AS [Net reporting amount credit interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_reporting_amount_debit ELSE 0 END) AS [Net reporting amount debit interim]
		,SUM(CASE WHEN PP.year_flag ='PY'  THEN ft.Net_reporting_amount ELSE 0 END) AS [Net reporting amount prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_reporting_amount_credit ELSE 0 END) AS [Net reporting amount credit prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_reporting_amount_debit ELSE 0 END) AS [Net reporting amount debit prior]
	
		,ROUND(SUM(ISNULL(ft.Net_functional_amount,0)),2) AS [Net functional amount]
		,ROUND(SUM(ISNULL(ft.Net_functional_credit_amount,0)),2) AS [Net functional amount credit]
		,ROUND(SUM(ISNULL(ft.Net_functional_debit_amount,0)),2) AS [Net functional amount debit]

		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_functional_amount ELSE 0 END) AS [Net functional amount current]
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_functional_credit_amount ELSE 0 END) AS [Net functional amount credit current]
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_functional_debit_amount ELSE 0 END) AS [Net functional amount debit current]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_functional_amount ELSE 0 END) AS [Net functional amount interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_functional_credit_amount ELSE 0 END) AS [Net functional amount credit interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_functional_debit_amount ELSE 0 END) AS [Net functional amount debit interim]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_functional_amount ELSE 0 END) AS [Net functional amount prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_functional_credit_amount ELSE 0 END) AS [Net functional amount credit prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_functional_debit_amount ELSE 0 END) AS [Net functional amount debit prior]
		,'Activity' AS [Source type]
		, pp.END_date AS [Period end date]
		, NULL AS [Fiscal period sequence]
		, NULL AS [Fiscal period sequence end]

	FROM dbo.Ft_JE_Amounts ft 
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = ft.year_flag
			AND PP.period_flag = ft.period_flag
		INNER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.Coa_id = ft.coa_id
			AND coa.bu_id = ft.BU_ID
		--INNER JOIN dbo.Dim_Preparer dp	on dp.user_listing_id = ft.user_listing_id
		--INNER JOIN dbo.Dim_Preparer dp1	on dp1.user_listing_id = ft.approved_by_id
/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		--INNER JOIN dbo.DIM_Source_listing ds ON ds.source_id = ft.source_id
		--INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		--LEFT OUTER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing BU on Bu.bu_id = ft.bu_id
		--LEFT OUTER JOIN dbo.v_Source_listing src ON src.source_id = ft.source_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 ON S1.ey_segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing S2 ON S2.ey_segment_id = ft.segment2_id

/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

	WHERE coa.ey_account_type in ('Assets','Liabilities','Equity')
		AND pp.period_flag NOT IN ('SP')


	GROUP BY
	
		ft.coa_id
		,ft.period_id
		,ft.bu_id
		,ft.segment1_id
		,ft.segment2_id
		,ft.Source_id
		,ft.user_listing_id
		,ft.approved_by_id

		--,coa.ey_account_type
		--,coa.ey_account_sub_type
		--,coa.ey_account_class
		--,coa.ey_account_sub_class
		--,coa.gl_account_cd
		--,coa.gl_account_name
		--,coa.ey_gl_account_name
		--,coa.ey_account_group_I
		--,bu.bu_ref
		--,bu.bu_group
		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		----,S1.segment_ref
		----,s2.segment_ref
		--,s1.ey_segment_ref
		--,s2.ey_segment_ref
		--,s1.ey_segment_group
		--,s2.ey_segment_group
		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,ft.year_flag
		,ft.period_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,pp.fiscal_year_cd
		,ft.ey_period
		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */
		----,ds.ey_source_group
		----,ds.Source_Ref
		--,src.source_group
		--,src.Source_Ref
		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		,ft.journal_type
		--,dp.department
		--,dp.preparer_Ref
		--,dp1.department
		--,dp1.preparer_ref
		,pp.END_date
		,ft.functional_amount_curr_cd 
		,ft.reporting_amount_curr_cd 
		, pp.fiscal_period_seq_END


	UNION

	SELECT 
		tb.coa_id as [COA Id]
		,tb.period_id as [Period Id]
		,tb.bu_id
		,tb.segment1_id
		,tb.segment2_id
		,NULL AS Source_id
		,NULL AS user_listing_id
		,NULL AS approved_by_id

		--,coa.ey_account_type AS [Account Type]
		--,coa.ey_account_sub_type AS [Account Sub-type]
		--,coa.ey_account_class	  AS [Account Class]
		--,coa.ey_account_sub_class	  AS [Account Sub-class]
		--,coa.gl_account_cd AS [GL Account Code]
		--,coa.gl_account_name AS [GL Account Name]
		--,coa.ey_gl_account_name AS [GL Account]
		--,coa.ey_account_group_I AS [Account Group]

		--,bu.bu_ref AS [Business Unit]
		--,bu.bu_group as [Business unit group]
		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		----,s1.segment_ref AS [Segment 1]
		----,s2.segment_ref AS [Segment 2]
		--,s1.ey_segment_ref AS [Segment 1]
		--,s2.ey_segment_ref AS [Segment 2]

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,s1.ey_segment_group AS [Segment 1 group]
		--,s2.ey_segment_group AS [Segment 2 group]
	
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,CASE WHEN pp.year_flag ='CY' THEN 'Current'
			WHEN pp.year_flag ='PY' THEN 'Prior'
			WHEN pp.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc 
		END AS [Accounting period]

		,pp.period_flag_desc AS [Accounting sub period]
		,pp.fiscal_year_cd AS [Year]
		,fc.fiscal_period_cd AS [Fiscal period]

		--,NULL AS [Source group]
		--,NULL AS [Source]
		,NULL AS [Journal type]
		--,NULL AS [Preparer department]
		--,NULL AS [Preparer]

		--,NULL AS [Approver department]
		--,NULL AS [Approver]
	
		--,tb.trial_balance_start_date_id AS 'Trial Balance Start Date'
		--,tb.trial_balance_END_Date_id AS 'Trial Balance END Date'
		--,tb.Functional_beginning_balance AS 'Functional Beginning Balance'
		--,tb.Functional_ENDing_balance AS 'Functional ENDing Balance'
		,tb.Functional_curr_cd AS [Functional Currency Code]
		,tb.reporting_curr_cd AS [Reporting currency code]

		--,0 AS 'Calculated ENDing Balance'
		--,0 AS 'Difference between calculated ENDing and ENDing'
	
		--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		--,tb.reporting_ENDing_balance AS 'Reporting ENDing balance'

		,ROUND(ISNULL(tb.reporting_beginning_balance,0),2) AS [Net reporting amount]
		,0 AS [Net reporting amount credit]
		,0 AS [Net reporting amount debit]

		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.reporting_beginning_balance ELSE 0 END) AS [Net reporting amount current] 
		,0 AS [Net reporting amount credit current]
		,0 AS [Net reporting amount debit current]
		,(CASE WHEN pp.period_flag = 'IP'  THEN tb.reporting_beginning_balance ELSE 0 END)  AS [Net reporting amount interim]
		,0 AS [Net reporting amount credit interim]
		,0 AS [Net reporting amount debit interim]
		,(CASE WHEN PP.year_flag ='PY'  THEN tb.reporting_beginning_balance ELSE 0 END) AS [Net reporting amount prior]
		,0 AS [Net reporting amount credit prior]
		,0 AS [Net reporting amount debit prior]
	
		,ROUND(ISNULL(tb.functional_beginning_balance,0),2) AS [Net functional amount]
		,0 AS [Net functional amount credit]
		,0 AS [Net functional amount debit]

		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.functional_beginning_balance ELSE 0 END) AS [Net functional amount current]
		,0 AS [Net functional amount credit current]
		,0 AS [Net functional amount debit current]
		,(CASE WHEN pp.period_flag = 'IP'  THEN tb.functional_beginning_balance ELSE 0 END)  AS [Net functional amount interim]
		,0 AS [Net functional amount credit interim]
		,0 AS [Net functional amount debit interim]
		,(CASE WHEN PP.year_flag ='PY' THEN tb.functional_beginning_balance ELSE 0 END) AS [Net functional amount prior]
		,0 AS [Net functional amount credit prior]
		,0 AS [Net functional amount debit prior]
		,'Beginning balance' AS [Source type]
		, pp.END_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]
	FROM dbo.TrialBalance tb
		
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calENDar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_END
			AND fc.fiscal_year_cd = pp.fiscal_year_cd

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		----INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		----LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		----LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */		

	WHERE fc.fiscal_period_seq IN 
		(
			SELECT DISTINCT pp1.fiscal_period_seq_END --MAX(pp1.fiscal_period_seq_END)  
			FROM dbo.Parameters_period pp1 
			WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
			and pp1.year_flag = pp.year_flag -- Added by prabakar on Aug 19
		)	
	AND coa.ey_account_type in ('Assets','Liabilities','Equity')
	AND pp.period_flag NOT IN ('SP')
	and  tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	UNION

	SELECT 
		tb.coa_id as [COA Id]
		,tb.period_id as [Period Id]
		,tb.bu_id
		,tb.segment1_id
		,tb.segment2_id
		,NULL AS Source_id
		,NULL AS user_listing_id
		,NULL AS approved_by_id

		--,coa.ey_account_type AS [Account Type]
		--,coa.ey_account_sub_type AS [Account Sub-type]
		--,coa.ey_account_class	  AS [Account Class]
		--,coa.ey_account_sub_class	  AS [Account Sub-class]
		--,coa.gl_account_cd AS [GL Account Code]
		--,coa.gl_account_name AS [GL Account Name]
		--,coa.ey_gl_account_name AS [GL Account]
		--,coa.ey_account_group_I AS [Account Group]

		--,bu.bu_ref AS [Business Unit]
		--,bu.bu_group as [Business unit group]

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */
		----,s1.segment_ref AS [Segment 1]
		----,s2.segment_ref AS [Segment 2]
		--,s1.ey_segment_ref AS [Segment 1]
		--,s2.ey_segment_ref AS [Segment 2]

		/* Added  below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,s1.ey_segment_group AS [Segment 1 group]
		--,s2.ey_segment_group AS [Segment 2 group]
	
		,pp.year_flag as [Year flag]
		,pp.period_flag as [Period flag]
		,CASE WHEN pp.year_flag ='CY' THEN 'Current'
			WHEN pp.year_flag ='PY' THEN 'Prior'
			WHEN pp.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc 
		END AS [Accounting period]

		,pp.period_flag_desc AS [Accounting sub period]
		,pp.fiscal_year_cd AS [Year]
		,fc.fiscal_period_cd AS [Fiscal period]

		--,NULL AS [Source group]
		--,NULL AS [Source]
		,NULL AS [Journal type]
		--,NULL AS [Preparer department]
		--,NULL AS [Preparer]

		--,NULL AS [Approver department]
		--,NULL AS [Approver]
	
		--,tb.trial_balance_start_date_id AS 'Trial Balance Start Date'
		--,tb.trial_balance_END_Date_id AS 'Trial Balance END Date'
		--,tb.Functional_beginning_balance AS 'Functional Beginning Balance'
		--,tb.Functional_ENDing_balance AS 'Functional ENDing Balance'
		,tb.Functional_curr_cd AS [Functional Currency Code]
		,tb.reporting_curr_cd AS [Reporting currency code]

	
		--,0 AS 'Calculated ENDing Balance'
		--,0 AS 'Difference between calculated ENDing and ENDing'
	
		--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		--,tb.reporting_ENDing_balance AS 'Reporting ENDing balance'

		,ROUND(ISNULL(tb.reporting_ENDing_balance,0),2) AS [Net reporting amount]
		,0 AS [Net reporting amount credit]
		,0 AS [Net reporting amount debit]



		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.reporting_ENDing_balance ELSE 0 END) AS [Net reporting amount current] 
		,0 AS [Net reporting amount credit current]
		,0 AS [Net reporting amount debit current]
		,(CASE WHEN PP.period_flag ='IP'  THEN tb.reporting_ENDing_balance ELSE 0 END) AS [Net reporting amount interim]
		,0 AS [Net reporting amount credit interim]
		,0 AS [Net reporting amount debit interim]
		,(CASE WHEN PP.year_flag ='PY'  THEN tb.reporting_ENDing_balance ELSE 0 END) AS [Net reporting amount prior]
		,0 AS [Net reporting amount credit prior]
		,0 AS [Net reporting amount debit prior]
	
		,ROUND(ISNULL(tb.functional_ENDing_balance,0),2) AS [Net functional amount]
		,0 AS [Net functional amount credit]
		,0 AS [Net functional amount debit]

		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.functional_ENDing_balance ELSE 0 END) AS [Net functional amount current]
		,0 AS [Net functional amount credit current]
		,0 AS [Net functional amount debit current]
		,(CASE WHEN PP.period_flag ='IP'  THEN tb.functional_ENDing_balance ELSE 0 END) AS [Net functional amount interim]
		,0 AS [Net functional amount credit interim]
		,0 AS [Net functional amount debit interim]
		,(CASE WHEN PP.year_flag ='PY' THEN tb.functional_ENDing_balance ELSE 0 END) AS [Net functional amount prior]
		,0 AS [Net functional amount credit prior]
		,0 AS [Net functional amount debit prior]
		,'Ending balance' AS [Source type]
		, pp.END_date AS [Period end date]
		, fc.fiscal_period_seq AS [Fiscal period sequence]
		, pp.fiscal_period_seq_END AS [Fiscal period sequence end]
	FROM dbo.TrialBalance tb
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calENDar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_year_cd = pp.fiscal_year_cd
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		----INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		----LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		----LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
	WHERE coa.ey_account_type IN ('Assets','Liabilities','Equity')
	AND pp.period_flag NOT IN ('SP')
	and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
	--		AND fc.fiscal_period_seq = pp.fiscal_period_seq_END
	--WHERE fc.fiscal_period_seq IN 
	--	(
	--		SELECT DISTINCT pp1.fiscal_period_seq_END --MAX(pp1.fiscal_period_seq_END)  
	--		FROM dbo.Parameters_period pp1 
	--		WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
	--	)
	

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_002_Income_Statement]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_002_Income_Statement]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_002_Income_Statement] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL_002_Income_Statement]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_002_Income_Statement]
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table [GL_002_Income_Statement] and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE [GL_002_Income_Statement]

	
	INSERT INTO dbo.[GL_002_Income_Statement]
	(
		COA_Id
		,Period_Id
		,BU_ID
		,Segment_1_id
		,Segment_2_id
		,Source_id
		,user_listing_id
		,approved_by_id
		,Year_flag
		,Period_flag
		,Accounting_period
		,Accounting_sub_period
		,[Year]
		,Fiscal_period
		,Journal_type
		,Functional_Currency_Code
		,Reporting_currency_code
		,Net_reporting_amount
		,Net_reporting_amount_credit
		,Net_reporting_amount_debit
		,Net_reporting_amount_current
		,Net_reporting_amount_credit_current
		,Net_reporting_amount_debit_current
		,Net_reporting_amount_interim
		,Net_reporting_amount_credit_interim
		,Net_reporting_amount_debit_interim
		,Net_reporting_amount_prior
		,Net_reporting_amount_credit_prior
		,Net_reporting_amount_debit_prior
		,Net_functional_amount
		,Net_functional_amount_credit
		,Net_functional_amount_debit
		,Net_functional_amount_current
		,Net_functional_amount_credit_current
		,Net_functional_amount_debit_current
		,Net_functional_amount_interim
		,Net_functional_amount_credit_interim
		,Net_functional_amount_debit_interim
		,Net_functional_amount_prior
		,Net_functional_amount_credit_prior
		,Net_functional_amount_debit_prior
		,Source_type
		,Period_end_date
	)
	
	SELECT 
		ft.coa_id
		,ft.period_id
		,ft.BU_ID
		,ft.Segment1_id
		,ft.Segment2_id
		,ft.Source_id
		,ft.user_listing_id
		,ft.approved_by_id

		--,coa.ey_account_type AS [Account Type]
		--,coa.ey_account_sub_type AS [Account Sub-type]
		--,coa.ey_account_class	  AS [Account Class]
		--,coa.ey_account_sub_class	  AS [Account Sub-class]
		--,coa.gl_account_cd AS [GL Account Code]
		--,coa.gl_account_name AS [GL Account Name]
		--,coa.ey_gl_account_name AS [GL Account]
		--,coa.ey_account_group_I AS [Account Group]

		--,bu.bu_ref AS [Business Unit]
		--,bu.bu_group AS [Business unit group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	

		----,S1.segment_ref AS [Segment 1]
		----,s2.segment_ref AS [Segment 2]
		--,S1.ey_segment_ref AS [Segment 1]
		--,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

		--,s1.ey_segment_group AS [Segment 1 group]
		--,s2.ey_segment_group AS [Segment 2 group]
		,ft.year_flag
		,ft.period_flag
		,CASE  WHEN ft.year_flag ='CY' THEN 'Current'
			WHEN ft.year_flag ='PY' THEN 'Prior'
			WHEN ft.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc 
		END AS [Accounting_period]

		,pp.period_flag_desc
		,pp.fiscal_year_cd
		,ft.ey_period 
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		----,ds.ey_source_group AS [Source group]
		----,ds.Source_Ref AS [Source]
		--,src.source_group AS [Source group]
		--,src.Source_Ref AS [Source]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		,ft.journal_type
		--,dp.department AS [Preparer department]
		--,dp.preparer_Ref AS [Preparer]

		--,dp1.department AS [Approver department]
		--,dp1.preparer_ref AS [Approver]
	
		----,tb.trial_balance_start_date_id AS [Trial Balance Start Date'
		----,tb.trial_balance_END_Date_id AS [Trial Balance END Date'
		----,tb.Functional_beginning_balance AS [Functional Beginning Balance'
		----,tb.Functional_ENDing_balance AS [Functional ENDing Balance'
		,ft.functional_amount_curr_cd
		,ft.reporting_amount_curr_cd

	
		--,0 AS [Calculated ENDing Balance'
		--,0 AS [Difference between calculated ENDing and ENDing'
	
		--,tb.reporting_beginning_balance AS [Reporting beginning balance'
		--,tb.reporting_ENDing_balance AS [Reporting ENDing balance'

		,ROUND(SUM(ISNULL(ft.Net_reporting_amount,0)),2) AS [Net reporting amount]
		,ROUND(SUM(ISNULL(ft.Net_reporting_amount_credit,0)),2) AS [Net reporting amount credit]
		,ROUND(SUM(ISNULL(ft.Net_reporting_amount_debit,0)),2) AS [Net reporting amount debit]

		/* All condition below has been updated based on the discussion with Amod
			pp.year_flag_desc = 'Current ' is replaced with pp.year_flag = 'CY' 
			pp.year_flag_desc = 'Interim ' is replaced with PP.period_flag = 'IP'
			pp.year_flag_desc = 'Prior ' is replaced with  PP.year_flag ='PY' 
		*/

		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_reporting_amount ELSE 0 END) AS [Net reporting amount current] 
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_reporting_amount_credit ELSE 0 END) AS [Net reporting amount credit current]
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_reporting_amount_debit ELSE 0 END) AS [Net reporting amount debit current]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_reporting_amount ELSE 0 END) AS [Net reporting amount interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_reporting_amount_credit ELSE 0 END) AS [Net reporting amount credit interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_reporting_amount_debit ELSE 0 END) AS [Net reporting amount debit interim]
		,SUM(CASE WHEN PP.year_flag ='PY'  THEN ft.Net_reporting_amount ELSE 0 END) AS [Net reporting amount prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_reporting_amount_credit ELSE 0 END) AS [Net reporting amount credit prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_reporting_amount_debit ELSE 0 END) AS [Net reporting amount debit prior]
	
		,ROUND(SUM(ISNULL(ft.Net_functional_amount,0)),2) AS [Net functional amount]
		,ROUND(SUM(ISNULL(ft.Net_functional_credit_amount,0)),2) AS [Net functional amount credit]
		,ROUND(SUM(ISNULL(ft.Net_functional_debit_amount,0)),2) AS [Net functional amount debit]

		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_functional_amount ELSE 0 END) AS [Net functional amount current]
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_functional_credit_amount ELSE 0 END) AS [Net functional amount credit current]
		,SUM(CASE WHEN pp.year_flag = 'CY'  THEN ft.Net_functional_debit_amount ELSE 0 END) AS [Net functional amount debit current]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_functional_amount ELSE 0 END) AS [Net functional amount interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_functional_credit_amount ELSE 0 END) AS [Net functional amount credit interim]
		,SUM(CASE WHEN PP.period_flag = 'IP' THEN ft.Net_functional_debit_amount ELSE 0 END) AS [Net functional amount debit interim]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_functional_amount ELSE 0 END) AS [Net functional amount prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_functional_credit_amount ELSE 0 END) AS [Net functional amount credit prior]
		,SUM(CASE WHEN PP.year_flag ='PY' THEN ft.Net_functional_debit_amount ELSE 0 END) AS [Net functional amount debit prior]
		,'Activity' AS [Source type]
		,pp.END_date AS [Period end date]
	FROM dbo.Ft_JE_Amounts ft 
		INNER JOIN dbo.Parameters_period PP on PP.year_flag = ft.year_flag
			AND PP.period_flag = ft.period_flag
		INNER JOIN dbo.DIM_Chart_of_Accounts coa ON coa.Coa_id = ft.coa_id
			AND coa.Coa_id = ft.coa_id
		--INNER JOIN dbo.Dim_Preparer dp	on dp.user_listing_id = ft.user_listing_id
		--INNER JOIN dbo.Dim_Preparer dp1	on dp1.user_listing_id = ft.approved_by_id
		--/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		----INNER JOIN dbo.Dim_BU bu ON ft.bu_id =bu.bu_id
		----INNER JOIN dbo.DIM_Source_listing ds	ON ds.source_id = ft.source_id
		----INNER JOIN dbo.Dim_Segment01_listing S1 on S1.segment_id = ft.segment1_id
		----INNER JOIN dbo.Dim_Segment02_listing S2 on S2.segment_id = ft.segment2_id

		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = ft.bu_id
		--LEFT OUTER JOIN dbo.v_Source_listing Src on src.source_id = ft.source_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = ft.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = ft.segment2_id

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- END */	
	WHERE coa.ey_account_type in ('Revenue','Expenses')
	/* commented the fiscl period since this is going off - prabakar tr */
	--INNER JOIN dbo.Dim_Fiscal_Period df
	--	ON  df.period_id =tb.period_id 
	--	AND df.bu_id = tb.bu_id
		/* commented the fiscl period since this is going off - prabakar tr */

	--where df.fiscal_period_seq  = 12
								-- (
						
								--	select max(df1.fiscal_period_seq) 
								--	from dbo.Dim_Fiscal_Period df1 
								--	where df1.fiscal_year_cd = df.fiscal_year_cd
								--	and df1.bu_id = df.bu_id
								--)
	
	--and pp.year_flag_desc is not null
	--AND tb.coa_id =9312
	--AND df.fiscal_year_cd = 2013

	GROUP BY
		ft.coa_id
		,ft.period_id

		,ft.BU_ID
		,ft.Segment1_id
		,ft.Segment2_id
		,ft.Source_id
		,ft.user_listing_id
		,ft.approved_by_id

		--,coa.ey_account_type
		--,coa.ey_account_sub_type
		--,coa.ey_account_class
		--,coa.ey_account_sub_class
		--,coa.gl_account_cd
		--,coa.gl_account_name
		--,coa.ey_gl_account_name
		--,coa.ey_account_group_I
		--,bu.bu_ref
		--,bu.bu_group
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		----,S1.segment_ref
		----,s2.segment_ref
		--,S1.ey_segment_ref
		--,s2.ey_segment_ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		--,s1.ey_segment_group
		--,s2.ey_segment_group
		,ft.year_flag
		,ft.period_flag
		,pp.year_flag_desc
		,pp.period_flag_desc
		,pp.fiscal_year_cd
		,ft.ey_period
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- begin */	
		--,src.source_group
		--,src.Source_Ref
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		,ft.journal_type
		--,dp.department
		--,dp.preparer_Ref
		--,dp1.department
		--,dp1.preparer_ref
		,pp.END_date
		,ft.functional_amount_curr_cd 
		,ft.reporting_amount_curr_cd 


	UNION

	SELECT 
		tb.coa_id 
		,tb.period_id 
		,tb.BU_ID
		,tb.Segment1_id
		,tb.Segment2_id
		,NULL AS Source_id
		,NULL AS user_listing_id
		,NULL AS approved_by_id

		--,coa.ey_account_type AS [Account Type]
		--,coa.ey_account_sub_type AS [Account Sub-type]
		--,coa.ey_account_class	  AS [Account Class]
		--,coa.ey_account_sub_class	  AS [Account Sub-class]
		--,coa.gl_account_cd AS [GL Account Code]
		--,coa.gl_account_name AS [GL Account Name]
		--,coa.ey_gl_account_name AS [GL Account]
		--,coa.ey_account_group_I AS [Account Group]

		--,bu.bu_ref AS [Business Unit]
		--,bu.bu_group AS [Business unit group]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		----,s1.segment_ref AS [Segment 1]
		----,s2.segment_ref AS [Segment 2]
		--,s1.ey_segment_ref AS [Segment 1]
		--,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
		--,s1.ey_segment_group AS [Segment 1 group]
		--,s2.ey_segment_group AS [Segment 2 group]
	
		,pp.year_flag 
		,pp.period_flag 
		,CASE WHEN pp.year_flag ='CY' THEN 'Current'
			WHEN pp.year_flag ='PY' THEN 'Prior'
			WHEN pp.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc 
		END 

		,pp.period_flag_desc
		,pp.fiscal_year_cd 
		,fc.fiscal_period_cd 

		--,NULL AS [Source group]
		--,NULL AS [Source]
		,NULL AS [Journal_type]
		--,NULL AS [Preparer department]
		--,NULL AS [Preparer]

		--,NULL AS [Approver department]
		--,NULL AS [Approver]
	
		----,tb.trial_balance_start_date_id AS [Trial Balance Start Date'
		----,tb.trial_balance_END_Date_id AS [Trial Balance END Date'
		----,tb.Functional_beginning_balance AS [Functional Beginning Balance'
		----,tb.Functional_ENDing_balance AS [Functional ENDing Balance'
		,tb.Functional_curr_cd 
		,tb.reporting_curr_cd

	
		--,0 AS [Calculated ENDing Balance'
		--,0 AS [Difference between calculated ENDing and ENDing'
	
		--,tb.reporting_beginning_balance AS [Reporting beginning balance'
		--,tb.reporting_ENDing_balance AS [Reporting ENDing balance'

		,ROUND(ISNULL(tb.reporting_beginning_balance,0),2) AS [Net reporting amount]
		,0 AS [Net reporting amount credit]
		,0 AS [Net reporting amount debit]
		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.reporting_beginning_balance ELSE 0 END) AS [Net reporting amount current]
		,0 AS [Net reporting amount credit current]
		,0 AS [Net reporting amount debit current]
		,0 AS [Net reporting amount interim]
		,0 AS [Net reporting amount credit interim]
		,0 AS [Net reporting amount debit interim]
		,(CASE WHEN PP.year_flag ='PY'  THEN tb.reporting_beginning_balance ELSE 0 END) AS [Net reporting amount prior]
		,0 AS [Net reporting amount credit prior]
		,0 AS [Net reporting amount debit prior]
		,ROUND(ISNULL(tb.functional_beginning_balance,0),2) AS [Net functional amount]
		,0 AS [Net functional amount credit]
		,0 AS [Net functional amount debit]
		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.functional_beginning_balance ELSE 0 END) AS [Net functional amount current]
		,0 AS [Net functional amount credit current]
		,0 AS [Net functional amount debit current]
		,0 AS [Net functional amount interim]
		,0 AS [Net functional amount credit interim]
		,0 AS [Net functional amount debit interim]
		,(CASE WHEN PP.year_flag ='PY' THEN tb.functional_beginning_balance ELSE 0 END) AS [Net functional amount prior]
		,0 AS [Net functional amount credit prior]
		,0 AS [Net functional amount debit prior]
		,'Beginning balance' AS [Source type]
		,pp.END_date AS [Period end date]
	FROM dbo.TrialBalance tb
		
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calENDar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_END
			AND fc.fiscal_year_cd = pp.fiscal_year_cd
		--/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		----INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		----LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		----LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		--/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	

	WHERE fc.fiscal_period_seq = (
						SELECT MAX(pp1.fiscal_period_seq_END) 
						FROM dbo.Parameters_period pp1 
						WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
						and pp1.year_flag = pp.year_flag -- Added by prabakar on Aug 19 2014 
		)
		AND coa.ey_account_type in ('Revenue','Expenses')

	UNION

	SELECT 
		tb.coa_id  
		,tb.period_id 
		,tb.BU_ID
		,tb.Segment1_id
		,tb.Segment2_id
		,NULL AS Source_id
		,NULL AS user_listing_id
		,NULL AS approved_by_id

		--,coa.ey_account_type AS [Account Type]
		--,coa.ey_account_sub_type AS [Account Sub-type]
		--,coa.ey_account_class	  AS [Account Class]
		--,coa.ey_account_sub_class	  AS [Account Sub-class]
		--,coa.gl_account_cd AS [GL Account Code]
		--,coa.gl_account_name AS [GL Account Name]
		--,coa.ey_gl_account_name AS [GL Account]
		--,coa.ey_account_group_I AS [Account Group]

		--,bu.bu_ref AS [Business Unit]
		--,bu.bu_group AS [Business unit group]

		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */	
		----,s1.segment_ref AS [Segment 1]
		----,s2.segment_ref AS [Segment 2]
		--,s1.ey_segment_ref AS [Segment 1]
		--,s2.ey_segment_ref AS [Segment 2]
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		--,s1.ey_segment_group AS [Segment 1 group]
		--,s2.ey_segment_group AS [Segment 2 group]
	
		,pp.year_flag  
		,pp.period_flag  
		,CASE WHEN pp.year_flag ='CY' THEN 'Current'
			WHEN pp.year_flag ='PY' THEN 'Prior'
			WHEN pp.year_flag ='SP' THEN 'Subsequent'
			ELSE pp.year_flag_desc 
		END  

		,pp.period_flag_desc  
		,pp.fiscal_year_cd  
		,fc.fiscal_period_cd  

		--,NULL AS [Source group]
		--,NULL AS [Source]
		,NULL AS [Journal_type]
		--,NULL AS [Preparer department]
		--,NULL AS [Preparer]

		--,NULL AS [Approver department]
		--,NULL AS [Approver]
	
		--,tb.trial_balance_start_date_id AS [Trial Balance Start Date'
		--,tb.trial_balance_END_Date_id AS [Trial Balance END Date'
		--,tb.Functional_beginning_balance AS [Functional Beginning Balance'
		--,tb.Functional_ENDing_balance AS [Functional ENDing Balance'
		,tb.Functional_curr_cd  
		,tb.reporting_curr_cd  

	
		--,0 AS [Calculated ENDing Balance'
		--,0 AS [Difference between calculated ENDing and ENDing'
	
		--,tb.reporting_beginning_balance AS [Reporting beginning balance'
		--,tb.reporting_ENDing_balance AS [Reporting ENDing balance'

		,ROUND(ISNULL(tb.reporting_ENDing_balance,0),2) AS [Net reporting amount]
		,0 AS [Net reporting amount credit]
		,0 AS [Net reporting amount debit]
		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.reporting_ENDing_balance ELSE 0 END) AS [Net reporting amount current]
		,0 AS [Net reporting amount credit current]
		,0 AS [Net reporting amount debit current]
		,0 AS [Net reporting amount interim]
		,0 AS [Net reporting amount credit interim]
		,0 AS [Net reporting amount debit interim]
		,(CASE WHEN PP.year_flag ='PY'  THEN tb.reporting_ENDing_balance ELSE 0 END) AS [Net reporting amount prior]
		,0 AS [Net reporting amount credit prior]
		,0 AS [Net reporting amount debit prior]
		,ROUND(ISNULL(tb.functional_ENDing_balance,0),2) AS [Net functional amount]
		,0 AS [Net functional amount credit]
		,0 AS [Net functional amount debit]
		,(CASE WHEN pp.year_flag = 'CY'  THEN tb.functional_ENDing_balance ELSE 0 END) AS [Net functional amount current]
		,0 AS [Net functional amount credit current]
		,0 AS [Net functional amount debit current]
		,0 AS [Net functional amount interim]
		,0 AS [Net functional amount credit interim]
		,0 AS [Net functional amount debit interim]
		,(CASE WHEN PP.year_flag ='PY' THEN tb.functional_ENDing_balance ELSE 0 END) AS [Net functional amount prior]
		,0 AS [Net functional amount credit prior]
		,0 AS [Net functional amount debit prior]
		,'Ending balance' AS [Source type]
		,pp.END_date AS [Period end date]
	FROM dbo.TrialBalance tb
		INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
		INNER JOIN dbo.Dim_Fiscal_calENDar fc ON tb.period_id = fc.period_id
		INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_END
			AND fc.fiscal_year_cd = pp.fiscal_year_cd
		--/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		----INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		----LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		----LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		--/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */	
	WHERE fc.fiscal_period_seq = (
					SELECT MAX(pp1.fiscal_period_seq_END) 
					FROM dbo.Parameters_period pp1 
					WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
					and pp1.year_flag = pp.year_flag -- Added by prabakar on Aug 19 2014 
				)
		AND  coa.ey_account_type in ('Revenue','Expenses')

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_004_Cashflow_Analysis]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_004_Cashflow_Analysis]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_004_Cashflow_Analysis] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL005_Agg_GL_Account]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_004_Cashflow_Analysis]
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table GL_004_Cashflow_Analysis and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE dbo.GL_004_Cashflow_Analysis

	--INSERT INTO DBO.Agg_GL_Account 
	INSERT INTO dbo.GL_004_Cashflow_Analysis
	(
		coa_id
		,bu_id
		,source_id
		,segment1_id
		,segment2_id
		,user_listing_id
		,approved_by_id
		,year_flag
		,period_flag
		,ey_period
		,sys_man_ind
		,journal_type
		,functional_curr_cd
		,reporting_curr_cd
		,source_type
		,net_reporting_amount
		,net_reporting_amount_credit
		,net_reporting_amount_debit
		,net_functional_amount
		,net_functional_amount_credit
		,net_functional_amount_debit
	)
	
	Select 
		f.coa_id				-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,f.bu_id-- Prabakar 23Jun2014: added on Stu's requirement for GL004
		,f.source_id 
		,f.segment1_id 
		,f.segment2_id 
		,F.user_listing_id	-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,f.approved_by_id 
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.year_flag
		,f.period_flag
		,f.EY_period  
		,f.Sys_man_ind 				-- [Manish]24Jun2014: added on Stu's requirement for GL004
		,f.journal_type 
		,f.functional_curr_cd 
		,f.reporting_amount_curr_cd 

		,'Activity' AS [Source_Type]
		,SUM(f.net_reporting_amount) 
		,SUM(f.net_reporting_amount_credit) 
		,SUM(f.net_reporting_amount_debit) 

		,SUM(f.net_functional_amount) 
		,SUM(f.net_functional_amount_credit) 
		,SUM(f.net_functional_amount_debit) 

	
	FROM dbo.FT_GL_Account F
	GROUP BY
 		f.coa_id					-- [Manish]19Jun2014: added on Stu's requirement for GL004
		,f.bu_id
		-- Added source id, segment 1 id , segment 2 id by prabakar AS per discussion with Tim
		,f.source_id
		,f.segment1_id
		,f.segment2_id
		,F.user_listing_id			-- [Manish]23Jun2014: added on Stu's requirement for GL004
		,f.approved_by_id
		,f.year_flag
		,f.period_flag
		,f.EY_period
		,f.sys_man_ind
		,f.journal_type
		,f.functional_curr_cd
		,f.reporting_amount_curr_cd

	UNION
		SELECT  
			tb.coa_id								-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,tb.bu_id
			,0 AS [Source_id]
			,tb.segment1_id 
			,tb.segment2_id 
			,0 AS [user_listing_id]	
			,0 AS [approved_by_id]
			,pp.year_flag
			,pp.period_flag
			,fc.fiscal_period_cd AS [ey_period]
			,'N/A for balances'		AS [sys_man_ind]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS  [journal_type]
			,tb.functional_curr_cd  
			,tb.reporting_curr_cd 
			,'Beginning balance' AS [Source_Type]
			,tb.reporting_beginning_balance  
			,0.0 AS [Net_reporting_amount_credit]
			,0.0 AS [Net_reporting_amount_debit]
			,tb.functional_beginning_balance  
			,0.0 AS [Net_functional_amount_credit]
			,0.0 AS [Net_functional_amount_debit]
		FROM dbo.TrialBalance tb
			
			--INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd
			
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		----INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		----LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		----LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */

		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end) 
								FROM dbo.Parameters_period pp1 
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								and pp1.year_flag=pp.year_flag  -- added by prabakar on Aug 19
							)
		and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd

	UNION
		
		SELECT  
			tb.coa_id								-- [Manish]19Jun2014: added on Stu's requirement for GL004
			,tb.bu_id
			,0 AS [Source_id]
			,tb.segment1_id 
			,tb.segment2_id 
			,0 AS [user_listing_id]	
			,0 AS [approved_by_id]
			,pp.year_flag
			,pp.period_flag
			,fc.fiscal_period_cd AS [ey_period]
			,'N/A for balances'		AS [sys_man_ind]					-- [Manish]24Jun2014: added on Stu's requirement for GL004
			,'N/A for balances' AS [journal_type]
			,tb.functional_curr_cd  
			,tb.reporting_curr_cd 
			,'Ending balance' AS [Source_Type]

			,TB.reporting_ending_balance  

			,0.0 AS [Net_reporting_amount_credit]
			,0.0 AS [Net_reporting_amount_debit]
			,tb.functional_ending_balance
			,0.0 AS [Net_functional_amount_credit]
			,0.0 AS [Net_functional_amount_debit]
			
		FROM dbo.TrialBalance tb
			
			--INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd
			
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- Begin */		
		----INNER JOIN  dim_bu bu on tb.bu_id = bu.bu_id
		----LEFT OUTER JOIN  Dim_Segment01_listing s1  on s1.segment_id = tb.segment1_id
		----LEFT OUTER JOIN  Dim_Segment02_listing s2 on s2.segment_id = tb.segment2_id
		--LEFT OUTER JOIN dbo.v_Business_unit_listing Bu on bu.bu_id = tb.bu_id
		--LEFT OUTER JOIN dbo.v_Segment01_listing S1 on s1.ey_segment_id = tb.segment1_id
		--LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = tb.segment2_id
		/* Commented and Added below dynamic views to bring the data of bu, segment, source by Prabakar -- end */
		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end) 
								FROM dbo.Parameters_period pp1 
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								and pp1.year_flag = pp.year_flag  -- added by prabakar on Aug 19
								)
		and  tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_007_Significant_Acct]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_007_Significant_Acct]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_007_Significant_Acct] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL_007_Significant_Acct]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_007_Significant_Acct]
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table GL_007_Significant_Acct and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE GL_007_Significant_Acct

	--INSERT INTO DBO.GL_007_Significant_Acct 
	INSERT INTO dbo.GL_007_Significant_Acct
	(

		coa_id
		,bu_id
		,source_id
		,segment1_id
		,segment2_id
		,user_listing_id
		,approved_by_id
		,year_flag
		,period_flag
		,EY_period 
		,journal_type
		,reporting_curr_cd 
		,functional_curr_cd 
		,source_type
		,current_amount
		,prior_amount
		,count_of_je_line_items
		,count_of_manual_je_lines
		,manual_amount
		,manual_functional_amount
		,count_ofdistinct_preparers
		,total_debit_activity
		,largest_line_item
		,largest_functional_line_item
		,total_credit_activity
		,net_reporting_amount
		,net_reporting_amount_credit
		,net_reporting_amount_debit
		,net_functional_amount
		,net_functional_amount_credit
		,net_functional_amount_debit
		,functional_ending_balance
		,reporting_ending_balance
		,net_functional_amount_current
		,net_functional_amount_prior
		,net_reporting_amount_current
		,net_reporting_amount_prior
	)
	SELECT 
       
		FJ.coa_id
		,FJ.bu_id
		,FJ.source_id
		,FJ.segment1_id
		,FJ.segment2_id
		,FJ.user_listing_id
		,FJ.approved_by_id
		,FJ.year_flag
		,FJ.period_flag
		,FJ.EY_period  
		,FJ.journal_type AS [Journal type]
		
		,FJ.reporting_amount_curr_cd AS [Reporting currency code]
		,FJ.functional_curr_cd AS [Functional currency code]
		,'Activity' as [Source Type]

		,SUM(CASE  WHEN FJ.year_flag ='CY' THEN  FJ.amount ELSE 0 END) AS [Current Amount]
		,SUM(CASE  WHEN FJ.year_flag ='PY' THEN  FJ.amount ELSE 0 END) AS [Prior Amount]

		,COUNT(FJ.je_line_id) as [# of JE Line Items]
       
		,SUM(CASE WHEN FJ.sys_manual_ind IN ('U','M') THEN 1 ELSE 0 END) as [# of Manual JE Lines]
		,SUM(CASE WHEN FJ.sys_manual_ind IN ('U','M') THEN ROUND(ISNULL(FJ.AMOUNT,0),2) ELSE 0 END) as [Manual Amount ($)]
		,SUM(CASE WHEN FJ.sys_manual_ind IN ('U','M') THEN ROUND(ISNULL(FJ.functional_amount,0),2) ELSE 0 END) as [Manual Functional Amount]

		,COUNT(DISTINCT FJ.user_listing_id) as [# of Distinct Preparers]
		,SUM(ROUND(FJ.amount_debit,2)) as [Total Debit Activity]
       
		,MAX(ABS(FJ.reporting_amount))as [Largest Line Item]
		,MAX(ABS(FJ.functional_amount)) AS [Largest functional line item]
		,SUM(ROUND(FJ.reporting_amount_credit,2)) as [Total Credit Activity]

		,SUM(FJ.reporting_amount) AS [Net reporting amount]
		,SUM(FJ.reporting_amount_credit) AS [Net reporting amount credit]
		,SUM(FJ.reporting_amount_debit) AS [Net reporting amount debit]
       
		,SUM(FJ.functional_amount) AS [Net functional amount]
		,SUM(FJ.functional_credit_amount) AS [Net functional amount credit]
		,SUM(FJ.functional_debit_amount) AS [Net functional amount debit]

		--,tb.functional_beginning_balance AS 'Functional beginning balance'
		,0.0 AS [Functional ending balance]
		--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
		,0.0 AS [Reporting ending balance]

		,SUM(CASE  WHEN FJ.year_flag ='CY' THEN  FJ.functional_amount ELSE 0 END) AS [Net functional amount current]
		,SUM(CASE  WHEN FJ.year_flag ='PY' THEN  FJ.functional_amount ELSE 0 END) AS [Net functional amount prior]

		,SUM(CASE  WHEN FJ.year_flag ='CY' THEN  FJ.reporting_amount ELSE 0 END) AS [Net reporting amount current]
		,SUM(CASE  WHEN FJ.year_flag ='PY' THEN  FJ.reporting_amount ELSE 0 END) AS [Net reporting amount prior]

       
	FROM dbo.FLAT_JE FJ  -- dbo.ft_je_amounts
	WHERE year_flag = 'CY'
	GROUP BY 

		FJ.coa_id
		,FJ.bu_id
		,FJ.source_id
		,FJ.segment1_id
		,FJ.segment2_id
		,FJ.user_listing_id
		,FJ.approved_by_id
		,FJ.year_flag
		,FJ.period_flag
		,FJ.EY_period 
		,FJ.journal_type 
		,FJ.reporting_amount_curr_cd 
		,FJ.functional_curr_cd 
		


	UNION
		SELECT  
            
			tb.coa_id
			,tb.bu_id
			,0 as [Source_id]
			,tb.segment1_id
			,tb.segment2_id
			,0 as [user_listing_id]
			,0 as [approved_by_id]
			,PP.year_flag
			,PP.period_flag 
			,fc.fiscal_period_cd 
			,'N/A for balances' AS [Journal_type]
			,tb.reporting_curr_cd 
			,tb.functional_curr_cd
			,'Beginning balance' as [Source_Type]
			,NULL AS [Current Amount]
			,NULL AS [Prior Amount]
			,NULL AS [# of JE Line Items]
			,NULL as [# of Manual JE Lines]
			,NULL as [Manual Amount ($)]
			,NULL as [Manual Functional Amount]
			,NULL as [# of Distinct Preparers]
			,NULL as [Total Debit Activity]
			,NULL as [Largest Line Item]
			,NULL AS [Largest functional line item]
			,NULL as [Total Credit Activity]
			--,MAX(TB.reporting_ending_balance) as 'MAX by Month End'
			--,MAX(tb.functional_ending_balance) AS 'Max functional by month end'
			,tb.reporting_beginning_balance AS [Net reporting amount]
			,NULL AS [Net reporting amount credit]
			,NULL AS [Net reporting amount debit]
			,tb.functional_beginning_balance AS [Net functional amount]
			,NULL AS [Net functional amount credit]
			,NULL AS [Net functional amount debit]

			--,tb.functional_beginning_balance AS 'Functional beginning balance'
			,tb.functional_ending_balance AS [Functional ending balance]
			--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
			,tb.reporting_ending_balance AS [Reporting ending balance]

			,NULL AS [Net functional amount current]
			,NULL AS [Net functional amount prior]

			,NULL AS [Net reporting amount current]
			,NULL AS [Net reporting amount prior]
	
             FROM dbo.TrialBalance tb
                     INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id 
                     INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
                     INNER JOIN dbo.Parameters_period pp   ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
                           AND fc.fiscal_year_cd = pp.fiscal_year_cd
	      WHERE year_flag IN ('CY','PY')
			  AND tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
			  AND fc.fiscal_period_seq = (
									SELECT MAX(pp1.fiscal_period_seq_end) 
                                    FROM dbo.Parameters_period pp1 
                                    WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
									AND pp1.year_flag = PP.year_flag -- added by prabakar on july 30
									)

	UNION
			SELECT  
				tb.coa_id
				,tb.bu_id
				,0 as [Source_id]
				,tb.segment1_id
				,tb.segment2_id
				,0 as [user_listing_id]
				,0 as [approved_by_id]
				,PP.year_flag
				,PP.period_flag 
				,fc.fiscal_period_cd 
				,'N/A for balances' AS [Journal_type]
				,tb.reporting_curr_cd 
				,tb.functional_curr_cd
				,'Ending balance' as [Source Type]

				,NULL AS [Current Amount]
				,NULL AS [Prior Amount]

				,NULL AS [# of JE Line Items]

				,NULL as [# of Manual JE Lines]
				,NULL as [Manual Amount ($)]
				,NULL as [Manual Functional Amount]


				,NULL as [# of Distinct Preparers]
				,NULL as [Total Debit Activity]

				,NULL as [Largest Line Item]
				,NULL AS [Largest functional line item]
				,NULL as [Total Credit Activity]
				--,MAX(TB.reporting_ending_balance) as 'MAX by Month End'
				--,MAX(tb.functional_ending_balance) AS 'Max functional by month end'

				,tb.reporting_ending_balance AS [Net reporting amount]
				,NULL AS [Net reporting amount credit]
				,NULL AS [Net reporting amount debit]

				,tb.functional_ending_balance AS [Net functional amount]
				,NULL AS [Net functional amount credit]
				,NULL AS [Net functional amount debit]

				--,tb.functional_beginning_balance AS 'Functional beginning balance'
				,tb.functional_ending_balance AS [Functional ending balance]
				--,tb.reporting_beginning_balance AS 'Reporting beginning balance'
				,tb.reporting_ending_balance AS [Reporting ending balance]

				,NULL AS [Net functional amount current]
				,NULL AS [Net functional amount prior]

				,NULL AS [Net reporting amount current]
				,NULL AS [Net reporting amount prior]

              FROM dbo.TrialBalance tb
                     INNER JOIN dbo.DIM_Chart_of_Accounts coa on coa.Coa_id = tb.coa_id
                     INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
                     INNER JOIN dbo.Parameters_period pp   ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
                           AND fc.fiscal_year_cd = pp.fiscal_year_cd
              WHERE year_flag IN ('CY','PY')
			  and tb.ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
			  AND fc.fiscal_period_seq = (
                                    SELECT MAX(pp1.fiscal_period_seq_end) 
                                    FROM dbo.Parameters_period pp1 
                                    WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
									and pp1.year_flag = pp.year_flag -- added by prabakar on july 30
									)



END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_008_JE_Search]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_008_JE_Search]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_008_JE_Search] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL005_Agg_GL_Account]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_008_JE_Search]
History:		
V2			20141009		MSH		Table reference change - performance improvements
************************************************************************************************************************************************/
BEGIN

/* USE the latest table GL_008_JE_Search and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE GL_008_JE_Search

	--INSERT INTO DBO.Agg_GL_Account 
	INSERT INTO dbo.GL_008_JE_Search
	(
		Journal_entry_id
		,Journal_entry_line
		,Journal_entry_description
		,Journal_entry_type
		,Reporting_amount
		,Functional_amount
		,Journal_line_description
		,Year_flag
		,Period_flag
		,Bu_id
		,Segment1_id
		,Segment2_id
		,Source_id	
		,User_listing_id
		,Journal_type	
		,ey_period
		
		
	)
	
	SELECT 
		--DISTINCT -- Commneted by prabakar since Je_id and Je_line_id
		je_id 
		,je_line_id 
		,je_header_desc 
		,journal_type
		,reporting_amount
		,functional_amount
		,je_line_desc 
		,Year_flag
		,Period_flag
		,Bu_id
		,Segment1_id
		,Segment2_id
		,Source_id	
		,User_listing_id
		,Journal_type	
		,ey_period
		
	FROM dbo.flat_je
	WHERE ver_end_date_id IS NULL  -- added by prabakar on july 2nd to pull the latest version only

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_008_JE_Search_Amount]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_008_JE_Search_Amount]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_008_JE_Search_Amount] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL_008_JE_Search_Amount]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_008_JE_Search_Amount]
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table GL_005_Agg_GL_Account and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE GL_008_JE_Search_Amount
	
	INSERT INTO dbo.GL_008_JE_Search_Amount
	(
		Journal_entry_id
		,Journal_entry_line
		,Journal_entry_description
		,Journal_entry_type
		,Reporting_amount
		,Functional_amount
	)
	SELECT DISTINCT 
		je_id AS [Journal Entry Id]
		,je_line_id AS [Journal Entry Line]
		,je_header_desc AS [Journal Entry Description]
		--,sys_manual_ind AS [Journal Entry Type]
		,journal_type AS [Journal Entry Type]
		, reporting_amount AS [Reporting Amount]
		, functional_amount AS [Functional Amount]
	FROM dbo.flat_je
	WHERE ver_end_date_id IS NULL  -- added by prabakar on july 2nd to pull the latest version only

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_008_JE_Search_Description]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_008_JE_Search_Description]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_008_JE_Search_Description] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL_008_JE_Search_Description]
Script Date:	17/06/2014
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_008_JE_Search_Description]
History:		
************************************************************************************************************************************************/
BEGIN

/* USE the latest table GL_008_JE_Search_Description and update the sp accordingly by prabakar - action item required */
	TRUNCATE TABLE GL_008_JE_Search_Description

	
	INSERT INTO dbo.GL_008_JE_Search_Description
	(
		Journal_entry_id
		,Journal_entry_line 
		,Journal_line_description -- added by prabakar on july 28
		,Journal_entry_description
		,Journal_entry_type
	)
	SELECT DISTINCT 
		je_id 
		,je_line_id 
		,je_line_desc -- added by prabakar on july 28
		,je_header_desc 
		,journal_type 
	FROM dbo.flat_je
	WHERE ver_end_date_id IS NULL  -- added by prabakar on july 2nd to pull the latest version only

END  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_GL_016_Balance_by_GL]')) Drop PROCEDURE [dbo].[PROC_Refresh_Data_GL_016_Balance_by_GL]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Data_GL_016_Balance_by_GL] 
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [GL_016_Balance_by_GL]
Script Date:	08/21/2014
Created By:		AO
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_GL_016_Balance_by_GL]
History:		
************************************************************************************************************************************************/
BEGIN

	TRUNCATE TABLE dbo.GL_016_Balance_by_GL

	--INSERT INTO DBO.GL_016_Balance_by_GL 
	INSERT INTO dbo.GL_016_Balance_by_GL
	(
		coa_id
		,bu_id
		,source_id
		,segment1_id
		,segment2_id
		,user_listing_id
		,approved_by_id
		,year_flag
		,period_flag
		,ey_period
		,sys_man_ind
		,journal_type
		,functional_curr_cd
		,reporting_curr_cd
		,source_type
		,net_reporting_amount
		,net_reporting_amount_credit
		,net_reporting_amount_debit
		,net_functional_amount
		,net_functional_amount_credit
		,net_functional_amount_debit
	)
	
	Select 
		f.coa_id				
		,f.bu_id
		,f.source_id 
		,f.segment1_id 
		,f.segment2_id 
		,F.user_listing_id	
		,f.approved_by_id 
	
		,f.year_flag
		,f.period_flag
		,f.EY_period  
		,f.Sys_man_ind 				
		,f.journal_type 
		,f.functional_curr_cd 
		,f.reporting_amount_curr_cd 

		,'Activity' AS [Source_Type]
		,SUM(f.net_reporting_amount) 
		,SUM(f.net_reporting_amount_credit) 
		,SUM(f.net_reporting_amount_debit) 

		,SUM(f.net_functional_amount) 
		,SUM(f.net_functional_amount_credit) 
		,SUM(f.net_functional_amount_debit) 

	
	FROM dbo.FT_GL_Account F
	GROUP BY
 		f.coa_id					
		,f.bu_id
		
		,f.source_id
		,f.segment1_id
		,f.segment2_id
		,F.user_listing_id		
		,f.approved_by_id
		,f.year_flag
		,f.period_flag
		,f.EY_period
		,f.sys_man_ind
		,f.journal_type
		,f.functional_curr_cd
		,f.reporting_amount_curr_cd

	UNION
		SELECT  
			tb.coa_id								
			,tb.bu_id
			,0 AS [Source_id]
			,tb.segment1_id 
			,tb.segment2_id 
			,0 AS [user_listing_id]	
			,0 AS [approved_by_id]
			,pp.year_flag
			,pp.period_flag
			,fc.fiscal_period_cd AS [ey_period]
			,'N/A for balances'		AS [sys_man_ind]					
			,'N/A for balances' AS  [journal_type]
			,tb.functional_curr_cd  
			,tb.reporting_curr_cd 
			,'Beginning balance' AS [Source_Type]
			,tb.reporting_beginning_balance  
			,0.0 AS [Net_reporting_amount_credit]
			,0.0 AS [Net_reporting_amount_debit]
			,tb.functional_beginning_balance  
			,0.0 AS [Net_functional_amount_credit]
			,0.0 AS [Net_functional_amount_debit]
		FROM dbo.TrialBalance tb
			
			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd

		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end) 
								FROM dbo.Parameters_period pp1 
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								and pp1.year_flag=pp.year_flag  
							)
		and tb.ver_end_date_id is null 

	UNION
		
		SELECT  
			tb.coa_id							
			,tb.bu_id
			,0 AS [Source_id]
			,tb.segment1_id 
			,tb.segment2_id 
			,0 AS [user_listing_id]	
			,0 AS [approved_by_id]
			,pp.year_flag
			,pp.period_flag
			,fc.fiscal_period_cd AS [ey_period]
			,'N/A for balances'		AS [sys_man_ind]					
			,'N/A for balances' AS [journal_type]
			,tb.functional_curr_cd  
			,tb.reporting_curr_cd 
			,'Ending balance' AS [Source_Type]

			,TB.reporting_ending_balance  

			,0.0 AS [Net_reporting_amount_credit]
			,0.0 AS [Net_reporting_amount_debit]
			,tb.functional_ending_balance
			,0.0 AS [Net_functional_amount_credit]
			,0.0 AS [Net_functional_amount_debit]
			
		FROM dbo.TrialBalance tb
			

			INNER JOIN dbo.Dim_Fiscal_calendar fc ON tb.period_id = fc.period_id
			INNER JOIN dbo.Parameters_period pp	ON fc.fiscal_period_seq = pp.fiscal_period_seq_end
				AND fc.fiscal_year_cd = pp.fiscal_year_cd
			
	
		WHERE fc.fiscal_period_seq = (
								SELECT MAX(pp1.fiscal_period_seq_end) 
								FROM dbo.Parameters_period pp1 
								WHERE pp1.fiscal_year_cd = pp.fiscal_year_cd
								and pp1.year_flag = pp.year_flag  
								)
		and  tb.ver_end_date_id is null 

END  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_RDM_GL_Ft_JE_Amounts]')) Drop PROC [dbo].[PROC_Refresh_Data_RDM_GL_Ft_JE_Amounts]
GO

CREATE PROCEDURE [dbo].[PROC_Refresh_Data_RDM_GL_Ft_JE_Amounts]
AS 
/**********************************************************************************************************************************************
Description:	PROC to create and insert into table Ft_JE_Amounts
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_RDM_GL_Ft_JE_Amounts]
************************************************************************************************************************************************/

BEGIN
	
	TRUNCATE TABLE dbo.Ft_JE_Amounts

	INSERT INTO [dbo].Ft_JE_Amounts
	(
		je_id
		,coa_id
		,period_id
		,bu_id
		,source_id
		,user_listing_id
		,approved_by_id
		,segment1_id
		,segment2_id
		,dr_cr_ind
		,reversal_ind
		,sys_manual_ind
		,Journal_type
		,year_flag
		,period_flag
		,ey_period
		,entry_date_id
		,effective_date_id
		,Net_amount
		,Net_amount_debit
		,Net_amount_credit
		,amount_curr_cd
		,Net_reporting_amount
		,Net_reporting_amount_debit
		,Net_reporting_amount_credit
		,reporting_amount_curr_cd
		,Net_functional_amount
		,Net_functional_debit_amount
		,Net_functional_credit_amount
		,functional_amount_curr_cd
		,count_je_id
	)
	SELECT 
		je.je_id
		,je.coa_id
		,je.period_id
		,je.bu_id
		,je.source_id
		,je.user_listing_id
		,je.approved_by_id
		,je.segment1_id
		,je.segment2_id
		,je.dr_cr_ind
		,je.reversal_ind
		,je.sys_manual_ind
		,je.journal_type
		,je.year_flag
		,je.period_flag
		,je.ey_period
		,je.entry_date_id
		,je.effective_date_id
		,sum(je.amount)
		,sum(je.amount_debit)
		,sum(je.amount_credit)
		,je.amount_curr_cd
		,sum(je.reporting_amount)
		,sum(je.reporting_amount_debit)
		,sum(je.reporting_amount_credit)
		,je.reporting_amount_curr_cd
		,sum(je.functional_amount)
		,sum(je.functional_debit_amount)
		,sum(je.functional_credit_amount)
		,je.functional_curr_cd
		,count(je.je_id)
	FROM dbo.FLAT_JE je
	where je.ver_end_date_id is null -- Added by prabakar on july 2nd to pull only the latest version 
	GROUP BY
		je_id
		,coa_id
		,period_id
		,bu_id
		,source_id
		,user_listing_id
		,approved_by_id
		,segment1_id
		,segment2_id
		,dr_cr_ind
		,reversal_ind
		,sys_manual_ind
		,journal_type
		,year_flag
		,period_flag
		,ey_period
		,entry_date_id
		,effective_date_id
		,amount_curr_cd
		,reporting_amount_curr_cd
		,functional_curr_cd
	ORDER BY je_id asc
END
GO
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Data_RDM_GL_Trialbalance]')) Drop PROC [dbo].[PROC_Refresh_Data_RDM_GL_Trialbalance]
GO

CREATE PROCEDURE [dbo].[PROC_Refresh_Data_RDM_GL_Trialbalance]
AS 
/**********************************************************************************************************************************************
Description:	PROC to create and insert into table Trialbalance
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[PROC_Refresh_Data_RDM_GL_Trialbalance]
************************************************************************************************************************************************/

BEGIN

	TRUNCATE TABLE DBO.Trialbalance

	INSERT INTO dbo.Trialbalance
	(
		[bu_id],
		[coa_id],
		[period_id],
		segment1_id,
		segment2_id,
		[engagement_id],
		[trial_balance_start_date_id],
		[trial_balance_end_date_id],
		[beginning_balance],
		[ending_balance],
		[balance_curr_cd],
		
		[functional_beginning_balance],
		[functional_ending_balance],
		[functional_curr_cd],

		[reporting_beginning_balance],
		[reporting_ending_balance],
		[reporting_curr_cd],
		ver_start_date_id,
		ver_end_date_id,
		ver_desc 
	)
		
	SELECT 
			
		[bu_id],
		[coa_id],
		[period_id],
		--tb.segment01,
		--tb.segment02,
		sl1.ey_segment_id,
		sl2.ey_segment_id,
		[engagement_id],
		[trial_balance_start_date_id],
		[trial_balance_end_date_id],
		--Changed by Rajaan from amount columns to round of decimal 2 to avoid exponential  value created from CDM -- Begin
		ROUND([local_beginning_balance],2), 
		ROUND([local_ending_balance],2), 
		[local_curr_cd],

		ROUND([beginning_balance],2),  -- referred as functional begining balance
		ROUND([ending_balance],2), -- referred as funtional ending balance
		[balance_curr_cd], --- referred as functional curr code

		ROUND([reporting_beginning_balance],2),
		ROUND([reporting_ending_balance],2),
		--Changed by Rajaan from amount columns to round of decimal 2 to avoid exponential  value created from CDM -- end
		[reporting_curr_cd]
		,tb.ver_start_date_id
		,tb.ver_end_date_id
		,tb.ver_desc
	FROM dbo.Trial_balance TB
	LEFT OUTER JOIN		 [dbo].[v_Segment01_listing] SL1		ON		TB.Segment01 = SL1.Segment01
																	OR	TB.Segment02 = SL1.Segment02
																	OR	TB.Segment03 = SL1.Segment03
																	OR	TB.Segment04 = SL1.Segment04
																	OR	TB.Segment05 = SL1.Segment05
	LEFT OUTER JOIN		 [dbo].[v_Segment02_listing] SL2		ON		TB.Segment01 = SL2.Segment01
																	OR	TB.Segment02 = SL2.Segment02
																	OR	TB.Segment03 = SL2.Segment03
																	OR	TB.Segment04 = SL2.Segment04
																	OR	TB.Segment05 = SL2.Segment05
	--WHERE				 TB.ver_end_date_id IS NULL
		
END
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PROC_Refresh_Load_GL012_Seq_Day_of_month]')) Drop PROCEDURE [dbo].[PROC_Refresh_Load_GL012_Seq_Day_of_month]
GO

CREATE  PROCEDURE  [dbo].[PROC_Refresh_Load_GL012_Seq_Day_of_month] 
--(
--	 @begin_date datetime	= NULL
--	,@end_date datetime		= NULL
--)
AS
/**********************************************************************************************************************************************
Description:	Procedure for inserting data into [DIM_Calendar_seq_date]
Script Date:	17/06/2014
Created By:		
Version:		2
Sample Command:	EXEC dbo.PROC_Refresh_Load_GL012_Seq_Day_of_month '20140101','20141231'
History:	
V1				10/07/2014  	MSH		UPDATED TO PULL BEGIN AND END DATE FROM PARAMETERS_PERIOD TABLE
V1				17/06/2014  	PRL		CREATED
************************************************************************************************************************************************/
BEGIN
	DECLARE @begin_date date	= NULL
			,@end_date date		= NULL

	SELECT	@begin_date	= MIN(year_start_date) 
			,@end_date		= MAX(year_end_date) 
	FROM	dbo.Parameters_period

	TRUNCATE TABLE dbo.DIM_Calendar_seq_date

	WHILE (@begin_date <= @end_date)
	BEGIN
		INSERT INTO dbo.DIM_Calendar_seq_date
		(
			Calendar_date
			,Sequence
		)
		VALUES
		(
			@begin_date
			,[dbo].[FUNC_Get_Seq_Day_of_month] (@begin_date)
		)

		SELECT @begin_date = DATEADD(D,1,@begin_date)
		
	END
	
END   
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_flat_fe_detail]')) Drop PROC [dbo].[usp_flat_fe_detail]
GO

CREATE PROCEDURE [dbo].[usp_flat_fe_detail]
	@Cond_Col_Name_in nvarchar(50)
    ,@Start_Date_Col_Name_in nvarchar(50) 
	,@end_Date_Col_Name_in nvarchar(50) 
	,@indicator_in nvarchar(2)
AS 

/**********************************************************************************************************************************************
Description:	PROC to insert into table GL_016_Balance_By_GL
Script Date:	17/06/2014  
Created By:		
Version:		1
Sample Command:	EXEC [dbo].[usp_flat_fe_detail]
************************************************************************************************************************************************/
/* 
Created By Prabakar TR on May 13
Purpose : Used to pull the Detail information from Flat Fe table to show the detail when user click Blank COUNT Report

exec usp_flat_fe_detail 'year_flag_desc', 'start_date', 'end_date',  'IP'

*/
 
BEGIN

    SET NOCOUNT ON;
	
	DECLARE @Cond_Col_Name nvarchar(50)
		,@Start_Date_Col_Name nvarchar(50) 
		,@end_Date_Col_Name nvarchar(50)
		,@indicator nvarchar(2)
		,@where_qry nvarchar(max)
		,@select_qry nvarchar(max)

	SELECT @Cond_Col_Name = CASE  WHEN @Cond_Col_Name_in = 'source_id' THEN 'f.source_id' 
										WHEN @Cond_Col_Name_in = 'year_flag_desc' THEN 'PP.year_flag_desc' 
										 ELSE @Cond_Col_Name_in END

		,@Start_Date_Col_Name =  CASE  WHEN @Start_Date_Col_Name_in = 'year_start_date' THEN 'PP.year_start_date' 
										WHEN @Start_Date_Col_Name_in = 'start_date' THEN 'PP.start_date' 
										 ELSE @Start_Date_Col_Name_in END
		,@end_Date_Col_Name =CASE	WHEN @end_Date_Col_Name_in = 'year_end_date' THEN 'PP.year_end_date' 
									WHEN @end_Date_Col_Name_in = 'end_date' THEN 'PP.end_date' 
									ELSE @end_Date_Col_Name_in END
		,@indicator = @indicator_in
	
	IF LTRIM(RTRIM(@Start_Date_Col_Name)) ='' 
		SELECT @Start_Date_Col_Name = NULL

	IF LTRIM(RTRIM(@end_Date_Col_Name)) = '' 
		SELECT @end_Date_Col_Name = NULL

	IF LTRIM(RTRIM(@Cond_Col_Name )) =''
		SELECT @Cond_Col_Name = NULL


	IF @Start_Date_Col_Name IS NOT NULL AND  @end_Date_Col_Name  IS NOT null AND @Cond_Col_Name IS NOT NULL
	BEGIN
		SELECT @where_qry = 'WHERE '
		SELECT @where_qry = @where_qry + CASE	WHEN CHARINDEX('date', @Cond_Col_Name) > 0	THEN 'ISNULL(' + @Cond_Col_Name + ', ''1900-01-01'')  = ''1900-01-01'' '
												WHEN CHARINDEX('id', @Cond_Col_Name) > 0	THEN 'ISNULL(' + @Cond_Col_Name + ', 0)  = 0 '
												ELSE											 'ISNULL(' + @Cond_Col_Name + ', ''EY Unknown'') IN (''EY Unknown'', ''EY_Unknown'', ''EY_EMPTY'', ''EY_0000'',''EY_DEFAULT'')'
											END
		SELECT @where_qry = @where_qry + ' and effective_date BETWEEN ' + @Start_Date_Col_Name + ' and ' + @end_Date_Col_Name
	END


	If @indicator = 'CY' or @indicator = 'IP' or @indicator = 'PY' or @indicator = 'SP'
	BEGIN
		IF @where_qry is not null
		BEGIN
			SELECT @where_qry = @where_qry + ' ' +  CASE	WHEN @indicator IN ('CY', 'PY', 'SP')	THEN ' and PP.YEAR_FLAG = ''' + @indicator + ''''
															WHEN @indicator IN ('IP')				THEN ' and PP.period_flag =  ''' + @indicator  + ''''
													END	
		END						
	END

	--select @select_qry =  'SELECT * FROM  flat_je f inner join  parameters_period p on f.year_flag = p.year_flag and f.period_flag = p.period_flag ' + @where_qry

			
	--select @select_qry

	IF @where_qry is null 
		SELECT @where_qry = ' WHERE f.ver_end_date_id is null '
	ELSE
		SELECT @where_qry  = @where_qry  + ' and f.ver_end_date_id is null'

	SELECT @select_qry =  'SELECT 
		[je_id]				as [Journal entry ID]
		,[je_line_id]				as [Journal entry line ID]
		,[ey_account_type]		as [Account type]
		,[ey_account_sub_type]	as [Account subtype]
		,[ey_account_class]		as [Account class]
		,[ey_account_sub_class]	as [Account subclass]
		,[gl_account_cd]			as [GL account code]
		,[ey_gl_account_name]		as [GL account]
		,[functional_amount]		as [Functional amount]
		,[functional_curr_cd]		as [Functional currency]
		,[reporting_amount]		   as [Reporting amount]
		,[reporting_amount_curr_cd]  as [Reporting currency]
		,bu.[bu_ref]					as [Business unit]
		,bu.[bu_group]				as [Business unit group]
		,src.[source_ref]			as [Source]
		,src.[source_group]			as [Source group]
		,s1.[ey_segment_group]		   as [Segment 1 group]
		,s1.[ey_segment_ref]					as [Segment 1]
		,s2.[ey_segment_group]		   as [Segment 2 group]
		,s2.[ey_segment_ref]					as [Segment 2]
		--,year_flag_desc			as [Accounting period]
		,CASE	WHEN f.year_flag =''' + 'CY''' + ' THEN ''' + 'Current''
			 	WHEN f.year_flag =''' + 'PY''' + ' THEN ''' + 'Prior''
				WHEN f.year_flag =''' + 'SP''' + ' THEN ''' + 'Subsequent''
				ELSE PP.year_flag_desc 
		END AS [Accounting period]
		,PP.period_flag_desc			as [Accounting sub period]
		,[EY_period]				as [Fiscal period]
		,[Entry_Date]				as [Entry date]
		,[Effective_Date]			as [Effective date]
		,[department]				as [Preparer department]
		,[preparer_ref]			as [Preparer]
		,[approver_department]	   as [Approver department]
		,[approver_ref]			   as [Approver]
		,[journal_type]		   as [Journal type] 
		,je_header_desc			as [Journal header description]
		,je_line_desc			as [Journal line description]
		FROM dbo.flat_je f
		LEFT JOIN dbo.Parameters_period  PP on pp.period_flag = f.period_flag and pp.year_flag = f.year_flag
		LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = f.bu_id
		LEFT OUTER JOIN dbo.v_Segment01_listing s1 on s1.ey_segment_id = F.segment1_id
		LEFT OUTER JOIN dbo.v_Segment02_listing s2 on s2.ey_segment_id = F.segment2_id
		LEFT OUTER JOIN dbo.v_Source_listing src on src.source_id = f.source_id '
		
	+ @where_qry --, dbo.audit_dates '

	--select @select_qry
	EXECUTE sp_executesql   @select_qry

	
END




  
GO -- new file   
  
