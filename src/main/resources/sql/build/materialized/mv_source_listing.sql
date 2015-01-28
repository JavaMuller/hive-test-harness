CREATE TABLE
    mv_source_listing
    (
        source_id INT,
        engagement_id string,
        source_cd string,
        source_desc string,
        erp_subledger_module string,
        bus_process_major string,
        bus_process_minor string,
        sys_manual_ind string,
        ver_start_date_id INT,
        ver_end_date_id INT,
        ver_desc string,
        source_group string,
        source_ref string
    ) ;


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