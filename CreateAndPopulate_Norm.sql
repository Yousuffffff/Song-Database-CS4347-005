-- Create database
DROP DATABASE IF EXISTS SongDB;
CREATE DATABASE SongDB;

USE SongDB;

-- Create tables
CREATE TABLE ARTIST (
	Artist_ID INT PRIMARY KEY,
	Artist_name VARCHAR(100),
	Artist_type INT NOT NULL CHECK (Artist_type IN(1,2))
);
-- Type 1 is Solo
-- Type 2 is Group

CREATE TABLE GROUP_MEMBERS (
	Group_ID INT NOT NULL,
	Member_name VARCHAR(100) NOT NULL,
	FOREIGN KEY (Group_ID) REFERENCES ARTIST(Artist_ID), 
    PRIMARY KEY (Group_ID, Member_name)
);

CREATE TABLE FEATURES (
	Artist_ID INT NOT NULL,
	Feature_ID INT NOT NULL,
	FOREIGN KEY (Artist_ID) REFERENCES ARTIST(Artist_ID),
	FOREIGN KEY (Feature_ID) REFERENCES ARTIST(Artist_ID), 
    PRIMARY KEY (Artist_ID, Feature_ID)
);

CREATE TABLE ALBUM (
	Album_ID INT PRIMARY KEY,
	Album_name VARCHAR(100) NOT NULL,
	Release_date DATE NOT NULL,
	Artist_ID INT NOT NULL,
	FOREIGN KEY (Artist_ID) REFERENCES ARTIST(Artist_ID)
);

CREATE TABLE SONG (
	Song_ID INT PRIMARY KEY,
	Song_name VARCHAR(100) NOT NULL,
	Release_date DATE NOT NULL,
	Artist_ID INT NOT NULL,
	FOREIGN KEY (Artist_ID) REFERENCES ARTIST(Artist_ID)
);

CREATE TABLE SONG_GENRES (
	Song_ID INT NOT NULL,
	Genre_name VARCHAR(100) NOT NULL,
	FOREIGN KEY (Song_ID) REFERENCES SONG(Song_ID), 
    PRIMARY KEY (Song_ID, Genre_name)
);

CREATE TABLE ARTIST_GENRES (
	Artist_ID INT,
	Genre_name VARCHAR(100) NOT NULL,
	FOREIGN KEY (Artist_ID) REFERENCES ARTIST(Artist_ID), 
    PRIMARY KEY (Artist_ID, Genre_name)
);

CREATE TABLE APP_USER (
	User_ID INT PRIMARY KEY,
	Username VARCHAR(100) NOT NULL,
	Name VARCHAR(100) NOT NULL,
	Date_joined DATE NOT NULL,
	No_of_playlists INT DEFAULT 0
);

CREATE TABLE SUBSCRIPTION (
	User_ID INT NOT NULL,
	Start_date DATE NOT NULL,
	End_date DATE,
	Price DECIMAL,
	FOREIGN KEY (User_ID) REFERENCES APP_USER(User_ID), 
    PRIMARY KEY (User_ID, Start_date)
);

CREATE TABLE PLAYLIST (
	Playlist_ID INT PRIMARY KEY,
	Playlist_name VARCHAR(100) NOT NULL,
	Creator_ID INT NOT NULL,
	No_of_albums INT DEFAULT 0,
	No_of_songs INT DEFAULT 0,
	Is_private BIT,
	FOREIGN KEY (Creator_ID) REFERENCES APP_USER(User_ID)
);

-- CONTAIN relation separated into 3 relations: 

CREATE TABLE ALBUM_CONTAIN_SONG (
	Album_ID INT,
	Song_ID INT,
	FOREIGN KEY (Album_ID) REFERENCES ALBUM(Album_ID),
	FOREIGN KEY (Song_ID) REFERENCES SONG(Song_ID), 
    PRIMARY KEY (Album_ID, Song_ID)
);

CREATE TABLE PLAYLIST_CONTAIN_SONG (
	Playlist_ID INT,
	Song_ID INT,
	FOREIGN KEY (Playlist_ID) REFERENCES PLAYLIST(Playlist_ID),
	FOREIGN KEY (Song_ID) REFERENCES SONG(Song_ID), 
    PRIMARY KEY (Playlist_ID, Song_ID)
);

