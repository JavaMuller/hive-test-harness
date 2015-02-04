CREATE TABLE
    mv_user_listing
    (
        user_listing_id INT,
        bu_id INT,
        engagement_id string,
        client_user_id string,
        first_name string,
        last_name string,
        full_name string,
        department string,
        title string,
        role_resp string,
        sys_manual_ind string,
        active_ind string,
        active_ind_change_date_id INT,
        created_by_id INT,
        created_date_id INT,
        created_time_id INT,
        last_modified_by_id INT,
        last_modified_date_id INT,
        ver_start_date_id INT,
        ver_end_date_id INT,
        ver_desc string,
        client_ref string,
        preparer_ref string
) stored AS orc;


insert overwrite TABLE mv_user_listing
  SELECT
    all_version.user_listing_id,
    latest_version.bu_id,
    latest_version.engagement_id,
    latest_version.client_user_id,
    latest_version.first_name,
    latest_version.last_name,
    latest_version.full_name,
    latest_version.department,
    latest_version.title,
    latest_version.role_resp,
    latest_version.sys_manual_ind,
    latest_version.active_ind,
    latest_version.active_ind_change_date_id,
    latest_version.created_by_id,
    latest_version.created_date_id,
    latest_version.created_time_id,
    latest_version.last_modified_by_id,
    latest_version.last_modified_date_id,
    latest_version.ver_start_date_id,
    latest_version.ver_end_date_id,
    latest_version.ver_desc,
    concat(latest_version.client_user_id, ' - ', latest_version.full_name) AS client_ref,
    concat(latest_version.client_user_id, ' - ', latest_version.full_name) AS preparer_ref
  FROM
    User_listing all_version
    LEFT OUTER JOIN
    User_listing latest_version
      ON
        all_version.client_user_id = latest_version.client_user_id
        AND all_version.bu_id = latest_version.bu_id
  WHERE
    latest_version.ver_end_date_id IS NULL;