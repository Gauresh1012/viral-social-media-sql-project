create Database Viral_Social_media;

use Viral_Social_media;
#-------------------------------------------------------------------------------------------------------------------------------------
create table Social_media(
Post_ID varchar (20),
Platform varchar (100),
Hashtag varchar (90),
Content_Type varchar(100),
Region varchar (50), 
Views int,
Likes int,
Shares int,
Comments int,
Engagement_Level varchar(50)
);
#-------------------------------------------------------------------------------------------------------------------------------------
select * from Social_media;
#-------------------------------------------------------------------------------------------------------------------------------------
LOAD DATA INFILE 'C:/Viral_Social_Media_Trends.csv'
INTO TABLE Social_media
FIELDS TERMINATED BY ',' 
IGNORE 1 ROWS;
#-------------------------------------------------------------------------------------------------------------------------------------
-- How many posts exist in the dataset for each social media platform?
select Platform,count(Post_ID) as Total_Posts from Social_media group by 1;
#------------------------------------------------------------------------------------------------------------------------------------
-- Which post has the highest number of views?
select Post_ID,Views from Social_media order by 2 desc limit 1 ;
#-------------------------------------------------------------------------------------------------------------------------------------
-- Which post has the second highest number of views?
with ctc as (
select Post_ID,Views, row_number() over(order by Views desc) as ranks from Social_media
) 
select Post_ID,Views from ctc where ranks=2;
#-------------------------------------------------------------------------------------------------------------------------------------
-- What is the most frequently used hashtag?
select Hashtag,count(*) as Count from Social_media group by 1 order by 2 desc;
#-------------------------------------------------------------------------------------------------------------------------------------
-- How many posts belong to each engagement level (High, Medium, Low)?
select Engagement_Level,count(*) as Post_Count from Social_media group by 1 order by 2 desc;
#-------------------------------------------------------------------------------------------------------------------------------------
-- What is the total number of views across all platforms?
select sum(Views) as total_number_of_views from Social_media;
#-------------------------------------------------------------------------------------------------------------------------------------
## Intermediate Questions ##
select * from Social_media;

-- What is the average number of likes, shares, and comments per platform?
select Platform,avg(Likes) as Avg_Likes,avg(Comments) as Avg_Comments,avg(Shares) as Avg_Shares from Social_media group by 1;
#-------------------------------------------------------------------------------------------------------------------------------------
-- Which hashtags generate the highest engagement (Likes + Shares + Comments)?
select hashtag,max(Likes),max(Shares),max(Comments) from Social_media group by 1 order by 2,3,4 desc;
#-------------------------------------------------------------------------------------------------------------------------------------
-- What is the most popular content type based on total views?
select Content_Type,sum(Views) as Total_views from Social_media group by 1 order by 2 desc;
#-------------------------------------------------------------------------------------------------------------------------------------
-- How do different engagement levels vary across regions?
select Count(*),Region,Engagement_Level from Social_media group by 2,3 order by 2,3;
#-------------------------------------------------------------------------------------------------------------------------------------
-- What is the top-performing post in terms of total engagement (Likes + Shares + Comments)?
select Post_ID, Platform, Hashtag, Content_Type, Region,(Likes+Shares+Comments) as Total_engagement  from Social_media order by Total_engagement desc limit 1;
#-------------------------------------------------------------------------------------------------------------------------------------
## Advanced Questions ##
select * from Social_media;
#-------------------------------------------------------------------------------------------------------------------------------------
-- Which platform has the highest average engagement per post?
select Platform,avg(Likes+Shares+Comments) as Avg_engagement from Social_media Group by 1 order by Avg_engagement desc;
#-------------------------------------------------------------------------------------------------------------------------------------
-- What is the correlation between views and engagement metrics (Likes, Shares, Comments)?
select round(avg(Likes/Views),4)  as Avg_Likes_Per_View,
       round(avg(Shares/Views),4) as Avg_Shares_Per_View,
       round(avg(Comments/Views),4) as Avg_Comments_Per_View from Social_media where views > 0;
#-------------------------------------------------------------------------------------------------------------------------------------       
-- Which region has the most viral posts based on total engagement?
select Region,sum(Likes+Shares+Comments)AS tOTAL_ENGAGEMENT from Social_media GROUP BY 1 order by 2 desc;
#-------------------------------------------------------------------------------------------------------------------------------------
-- How do different content types perform across platforms?
select Content_Type,Platform,count(*) as Perform from Social_media group by 1,2 order by 1,2;
#-------------------------------------------------------------------------------------------------------------------------------------
-- What percentage of posts fall into each engagement level category?
SELECT Engagement_Level, 
       COUNT(*) AS Total_Posts,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Social_Media), 2) AS Percentage
FROM Social_Media
GROUP BY Engagement_Level
ORDER BY Percentage DESC;
#-------------------------------------------------------------------------------------------------------------------------------------
