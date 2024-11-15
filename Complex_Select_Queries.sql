---1. List all playlists with fewer than 5 songs, including the account name for each playlist

SELECT Playlist.Playlist_name, APP_USER.Username
FROM PLAYLIST
JOIN CONTAIN ON PLAYLIST.Playlist_ID = CONTAIN.Playlist_ID
JOIN APP_USER ON PLAYLIST.Creator_ID = APP_USER.User_ID
GROUP BY Playlist.Playlist_name, APP_USER.Username
HAVING COUNT(CONTAIN.Song_ID) < 5;


--2. Retrieve all songs that are present in more than two playlists

SELECT Song.Song_name, COUNT(Contain.Playlist_ID) AS Playlist_Count
FROM SONG
JOIN CONTAIN ON SONG.Song_ID = CONTAIN.Song_ID
GROUP BY Song.Song_name
HAVING COUNT(CONTAIN.Playlist_ID) > 2;

--3. Find the number of songs in each playlist, sorted by the number of songs in descending order

SELECT Playlist.Playlist_name, COUNT(Contain.Song_ID) AS Number_of_Songs
FROM PLAYLIST
JOIN CONTAIN ON PLAYLIST.Playlist_ID = CONTAIN.Playlist_ID
GROUP BY Playlist.Playlist_name
ORDER BY Number_of_Songs DESC;

--4. Get a list of all songs along with the number of playlists they belong to

SELECT Song.Song_name, COUNT(Contain.Playlist_ID) AS Playlist_Count
FROM SONG
JOIN CONTAIN ON SONG.Song_ID = CONTAIN.Song_ID
GROUP BY Song.Song_name;


--5. List the accounts that own more than 1 playlists

SELECT APP_USER.Username
FROM APP_USER
JOIN PLAYLIST ON APP_USER.User_ID = PLAYLIST.Creator_ID
GROUP BY APP_USER.Username
HAVING COUNT(PLAYLIST.Playlist_ID) > 2;


--6. Show the names of playlists and the number of unique songs each contains

SELECT Playlist.Playlist_name, COUNT(DISTINCT Con.Song_ID) AS Unique_Songs
FROM PLAYLIST
JOIN CONTAIN AS Con ON Playlist.Playlist_ID = Con.Playlist_ID
GROUP BY Playlist.Playlist_name;

