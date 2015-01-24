
CREATE TABLE [dbo].[GL_008_JE_Search](

	Journal_entry_id nvarchar(100) null
	,Journal_entry_line nvarchar(100) null
	,Journal_entry_description nvarchar(250) null
	,Journal_entry_type nvarchar(25) null
	,Reporting_amount float null
	,Functional_amount float null
	,Journal_line_description nvarchar(250) null
	,Year_flag	nvarchar(25) NULL
	,Period_flag	nvarchar(25)NULL
	,Bu_id	Int	NULL
	,Segment1_id	Int	 NULL
	,Segment2_id	Int	 NULL
	,Source_id	Int	NULL
	,User_listing_id	Int	 NULL
	,Journal_type	nvarchar(25) NULL
	,ey_period nvarchar(100) NULL

) ON [PRIMARY]