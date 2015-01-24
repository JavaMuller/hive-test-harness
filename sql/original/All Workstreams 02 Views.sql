
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Business_unit_listing]')) Drop VIEW [dbo].[v_Business_unit_listing]
GO

CREATE VIEW [dbo].[v_Business_unit_listing]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Business_unit_listing
Script Date:	08/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Business_unit_listing]
History:		
V1				08/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

SELECT
					 all_version.bu_id
					,latest_version.engagement_id
					,latest_version.bu_cd
					,latest_version.bu_desc
					,latest_version.bu_hier_01_cd
					,latest_version.bu_hier_01_desc
					,latest_version.bu_hier_02_cd
					,latest_version.bu_hier_02_desc
					,latest_version.bu_hier_03_cd
					,latest_version.bu_hier_03_desc
					,latest_version.bu_hier_04_cd
					,latest_version.bu_hier_04_desc
					,latest_version.bu_hier_05_cd
					,latest_version.bu_hier_05_desc
					,latest_version.seg_01_cd
					,latest_version.seg_01_desc
					,latest_version.seg_02_cd
					,latest_version.seg_02_desc
					,latest_version.seg_03_cd
					,latest_version.seg_03_desc
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					,CONVERT(VARCHAR(100), ISNULL(latest_version.bu_hier_01_desc, BU_MAPPING.bu_group))		AS	bu_group
					,ISNULL(latest_version.bu_cd, '') + ' - ' + ISNULL(latest_version.bu_desc, '')			AS bu_ref
FROM				 dbo.Business_unit_listing all_version
LEFT OUTER JOIN		 dbo.Business_unit_listing latest_version	ON		all_version.bu_cd = latest_version.bu_cd

--TODO: REMOVE HARDCODED GROUP MAPPINGS WHEN PARAMETER VALUES ARE POPULATED INTO bu_hier_01_desc COLUMN ---------------------------
LEFT OUTER JOIN		 
(
	SELECT			 2	AS bu_id,	'Limited scope'		AS bu_group	UNION ALL
	SELECT			 3	AS bu_id,	'Limited scope'		AS bu_group	UNION ALL
	SELECT			 4	AS bu_id,	'Full scope'		AS bu_group	UNION ALL
	SELECT			 5	AS bu_id,	'Full scope'		AS bu_group	UNION ALL
	SELECT			 6	AS bu_id,	'Other component'	AS bu_group	UNION ALL
	SELECT			 8	AS bu_id,	'EY component'		AS bu_group	UNION ALL
	SELECT			 9	AS bu_id,	'Other component'	AS bu_group	UNION ALL
	SELECT			 10	AS bu_id,	'Limited scope'		AS bu_group	
) AS BU_MAPPING													ON		all_version.bu_id = BU_MAPPING.bu_id
-----------------------------------------------------------------------------------------------------------------------------------
WHERE				 latest_version.ver_end_date_id IS NULL
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Chart_of_accounts]')) Drop VIEW [dbo].[v_Chart_of_accounts]
GO

CREATE VIEW [dbo].[v_Chart_of_accounts]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Chart_of_accounts
Script Date:	09/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Chart_of_accounts]
History:		
V1				09/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

SELECT
					 all_version.coa_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.coa_effective_date_id
					,latest_version.gl_account_cd
					,latest_version.gl_subacct_cd
					,latest_version.gl_account_name
					,latest_version.gl_subacct_name
					,latest_version.consolidation_account
					,latest_version.ey_account_type
					,latest_version.ey_account_sub_type
					,latest_version.ey_account_class
					,latest_version.ey_account_sub_class
					,latest_version.ey_account_group_I
					,latest_version.ey_account_group_II
					,latest_version.ey_sub_ledger
					,latest_version.ey_cash_activity
					,latest_version.ey_index
					,latest_version.ey_sub_index
					,latest_version.ey_management_account_ind
					,latest_version.created_by_id
					,latest_version.created_date_id
					,latest_version.created_time_id
					,latest_version.last_modified_by_id
					,latest_version.last_modified_date_id
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					,latest_version.gl_account_cd + ' - ' + latest_version.gl_account_name		AS ey_gl_account_name

