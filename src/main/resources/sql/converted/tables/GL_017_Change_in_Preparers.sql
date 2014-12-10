CREATE TABLE
    GL_017_Change_in_Preparers
    (
        --- Added by prabakar to have source, bu, segment to be dynamic on jun 26 - begin
        bu_id INT NULL,
        source_id INT NULL,
        segment1_idINT NULL,
        segment2_idINT NULL,
        --- Added by prabakar to have source, bu, segment to be dynamic on jun 26 --end
        year_flag_desc nvarchar(100) NULL,
        period_flag_desc nvarchar(100) NULL,
        year_flag nvarchar(25) NULL,
        period_flag nvarchar(25) NULL,
        bu_group nvarchar(200) NULL,
        bu_ref nvarchar(200) NULL,
        segment1_ref nvarchar(125) NULL,
        segment2_ref nvarchar(125) NULL,
        segment1_group nvarchar(100) NULL,
        segment2_group nvarchar(100) NULL,
        Ey_period nvarchar(50) NULL,
        source_group nvarchar(200) NULL,
        Source_ref nvarchar(200) NULL,
        sys_manual_ind nvarchar(2) NULL,
        Journal_type nvarchar(25) NULL,
        preparer_ref nvarchar(200) NULL,
        department nvarchar(100) NULL,
        Category VARCHAR(25) NULL, -- updated the length from 6 - 25
        reporting_amount_curr_cd nvarchar(25) NULL,
        functional_curr_cd nvarchar(25) NULL
    )
