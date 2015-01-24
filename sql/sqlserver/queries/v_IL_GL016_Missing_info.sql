	SELECT
		je_id AS [Journal entry ID]
		,je_line_id AS [Journal entry line ID]
		,je_line_desc AS [Journal entry line description]
		,je_header_desc AS [Journal entry header description]
		,gl_account_cd AS [GL account code]
		,gl_subacct_name AS [GL sub-account name]
		,ey_gl_account_name AS [GL account]
		,ey_account_type AS [EY account type]
		,ey_account_sub_type AS [EY account sub-type]
		,ey_account_class AS [EY account class]
		,source_id AS [Source ID]
		,user_listing_id AS [User listing ID]
		,client_user_id AS [Client user ID]
		,preparer_ref AS [Preparer]
		,department AS [Preparer department]
		,first_name AS [Preparer first name]
		,role_resp AS [Preparer role]
		,bu_id AS [Business unit ID]
		,year_flag_desc AS [Accounting period]
		,period_flag_desc AS [Accounting sub period]
		,approver_department AS [Approver department]
		,approver_ref AS [Approver]
		,approved_by_id AS [Approver ID]
		,journal_type AS [Journal type]
		,year_flag AS [Year flag]
		,period_flag AS [Period flag]
		,segment1_id AS [Segment 1 id]
		,segment2_id AS [Segment 2 id]

		--,source_cd AS [Source code]
		--,source_desc AS [Source description]
		--,source_ref AS [Source]
		--,bu_cd AS [Business unit code]
		--,bu_desc AS [Business unit description]
		--,bu_ref AS [Business unit]
		--,bu_group AS [Business unit group]
		--,segment1_ref AS [Segment 1]
		--,segment2_ref AS [Segment 2]
		--,segment1_group AS [Segment 1 group]
		--,segment2_group AS [Segment 2 group]
		--,source_group AS [Source group]
		--,segment1_desc AS [Segment 1 desc]
		--,segment2_desc AS [Segment2_desc]


		,'' AS [Source code]
		,'' AS [Source description]
		,'' AS [Source]
		,'' AS [Business unit code]
		,'' AS [Business unit description]
		,'' AS [Business unit]
		,'' AS [Business unit group]
		,'' AS [Segment 1]
		,'' AS [Segment 2]
		,'' AS [Segment 1 group]
		,'' AS [Segment 2 group]
		,'' AS [Source group]
		,'' AS [Segment 1 desc]
		,'' AS [Segment2_desc]
	FROM dbo.FLAT_JE

	WHERE
		(je_line_desc IS NULL
		OR je_header_desc IS NULL
		OR gl_account_cd IS NULL
		OR client_user_id IS NULL
		OR department IS NULL
		OR role_resp IS NULL
		OR bu_id IS NULL
		OR approver_department IS NULL
		OR approver_ref IS NULL
		--OR segment1_group IS NULL
		--OR segment2_group IS NULL
		--OR source_group IS NULL
		--OR segment1_desc IS NULL
		--OR segment2_desc IS NULL
		--OR source_cd IS NULL
		--OR bu_cd IS NULL
		--OR bu_group IS NULL
		--OR segment1_ref IS NULL
		--OR segment2_ref IS NULL
		)
		and ver_end_date_id is null -- added by prabakar