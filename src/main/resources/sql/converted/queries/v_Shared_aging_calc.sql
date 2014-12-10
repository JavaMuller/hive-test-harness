SELECT
  A.band + 1 AS band,
  A.ey_band_threshold_lower,
  A.ey_band_threshold_higher,
  (CONVERT(VARCHAR(10), A.band + 1) + '.  ' + A.aging_ref)
FROM
  (
    SELECT
      0    AS band,
      NULL AS ey_band_threshold_lower,
      NULL AS ey_band_threshold_higher,
      'Not due'
    UNION ALL
    SELECT
      pab1.band                                        AS band,
      pab1.ey_band_threshold_lower                     AS ey_band_threshold_lower,
      ISNULL(pab2.ey_band_threshold_lower - 1, 999999) AS ey_band_threshold_higher,
      CASE
      WHEN (pab2.ey_band_threshold_lower - 1) IS NULL
      THEN ' >=' + CONVERT(VARCHAR(10), pab1.ey_band_threshold_lower) + ' days'
      ELSE CONVERT(VARCHAR(10), pab1.ey_band_threshold_lower) + '-' + CONVERT(VARCHAR(10)
      , ISNULL(pab2.ey_band_threshold_lower - 1, 999999)) + ' days'
      END
    FROM
      parameters_aging_bands pab1
      LEFT OUTER JOIN
      parameters_aging_bands pab2
        ON
          pab1.band + 1 = pab2.band) AS A