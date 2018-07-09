/*
Here's the first-touch query, in case you need it
*/

/*
#1a. count the distinct number of utm_campaigns
*/

SELECT utm_campaign, COUNT(utm_campaign)
FROM page_visits
Group By 1;

/* AND...
*/
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

/*
#1b. count the distinct number of utm_sources
*/

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

/*
#1c. view the different utm_sources and utm_campaigns
*/

SELECT utm_source, utm_campaign
FROM page_visits
GROUP BY 1;

/*
#2 pages on CoolTShirts.com
*/

SELECT page_name
FROM page_visits
GROUP BY 1
ORDER BY 1;

/*
#3
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
  )
SELECT 	ft_attr.utm_source,
  			ft_attr.utm_campaign,
  			COUNT(*)
  FROM ft_attr
  GROUP BY 1, 2
  ORDER BY 3 DESC;
  /*
  #4 LAST TOUCH
  */
  
WITH last_touch AS (
		SELECT user_id,
				MAX(timestamp) AS last_touch_at
		FROM page_visits
		GROUP BY user_id),
lt_attr AS (
  SELECT 
  	lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
  )
SELECT 	lt_attr.utm_source,
  			lt_attr.utm_campaign,
  			COUNT(*)
  FROM lt_attr
  GROUP BY 1, 2
  ORDER BY 3 DESC;
 /* 
 #5 visitors making a purchase
 */
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';

/*
#6 Last touches on purchase page
*/
WITH last_touch AS (
		SELECT user_id,
				MAX(timestamp) AS last_touch_at
		FROM page_visits
  	WHERE page_name = '4 - purchase'
		GROUP BY user_id),
lt_attr AS (
  SELECT 
  	lt.user_id,
    lt.last_touch_at,
  	pv.page_name,
    pv.utm_source,
		pv.utm_campaign
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
  )
SELECT 	
				lt_attr.page_name,
			  lt_attr.utm_source,
  			lt_attr.utm_campaign,
  			COUNT(*)
  FROM lt_attr
  GROUP BY 1, 2
  ORDER BY 4 DESC;


SELECT COUNT(DISTINCT user_id), page_name
FROM page_visits
GROUP BY page_name;