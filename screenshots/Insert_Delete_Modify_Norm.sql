

-- Display Song ID, Song Name, Artist Name, Release Date, and Genre of songs 
--		that fit into Rock or any of its subgenres
select Song.Song_ID as 'Song ID', Song_name as 'Song Name', Artist_Name as 'Artist', 
	Release_date as 'Release Date', Genre_name as 'Genre'
from Song LEFT OUTER JOIN Song_Genres on Song.Song_ID = Song_Genres.Song_ID 
		Join Artist on Artist.Artist_ID = Song.Artist_ID
where Genre_name like '%Rock%';

-- Inserts an App User
insert into app_user (User_ID, Username, Name, Date_joined)
	values(10, 'iheartmusic', 'Romeo Romano', '2021-05-02');
-- Display
select * from app_user where User_ID = 10;

-- Delete an App User
delete from app_user where User_ID = 10;
-- Display
select * from app_user where User_ID = 10;

-- Update a subscription's price
select * from subscription where user_id = 2;
update subscription
set price = 700
where user_id = 2;
select * from subscription where user_id = 2;

-- view of subscriptions of app users that have been on the app for at least 5 years
Go
create or alter view Long_Runners as
select app_user.User_ID as 'User ID', Username, Name, Start_date as 'Start Date', end_date as 'End Date'
from app_user join subscription on app_user.user_id = subscription.user_id
where DATEDIFF(year, Start_date, End_date) >= 5;
Go
select * from Long_Runners;

