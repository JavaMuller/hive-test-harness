SELECT
    TB.coa_id ,
    COA.ey_account_type ,
    COA.ey_account_sub_type ,
    COA.ey_account_class ,
    COA.ey_account_sub_class ,
    COA.ey_account_group_I ,
    COA.gl_account_name ,
    COA.gl_account_cd ,
    COA.ey_gl_account_name ,
    bu.bu_ref ,
    bu.bu_group ,
    PP.year_flag ,
    CASE
        WHEN PP.year_flag = 'CY'
        THEN 'Current'
        WHEN PP.year_flag = 'PY'
        THEN 'Prior'
        WHEN PP.year_flag = 'SP'
        THEN 'Subsequent'
        ELSE pp.year_flag_desc
                                                                                     END ,
    TB.functional_ending_balance - TB.functional_beginning_balance [Functional amount] ,
    TB.reporting_ending_balance - TB.reporting_beginning_balance [Reporting amount   ] ,
    TB.functional_beginning_balance [Functional beginning balance                    ] ,
    TB.functional_ending_balance [Functional ending balance                          ] ,
    TB.reporting_beginning_balance [Reporting beginning balance                      ] ,
    TB.reporting_ending_balance [Reporting ending balance                            ]
FROM
    [Trialbalance] TB
LEFT OUTER JOIN
    [v_Fiscal_calendar] FC
ON
    TB.period_id = FC.period_id
LEFT OUTER JOIN
    [Gregorian_calendar] GC
ON
    TB.trial_balance_end_date_id = GC.date_id
INNER JOIN
    [Parameters_period] PP
ON
    FC.fiscal_period_seq = PP.fiscal_period_seq_end
AND fc.fiscal_year_cd = PP.fiscal_year_cd
AND PP.period_flag = 'RP'
LEFT OUTER JOIN
    dbo.v_Chart_of_accounts COA
ON
    COA.coa_id = TB.coa_id
AND COA.bu_id = TB.bu_id
LEFT OUTER JOIN
    dbo.v_Business_unit_listing bu
ON
    bu.bu_id = TB.bu_id
WHERE
    tb.ver_end_date_id IS NULL