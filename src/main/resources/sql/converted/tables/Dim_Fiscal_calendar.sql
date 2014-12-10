CREATE TABLE
    [Dim_Fiscal_calendar]
    (
        [period_id] [INT] NOT NULL ,
        [bu_id] [INT] NULL ,
        [fiscal_period_cd] [nvarchar](50) NULL ,
        [fiscal_period_desc] [nvarchar](100) NULL ,
        [fiscal_period_start] [nvarchar](50) NULL ,
        [fiscal_period_end] [nvarchar](50) NULL ,
        [fiscal_quarter_cd] [nvarchar](50) NULL ,
        [fiscal_quarter_desc] [nvarchar](100) NULL ,
        [fiscal_quarter_start] [nvarchar](50) NULL ,
        [fiscal_quarter_end] [nvarchar](50) NULL ,
        [fiscal_year_cd] [nvarchar](50) NULL ,
        [fiscal_year_desc] [nvarchar](100) NULL ,
        [fiscal_year_start] [nvarchar](50) NULL ,
        [fiscal_year_end] [nvarchar](50) NULL ,
        [adjustment_period] [nvarchar](1) NULL ,
        [engagement_id] [uniqueidentifier] NULL ,
        [fiscal_period_seq] [INT] NULL ,
        [ver_start_date_id] [INT] NULL ,
        [ver_end_date_id] [INT] NULL ,
        [ver_desc] [nvarchar](200) NULL
    )