FROM				 dbo.Chart_of_accounts all_version
LEFT OUTER JOIN		 dbo.Chart_of_accounts latest_version	ON		all_version.gl_account_cd = latest_version.gl_account_cd
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_all		ON		all_version.bu_id = bu_all.bu_id
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_latest	ON		latest_version.bu_id = bu_latest.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL
				AND	 bu_latest.bu_cd = bu_all.bu_cd  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Customer_master]')) Drop VIEW [dbo].[v_Customer_master]
GO

CREATE VIEW [dbo].[v_Customer_master]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Customer_master
Script Date:	09/05/2013
Created By:		MSH
Version:		2
Sample Command:	SELECT	*	FROM	[v_Customer_master]
History:		
V1				09/05/2013   	MSH		CREATED
V2				20140819		MSH		Added bu_latest.bu_cd to output list
************************************************************************************************************************************************/

SELECT
					 all_version.customer_master_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.customer_master_as_of_date_id
					,latest_version.customer_account_cd
					,latest_version.customer_account_name
					,latest_version.customer_group
					,latest_version.customer_physical_street_addr1
					,latest_version.customer_physical_street_addr2
					,latest_version.customer_physical_city
					,latest_version.customer_physical_state_province
					,latest_version.customer_physical_country
					,latest_version.customer_physical_zip_code
					,latest_version.customer_tax_id
					,latest_version.customer_billing_address1
					,latest_version.customer_billing_address2
					,latest_version.customer_billing_city
					,latest_version.customer_billing_state_province
					,latest_version.customer_billing_country
					,latest_version.customer_billing_zip_code
					,latest_version.payment_terms_desc
					,latest_version.payment_terms_days
					,latest_version.bank_name
					,latest_version.bank_account_no
					,latest_version.beneficiary
					,latest_version.active_ind
					,latest_version.active_ind_change_date_id
					,latest_version.credit_limit_curr_cd
					,latest_version.transaction_credit_limit
					,latest_version.overall_credit_limit
					,latest_version.created_by_id
					,latest_version.created_date_id
					,latest_version.created_time_id
					,latest_version.last_modified_by_id
					,latest_version.last_modified_date_id
					,latest_version.approved_by_id
					,latest_version.approved_by_date_id
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					,latest_version.ey_related_party
					,ISNULL(latest_version.customer_account_cd, '') + ' - ' + ISNULL(latest_version.customer_account_name, '') AS customer_ref
					,bu_latest.bu_cd

FROM				 dbo.Customer_master all_version
LEFT OUTER JOIN		 dbo.Customer_master latest_version		ON		all_version.customer_account_cd = latest_version.customer_account_cd
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_all		ON		all_version.bu_id = bu_all.bu_id
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_latest	ON		latest_version.bu_id = bu_latest.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL
				AND	 bu_latest.bu_cd = bu_all.bu_cd  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Fiscal_calendar]')) Drop VIEW [dbo].[v_Fiscal_calendar]
GO

CREATE VIEW [dbo].[v_Fiscal_calendar]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Fiscal_calendar
Script Date:	09/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Fiscal_calendar]
History:		
V1				09/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

SELECT
					 all_version.period_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.fiscal_period_cd
					,latest_version.fiscal_period_desc
					,latest_version.fiscal_period_seq
					,latest_version.fiscal_period_start
					,latest_version.fiscal_period_end
					,latest_version.fiscal_quarter_cd
					,latest_version.fiscal_quarter_desc
					,latest_version.fiscal_quarter_start
					,latest_version.fiscal_quarter_end
					,latest_version.fiscal_year_cd
					,latest_version.fiscal_year_desc
					,latest_version.fiscal_year_start
					,latest_version.fiscal_year_end
					,latest_version.adjustment_period
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc

FROM				 dbo.Fiscal_calendar all_version
LEFT OUTER JOIN		 dbo.Fiscal_calendar latest_version		ON		all_version.fiscal_period_cd = latest_version.fiscal_period_cd
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_all		ON		all_version.bu_id = bu_all.bu_id
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_latest	ON		latest_version.bu_id = bu_latest.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL
				AND	 bu_latest.bu_cd = bu_all.bu_cd  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Product_master]')) Drop VIEW [dbo].[v_Product_master]
GO

CREATE VIEW [dbo].[v_Product_master]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Product_master
Script Date:	09/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Product_master]
History:		
V1				09/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

