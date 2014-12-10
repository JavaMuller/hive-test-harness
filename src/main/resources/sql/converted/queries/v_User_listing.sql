SELECT
    all_version.user_listing_id ,
    latest_version.bu_id ,
    latest_version.engagement_id ,
    latest_version.client_user_id ,
    latest_version.first_name ,
    latest_version.last_name ,
    latest_version.full_name ,
    latest_version.department ,
    latest_version.title ,
    latest_version.role_resp ,
    latest_version.sys_manual_ind ,
    latest_version.active_ind ,
    latest_version.active_ind_change_date_id ,
    latest_version.created_by_id ,
    latest_version.created_date_id ,
    latest_version.created_time_id ,
    latest_version.last_modified_by_id ,
    latest_version.last_modified_date_id ,
    latest_version.ver_start_date_id ,
    latest_version.ver_end_date_id ,
    latest_version.ver_desc ,
    latest_version.client_user_id + ' - ' + latest_version.full_name AS client_ref ,
    latest_version.client_user_id + ' - ' + latest_version.full_name AS preparer_ref
FROM
    dbo.User_listing all_version
LEFT OUTER JOIN
    dbo.User_listing latest_version
ON
    all_version.client_user_id = latest_version.client_user_id
AND all_version.bu_id = latest_version.bu_id
WHERE
    latest_version.ver_end_date_id IS NULL