CREATE TABLE PLAYLIST_CONTAIN_ALBUM (
	Album_ID INT,
	Playlist_ID INT,
	FOREIGN KEY (Album_ID) REFERENCES ALBUM(Album_ID),
	FOREIGN KEY (Playlist_ID) REFERENCES PLAYLIST(Playlist_ID),
    PRIMARY KEY (Album_ID, Playlist_ID)
);


-- Create triggers to update album count, playlist count, etc.
CREATE TRIGGER INC_REF_COUNT_USER
ON PLAYLIST
AFTER INSERT
AS
BEGIN
	UPDATE APP_USER
    SET No_of_playlists = No_of_playlists + 1
	FROM APP_USER u
	INNER JOIN inserted i ON u.User_ID = i.Creator_ID;
END;

-- INC_REF_COUNT_PLAYLIST separated into 2 triggers

CREATE TRIGGER INC_REF_COUNT_PLAYLIST_ALBUM
ON PLAYLIST_CONTAIN_ALBUM
AFTER INSERT
AS
BEGIN
	UPDATE PLAYLIST
	SET No_of_albums = No_of_albums + 1
	FROM PLAYLIST p
	INNER JOIN inserted i ON p.Playlist_ID = i.Playlist_ID;
END;

CREATE TRIGGER INC_REF_COUNT_PLAYLIST_SONG
ON PLAYLIST_CONTAIN_SONG
AFTER INSERT
AS
BEGIN
	UPDATE PLAYLIST
	SET No_of_songs = No_of_songs + 1
	FROM PLAYLIST p
	INNER JOIN inserted i ON p.Playlist_ID = i.Playlist_ID;
END;

CREATE TRIGGER DEC_REF_COUNT_USER
ON PLAYLIST
AFTER DELETE
AS
BEGIN
    UPDATE APP_USER
    SET No_of_playlists = No_of_playlists - 1
	FROM APP_USER u
	INNER JOIN deleted d ON u.User_ID = d.Creator_ID;
END;

-- DEF_REF_COUNT_PLAYLIST separated into 2 triggers

CREATE TRIGGER DEC_REF_COUNT_PLAYLIST_ALBUM
ON PLAYLIST_CONTAIN_ALBUM
AFTER DELETE
AS
BEGIN
	UPDATE PLAYLIST
	SET No_of_albums = No_of_albums - 1
	FROM PLAYLIST p
	INNER JOIN deleted d ON p.Playlist_ID = d.Playlist_ID;
END; 

CREATE TRIGGER DEC_REF_COUNT_PLAYLIST_SONG
ON PLAYLIST_CONTAIN_SONG
AFTER DELETE
AS
BEGIN
	UPDATE PLAYLIST
	SET No_of_songs = No_of_songs - 1
	FROM PLAYLIST p
	INNER JOIN deleted d ON p.Playlist_ID = d.Playlist_ID;
END;


-- Populate the database
INSERT INTO ARTIST (Artist_ID, Artist_name, Artist_type)
VALUES
(0, 'Weezer', 2),
(1, 'Stevie Wonder', 1),
(2, 'Fleetwood Mac', 2),
(3, 'Michael Jackson', 1),
(4, 'Prince', 1),
(5, 'Pink Floyd', 2),
(6, 'Steely Dan', 2),
(7, 'Childish Gambino', 1),
(8, 'Amy Winehouse', 1),
(9, 'Taylor Swift', 1),
(10, 'Chappell Roan', 1),
(11, 'Sabrina Carpenter', 1),
(12, 'Paul McCartney', 1);

INSERT INTO ARTIST_GENRES (Artist_ID, Genre_name)
VALUES
(0, 'Rock'),
(1, 'Soul'),
(1, 'R&B'),
(1, 'Funk'),
(2, 'Classic Rock'),
(2, 'Pop'),
(3, 'Pop'),
(3, 'R&B'),
(4, 'Pop'),
(5, 'Psychedelic Rock'),
(6, 'Yacht Rock'),
(7, 'R&B'),
(7, 'Rap'),
(7, 'Hip-Hop'),
(8, 'Soul'),
(8, 'Jazz'),
(9, 'Pop'),
(10, 'Pop'),
(11, 'Pop'),
(12, 'Classic Rock');

