CREATE TABLE [dbo].[GL_018_KPIs_unpivot](

			[source_id] [int] NOT NULL,
			[source_ref] [nvarchar](200) NULL,
			[source_group] [nvarchar](250) NULL,
			[Source_Cd] [nvarchar](25) NULL,
			[Source_Desc] [nvarchar](100) NULL,
			--[bu_id] [int] NOT NULL,
			[bu_ref] [nvarchar](125) NULL,
			[bu_group] [nvarchar](125) NULL,
			[Preparer_Name] [nvarchar](200) NULL,
			[preparer_ref] [nvarchar](100) NULL,
			[Preparer_department] [nvarchar](100) NULL,
			[journal_type] [nvarchar](25) NULL,
			[segment1_ref] [nvarchar](250) NULL,
			[segment1_group] [nvarchar](250) NULL,
			[segment2_ref] [nvarchar](250) NULL,
			[segment2_group] [nvarchar](250) NULL,
			[year_flag_desc] [nvarchar](200) NULL,
			[period_flag_desc] [nvarchar](200) NULL,
			[ey_period] [nvarchar](50) NULL,
			[Ratio_type] [nvarchar](50) NULL,
			[Ratio] [nvarchar](50) NULL,
			[Amount] FLOAT NULL,
			[Multiplier] INT NULL

) ON [PRIMARY]