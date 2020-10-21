CREATE TABLE People (

 Name varchar(50) NOT NULL,
 City varchar(30) NOT NULL,
 [State] char(2) NOT NULL
);


INSERT INTO People(Name, City, [State])
VALUES
  ('John', 'Dallas','TX'),
  ('Mark', 'Seattle','WA'),
  ('Nick', 'Phoenix','AZ'),
  ('Laila', 'San Jose','CA'),
  ('Samantha', 'Tulsa','OK'),
  ('Bella', 'San Antonio','TX'),
  ('John', 'Dallas','TX'),
  ('John', 'Dallas','TX'),
  ('Mark', 'Seattle','WA'),
  ('Nick', 'Tempe','FL'),
  ('John', 'Dallas','TX');
  
SELECT * FROM People;


DELETE DUP
FROM
(
 SELECT ROW_NUMBER() OVER (PARTITION BY Name ORDER BY Name ) AS Val
 FROM People
) DUP
WHERE DUP.Val > 1;
 
-- Or else you can also use the following query
-- to delete duplicates having same Name, City and State fields in the People table
DELETE DUP
FROM
(
 SELECT ROW_NUMBER() OVER (PARTITION BY Name, City, State ORDER BY Name, City, State ) AS Val
 FROM Peole
) DUP
WHERE DUP.Val > 1;