-- counts the members that each artist has
-- if an artist has more than one member, it updates their type to 2


-- first change the artist type to 1, for demonstration purposes
UPDATE ARTIST
SET Artist_type = 1
WHERE Artist_name = 'Weezer';



-- select for the first screenshot
SELECT 
    Artist_name AS Artist, 
    Artist_type AS Type, 
    Member_name AS Member
FROM 
    ARTIST a
LEFT JOIN 
    GROUP_MEMBERS g ON a.Artist_ID = g.Group_ID
ORDER BY 
    a.Artist_name;



-- update the group now to fix it
UPDATE ARTIST a
JOIN (
    SELECT 
        Group_ID, 
        COUNT(Member_name) AS MemberCount
    FROM GROUP_MEMBERS
    GROUP BY Group_ID
) g ON a.Artist_ID = g.Group_ID
SET a.Artist_type = 2
WHERE g.MemberCount > 1;




-- select to show the change
SELECT 
    Artist_name AS Artist, 
    Artist_type AS Type, 
    Member_name AS Member
FROM 
    ARTIST a
LEFT JOIN 
    GROUP_MEMBERS g ON a.Artist_ID = g.Group_ID
ORDER BY 
    a.Artist_name;

