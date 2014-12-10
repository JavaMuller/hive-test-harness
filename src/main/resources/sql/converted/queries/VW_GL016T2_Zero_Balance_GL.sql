
SELECT
    fj.coa_id ,
    coa.gl_account_cd ,
    CASE
        WHEN fj.year_flag = 'CY'
        THEN 'Current'
        WHEN fj.year_flag = 'PY'
        THEN 'Prior'
        WHEN fj.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
    END ,
    NULL ,
    NULL ,
    NULL ,
    NULL ,
    'Journal entries with GL accounts not in trial balance' ,
    NULL AS 'FPS'
FROM
    dbo.FT_GL_Account FJ
INNER JOIN
    dbo.v_Chart_of_accounts coa
ON
    coa.coa_id = fj.coa_id
INNER JOIN
    dbo.Parameters_period PP
ON
    pp.period_flag = fj.period_flag
AND pp.year_flag = fj.year_flag
WHERE
    gl_account_cd NOT IN
                          (
                          SELECT DISTINCT
                              coa.gl_account_cd
                          FROM
                              dbo.trialbalance tb
                          INNER JOIN
                              dbo.DIM_Chart_of_Accounts coa
                          ON
                              coa.coa_id = tb.coa_id
                          WHERE
                              TB.ver_end_date_id IS NULL
                          UNION
                          SELECT
                              tb.coa_id ,
                              coa.gl_account_cd ,
                              CASE
                                  WHEN pp.year_flag = 'CY'
                                  THEN 'Current'
                                  WHEN pp.year_flag = 'PY'
                                  THEN 'Prior'
                                  WHEN pp.year_flag = 'SP'
                                  THEN 'Subsequent'
                              END ,
                              ROUND(tb.functional_beginning_balance,2) ,
                              ROUND(tb.functional_ending_balance,2) ,
                              ROUND(tb.reporting_beginning_balance,2) ,
                              ROUND(tb.reporting_ending_balance,2) ,
                              'Active GL accounts with no balance' ,
                              fc.fiscal_period_seq AS 'FPS'
                          FROM
                              dbo.TrialBalance tb
                          INNER JOIN
                              dbo.DIM_Chart_of_Accounts coa
                          ON
                              coa.Coa_id = tb.coa_id
                          INNER JOIN
                              dbo.Dim_Fiscal_calendar fc
                          ON
                              tb.period_id = fc.period_id
                          INNER JOIN
                              dbo.Parameters_period pp
                          ON
                              fc.fiscal_period_seq = pp.fiscal_period_seq_end
                          AND fc.fiscal_year_cd = pp.fiscal_year_cd
                          WHERE
                              fc.fiscal_period_seq =
                              (
                                  SELECT
                                      MAX(pp1.fiscal_period_seq_end)
                                  FROM
                                      dbo.Parameters_period pp1
                                  WHERE
                                      pp1.fiscal_year_cd = pp.fiscal_year_cd
                                  AND pp1.year_flag = pp.year_flag )
                          AND ( (
                                      ROUND(functional_beginning_balance,2) = 0
                                  AND ROUND(functional_ending_balance,2) = 0)
                              OR  (
                                      ROUND(reporting_beginning_balance,2) = 0
                                  AND ROUND(reporting_ending_balance,2) = 0) )
                          AND tb.coa_id IN
                                            (
                                            SELECT DISTINCT
                                                fj.coa_id
                                            FROM
                                                dbo.FT_GL_Account FJ )
                          AND TB.ver_end_date_id IS NULL