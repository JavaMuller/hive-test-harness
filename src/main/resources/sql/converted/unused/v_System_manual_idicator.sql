WITH
    SOURCE_USER_CTE AS
    (
        SELECT
            'Source Code grouping'  ,
            SL.source_id           ,
            P_SL.ey_sys_man_ident
        FROM
            Parameters_Source_listing P_SL
        INNER JOIN
            Source_listing SL
        ON
            P_SL.source_cd = SL.source_cd
        UNION ALL
        SELECT
            'User Listing grouping' ,
            UL.user_listing_id       ,
            P_UL.ey_sys_man_ident
        FROM
            Parameters_User_listing P_UL
        INNER JOIN
            User_listing UL
        ON
            P_UL.client_user_id = UL.client_user_id
    )
SELECT
    CASE
        WHEN SRC_USR.table_identifier = 'Source Code grouping'
        THEN SRC_USR.source_or_user_id
    END AS source_id ,
    CASE
        WHEN SRC_USR.table_identifier = 'User Listing grouping'
        THEN SRC_USR.source_or_user_id
    END AS user_listing_id ,
    SRC_USR.ey_sys_man_ident
FROM
    SOURCE_USER_CTE SRC_USR
INNER JOIN
    Parameters_engagement PE
ON
    SRC_USR.table_identifier = PE.system_manual_indicator_option