-- insert temp artist into table
INSERT INTO ARTIST (Artist_ID, Artist_name, Artist_type) 
VALUES (999, 'Temporary Artist', 1);

-- display
SELECT * FROM ARTIST WHERE Artist_ID = 999;

-- delete
DELETE FROM ARTIST WHERE Artist_ID = 999;

-- display delete
SELECT * FROM ARTIST WHERE Artist_ID = 999;