INSERT INTO GROUP_MEMBERS (Group_ID, Member_name)
VALUES
(0, 'Rivers Cuomo'),
(0, 'Brian Bell'),
(0, 'Patrick Wilson'),
(0, 'Scott Shriner'),
(2, 'Mick Fleetwood'),
(2, 'John McVie'),
(2, 'Christine McVie'),
(2, 'Lindsey Buckingham'),
(2, 'Stevie Nicks'),
(5, 'David Gilmour'),
(5, 'Roger Waters'),
(5, 'Nick Mason'),
(5, 'Richard Wright'),
(6, 'Donald Fagen'),
(6, 'Walter Becker');

INSERT INTO FEATURES (Artist_ID, Feature_ID)
VALUES
(3, 12);

INSERT INTO ALBUM (Album_ID, Album_name, Release_date, Artist_ID)
VALUES
(0, 'Weezer', '1994-05-10', 0),
(1, 'Songs In The Key Of Life', '1976-09-28', 1),
(2, 'Rumours', '1977-02-04', 2),
(3, 'Thriller', '1982-11-29', 3),
(4, 'Purple Rain', '1984-06-25', 4),
(5, 'The Dark Side of the Moon', '1973-03-01', 5),
(6, 'Can''t Buy A Thrill', '1972-11-01', 6),
(7, 'Awaken, My Love!', '2016-12-02', 7),
(8, 'Back To Black', '2006-10-27', 8),
(9, 'Speak Now', '2010-10-25', 9),
(10, 'The Rise and Fall of a Midwest Princess', '2023-09-22', 10),
(11, 'Short n'' Sweet', '2024-08-23', 11);

