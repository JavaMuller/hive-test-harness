CREATE TABLE GL_012_Date_Analysis
(
	Je_Id	nvarchar(100) NULL
	,Je_Line_Id	nvarchar(100) NULL
	,Account_Code	nvarchar(200) NULL
	,GL_Account	nvarchar(200) NULL
	,Account_Class	nvarchar(200) NULL
	,Fiscal_period	nvarchar(100) NULL
	,Year_flag	nvarchar(25) NULL
	,Period_flag	nvarchar(25)NULL
	,Bu_id	Int	NULL
	,Segment1_id	Int	 NULL
	,Segment2_id	Int	 NULL
	,Source_id	Int	NULL
	,User_listing_id	Int	 NULL
	,Approver_by_id	Int	 NULL
	,Journal_type	nvarchar(25) NULL
	,Adjusted_fiscal_period	nvarchar(50) NULL
	,Day_number_of_week	int	 NULL
	,Day_Of_Week	nvarchar(50) NULL
	,Day_of_month	int	 NULL
	,Calendar_date	datetime NULL
	,Sequence_number	int	 NULL
	,Reporting_currency_code	nvarchar(50) NULL
	,Functional_Currency_Code	nvarchar(50)NULL
	,Net_reporting_amount	float	NULL
	,Net_reporting_amount_credit	float	 NULL
	,Net_reporting_amount_debit	float	NULL
	,Net_functional_amount	float	 NULL
	,Net_functional_amount_debit	float NULL
	,Net_functional_amount_credit	float NULL
	,Net_Amount	float	NULL
	,Net_Amount_Credit	float	 NULL
	,Net_Amount_Debit	float	NULL

) ON [PRIMARY]