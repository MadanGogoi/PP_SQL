-- Query to show the Social Media table with a 10 limit 
	Select * from Social_Media_Db.Social_media_youtubers smy  limit 10;

-- Query to find the number of rows in the table
	SELECT 
		count(*)
	FROM
		Social_Media_Db.Social_media_youtubers smy ;

-- Query to change the column name 
	ALter table 
		Social_Media_Db.Social_media_youtubers 
	change 
		youtuber_name Youtuber_name varchar(255);


-- Which youtuber has the highest and lowest subscribers 
	SELECT 
		Youtuber_name, Cast(SUBSTRING(Subscribers,1,LENGTH(Subscribers) - 1 ) As DECIMAL) * 1000000 AS Subscribers_list
	FROM
		Social_Media_Db.Social_media_youtubers smy 
	order by 
		Subscribers_list DESC 
	limit 5;

	SELECT 
		Youtuber_name, Subscribers
	FROM
		Social_Media_Db.Social_media_youtubers smy 
	ORDER BY 	
		Subscribers ASC 
	LIMIT 1;
	

-- Which youtube channel gets more average comments(avg_comments)
	SELECT 
		Youtuber_name, avg_comments 
	FROM 
		Social_Media_Db.Social_media_youtubers smy
	ORDER BY 
		avg_comments DESC
	LIMIT 1;

-- Query to find that many average comments to N/A value
	Select 
		Youtuber_name,Subscribers 
	FROM
		Social_Media_Db.Social_media_youtubers
	WHERE 
		avg_comments = 'N/A'
	LIMIT 
		10;
	
-- Now, we will change this avg_comments value from N/A to 0 value
	
	UPDATE 
		Social_Media_Db.Social_media_youtubers 
	SET 	
		avg_comments = 0
	WHERE 	
		avg_comments ='N/A';


-- Query to check how many other attributes have N/A values 

	-- For Audience Country column
	Select 
		count(*) 
	FROM
		Social_Media_Db.Social_media_youtubers
	WHERE 
		Audience_Country  = 'N/A';
	
	
	-- We will delete those data which have "N/A" in Audience Country
	
	DELETE FROM 	
		Social_Media_Db.Social_media_youtubers /* We could have also replaced those values */
	WHERE 
		Audience_Country = 'N/A';
	
	-- Now, for avg_views column	
	Select 
		Youtuber_name  
	FROM
		Social_Media_Db.Social_media_youtubers
	WHERE 
		avg_views  = '0k';
	
	-- Now, update the avg_views columns
	UPDATE 
		Social_Media_Db.Social_media_youtubers 
	SET 
		avg_views  = '0k'
	WHERE 	
		avg_views = '0';
	
	
	-- Now, for avg_likes column
	
	Select 
		count(*) 
	FROM
		Social_Media_Db.Social_media_youtubers
	WHERE 
		avg_likes  = 'N/A';	
	
	
-- We will update this 'N/A' value to 0 in avg_likes
	
	UPDATE 
		Social_Media_Db.Social_media_youtubers 
	SET 
		avg_likes = 0
	WHERE 	
		avg_likes = 'N/A';
	
	/* Finally we updated all the data . */
	
		
-- Query to know the column schema 
	
	SELECT COLUMN_NAME, DATA_TYPE
	FROM 
		INFORMATION_SCHEMA.COLUMNS
	WHERE 
		TABLE_SCHEMA = 'Social_Media_Db' AND 
		TABLE_NAME = 'Social_media_youtubers' AND 
		COLUMN_NAME = 'avg_views';
	
-- Query to find which category has the largest subscribers 
	
	SELECT 
		Category, SUM(CAST(SUBSTRING(Subscribers, 1, LENGTH(Subscribers) - 1)as Decimal )* 1000000 )  AS Subscribers_list
	FROM 
		Social_Media_Db.Social_media_youtubers smy 
	GROUP BY 
		Category 
	ORDER BY 
		Subscribers_list  DESC;
		

