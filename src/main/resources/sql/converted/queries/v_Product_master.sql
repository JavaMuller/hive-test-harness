SELECT
    all_version.product_master_id ,
    latest_version.bu_id ,
    latest_version.engagement_id ,
    latest_version.client_product_cd ,
    latest_version.product_desc ,
    latest_version.product_group ,
    latest_version.product_type ,
    latest_version.sales_unit ,
    latest_version.purchase_unit ,
    latest_version.created_by_id ,
    latest_version.created_date_id ,
    latest_version.created_time_id ,
    latest_version.last_modified_by_id ,
    latest_version.last_modified_date_id ,
    latest_version.ver_start_date_id ,
    latest_version.ver_end_date_id ,
    latest_version.ver_desc
FROM
    dbo.Product_master all_version
LEFT OUTER JOIN
    dbo.Product_master latest_version
ON
    all_version.client_product_cd = latest_version.client_product_cd
AND all_version.bu_id = latest_version.bu_id
WHERE
    latest_version.ver_end_date_id IS NULL