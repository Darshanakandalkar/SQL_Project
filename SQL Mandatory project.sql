use ig_clone;
select * from comments;  /id, coomment_text, photo_id, user_id, created_at/
select * from follows; /follower_id, followee_id, created_at/
select * from likes; /user_id, photo_id, created_at/
select * from photo_tags; /photo_id, tag_id,/
select * from photos; /id, image_url, user_id, created_at/
select * from tags; /id, tag_name, created_at/
select * from users; /id, username, created_at/
1)Create an ER diagram or draw a schema for the given database?

2)We want to reward the user who has been around the longest,find the 5 oldest users?
select * from users order by created_at limit 5;

3)To understand when to run the ad campaign, figure out the day of the week most users register on? 
select dayname(created_at) as Day,count(*) as Users from users
group by Day
order by Users desc limit 2;

4)To target inactive users in an email ad campaign, find the users who have never posted a photo?
select * from users;
select * from photos;

select id,username from users
where id not in (select user_id from photos);
//OR
select username from users
left join photos on users.id=photos.user_id
where photos.user_id is null;

5)Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?
select * from users;
select * from photos;
select * from likes;

select username, photos.image_url as IU, count(likes.photo_id) as total from users
JOIN photos ON users.id=photos.user_id
JOIN likes ON photos.id=likes.photo_id
group by IU
order by total desc
limit 1;

6)The investors want to know how many times does the average user post?
select ceil((select count(*) from photos)/(select count(*) from users)) as Userpost;

7)A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags?
select * from photo_tags;
select * from tags;

select id,tag_name,count(photo_tags.tag_id) as mostused from tags
join photo_tags on tags.id=photo_tags.tag_id
group by photo_tags.tag_id
order by mostused desc
limit 5;

8)To find out if there are bots, find users who have liked every single photo on the site?
select * from users;
select * from likes;
select * from photos;

select username,count(photo_id) as likes from users
left join likes on users.id=likes.user_id
where likes.user_id is not null
group by user_id
having likes =(select count(id) from photos);

9)To know who the celebrities are, find users who have never commented on a photo?
select * from users;
select * from comments;

select id,username from users
where id not in (select user_id from comments);
//OR
select username from users
left join comments on users.id=comments.user_id
where comments.user_id is null;

10)Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo?

select * from users;
select * from comments;
select * from photos;

select username from users
left join comments on users.id=comments.user_id
where comments.user_id is null;

select username,count(photo_id) as commented from users
inner join comments on users.id=comments.user_id
where comments.user_id is not null
group by user_id
having commented =(select count(id) from photos);