-- Query to find what catgeory Indian and United States people like to watch more

	SELECT 
		Category
	FROM
		Social_Media_Db.Social_media_youtubers smy 
	WHERE  
		Audience_Country = 'India'
	GROUP BY 
	Category ;

	SELECT 
		Category
	FROM 
		Social_Media_Db.Social_media_youtubers smy 
	WHERE 	
		Audience_Country = 'United States'
	GROUP BY 
		Category ;
		
	
-- Query to find what category's like to watch by US And India		
	SELECT 
		Category
	FROM 
		Social_Media_Db.Social_media_youtubers smy 
	WHERE 	
		Audience_Country IN ('United States' ,'India')
	GROUP BY 
		Category
	
	
-- Query to find which catgeory's are both similar to India and US 
	SELECT 
		Category
	FROM 
		Social_Media_Db.Social_media_youtubers smy 
	WHERE 	
		Audience_Country IN ('United States' , 'India')
	GROUP BY 
		Category 
	HAVING 
		COUNT(DISTINCT Audience_Country) = 2;
	
-- Query to find how many category column values are null
	SELECT 
		count(*)
	FROM
		Social_Media_Db.Social_media_youtubers smy 
	Where 
		Category = '';
	

-- Query to update the Category attribute whose values are empty
	
	UPDATE 
		Social_Media_Db.Social_media_youtubers
	SET 	
		Category = 'Miscellaneous'
	WHERE 
		Category = 'miscellaneous';
		
		
-- Query to find which Category has highest Average Views 	
	SELECT 
		Category,
		ROUND(SUM(transformed_value))as total_transformed_value
	FROM(
		SELECT
			Category,
			CASE 
				WHEN avg_views LIKE '%k' THEN CAST(SUBSTRING(avg_views, 1, LENGTH(avg_views) - 1) as FLOAT) * 1000
				WHEN avg_views LIKE '%M' THEN CAST(SUBSTRING(avg_views, 1, LENGTH(avg_views) - 1) as FLOAT ) * 1000000
				ELSE CAST(avg_views as DECIMAL)
			END as transformed_value
		FROM
			Social_Media_Db.Social_media_youtubers smy 
		) AS subquery
	GROUP BY
		Category
	ORDER BY 
		total_transformed_value DESC;
	
	
-- Query to find which Category has the highest average likes 
	
	SELECT 
		Category,
		ROUND(SUM(transformed_value)) as total_transformed_value
	FROM(
		SELECT
			Category,
			CASE
				WHEN avg_likes LIKE '%k' THEN CAST(SUBSTRING(avg_likes, 1, LENGTH(avg_likes) - 1) as FLOAT) * 1000
				WHEN avg_likes LIKE '%M' THEN CAST(SUBSTRING(avg_likes, 1, LENGTH(avg_likes) - 1) as FLOAT ) * 1000000
				ELSE CAST(avg_likes as DECIMAL)
			END as transformed_value
		FROM
			Social_Media_Db.Social_media_youtubers smy 
		) AS subquery
	GROUP BY 
		Category
	ORDER BY 
		total_transformed_value DESC;
		
-- Query to find which country audience has the highest average likes 
	
	SELECT 
		Audience_Country,
		ROUND(SUM(transformed_value)) as total_transformed_value
	FROM(
		SELECT
			Audience_Country,
			CASE
				WHEN avg_likes LIKE '%k' THEN CAST(SUBSTRING(avg_likes, 1, LENGTH(avg_likes) - 1) as FLOAT) * 1000
				WHEN avg_likes LIKE '%M' THEN CAST(SUBSTRING(avg_likes, 1, LENGTH(avg_likes) - 1) as FLOAT ) * 1000000
				ELSE CAST(avg_likes as DECIMAL)
			END as transformed_value
		FROM
			Social_Media_Db.Social_media_youtubers smy 
		) AS subquery
	GROUP BY 
		Audience_Country
	ORDER BY 
		total_transformed_value DESC;

-- Query to find which category has how many channels 
	
	
	SELECT 	
		Category, count(channel_name) as total_channels 
	FROM
		Social_Media_Db.Social_media_youtubers smy 
	GROUP BY 
		Category 
	ORDER BY 
		total_channels DESC ;

		
	

