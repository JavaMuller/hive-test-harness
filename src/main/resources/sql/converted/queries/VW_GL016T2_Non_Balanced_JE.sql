	SELECT
		je_id 
		,year_flag_desc 
		,COUNT(je_id) 
	FROM
		(
			SELECT     je_id,SUM(Net_reporting_amount) AS Net_Amount,pp.year_flag_desc
			FROM          dbo.Ft_JE_Amounts f  --dbo.FLAT_JE
			INNER JOIN dbo.Parameters_period	 PP ON PP.year_flag = f.year_flag and pp.period_flag = f.period_flag
			--WHERE ver_end_date_id is null -- Added by prabakar to pull the latest version of data on July 2nd
			GROUP BY je_id,pp.year_flag_desc
			HAVING      (SUM(ROUND(Net_reporting_amount,2))<> 0)
		) AS sub1

	GROUP BY
		year_flag_desc
		,je_id