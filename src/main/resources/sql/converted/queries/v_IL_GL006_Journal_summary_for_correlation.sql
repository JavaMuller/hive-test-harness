SELECT
					TB.coa_id			[COA Id]
						--,TB.bu_id
					,COA.ey_account_type						AS	[Account Type]
					,COA.ey_account_sub_type					AS	[Account Sub-type]
					,COA.ey_account_class					AS	[Account Class]
					,COA.ey_account_sub_class				AS	[Account Sub-class]
					,COA.ey_account_group_I					AS	[EY account group I]
					,COA.gl_account_name						AS	[GL Account Name]
					,COA.gl_account_cd						AS	[Account Code]
					,COA.ey_gl_account_name					AS	[GL Account]
					,bu.bu_ref								AS	[Business unit]
					,bu.bu_group							AS	[Business unit group]

					,PP.year_flag [Year Flag]

					,CASE WHEN PP.year_flag = 'CY' THEN 'Current'
						WHEN PP.year_flag = 'PY' THEN 'Prior'
						WHEN PP.year_flag = 'SP' THEN 'Subsequent'
						ELSE pp.year_flag_desc
					END	AS [Accounting period]--PP.year_flag_desc [Accounting period]

						--,TB.balance_curr_cd
						-- Changed the reference column since begining and ending is referred as functional begin and ending in RDM -- by prabakar july 1st begin
						--,TB.beginning_balance
						--,TB.ending_balance
					,TB.functional_ending_balance - TB.functional_beginning_balance [Functional amount]
					,TB.reporting_ending_balance - TB.reporting_beginning_balance	[Reporting amount]

					,TB.functional_beginning_balance					[Functional beginning balance]
					,TB.functional_ending_balance						[Functional ending balance]
					-- Changed the reference column since begining and ending is referred as functional begin and ending in RDM -- by prabakar july 1st end
					--,TB.reporting_curr_cd
					,TB.reporting_beginning_balance						[Reporting beginning balance]
					,TB.reporting_ending_balance						[Reporting ending balance]

	FROM				 [Trialbalance] TB --[Trial_balance] TB -- Changed by prabakar on july 1st to refer the rdm table instead cdm
	LEFT OUTER JOIN		 [v_Fiscal_calendar] FC			ON		TB.period_id = FC.period_id
	LEFT OUTER JOIN		 [Gregorian_calendar] GC			ON		TB.trial_balance_end_date_id = GC.date_id
	--Joining condition is updated and commented the exisitng condition by Prabakar on July 30th as per Conversation with TIM -- BEGIN
	INNER JOIN			 [Parameters_period] PP			ON	FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	AND fc.fiscal_year_cd = PP.fiscal_year_cd
																	AND PP.period_flag = 'RP'
																	--GC.calendar_date = PP.year_end_date
																	--AND FC.fiscal_period_seq = PP.fiscal_period_seq_end
																	--AND PP.end_date = PP.year_end_date
																	--AND PP.year_flag = 'CY'
	LEFT OUTER JOIN dbo.v_Chart_of_accounts COA on COA.coa_id = TB.coa_id AND COA.bu_id = TB.bu_id
	LEFT OUTER JOIN dbo.v_Business_unit_listing bu on bu.bu_id = TB.bu_id
	--Joining condition is updated and commented the exisitng condition by Prabakar on July 30th as per Conversation with TIM -- END
	WHERE tb.ver_end_date_id IS NULL