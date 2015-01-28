insert overwrite TABLE mv_source_listing
    SELECT
        all_version.source_id,
        all_version.engagement_id,
        all_version.source_cd,
        all_version.source_desc,
        all_version.erp_subledger_module,
        all_version.bus_process_major,
        all_version.bus_process_minor,
        all_version.sys_manual_ind,
        all_version.ver_start_date_id,
        all_version.ver_end_date_id,
        all_version.ver_desc,
        all_version.ey_source_group AS source_group,
        concat(all_version.source_cd, ' - ', all_version.source_desc)         AS source_ref
    FROM
        Source_listing all_version
    WHERE
        all_version.ver_end_date_id IS NULL;