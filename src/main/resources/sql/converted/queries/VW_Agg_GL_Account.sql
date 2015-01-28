SELECT
    AGG.coa_id AS `COA ID `,
    COA.ey_account_type AS `Account TYPE `,
    COA.ey_account_sub_type AS `Account Sub - TYPE `,
    COA.ey_account_class AS `Account CLASS `,
    COA.ey_account_sub_class AS `Account Sub - CLASS `,
    COA.gl_account_name AS `GL Account NAME `,
    COA.ey_gl_account_name AS `GL Account`,
    COA.ey_gl_account_name AS `EY GL Account NAME `,
    COA.gl_account_cd AS `GL Account Cd`,
    COA.ey_account_group_I AS `Account GROUP `,
    COA.ey_account_group_II AS `Account sub GROUP `,
    Sys_man_ind AS ` SYSTEM - MANUAL `,
    UL.preparer_ref AS Preparer,
    UL.department AS `Preparer department`,
    journal_type AS `Journal TYPE `,
    AGG.year_flag AS ` YEAR flag`,
    AGG.period_flag AS ` PERIOD flag`,
    CASE
    WHEN AGG.year_flag = 'CY'
    THEN 'Current'
    WHEN AGG.year_flag = 'PY'
    THEN 'Prior'
    WHEN AGG.year_flag = 'SP'
    THEN 'Subsequent'
    ELSE PP.year_flag_desc
    END AS `Accounting PERIOD `,
    PP.period_flag_desc AS `Accounting sub PERIOD `,
    Ey_period AS `Fiscal PERIOD`,
    reporting_amount_curr_cd AS `Reporting currency code`,
    Net_reporting_amount AS `Net reporting amount`,
    Net_reporting_amount_credit AS `Net reporting credit amount`,
    Net_reporting_amount_debit AS `Net reporting debit amount`,
    functional_curr_cd AS `Functional currency code`,
    net_functional_amount AS `Net functional amount`,
    net_functional_amount_credit AS `Net functional credit amount`,
    net_functional_amount_debit AS `Net functional debit amount`,
    Bu.bu_group AS `Business unit GROUP `,
    Bu.bu_ref AS `Business Unit`,
    DS.source_ref AS ` SOURCE `,
    DS.source_group AS ` SOURCE GROUP `,
    SEG1.ey_segment_ref AS `Segment 1`,
    SEG2.ey_segment_ref AS `Segment 2`,
    SEG1.ey_segment_group AS `Segment 1 GROUP `,
    SEG2.ey_segment_group AS `Segment 2 GROUP `,
    agg.dr_cr_ind AS `INDICATOR`
FROM
    mv_agg_act AGG
    INNER JOIN
    mv_chart_of_accounts COA
        ON
            COA.coa_id = AGG.coa_id
            AND COA.bu_id = AGG.bu_id
    LEFT OUTER JOIN
    Parameters_period PP
        ON
            PP.period_flag = AGG.period_flag
            AND PP.year_flag = AGG.year_flag
    LEFT OUTER JOIN
    mv_user_listing UL
        ON
            UL.user_listing_id = AGG.user_listing_id
    LEFT OUTER JOIN
    mv_source_listing DS
        ON
            DS.source_id = AGG.Source_Id
    LEFT OUTER JOIN
    mv_business_unit_listing Bu
        ON
            BU.bu_id = AGG.bu_id
    LEFT OUTER JOIN
    mv_segment01_listing Seg1
        ON
            seg1.ey_segment_id = AGG.segment1_id
    LEFT OUTER JOIN
    mv_segment02_listing Seg2
        ON
            seg2.ey_segment_id = AGG.segment2_id;