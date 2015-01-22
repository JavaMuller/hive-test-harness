SELECT DISTINCT *
FROM
    (
        SELECT CASE
               WHEN f.year_flag = 'CY'
               THEN 'Current'
               WHEN f.year_flag = 'PY'
               THEN 'Prior'
               WHEN f.year_flag = 'SP'
               THEN 'Subsequent'
               ELSE pp.year_flag_desc
               END AS `Accounting period`,
        PP.Period_flag_desc AS `Accounting sub period`,
        F.year_flag AS ` YEAR flag`,
        F.period_flag AS `Period flag`,
        F.ey_period AS `Fiscal period`,
        C.ey_account_type AS `Account TYPE `,
        C.ey_account_sub_type AS `Account Sub- TYPE `,
        C.ey_account_class AS `Account Class`,
        C.ey_account_sub_class AS `Account Sub-class`,
        C.gl_account_name AS `GL Account NAME `,
        C.gl_account_cd AS `GL Account Cd`,
        C.ey_gl_account_name AS `GL Account`,
        C.ey_account_group_I AS `Account GROUP `,
        Dp.preparer_ref AS `Preparer`,
        DP.department AS `Preparer department`,
        DP1.department AS `Approver department`,
        DP1.preparer_ref AS `Approver`,
        B.bu_group AS `Business unit GROUP `,
        b.bu_ref AS `Business unit`,
        s1.ey_segment_group AS `Segment 1 GROUP`,
        s2.ey_segment_group AS `Segment 2 GROUP`,
        s1.ey_segment_ref AS `Segment 1`,
        s2.ey_segment_ref AS `Segment 2`,
        src.source_group AS `Source GROUP `,
        src.source_Ref AS `Source`,
        f.journal_type AS `Journal TYPE `,
        f.reporting_amount_curr_cd AS `Reporting currency code`,
        f.functional_curr_cd AS `Functional currency code`,
        SUM(f.Net_reporting_amount) AS `Net reporting amount`,
        SUM(f.Net_reporting_amount_credit) AS `Net reporting amount credit`,
        SUM(f.Net_reporting_amount_debit) AS `Net reporting amount debit`,
        SUM(f.Net_functional_amount) AS `Net functional amount`,
        SUM(f.Net_functional_amount_credit) AS `Net functional amount credit`,
        SUM(f.Net_functional_amount_debit) AS `Net functional amount debit`,
        'Activity' AS `Source TYPE `,
        NULL AS `Period END DATE `,
        NULL AS `Fiscal period sequence`,
        NULL AS `Fiscal period sequence END `
        FROM
        FT_GL_Account F
        INNER JOIN
        Parameters_period PP
        ON
        PP.year_flag = f.year_flag
        AND PP.period_flag = f.period_flag
        INNER JOIN
        Dim_Preparer DP
        ON
        DP.user_listing_id = f.user_listing_id
        LEFT OUTER JOIN
        Dim_Preparer DP1
        ON
        DP1.user_listing_id = f.approved_by_id
        LEFT OUTER JOIN
        v_Business_unit_listing B
        ON
        B.bu_id = F.bu_id
        LEFT OUTER JOIN
        v_Segment01_listing s1
        ON
        s1.ey_segment_id = f.segment1_id
        LEFT OUTER JOIN
        v_Segment02_listing s2
        ON
        s2.ey_segment_id = f.segment2_id
        LEFT OUTER JOIN
        v_Source_listing Src
        ON
        Src.Source_Id = f.source_id
        INNER JOIN
        DIM_Chart_of_Accounts C
        ON
        C.Coa_id = f.coa_id
        GROUP BY
        PP.year_flag_desc,
        PP.Period_flag_desc,
        F.year_flag,
        F.period_flag,
        F.ey_period,
        C.ey_account_type,
        C.ey_account_sub_type,
        C.ey_account_class,
        C.ey_account_sub_class,
        C.gl_account_name,
        C.gl_account_cd,
        C.ey_gl_account_name,
        C.ey_account_group_I,
        Dp.preparer_ref,
        DP.department,
        DP1.department,
        DP1.preparer_ref,
        B.bu_group,
        b.bu_ref,
        s1.ey_segment_group,
        s2.ey_segment_group,
        s1.ey_segment_ref,
        s2.ey_segment_ref,
        src.source_group,
        src.source_Ref,
        f.journal_type,
        f.reporting_amount_curr_cd,
        f.functional_curr_cd
        UNION ALL
        SELECT
        CASE
        WHEN pp.year_flag = 'CY'
        THEN 'Current'
        WHEN pp.year_flag = 'PY'
        THEN 'Prior'
        WHEN pp.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
        END AS `Accounting period`,
        pp.Period_flag_desc AS `Accounting sub period`,
        pp.year_flag AS ` YEAR flag`,
        pp.period_flag AS `Period flag`,
        fc.fiscal_period_cd AS `Fiscal period`,
        coa.ey_account_type AS `Account TYPE `,
        coa.ey_account_sub_type AS `Account Sub- TYPE `,
        coa.ey_account_class AS `Account Class`,
        coa.ey_account_sub_class AS `Account Sub-class`,
        coa.gl_account_name AS `GL Account NAME `,
        coa.gl_account_cd AS `GL Account Cd`,
        coa.ey_gl_account_name AS `GL Account`,
        coa.ey_account_group_I AS `Account GROUP `,
        'N/A for balances' AS `Preparer`,
        'N/A for balances' AS `Preparer department`,
        'N/A for balances' AS `Approver department`,
        'N/A for balances' AS `Approver`,
        bu.bu_group AS `Business unit GROUP `,
        bu.bu_ref AS `Business unit`,
        s1.ey_segment_group AS `Segment 1 GROUP `,
        s2.ey_segment_group AS `Segment 2 GROUP `,
        s1.ey_segment_ref AS `Segment 1`,
        s2.ey_segment_ref AS `Segment 2`,
        'N/A for balances' AS `Source GROUP `,
        'N/A for balances' AS `Source`,
        'N/A for balances' AS `Journal TYPE `,
        tb.reporting_curr_cd AS `Reporting currency code`,
        tb.functional_curr_cd AS `Functional currency code`,
        tb.reporting_ending_balance AS `Net reporting amount`,
        0.0 AS `Net reporting amount credit`,
        0.0 AS `Net reporting amount debit`,
        tb.functional_ending_balance AS `Net functional amount`,
        0.0 AS `Net functional amount credit`,
        0.0 AS `Net functional amount debit`,
        'Balance' AS `Source TYPE `,
        pp.end_date AS `Period END DATE `,
        fc.fiscal_period_seq AS `Fiscal period sequence`,
        pp.fiscal_period_seq_END AS `Fiscal period sequence END `
        FROM
        TrialBalance tb
        INNER JOIN
        DIM_Chart_of_Accounts coa
        ON
        coa.Coa_id = tb.coa_id
        INNER JOIN
        Dim_Fiscal_calendar fc
        ON
        tb.period_id = fc.period_id
        AND tb.bu_id = fc.bu_id
        INNER JOIN
        Parameters_period pp
        ON
        fc.fiscal_year_cd = pp.fiscal_year_cd
        LEFT OUTER JOIN
        v_Business_unit_listing Bu
        ON
        Bu.bu_id = tb.bu_id
        LEFT OUTER JOIN
        v_Segment01_listing s1
        ON
        s1.ey_segment_id = tb.segment1_id
        LEFT OUTER JOIN
        v_Segment02_listing s2
        ON
        s2.ey_segment_id = tb.segment2_id
        WHERE
        tb.ver_end_date_id IS NULL
        AND (((
        pp.period_flag = 'IP'
        OR pp.period_flag = 'PIP'))
        OR ((
        pp.period_flag = 'RP'
        OR pp.period_flag = 'PRP'))
        OR (
        pp.period_flag = 'SP'))
    );