CREATE TABLE
    Dim_Transaction_Type
    (
        transaction_type_id INT NOT NULL ,
        transaction_type_cd nvarchar(25) NOT NULL ,
        bu_id INT NOT NULL ,
        engagement_id uniqueidentifier NOT NULL ,
        transaction_type_desc nvarchar(100) NULL ,
        transaction_type_group_desc nvarchar(100) NULL ,
        EY_transaction_type nvarchar(25) NULL ,
        entry_by_id INT NULL ,
        entry_date_id INT NOT NULL ,
        entry_time_id INT NOT NULL ,
        last_modified_by_id INT NOT NULL ,
        last_modified_date_id INT NOT NULL ,
        ver_start_date_id INT NOT NULL ,
        ver_end_date_id INT NULL ,
        ver_desc nvarchar(100) NULL ,
        transaction_type_ref nvarchar(125) NULL
    )
