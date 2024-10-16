-- select playlist name, creators name, no. of albums, and no. of songs
-- join w/ APP_USER to display creators name
SELECT 
    p.Playlist_name AS Playlist, 
    u.Name AS Creator, 
    p.No_of_albums AS Albums, 
    p.No_of_songs AS Songs
FROM 
    PLAYLIST p
-- join to get creators name
JOIN 
    APP_USER u ON p.Creator_ID = u.User_ID
-- sort by no. of albums
-- If two playlists have the same no. of albums, sort by the no. of songs
ORDER BY 
    p.No_of_albums DESC, 
    p.No_of_songs DESC;
