CREATE TABLE
    mv_business_unit_listing
    (
        bu_id INT,
        engagement_id STRING,
        bu_cd STRING,
        bu_desc STRING,
        bu_hier_01_cd STRING,
        bu_hier_01_desc STRING,
        bu_hier_02_cd STRING,
        bu_hier_02_desc STRING,
        bu_hier_03_cd STRING,
        bu_hier_03_desc STRING,
        bu_hier_04_cd STRING,
        bu_hier_04_desc STRING,
        bu_hier_05_cd STRING,
        bu_hier_05_desc STRING,
        seg_01_cd STRING,
        seg_01_desc STRING,
        seg_02_cd STRING,
        seg_02_desc STRING,
        seg_03_cd STRING,
        seg_03_desc STRING,
        ver_start_date_id INT,
        ver_end_date_id INT,
        ver_desc STRING,
        bu_group STRING,
        bu_ref STRING
    ) ;


insert overwrite TABLE mv_business_unit_listing
    SELECT
        all_version.bu_id,
        latest_version.engagement_id,
        latest_version.bu_cd,
        latest_version.bu_desc,
        latest_version.bu_hier_01_cd,
        latest_version.bu_hier_01_desc,
        latest_version.bu_hier_02_cd,
        latest_version.bu_hier_02_desc,
        latest_version.bu_hier_03_cd,
        latest_version.bu_hier_03_desc,
        latest_version.bu_hier_04_cd,
        latest_version.bu_hier_04_desc,
        latest_version.bu_hier_05_cd,
        latest_version.bu_hier_05_desc,
        latest_version.seg_01_cd,
        latest_version.seg_01_desc,
        latest_version.seg_02_cd,
        latest_version.seg_02_desc,
        latest_version.seg_03_cd,
        latest_version.seg_03_desc,
        latest_version.ver_start_date_id,
        latest_version.ver_end_date_id,
        latest_version.ver_desc,
        COALESCE(latest_version.bu_hier_01_desc, BU_MAPPING.bu_group) AS bu_group,
        concat(COALESCE(latest_version.bu_cd, ''),' - ', COALESCE(latest_version.bu_desc, '')) AS bu_ref
    FROM
        Business_unit_listing all_version
        LEFT OUTER JOIN
        Business_unit_listing latest_version
            ON
                all_version.bu_cd = latest_version.bu_cd
        LEFT OUTER JOIN
        (
            SELECT
                2 AS bu_id,
                'Limited scope' AS bu_group
            UNION ALL
            SELECT
                3 AS bu_id,
                'Limited scope' AS bu_group
            UNION ALL
            SELECT
                4 AS bu_id,
                'Full scope' AS bu_group
            UNION ALL
            SELECT
                5 AS bu_id,
                'Full scope' AS bu_group
            UNION ALL
            SELECT
                6 AS bu_id,
                'Other component' AS bu_group
            UNION ALL
            SELECT
                8 AS bu_id,
                'EY component' AS bu_group
            UNION ALL
            SELECT
                9 AS bu_id,
                'Other component' AS bu_group
            UNION ALL
            SELECT
                10 AS bu_id,
                'Limited scope' AS bu_group) AS BU_MAPPING
            ON
                all_version.bu_id = BU_MAPPING.bu_id
    WHERE
        latest_version.ver_end_date_id IS NULL;