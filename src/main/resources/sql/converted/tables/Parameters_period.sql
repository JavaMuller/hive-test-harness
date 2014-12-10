
CREATE TABLE [dbo].[Parameters_period] (
year_flag					NVARCHAR(25)			NOT NULL
,year_flag_desc				NVARCHAR(100)			NOT NULL
,period_flag				NVARCHAR(25)			NOT NULL
,period_flag_desc			NVARCHAR(100)			NOT NULL
,fiscal_period_seq_start	INT						NULL
,fiscal_period_seq_end		INT						NULL
,fiscal_year_cd				NVARCHAR(100)			NULL
,start_date					DATE					NULL
,end_date					DATE					NULL
,year_start_date			DATE					NULL
,year_end_date				DATE					NULL
)