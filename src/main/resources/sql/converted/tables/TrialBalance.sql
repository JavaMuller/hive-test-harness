CREATE TABLE
    [TrialBalance]
    (
        [coa_id] [INT] NOT NULL ,
        [bu_id] [INT] NOT NULL ,
        [period_id] [INT] NOT NULL ,
        [segment1_id] [INT] NULL ,
        [segment2_id] [INT] NULL ,
        [engagement_id] [nvarchar](100) NULL ,
        [trial_balance_start_date_id] [INT] NULL ,
        [trial_balance_end_date_id] [INT] NULL ,
        [functional_beginning_balance] [FLOAT] NULL ,
        [functional_ending_balance] [FLOAT] NULL ,
        [functional_curr_cd] [nvarchar](8) NULL ,
        [beginning_balance] [FLOAT] NULL ,
        [ending_balance] [FLOAT] NULL ,
        [balance_curr_cd] [nvarchar](8) NULL ,
        [reporting_beginning_balance] [FLOAT] NULL ,
        [reporting_ending_balance] [FLOAT] NULL ,
        [reporting_curr_cd] [nvarchar](8) NULL ,
        [ver_start_date_id] [INT] NULL ,
        [ver_end_date_id] [INT] NULL ,
        [ver_desc] [nvarchar](100) NULL
    )