INSERT INTO SONG (Song_ID, Song_name, Release_date, Artist_ID)
VALUES
(0, 'My Name Is Jonas', '1994-05-10', 0),
(1, 'No One Else', '1994-05-10', 0),
(2, 'The World Has Turned And Left Me Here', '1994-05-10', 0),
(3, 'Buddy Holly', '1994-05-10', 0),
(4, 'Undone - The Sweater Song', '1994-05-10', 0),
(5, 'Surf Wax America', '1994-05-10', 0),
(6, 'Say It Ain''t So', '1994-05-10', 0),
(7, 'In The Garage', '1994-05-10', 0),
(8, 'Holiday', '1994-05-10', 0),
(9, 'Only In Dreams', '1994-05-10', 0),
(10, 'Love''s In Need Of Love Today', '1976-09-28', 1),
(11, 'Have A Talk With God', '1976-09-28', 1),
(12, 'Village Ghetto Land', '1976-09-28', 1),
(13, 'Contusion', '1976-09-28', 1),
(14, 'Sir Duke', '1976-09-28', 1),
(15, 'I Wish', '1976-09-28', 1),
(16, 'Knocks Me Off My Feet', '1976-09-28', 1),
(17, 'Pastime Paradise', '1976-09-28', 1),
(18, 'Summer Soft', '1976-09-28', 1),
(19, 'Ordinary Pain', '1976-09-28', 1),
(20, 'Isn''t She Lovely', '1976-09-28', 1),
(21, 'Joy Inside My Tears', '1976-09-28', 1),
(22, 'Black Man', '1976-09-28', 1),
(23, 'Ngiculela-Es Una Historia-I Am Singing', '1976-09-28', 1),
(24, 'If It''s Magic', '1976-09-28', 1),
(25, 'As', '1976-09-28', 1),
(26, 'Another Star', '1976-09-28', 1),
(27, 'Saturn', '1976-09-28', 1),
(28, 'Ebony Eyes', '1976-09-28', 1),
(29, 'All Day Sucker', '1976-09-28', 1),
(30, 'Easy Goin'' Evening (My Mama''s Call)', '1976-09-28', 1),
(31, 'Second Hand News', '1977-02-04', 2),
(32, 'Dreams', '1977-02-04', 2),
(33, 'Never Going Back Again', '1977-02-04', 2),
(34, 'Don''t Stop', '1977-02-04', 2),
(35, 'Go Your Own Way', '1977-02-04', 2),
(134, 'Songbird', '1977-02-04', 2),
(36, 'The Chain', '1977-02-04', 2),
(37, 'You Make Loving Fun', '1977-02-04', 2),
(38, 'I Don''t Want to Know', '1977-02-04', 2),
(39, 'Oh Daddy', '1977-02-04', 2),
(40, 'Gold Dust Woman', '1977-02-04', 2),
(41, 'Wanna Be Startin'' Somethin''', '1982-11-29', 3),
(42, 'Baby Be Mine', '1982-11-29', 3),
(43, 'The Girl Is Mine', '1982-11-29', 3),
(44, 'Thriller', '1982-11-29', 3),
(45, 'Beat It', '1982-11-29', 3),
(46, 'Billie Jean', '1982-11-29', 3),
(47, 'Human Nature', '1982-11-29', 3),
(48, 'P.Y.T. (Pretty Young Thing)', '1982-11-29', 3),
(49, 'The Lady in My Life', '1982-11-29', 3),
(50, 'Let''s Go Crazy', '1984-06-25', 4),
(51, 'Take Me with U', '1984-06-25', 4),
(52, 'The Beautiful Ones', '1984-06-25', 4),
(53, 'Computer Blue', '1984-06-25', 4),
(54, 'Darling Nikki', '1984-06-25', 4),
(55, 'When Doves Cry', '1984-06-25', 4),
(56, 'I Would Die 4 U', '1984-06-25', 4),
(57, 'Baby I''m a Star', '1984-06-25', 4),
(58, 'Purple Rain', '1984-06-25', 4),
(59, 'Speak to Me', '1973-03-01', 5),
(60, 'Breathe (In the Air)', '1973-03-01', 5),
(61, 'On the Run', '1973-03-01', 5),
(62, 'Time', '1973-03-01', 5),
(63, 'The Great Gig in the Sky', '1973-03-01', 5),
(64, 'Money', '1973-03-01', 5),
(65, 'Us and Them', '1973-03-01', 5),
(66, 'Any Colour You Like', '1973-03-01', 5),
(67, 'Brain Damage', '1973-03-01', 5),
(68, 'Eclipse', '1973-03-01', 5),
(69, 'Do It Again', '1972-11-01', 6),
(70, 'Dirty Work', '1972-11-01', 6),
(71, 'Kings', '1972-11-01', 6),
(72, 'Midnite Cruiser', '1972-11-01', 6),
(73, 'Only A Fool Would Say That', '1972-11-01', 6),
(74, 'Reelin'' In The Years', '1972-11-01', 6),
(75, 'Fire In The Hole', '1972-11-01', 6),
(76, 'Brooklyn (Owes The Charmer Under Me)', '1972-11-01', 6),
(77, 'Change Of The Guard', '1972-11-01', 6),
(78, 'Turn That Heartbeat Over Again', '1972-11-01', 6),
(79, 'Me and Your Mama', '2016-12-02', 7),
(80, 'Have Some Love', '2016-12-02', 7),
(81, 'Boogieman', '2016-12-02', 7),
(82, 'Zombies', '2016-12-02', 7),
(83, 'Riot', '2016-12-02', 7),
(84, 'Redbone', '2016-12-02', 7),
(85, 'California', '2016-12-02', 7),
(86, 'Terrified', '2016-12-02', 7),
(87, 'Baby Boy', '2016-12-02', 7),
(88, 'The Night Me and Your Mama Met', '2016-12-02', 7),
(89, 'Stand Tall', '2016-12-02', 7),
(90, 'Rehab', '2006-10-27', 8),
(91, 'You Know I''m No Good', '2006-10-27', 8),
(92, 'Me & Mr Jones', '2006-10-27', 8),
(93, 'Just Friends', '2006-10-27', 8),
(94, 'Back To Black', '2006-10-27', 8),
(95, 'Love Is A Losing Game', '2006-10-27', 8),
(96, 'Tears Dry On Their Own', '2006-10-27', 8),
(97, 'Wake Up Alone', '2006-10-27', 8),
(98, 'Some Unholy War', '2006-10-27', 8),
(99, 'He Can Only Hold Her', '2006-10-27', 8),
(100, 'Addicted', '2006-10-27', 8),
(101, 'Mine', '2010-10-25', 9),
(102, 'Sparks Fly', '2010-10-25', 9),
(103, 'Back To December', '2010-10-25', 9),
(104, 'Speak Now', '2010-10-25', 9),
(105, 'Dear John', '2010-10-25', 9),
(106, 'Mean', '2010-10-25', 9),
(107, 'The Story Of Us', '2010-10-25', 9),
(108, 'Never Grow Up', '2010-10-25', 9),
(109, 'Enchanted', '2010-10-25', 9),
(110, 'Better Than Revenge', '2010-10-25', 9),
(111, 'Innocent', '2010-10-25', 9),
(112, 'Haunted', '2010-10-25', 9),
(113, 'Last Kiss', '2010-10-25', 9),
(114, 'Long Live', '2010-10-25', 9),
(115, 'Femininomenon', '2023-09-22', 10),
(116, 'Red Wine Supernova', '2023-09-22', 10),
(117, 'After Midnight', '2023-09-22', 10),
(118, 'Coffee', '2023-09-22', 10),
(119, 'Casual', '2023-09-22', 10),
(120, 'Super Graphic Ultra Modern Girl', '2023-09-22', 10),
(121, 'HOT TO GO!', '2023-09-22', 10),
(122, 'My Kink Is Karma', '2023-09-22', 10),
(123, 'Picture You', '2023-09-22', 10),
(124, 'Kaleidoscope', '2023-09-22', 10),
(125, 'Pink Pony Club', '2023-09-22', 10),
(126, 'Naked In Manhattan', '2023-09-22', 10),
(127, 'California', '2023-09-22', 10),
(128, 'Guilty Pleasure', '2023-09-22', 10),
(129, 'Espresso','2024-08-23', 11),
(130, 'Taste','2024-08-23', 11),
(131, 'Please Please Please','2024-08-23', 11),
(132, 'Bed Chem','2024-08-23', 11),
(133, 'Good Graces','2024-08-23', 11);

