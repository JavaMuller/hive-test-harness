SELECT DISTINCT
    *
FROM
    (
     SELECT
            fj.coa_id AS `Coa Id`,
            fj.ey_account_type AS `Account Type`,
            fj.ey_account_sub_type AS `Account Sub-type`,
            fj.ey_account_class AS `Account Class`,
            fj.ey_account_sub_class AS `Account Sub-class`,
            fj.gl_account_cd AS `GL Account Cd`,
            fj.gl_account_name AS `GL Account Name`,
            fj.ey_gl_account_name AS `GL Account`,
            fj.bu_id AS `BU Id`,
            bu.bu_ref AS `Business unit`,
            bu.bu_group AS `Business unit group`,
            fj.segment1_id AS `Segment 1 Id`,
            s1.ey_segment_ref AS `Segment 1`,
            s1.ey_segment_group AS `Segment 1 group`,
            fj.segment2_id AS `Segment 2 Id`,
            s2.ey_segment_ref AS `Segment 2`,
            s2.ey_segment_group AS `Segment 2 group`,
            fj.functional_curr_cd AS `Functional Currency Code`,
            fj.reporting_amount_curr_cd AS `Reporting currency code`,
            fj.period_flag AS `Period flag`,
            fj.year_flag AS `Year flag`,
            CASE
                WHEN fj.year_flag = 'CY'
                THEN 'Current'
                WHEN fj.year_flag = 'PY'
                THEN 'Prior'
                WHEN fj.year_flag = 'SP'
                THEN 'Subsequent'
                ELSE fj.year_flag_Desc
            END AS `Accounting period`,
            fj.period_flag_desc AS `Accounting sub period`,
            SUM ( functional_amount ) AS `Net functional amount`,
            SUM ( reporting_amount ) AS `Net reporting amount`,
            fj.ver_end_date_id AS `Version end date Id`,
            fj.ver_desc AS `Version description`,
            'Backposting activity' AS `Source type`
       FROM
            flat_je fj
LEFT OUTER JOIN
            mv_business_unit_listing BU
         ON
            Bu.bu_id = fj.bu_id
LEFT OUTER JOIN
            mv_segment01_listing S1
         ON
            S1.ey_segment_id = fj.segment1_id
LEFT OUTER JOIN
            mv_segment02_listing S2
         ON
            S2.ey_segment_id = fj.segment2_id
      WHERE
            fj.period_flag = 'IP'
        AND fj.ver_end_date_id IS NULL
   GROUP BY
            fj.coa_id,
            fj.gl_account_cd,
            fj.gl_account_name,
            fj.ey_gl_account_name,
            fj.bu_id,
            bu.bu_ref,
            bu.bu_group,
            fj.segment1_id,
            s1.ey_segment_ref,
            s1.ey_segment_group,
            fj.segment2_id,
            s2.ey_segment_ref,
            s2.ey_segment_group,
            fj.functional_curr_cd,
            fj.reporting_amount_curr_cd,
            fj.period_flag,
            fj.year_flag,
            fj.year_flag_desc,
            fj.ver_end_date_id,
            fj.ver_desc,
            fj.ey_account_type,
            fj.ey_account_sub_type,
            fj.ey_account_class,
            fj.ey_account_sub_class,
            period_flag_desc
  UNION ALL
     SELECT
            tb.coa_id AS `Coa Id`,
            coa.ey_account_type AS `Account Type`,
            coa.ey_account_sub_type AS `Account Sub-type`,
            coa.ey_account_class AS `Account Class`,
            coa.ey_account_sub_class AS `Account Sub-class`,
            coa.gl_account_cd AS `GL Account Cd`,
            coa.gl_account_name AS `GL Account Name`,
            coa.ey_gl_account_name AS `GL Account`,
            tb.bu_id AS `BU Id`,
            bu.bu_ref AS `Business unit`,
            bu.bu_group AS `Business unit group`,
            tb.segment1_id AS `Segment 1 Id`,
            s1.ey_segment_ref AS `Segment 1`,
            s1.ey_segment_group AS `Segment 1 group`,
            tb.segment2_id AS `Segment 2 Id`,
            s2.ey_segment_ref AS `Segment 2`,
            s2.ey_segment_group AS `Segment 2 group`,
            tb.functional_curr_cd AS `Functional Currency Code`,
            tb.reporting_curr_cd AS `Reporting currency code`,
            pp.period_flag AS `Period flag`,
            pp.year_flag AS `Year flag`,
            CASE
                WHEN pp.year_flag = 'CY'
                THEN 'Current'
                WHEN pp.year_flag = 'PY'
                THEN 'Prior'
                WHEN pp.year_flag = 'SP'
                THEN 'Subsequent'
                ELSE pp.year_flag_desc
            END AS `Accounting period`,
            pp.period_flag_desc AS `Accounting sub period`,
            tb.functional_beginning_balance + ag.net_functional_amount AS `Net functional amount`,
            tb.reporting_beginning_balance + ag.net_reporting_amount AS `Net reporting amount`,
            NULL AS `Version end date Id`,
            NULL AS `Version description`,
            'Interim as posted' AS `Source type`
       FROM
           trial_balance tb
FULL OUTER JOIN
            (
             SELECT
                    fj.coa_id,
                    fj.gl_account_cd,
                    fj.gl_account_name,
                    fj.ey_gl_account_name,
                    fj.bu_id,
                    bu.bu_ref,
                    bu.bu_group,
                    fj.segment1_id,
                    s1.ey_segment_ref,
                    s1.ey_segment_group,
                    fj.segment2_id,
                    s2.ey_segment_ref,
                    s2.ey_segment_group,
                    fj.functional_curr_cd,
                    fj.reporting_amount_curr_cd,
                    fj.period_flag,
                    fj.year_flag,
                    fj.year_flag_desc,
                    fj.ver_end_date_id,
                    fj.ver_desc,
                    SUM ( functional_amount ) AS net_functional_amount,
                    SUM ( reporting_amount ) AS net_reporting_amount
               FROM
                    flat_je fj
    LEFT OUTER JOIN
                    mv_business_unit_listing BU
                 ON
                    Bu.bu_id = fj.bu_id
    LEFT OUTER JOIN
                    mv_segment01_listing S1
                 ON
                    S1.ey_segment_id = fj.segment1_id
    LEFT OUTER JOIN
                    mv_segment02_listing S2
                 ON
                    S2.ey_segment_id = fj.segment2_id
              WHERE
                    fj.period_flag = 'IP'
                AND fj.ver_end_date_id IS NULL
           GROUP BY
                    fj.coa_id,
                    fj.gl_account_cd,
                    fj.gl_account_name,
                    fj.ey_gl_account_name,
                    fj.bu_id,
                    bu.bu_ref,
                    bu.bu_group,
                    fj.segment1_id,
                    s1.ey_segment_ref,
                    s1.ey_segment_group,
                    fj.segment2_id,
                    s2.ey_segment_ref,
                    s2.ey_segment_group,
                    fj.functional_curr_cd,
                    fj.reporting_amount_curr_cd,
                    fj.period_flag,
                    fj.year_flag,
                    fj.year_flag_desc,
                    fj.ver_end_date_id,
                    fj.ver_desc ) ag
         ON
            ag.coa_id = tb.coa_id
        AND ag.bu_id = tb.bu_id
 INNER JOIN
            DIM_Chart_of_Accounts coa
         ON
            coa.Coa_id = tb.coa_id
 INNER JOIN
            Dim_Fiscal_calendar fc
         ON
            tb.period_id = fc.period_id
 INNER JOIN
            Parameters_period pp
         ON
            fc.fiscal_period_seq = pp.fiscal_period_seq_end
        AND fc.fiscal_year_cd = pp.fiscal_year_cd
LEFT OUTER JOIN
            mv_business_unit_listing BU
         ON
            Bu.bu_id = tb.bu_id
LEFT OUTER JOIN
            mv_segment01_listing S1
         ON
            S1.ey_segment_id = tb.segment1_id
LEFT OUTER JOIN
            mv_segment02_listing S2
         ON
            S2.ey_segment_id = tb.segment2_id
      WHERE
            pp.period_flag = 'IP'
        AND tb.ver_end_date_id IS NULL
  UNION ALL
     SELECT
            tb.coa_id AS `Coa Id`,
            coa.ey_account_type AS `Account Type`,
            coa.ey_account_sub_type AS `Account Sub-type`,
            coa.ey_account_class AS `Account Class`,
            coa.ey_account_sub_class AS `Account Sub-class`,
            coa.gl_account_cd AS `GL Account Cd`,
            coa.gl_account_name AS `GL Account Name`,
            coa.ey_gl_account_name AS `GL Account`,
            tb.bu_id AS `BU Id`,
            bu.bu_ref AS `Business unit`,
            bu.bu_group AS `Business unit group`,
            tb.segment1_id AS `Segment 1 Id`,
            s1.ey_segment_ref AS `Segment 1`,
            s1.ey_segment_group AS `Segment 1 group`,
            tb.segment2_id AS `Segment 2 Id`,
            s2.ey_segment_ref AS `Segment 2`,
            s2.ey_segment_group AS `Segment 2 group`,
            tb.functional_curr_cd AS `Functional Currency Code`,
            tb.reporting_curr_cd AS `Reporting currency code`,
            pp.period_flag AS `Period flag`,
            pp.year_flag AS `Year flag`,
            CASE
                WHEN pp.year_flag = 'CY'
                THEN 'Current'
                WHEN pp.year_flag = 'PY'
                THEN 'Prior'
                WHEN pp.year_flag = 'SP'
                THEN 'Subsequent'
                ELSE pp.year_flag_desc
            END AS `Accounting period`,
            pp.period_flag_desc AS `Accounting sub period`,
            tb.functional_ending_balance AS `Net functional amount`,
            tb.reporting_ending_balance AS `Net reporting amount`,
            NULL AS `Version end date Id`,
            NULL AS `Version description`,
            'Interim as shown' AS `Source type`
       FROM
           trial_balance tb
 INNER JOIN
            DIM_Chart_of_Accounts coa
         ON
            coa.Coa_id = tb.coa_id
 INNER JOIN
            Dim_Fiscal_calendar fc
         ON
            tb.period_id = fc.period_id
 INNER JOIN
            Parameters_period pp
         ON
            fc.fiscal_period_seq = pp.fiscal_period_seq_end
        AND fc.fiscal_year_cd = pp.fiscal_year_cd
LEFT OUTER JOIN
            mv_business_unit_listing BU
         ON
            Bu.bu_id = tb.bu_id
LEFT OUTER JOIN
            mv_segment01_listing S1
         ON
            S1.ey_segment_id = tb.segment1_id
LEFT OUTER JOIN
            mv_segment02_listing S2
         ON
            S2.ey_segment_id = tb.segment2_id
      WHERE
            pp.period_flag = 'IP'
        AND tb.ver_end_date_id IS NULL ) ;