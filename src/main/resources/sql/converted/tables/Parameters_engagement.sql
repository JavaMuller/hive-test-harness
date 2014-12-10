CREATE TABLE [dbo].[Parameters_engagement]
(
engagement_id							UNIQUEIDENTIFIER	NULL
,planning_materiality					NVARCHAR(50)		NULL
,tolerable_error 						INT					NULL
,sad_thresholds							INT					NULL
,current_year_cd						NVARCHAR(100)		NULL
,audit_period_end_period_cd				NVARCHAR(100)		NULL
,interim_period_end_period_cd			NVARCHAR(100)		NULL
,prior_year_cd							NVARCHAR(100)		NULL
,comparative_period_end_period_cd		NVARCHAR(100)		NULL
,receivables_ey_class					NVARCHAR(100)		NULL
,AR_aged_debt_threshold					INT					NULL
,AR_aging_basis							NVARCHAR(50)		NULL
,AP_aging_basis							NVARCHAR(50)		NULL
,bu_id_for_dates						INT					NULL
,Segment_selection1						VARCHAR(50)			NULL
,Segment_selection2						VARCHAR(50)			NULL
,prior_period_start_date				DATE				NULL
,prior_period_end_date					DATE				NULL
,comparative_period_end_date			DATE				NULL
,audit_period_start_date				DATE				NULL
,audit_period_end_date					DATE				NULL
,interim_period_end_date				DATE				NULL
,system_manual_indicator_option			NVARCHAR(50)		NULL
)