INSERT INTO SONG_GENRES (Song_ID, Genre_name)
VALUES
(0, 'Rock'),
(1, 'Rock'),
(2, 'Rock'),
(3, 'Rock'),
(4, 'Rock'),
(5, 'Rock'),
(6, 'Rock'),
(7, 'Rock'),
(8, 'Rock'),
(9, 'Rock'),
(10, 'R&B'),
(10, 'Soul'),
(11, 'R&B'),
(11, 'Soul'),
(12, 'R&B'),
(12, 'Soul'),
(13, 'R&B'),
(13, 'Soul'),
(14, 'R&B'),
(14, 'Soul'),
(15, 'R&B'),
(15, 'Soul'),
(16, 'R&B'),
(16, 'Soul'),
(17, 'R&B'),
(17, 'Soul'),
(18, 'R&B'),
(18, 'Soul'),
(19, 'R&B'),
(19, 'Soul'),
(20, 'R&B'),
(20, 'Soul'),
(21, 'R&B'),
(21, 'Soul'),
(22, 'R&B'),
(22, 'Soul'),
(23, 'R&B'),
(23, 'Soul'),
(24, 'R&B'),
(24, 'Soul'),
(25, 'R&B'),
(25, 'Soul'),
(26, 'R&B'),
(26, 'Soul'),
(27, 'R&B'),
(27, 'Soul'),
(28, 'R&B'),
(28, 'Soul'),
(29, 'R&B'),
(29, 'Soul'),
(30, 'R&B'),
(30, 'Soul'),
(31, 'Classic Rock'),
(32, 'Classic Rock'),
(33, 'Classic Rock'),
(34, 'Classic Rock'),
(35, 'Classic Rock'),
(134, 'Classic Rock'),
(36, 'Classic Rock'),
(37, 'Classic Rock'),
(38, 'Classic Rock'),
(39, 'Classic Rock'),
(40, 'Classic Rock'),
(41, 'Pop'),
(42, 'Pop'),
(43, 'Pop'),
(44, 'Pop'),
(45, 'Pop'),
(46, 'Pop'),
(47, 'Pop'),
(48, 'Pop'),
(49, 'Pop'),
(50, 'Pop'),
(51, 'Pop'),
(52, 'Pop'),
(53, 'Pop'),
(54, 'Pop'),
(55, 'Pop'),
(56, 'Pop'),
(57, 'Pop'),
(58, 'Pop'),
(59, 'Psychedelic Rock'),
(60, 'Psychedelic Rock'),
(61, 'Psychedelic Rock'),
(62, 'Psychedelic Rock'),
(63, 'Psychedelic Rock'),
(64, 'Psychedelic Rock'),
(65, 'Psychedelic Rock'),
(66, 'Psychedelic Rock'),
(67, 'Psychedelic Rock'),
(68, 'Psychedelic Rock'),
(69, 'Yacht Rock'),
(70, 'Yacht Rock'),
(71, 'Yacht Rock'),
(72, 'Yacht Rock'),
(73, 'Yacht Rock'),
(74, 'Yacht Rock'),
(75, 'Yacht Rock'),
(76, 'Yacht Rock'),
(77, 'Yacht Rock'),
(78, 'Yacht Rock'),
(79, 'R&B'),
(80, 'R&B'),
(81, 'R&B'),
(82, 'R&B'),
(83, 'R&B'),
(84, 'R&B'),
(85, 'R&B'),
(86, 'R&B'),
(87, 'R&B'),
(88, 'R&B'),
(89, 'R&B'),
(90, 'Soul'),
(91, 'Soul'),
(92, 'Soul'),
(93, 'Soul'),
(94, 'Soul'),
(95, 'Soul'),
(96, 'Soul'),
(97, 'Soul'),
(98, 'Soul'),
(99, 'Soul'),
(100, 'Soul'),
(101, 'Pop'),
(102, 'Pop'),
(103, 'Pop'),
(104, 'Pop'),
(105, 'Pop'),
(106, 'Pop'),
(107, 'Pop'),
(108, 'Pop'),
(109, 'Pop'),
(110, 'Pop'),
(111, 'Pop'),
(112, 'Pop'),
(113, 'Pop'),
(114, 'Pop'),
(115, 'Pop'),
(116, 'Pop'),
(117, 'Pop'),
(118, 'Pop'),
(119, 'Pop'),
(120, 'Pop'),
(121, 'Pop'),
(122, 'Pop'),
(123, 'Pop'),
(124, 'Pop'),
(125, 'Pop'),
(126, 'Pop'),
(127, 'Pop'),
(128, 'Pop'),
(129, 'Pop'),
(130, 'Pop'),
(131, 'Pop'),
(132, 'Pop'),
(133, 'Pop');