SELECT
					 all_version.product_master_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.client_product_cd
					,latest_version.product_desc
					,latest_version.product_group
					,latest_version.product_type
					,latest_version.sales_unit
					,latest_version.purchase_unit
					,latest_version.created_by_id
					,latest_version.created_date_id
					,latest_version.created_time_id
					,latest_version.last_modified_by_id
					,latest_version.last_modified_date_id
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc

FROM				 dbo.Product_master all_version
LEFT OUTER JOIN		 dbo.Product_master latest_version	ON		all_version.client_product_cd = latest_version.client_product_cd
															AND	all_version.bu_id = latest_version.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Segment01_listing]')) Drop VIEW [dbo].[v_Segment01_listing]
GO

CREATE VIEW [dbo].[v_Segment01_listing]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Product_master
Script Date:	28/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Segment01_listing]
History:		
V1				28/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

WITH SEGMENT_CTE
AS
(
	SELECT
					 'Segment01'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment01_listing] SL
	UNION ALL
	SELECT
					 'Segment02'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment02_listing] SL
	UNION ALL
	SELECT
					 'Segment03'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment03_listing] SL
	UNION ALL
	SELECT
					 'Segment04'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment04_listing] SL
	UNION ALL
	SELECT
					 'Segment05'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment05_listing] SL
)

SELECT 
					 CASE WHEN SEGMENT.table_identifier = 'Segment01' THEN	SEGMENT.segment_id END	AS Segment01
					,CASE WHEN SEGMENT.table_identifier = 'Segment02' THEN	SEGMENT.segment_id END	AS Segment02
					,CASE WHEN SEGMENT.table_identifier = 'Segment03' THEN	SEGMENT.segment_id END	AS Segment03
					,CASE WHEN SEGMENT.table_identifier = 'Segment04' THEN	SEGMENT.segment_id END	AS Segment04
					,CASE WHEN SEGMENT.table_identifier = 'Segment05' THEN	SEGMENT.segment_id END	AS Segment05
					,SEGMENT.segment_id AS ey_segment_id
					,SEGMENT.segment_cd
					,SEGMENT.segment_desc
					,SEGMENT.ey_segment_group
					,SEGMENT.segment_cd + ' - ' + SEGMENT.segment_desc AS ey_segment_ref  --Added by prabakar on June 25th for GL purpose
FROM				 SEGMENT_CTE SEGMENT
INNER JOIN			 [dbo].[Parameters_engagement] PE		ON		SEGMENT.table_identifier = PE.segment_selection1
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Segment02_listing]')) Drop VIEW [dbo].[v_Segment02_listing]
GO

CREATE VIEW [dbo].[v_Segment02_listing]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Product_master
Script Date:	28/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Segment02_listing]
History:		
V1				28/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

WITH SEGMENT_CTE
AS
(
	SELECT
					 'Segment01'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment01_listing] SL
	UNION ALL
	SELECT
					 'Segment02'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment02_listing] SL
	UNION ALL
	SELECT
					 'Segment03'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment03_listing] SL
	UNION ALL
	SELECT
					 'Segment04'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment04_listing] SL
	UNION ALL
	SELECT
					 'Segment05'		AS		table_identifier
					,SL.segment_id
					,SL.segment_cd
					,SL.segment_desc
					,SL.ey_segment_group
	FROM			 [dbo].[Segment05_listing] SL
)

SELECT 
					 CASE WHEN SEGMENT.table_identifier = 'Segment01' THEN	SEGMENT.segment_id END	AS Segment01
					,CASE WHEN SEGMENT.table_identifier = 'Segment02' THEN	SEGMENT.segment_id END	AS Segment02
					,CASE WHEN SEGMENT.table_identifier = 'Segment03' THEN	SEGMENT.segment_id END	AS Segment03
					,CASE WHEN SEGMENT.table_identifier = 'Segment04' THEN	SEGMENT.segment_id END	AS Segment04
					,CASE WHEN SEGMENT.table_identifier = 'Segment05' THEN	SEGMENT.segment_id END	AS Segment05
					,SEGMENT.segment_id AS ey_segment_id
					,SEGMENT.segment_cd
					,SEGMENT.segment_desc
					,SEGMENT.ey_segment_group
					,SEGMENT.segment_cd + ' - ' + SEGMENT.segment_desc AS ey_segment_ref  --Added by prabakar on June 25th for GL purpose
