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
    o.grass_date
    ,o.shopid
    ,dimcat.main_display_name
    ,sum(gmv_usd) as gmv_usd
    ,sum(order_fraction) as orders
    , CASE
            WHEN grass_date BETWEEN DATE_ADD('month',-1,DATE_TRUNC('month',DATE_ADD('day',-1,current_date))) and DATE_ADD('day',-1,current_date)  then 1
            else 0
    END as L30D
FROM 
shopee_ph.order_mart__order_item_profile o
LEFT JOIN shopee_ph.user_profile u on u.shopid = o.shopid 
LEFT JOIN dimcat on o.itemid = dimcat.itemid
WHERE
    u.is_official_store = 1
    and grass_date BETWEEN DATE_ADD('month',-3,DATE_TRUNC('month',DATE_ADD('day',-1,current_date))) and 	DATE_ADD('day',-1,current_date)
GROUP BY 1,2,3,6