INSERT INTO ALBUM_CONTAIN_SONG (Album_ID, Song_ID)
VALUES
(0, 0),
(0, 1),
(0, 2),
(0,	3),
(0, 4),
(0, 5),
(0, 6),
(0, 7),
(0, 8),
(0, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(2, 31),
(2, 32),
(2, 33),
(2, 34),
(2, 35),
(2, 134),
(2, 36),
(2, 37),
(2, 38),
(2, 39),
(2, 40),
(3, 41),
(3, 42),
(3, 43),
(3, 44),
(3, 45),
(3, 46),
(3, 47),
(3, 48),
(3, 49),
(4, 50),
(4, 51),
(4, 52),
(4, 53),
(4, 54),
(4, 55),
(4, 56),
(4, 57),
(4, 58),
(5, 59),
(5, 60),
(5, 61),
(5, 62),
(5, 63),
(5, 64),
(5, 65),
(5, 66),
(5, 67),
(5, 68),
(6, 69),
(6, 70),
(6, 71),
(6, 72),
(6, 73),
(6, 74),
(6, 75),
(6, 76),
(6, 77),
(6, 78),
(7, 79),
(7, 80),
(7, 81),
(7, 82),
(7, 83),
(7, 84),
(7, 85),
(7, 86),
(7, 87),
(7, 88),
(7, 89),
(8, 90),
(8, 91),
(8, 92),
(8, 93),
(8, 94),
(8, 95),
(8, 96),
(8, 97),
(8, 98),
(8, 99),
(8, 100),
(9, 101),
(9, 102),
(9, 103),
(9, 104),
(9, 105),
(9, 106),
(9, 107),
(9, 108),
(9, 109),
(9, 110),
(9, 111),
(9, 112),
(9, 113),
(9, 114),
(10, 115),
(10, 116),
(10, 117),
(10, 118),
(10, 119),
(10, 120),
(10, 121),
(10, 122),
(10, 123),
(10, 124),
(10, 125),
(10, 126),
(10, 127),
(10, 128),
(11, 129),
(11, 130),
(11, 131),
(11, 132),
(11, 133);

INSERT INTO APP_USER (User_ID, Username, Name, Date_joined)
VALUES
(0, 'micknessaromatic', 'James Smith', '2020-12-01'),
(1, 'spashed_jobless', 'Britney Spares', '2015-08-23'),
(2, 'tashing_t3n', 'Blake Kensinger', '2010-04-05'),
(3, 'birleydimwitted', 'Jason Salinger', '2013-07-11'),
(4, 'clooves!gentle', 'Michael Matthews', '2014-10-01'),
(5, '4aviorange', 'Avery Lester', '2009-01-20'),
(6, 'thorough_snob', 'Alex Mason', '2016-03-04'),
(7, 'bregounsightly', 'Diego Ramirez', '2019-08-29'),
(8, 'greasforceful', 'Grave Lively', '2020-05-01'),
(9, 'peettasteful', 'Peter Green', '2010-02-28');

INSERT INTO SUBSCRIPTION (User_ID, Start_date, End_date, Price)
VALUES
(0, '2020-12-01', '2022-12-01', 100.00),
(1, '2015-09-24', '2015-10-24', 10.99),
(2, '2013-03-15', '2025-01-01', 600.00),
(3, '2013-07-11', '2014-07-11', 50.99),
(4, '2014-10-01', '2017-11-11', 259.99),
(5, '2009-01-20', '2021-07-14', 600.00),
(6, '2016-03-04', '2018-03-04', 100.00),
(7, '2019-08-29', '2026-05-01', 300.99),
(8, '2020-05-01', '2023-04-09', 299.99),
(9, '2010-02-28', '2025-02-28', 750.00);

INSERT INTO PLAYLIST (Playlist_ID, Playlist_name, Creator_ID, Is_private)
VALUES
(0, 'Soul Touching', 4, 0),
(1, 'Unshakable Confidence', 4, 1),
(2, 'Nighttime', 3, 1),
(3, 'Wedding Options', 7, 0),
(4, 'Barn Dance', 9, 0),
(5, 'Urban Melodies', 0, 0),
(6, 'Groovy Beats', 1, 1),
(7, 'Enigmatic Winter', 8, 0),
(8, 'Voyage', 8, 0),
(9, 'Sweet Mix', 2, 1),
(10, 'vibes', 5, 0);



INSERT INTO PLAYLIST_CONTAIN_SONG (Playlist_ID, Song_ID)
VALUES
(0, 123),
(0, 10),
(0, 5),
(0, 101),
(0, 20),
(1, 15),
(1, 16),
(1, 17),
(2, 100),
(2, 133),
(2, 98),
(2, 43),
(3, 45),
(3, 58),
(3, 43),
(3, 12),
(3, 13),
(4, 24),
(4, 25),
(4, 26),
(4, 39),
(4, 76),
(5, 35),
(5, 56),
(5, 106),
(5, 107),
(6, 20),
(6, 21),
(6, 128),
(6, 129),
(6, 130),
(7, 2),
(7, 3),
(7, 50),
(7, 43),
(7, 29),
(8, 102),
(8, 27),
(8, 29),
(9, 67),
(9, 89),
(9, 91),
(9, 92),
(10, 20),
(10, 21),
(10, 22),
(10, 70),
(10, 53),
(10, 35);

INSERT INTO PLAYLIST_CONTAIN_ALBUM (Album_ID, Playlist_ID)
VALUES
(0, 0, NULL),
(4, 1, NULL),
(10, 2, NULL),
(8, 3, NULL),
(6, 7, NULL),
(8, 8, NULL);