FROM				 SEGMENT_CTE SEGMENT
INNER JOIN			 [dbo].[Parameters_engagement] PE		ON		SEGMENT.table_identifier = PE.segment_selection2	
  
GO -- new file   
  
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Shared_aging_calc]')) Drop VIEW [dbo].[v_Shared_aging_calc] 
GO

CREATE VIEW [dbo].[v_Shared_aging_calc]
--WITH SCHEMABINDING
AS

/**********************************************************************************************************************************************
Description:	View for fetching data from [parameters_aging_bands]
Script Date:	16/06/2014
Created By:		
Version:		1
Sample Command:	SELECT	*	FROM	[dbo].[v_Shared_Aging_Calc] order by aging_ref  asc
History:		
************************************************************************************************************************************************/
		SELECT 
			A.band + 1 as band
			,A.ey_band_threshold_lower
			,A.ey_band_threshold_higher
			,(CONVERT(VARCHAR(10),A.band + 1) + '.  ' + A.[aging_ref]) as [aging_ref]
		FROM
			(SELECT	0 AS band
					, NULL as ey_band_threshold_lower
					, NULL AS ey_band_threshold_higher
					, 'Not due' as [aging_ref]
			UNION ALL

			SELECT pab1.band								AS band
					,pab1.ey_band_threshold_lower			AS ey_band_threshold_lower
					,ISNULL(pab2.ey_band_threshold_lower - 1,999999)		AS ey_band_threshold_higher
					,CASE when (pab2.ey_band_threshold_lower - 1) IS NULL THEN ' >=' +  CONVERT(VARCHAR(10),pab1.ey_band_threshold_lower) +' days'
							ELSE CONVERT(VARCHAR(10),pab1.ey_band_threshold_lower ) + '-' + CONVERT(VARCHAR(10),ISNULL(pab2.ey_band_threshold_lower - 1,999999)) +' days' END AS [Aging ref]
			FROM [dbo].[parameters_aging_bands] pab1
					LEFT OUTER JOIN	 [dbo].[parameters_aging_bands] pab2		ON		pab1.band + 1 = pab2.band 
			) AS A  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Source_listing]')) Drop VIEW [dbo].[v_Source_listing]
GO

CREATE VIEW [dbo].[v_Source_listing]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Source_listing
Script Date:	08/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Source_listing]
History:		
V1				08/05/2013   	MSH		CREATED
************************************************************************************************************************************************/
SELECT
					 all_version.source_id
					,latest_version.engagement_id
					,latest_version.source_cd
					,latest_version.source_desc
					,latest_version.erp_subledger_module
					,latest_version.bus_process_major
					,latest_version.bus_process_minor
					,latest_version.sys_manual_ind
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					,CONVERT(VARCHAR(100), ISNULL(latest_version.ey_source_group, SOURCE_MAPPING.source_group))		AS	source_group
					,latest_version.source_cd + ' - ' + latest_version.source_desc									AS source_ref

FROM				 dbo.Source_listing all_version
LEFT OUTER JOIN		 dbo.Source_listing latest_version	ON		all_version.source_cd = latest_version.source_cd

