Movies database
===============

Aim: Create a large dataset for exploratory analysis with graphical tools.

Data of interest for each film:

* year produced
* budget
* ratings (by users and by critics)
* genre

Data sources
------------

IMDB:

* business.list
* movies.list
* ratings.list
* 

Movie review query engine. <http://www.mrqe.com/>.  
Url format: http://www.mrqe.com/lookup?^title+(year).  
Review format: Title (Name) reivew [3/5]

Storage
-------

In SQLite database.  Access chiefly through ActiveRecord.

Tables:

* Movies: `id*, title*, year, budget, length`
* Ratings: `id*, movie_id*, score, outof, rater`
* Genre: `id*, movie_id*, genre`



\* denotes indexed.


Import
------

1. Remove extraneous data from .list files
2. Import each file in turn into database
3. Produce desired output for Di
4. For selected movies, download reviews off mrqe.