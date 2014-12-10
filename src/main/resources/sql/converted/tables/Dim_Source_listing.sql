CREATE TABLE
    Dim_Source_listing
    (
        Source_Id INT NOT NULL ,
        source_cd nvarchar(25) NULL ,
        source_desc nvarchar(100) NULL ,
        erp_subledger_module nvarchar(100) NULL ,
        bus_process_major nvarchar(100) NULL ,
        bus_process_minor nvarchar(100) NULL ,
        source_ref nvarchar(200) NULL ,
        sys_manual_ind CHAR(1) NULL ,
        ver_start_date_id INT NULL ,
        ver_end_date_id INT NULL ,
        ver_desc nvarchar(100) NULL ,
        ey_source_group nvarchar(200) NULL
    )