--TODO: REMOVE HARDCODED GROUP MAPPINGS WHEN PARAMETER VALUES ARE POPULATED INTO ey_source_group COLUMN ---------------------------
LEFT OUTER JOIN
(
SELECT 'AA' AS source_cd, 'Fixed Assets'	AS source_group UNION ALL
SELECT 'AB' AS source_cd, 'Manual'			AS source_group UNION ALL
SELECT 'AF' AS source_cd, 'Fixed Assets'	AS source_group UNION ALL
SELECT 'KA' AS source_cd, 'Payables'		AS source_group UNION ALL
SELECT 'KG' AS source_cd, 'Payables'		AS source_group UNION ALL
SELECT 'KP' AS source_cd, 'Payables'		AS source_group UNION ALL
SELECT 'KR' AS source_cd, 'Payables'		AS source_group UNION ALL
SELECT 'PR' AS source_cd, 'Inventory'		AS source_group UNION ALL
SELECT 'RE' AS source_cd, 'Payables'		AS source_group UNION ALL
SELECT 'RV' AS source_cd, 'Receivables'		AS source_group UNION ALL
SELECT 'SA' AS source_cd, 'Manual'			AS source_group UNION ALL
SELECT 'SB' AS source_cd, 'Adjustments'		AS source_group UNION ALL
SELECT 'WA' AS source_cd, 'Inventory'		AS source_group UNION ALL
SELECT 'WE' AS source_cd, 'Inventory'		AS source_group UNION ALL
SELECT 'WI' AS source_cd, 'Inventory'		AS source_group UNION ALL
SELECT 'WL' AS source_cd, 'Inventory'		AS source_group UNION ALL
SELECT 'ZP' AS source_cd, 'Cash'			AS source_group UNION ALL
SELECT 'ZR' AS source_cd, 'Cash'			AS source_group UNION ALL
SELECT 'ZV' AS source_cd, 'Cash'			AS source_group
) AS SOURCE_MAPPING										ON		latest_version.source_cd = SOURCE_MAPPING.source_cd
-----------------------------------------------------------------------------------------------------------------------------------
WHERE				 latest_version.ver_end_date_id IS NULL  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_System_manual_idicator]')) Drop VIEW [dbo].[v_System_manual_idicator]
GO

CREATE VIEW [dbo].[v_System_manual_idicator]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling system manual indicator from source and user listing and based on parameters
Script Date:	31/07/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_System_manual_idicator]
History:		
V1				31/07/2013   	MSH		CREATED
************************************************************************************************************************************************/

WITH SOURCE_USER_CTE
AS
(
	SELECT 
					 'Source Code grouping'		AS		table_identifier
					,SL.source_id				AS		source_or_user_id
					--,SL.source_cd
					,P_SL.ey_sys_man_ident
					
	FROM			 [dbo].[Parameters_Source_listing] P_SL
	INNER JOIN		 [dbo].[Source_listing] SL				ON		P_SL.source_cd = SL.source_cd 
	UNION ALL
	SELECT
					 'User Listing grouping'		AS		table_identifier
					,UL.user_listing_id				AS		source_or_user_id  
					--,UL.client_user_id
					,P_UL.ey_sys_man_ident
					
	FROM			 [dbo].[Parameters_User_listing] P_UL
	INNER JOIN		 [dbo].[User_listing] UL				ON		P_UL.client_user_id = UL.client_user_id 

)

SELECT 
					 CASE WHEN SRC_USR.table_identifier = 'Source Code grouping'	THEN	SRC_USR.source_or_user_id END	AS source_id
					,CASE WHEN SRC_USR.table_identifier = 'User Listing grouping'	THEN	SRC_USR.source_or_user_id END	AS user_listing_id
					,SRC_USR.ey_sys_man_ident
FROM				 SOURCE_USER_CTE SRC_USR
INNER JOIN			 [dbo].[Parameters_engagement] PE		ON		SRC_USR.table_identifier = PE.system_manual_indicator_option
  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Transaction_type]')) Drop VIEW [dbo].[v_Transaction_type]
GO

CREATE VIEW [dbo].[v_Transaction_type]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Transaction_type
Script Date:	09/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_Transaction_type]
History:		
V1				09/05/2013   	MSH		CREATED
************************************************************************************************************************************************/
SELECT
					 all_version.Transaction_type_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.Transaction_type_cd
					,latest_version.transaction_type_desc
					,latest_version.transaction_type_group_desc
					,latest_version.EY_transaction_type
					,latest_version.entry_by_id
					,latest_version.entry_date_id
					,latest_version.entry_time_id
					,latest_version.last_modified_by_id
					,latest_version.last_modified_date_id
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					,latest_version.ey_transaction_type AS	ey_trans_type
					,ISNULL(latest_version.Transaction_type_cd, '') + ' - ' + ISNULL(latest_version.transaction_type_desc, '') AS transaction_type_ref

FROM				 dbo.Transaction_type all_version
LEFT OUTER JOIN		 dbo.Transaction_type latest_version	ON		all_version.Transaction_type_cd = latest_version.Transaction_type_cd
WHERE				 latest_version.ver_end_date_id IS NULL  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_User_listing]')) Drop VIEW [dbo].[v_User_listing]
GO

