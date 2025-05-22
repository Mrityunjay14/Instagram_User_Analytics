/* A) Marketing Analysis:
 1. Loyal User Reward: User's who have been using the platform for the longest time.*/
SELECT * FROM users;

SELECT 	username, created_at from users order by created_at asc limit 5;

/*2. Inactive User Engagement: User's who have never posted a single photo on Instagram.*/
SELECT * FROM photos, users;
SELECT u.username FROM users AS u LEFT JOIN photos AS p on p.user_id=u.id where p.image_url is null order by u.username;

/*3. Contest Winner Declaration: List of the users who got most likes on a single photo.*/
SELECT * FROM likes, photos, users;

SELECT 
    likes.photo_id, 
    users.username, 
    COUNT(likes.user_id) AS nooflikes
FROM 
    likes
    INNER JOIN photos ON likes.photo_id = photos.id
    INNER JOIN users ON photos.user_id = users.id
GROUP BY 
    likes.photo_id, 
    users.username
ORDER BY 
    nooflikes DESC;
    
/*4. Hashtag Research: Top five most commonly hashtags used on the Instagram*/

SELECT * FROM photo_tags, tags;

SELECT 
    t.tag_name, 
    COUNT(p.photo_id) AS ht 
FROM 
    photo_tags p 
    INNER JOIN tags t ON t.id = p.tag_id 
GROUP BY 
    t.tag_name 
ORDER BY 
    ht DESC 
LIMIT 5;

/*5. Ad Campaign Launch: Provide insights on when to schedule an ad campaign?*/

SELECT * FROM users;

SELECT DATE_FORMAT((created_at), '%W') AS dayy, count(username) FROM users GROUP BY 1 ORDER BY 2 DESC;

/*B) Investor Metrics:
1. User Engagement: Calculating the average number of posts per user on Instagram. Also, finding total number of photos
on Instagram/ total number of users.*/

SELECT * FROM photos, users;
WITH base AS(
SELECT u.id AS userid, COUNT(p.id) AS photoid FROM users u LEFT JOIN photos p ON p.user_id=u.id GROUP BY u.id)
SELECT SUM(photoid) AS totalphotos, COUNT(userid) AS total_users, SUM(photoid)/ COUNT(userid) AS photoperuser FROM base;

/*2. Bots & Fake Accounts: Identifying users (potentially bots) who have liked every single photo on the site (since it's
impossible for the normal user).*/

SELECT * FROM users, likes;
WITH base AS(
SELECT u.username, COUNT(l.photo_id) AS likess FROM likes l INNER JOIN users u ON u.id= l.user_id 
GROUP BY u.username)
SELECT username, likess FROM base WHERE likess= (SELECT COUNT(*) FROM photos) ORDER BY username;