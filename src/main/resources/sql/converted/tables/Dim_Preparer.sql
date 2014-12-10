CREATE TABLE
    Dim_Preparer
    (
        user_listing_id INT NOT NULL ,
        client_user_id nvarchar(25) NULL ,
        first_name nvarchar(100) NULL ,
        last_name nvarchar(100) NULL ,
        full_name nvarchar(100) NULL ,
        preparer_ref nvarchar(200) NULL ,
        department nvarchar(100) NULL ,
        title nvarchar(100) NULL ,
        role_resp nvarchar(100) NULL ,
        sys_manual_ind CHAR(1) NULL ,
        active_ind CHAR(1) NULL ,
        active_ind_change_date_id INT NULL ,
        created_by_id INT NULL ,
        created_date_id INT NULL ,
        created_time_id INT NULL ,
        last_modified_by_id INT NULL ,
        last_modified_date_id INT NULL ,
        ver_start_date_id INT NULL ,
        ver_end_date_id INT NULL
    )
