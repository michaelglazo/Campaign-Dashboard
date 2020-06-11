WITH dimcat AS (
    SELECT DISTINCT
        item_profile.itemid
        , IF(category_mapping.main_display_name = 'Digital Goods & Vouchers', 'Digital Orders', category_mapping.cluster) AS cluster
        , category_mapping.main_display_name
    FROM
        shopee_ph.item_profile
    JOIN
        shopee_ph_anlys.category_mapping
        ON item_profile.main_category = category_mapping.main_category
)

SELECT
    t.shopid
    ,dimcat.main_display_name
    ,sum(pv_cd) as pv_cd
FROM 
    shopee_ph.traffic_mart_dws__item_exposure_di t
LEFT JOIN shopee_ph.user_profile u on u.shopid = t.shopid 
LEFT JOIN dimcat on t.itemid = dimcat.itemid
WHERE 
    u.is_official_store = 1
    and local_date BETWEEN DATE_ADD('month',-3,DATE_TRUNC('month',DATE_ADD('day',-1,current_date))) and 	DATE_ADD('day',-1,current_date)
GROUP BY
1,2