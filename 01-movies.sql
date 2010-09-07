-- sqlite3 movies.sqlite3 < movies.sql

CREATE TABLE Movies (
id INTEGER PRIMARY KEY,
title varchar(250),
year integer,
budget integer,
length integer,
imdb_rating float,
imdb_votes integer,
imdb_rating_votes varchar(10),
mpaa_rating varchar(5)
);

CREATE TABLE Ratings (id INTEGER PRIMARY KEY, movie_id integer, score varchar(10), outof10 float, votes integer);
CREATE TABLE Genres (id INTEGER PRIMARY KEY , movie_id integer, genre varchar(50));

CREATE INDEX title on Movies (title);
CREATE INDEX year on Movies (year);
CREATE INDEX titleyear on Movies (title, year);
CREATE INDEX id on Movies (id);
CREATE INDEX rid on Ratings (id);
CREATE INDEX rmid on Ratings (movie_id);
CREATE INDEX gid on Genres (id);
CREATE INDEX gmid on Genres (movie_id);