CREATE VIEW [dbo].[v_User_listing]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of User_listing
Script Date:	09/05/2013
Created By:		MSH
Version:		1
Sample Command:	SELECT	*	FROM	[v_User_listing]
History:		
V1				09/05/2013   	MSH		CREATED
************************************************************************************************************************************************/

SELECT
					 all_version.user_listing_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.client_user_id
					,latest_version.first_name
					,latest_version.last_name
					,latest_version.full_name
					,latest_version.department
					,latest_version.title
					,latest_version.role_resp
					,latest_version.sys_manual_ind
					,latest_version.active_ind
					,latest_version.active_ind_change_date_id
					,latest_version.created_by_id
					,latest_version.created_date_id
					,latest_version.created_time_id
					,latest_version.last_modified_by_id
					,latest_version.last_modified_date_id
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					-- Added space between dash to keep conistant accross all Reference columns by prabakar on 1st jul 
					,latest_version.client_user_id + ' - ' + latest_version.full_name		AS client_ref
					-- Added below transformation column as such client_ref but in GL we are referred as Preparer_ref
					,latest_version.client_user_id + ' - ' + latest_version.full_name		AS preparer_ref

FROM				 dbo.User_listing all_version
LEFT OUTER JOIN		 dbo.User_listing latest_version	ON		all_version.client_user_id = latest_version.client_user_id
																AND	all_version.bu_id = latest_version.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL  
GO -- new file   
  

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[v_Vendor_master]')) Drop VIEW [dbo].[v_Vendor_master]
GO

CREATE VIEW [dbo].[v_Vendor_master]
AS
/**********************************************************************************************************************************************
Description:	View creation for pulling latest version data for all lines of Vendor_master
Script Date:	09/05/2013
Created By:		MSH
Version:		2
Sample Command:	SELECT	*	FROM	[v_Vendor_master]
History:		
V1				09/05/2013   	MSH		CREATED
V2				20140819		MSH		Added bu_latest.bu_cd to output list
************************************************************************************************************************************************/
SELECT
					 all_version.Vendor_master_id
					,latest_version.bu_id
					,latest_version.engagement_id
					,latest_version.vendor_master_as_of_date_id
					,latest_version.vendor_account_cd
					,latest_version.vendor_account_name
					,latest_version.vendor_group
					,latest_version.vendor_physical_street_addr1
					,latest_version.vendor_physical_street_addr2
					,latest_version.vendor_physical_city
					,latest_version.vendor_physical_state_province
					,latest_version.vendor_physical_country
					,latest_version.vendor_physical_zip_code
					,latest_version.vendor_tax_id
					,latest_version.vendor_billing_address1
					,latest_version.vendor_billing_address2
					,latest_version.vendor_billing_city
					,latest_version.vendor_billing_state_province
					,latest_version.vendor_billing_country
					,latest_version.vendor_billing_zip_code
					,latest_version.payment_terms_desc
					,latest_version.payment_terms_days
					,latest_version.bank_name
					,latest_version.bank_account_no
					,latest_version.beneficiary
					,latest_version.active_ind
					,latest_version.active_ind_change_date_id
					,latest_version.credit_limit_curr_cd
					,latest_version.transaction_credit_limit
					,latest_version.overall_credit_limit
					,latest_version.created_by_id
					,latest_version.created_date_id
					,latest_version.created_time_id
					,latest_version.last_modified_by_id
					,latest_version.last_modified_date_id
					,latest_version.approved_by_id
					,latest_version.approved_by_date_id
					,latest_version.ver_start_date_id
					,latest_version.ver_end_date_id
					,latest_version.ver_desc
					,latest_version.ey_related_party
					,ISNULL(latest_version.vendor_account_cd, '') + ' - ' + ISNULL(latest_version.vendor_account_name, '') AS vendor_ref
					,bu_latest.bu_cd

FROM				 dbo.Vendor_master all_version
LEFT OUTER JOIN		 dbo.Vendor_master latest_version	ON		all_version.Vendor_account_cd = latest_version.Vendor_account_cd
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_all		ON		all_version.bu_id = bu_all.bu_id
LEFT OUTER JOIN		 dbo.Business_unit_listing bu_latest	ON		latest_version.bu_id = bu_latest.bu_id
WHERE				 latest_version.ver_end_date_id IS NULL
				AND	 bu_latest.bu_cd = bu_all.bu_cd  
GO -- new file   
  
