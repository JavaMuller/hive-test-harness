SELECT
    NULL ,
    NULL ,
    coa.gl_account_cd ,
    coa.ey_gl_account_name ,
    coa.ey_account_class ,
    FJ.EY_period ,
    FJ.year_flag ,
    FJ.period_flag ,
    CASE
        WHEN FJ.year_flag ='CY'
        THEN 'Current'
        WHEN FJ.year_flag ='PY'
        THEN 'Prior'
        WHEN FJ.year_flag ='SP'
        THEN 'Subsequent'
        ELSE PP.year_flag_desc
    END ,
    PP.period_flag_desc ,
    bu.bu_ref ,
    bu.bu_group ,
    s1.ey_segment_ref ,
    s2.ey_segment_ref ,
    s1.ey_segment_group ,
    s2.ey_segment_group ,
    src.Source_ref ,
    src.source_group ,
    FJ.journal_type ,
    UL.preparer_ref ,
    UL.department ,
    NULL ,
    NULL ,
    FJ.reporting_amount_curr_cd ,
    FJ.functional_curr_cd [Functional Currency Code] ,
    FJ.net_reporting_amount ,
    FJ.Net_reporting_amount_credit ,
    FJ.Net_reporting_amount_debit ,
    FJ.net_functional_amount ,
    FJ.Net_functional_amount_debit ,
    FJ.Net_functional_amount_credit ,
    FC.fiscal_period_cd ,
    EntCal.day_number_of_week ,
    EntCal.day_of_week_desc ,
    EFFCAL.day_number_of_month AS [DAY OF MONTH] ,
    Net_Amount ,
    Net_Amount_Credit ,
    Net_Amount_Debit ,
    EntCal.calendar_date ,
    cd.Sequence
FROM
    dbo.FT_GL_Account FJ
INNER JOIN
    Gregorian_calendar EntCal
ON
    FJ.entry_date_id = EntCal.date_id
INNER JOIN
    Gregorian_calendar EFFCAL
ON
    FJ.effective_date_id = EFFCAL.date_id
INNER JOIN
    dbo.DIM_Calendar_seq_date cd
ON
    EntCal.calendar_date = cd.Calendar_date
INNER JOIN
    dbo.Parameters_period PP
ON
    PP.period_flag = FJ.period_flag
AND PP.year_flag = FJ.YEAR_FLAG
INNER JOIN
    dbo.v_Chart_of_accounts coa
ON
    coa.coa_id = FJ.coa_id
LEFT JOIN
    v_Fiscal_calendar FC
ON
    FJ.bu_id = FC.bu_id
AND ENTCAL.calendar_date BETWEEN FC.fiscal_period_start AND FC.fiscal_period_end
AND FC.adjustment_period = 'N'
LEFT OUTER JOIN
    dbo.v_User_listing UL
ON
    UL.user_listing_id = FJ.user_listing_id
LEFT OUTER JOIN
    dbo.v_Business_unit_listing BU
ON
    Bu.bu_id = fJ.bu_id
LEFT OUTER JOIN
    dbo.v_Source_listing src
ON
    src.source_id = fJ.source_id
LEFT OUTER JOIN
    dbo.v_Segment01_listing S1
ON
    S1.ey_segment_id = fJ.segment1_id
LEFT OUTER JOIN
    dbo.v_Segment02_listing S2
ON
    S2.ey_segment_id = fJ.segment2_id