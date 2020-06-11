SELECT a.grass_date as date_id
        , a.shopid
        , b.main_category
        , sum(ads_clicks) as Clicks
        , sum(ads_impressions) as Impressions
        , sum(ads_clicks) / cast(sum(ads_impressions) as DOUBLE) as CTR
        , sum(ads_orders) as Orders
        , sum(ads_items_sold) as Units_Sold
        , sum(ads_gmv_usd) as GMV
        , sum(ads_expenditure_usd) as Expense
        , sum(ads_gmv_usd) / cast(sum(ads_expenditure_usd) as DOUBLE) as ROI
        , CASE
            WHEN a.grass_date BETWEEN DATE_ADD('month',-1,DATE_TRUNC('month',DATE_ADD('day',-1,current_date))) and DATE_ADD('day',-1,current_date)  then 1
            else 0
         END as L30D 
FROM shopee_ph.paid_ads_mart__agg_ads_tab as a
LEFT JOIN shopee_ph.user_profile u on u.shopid = a.shopid
LEFT JOIN shopee_ph.item_profile b on b.shopid = a.shopid AND b.itemid = a.itemid
WHERE a.date_id BETWEEN DATE_ADD('month',-3,DATE_TRUNC('month',DATE_ADD('day',-1,current_date))) and DATE_ADD('day',-1,current_date)
AND u.is_official_store = 1
GROUP BY 1,2,3,12