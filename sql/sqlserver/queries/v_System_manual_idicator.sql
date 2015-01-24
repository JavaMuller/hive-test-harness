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
