require 'rubygems'
require 'sqlite3'
$db = SQLite3::Database.new( "movies.sqlite3" )
$title = "[a-z,&-;0-9$#+=\/!?. ]+"

def import_movies
	#$100,000 Pyramid, The (2001) (VG)			2001
	title_re = /^(#{$title}) \s+ \([0-9]+\) \s+ ([0-9]+)$/ix

	stmt = $db.prepare("INSERT INTO Movies (title, year) VALUES (?, ?);")
	$db.transaction do
		$db.execute "DELETE FROM Movies;"
	
		File.new("data/movies.list").each_line do |l|
			if match = title_re.match(l)
				stmt.execute!(match[1], match[2].to_i)
			end
		end
	end
end

def import_times
	#"Ballyskillen Opera House, The" (1980)			30	(6 episodes)
	time_re = /^(#{$title}) \s+ \(([0-9]+)\) \s+ (?:[a-z]+:)?([0-9]+)/ix 

	stmt = $db.prepare("UPDATE Movies set length=? WHERE title=? AND year=?;")
	$db.transaction do 
		File.new("data/running-times.list").each_line do |l|
			if match = time_re.match(l)
				stmt.execute!(match[3].to_i, match[1], match[2].to_i)
			end
		end
	end
end


def import_budgets
	dashes = "-------------------------------------------------------------------------------"
	title_re = /MV:\s+(#{$title}?) \s \(([0-9]+)\)/ix
	budget_re = /BT:\s+USD\s+([0-9,.]+)/ix

	stmt = $db.prepare("UPDATE Movies set budget=? WHERE title=? AND year=?;")
	$db.transaction do 
		File.new("data/business.list").each(dashes) do |l|
			if match = title_re.match(l.to_s) and bt = budget_re.match(l.to_s)
				stmt.execute!(bt[1].gsub!(",","").to_i, match[1], match[2].to_i) 
			end
		end
	end
end

def import_mpaa_ratings
	dashes = "-------------------------------------------------------------------------------"
	title_re = /MV:\s+(#{$title}?) \s \(([0-9]+)\)/ix
	rating_re = /RE: Rated (.*?) /i

	stmt = $db.prepare("UPDATE Movies set mpaa_rating=? WHERE title=? AND year=?;")
	$db.transaction do 
		File.new("data/mpaa-ratings-reasons.list").each(dashes) do |l|
			if match = title_re.match(l.to_s) and rt = rating_re.match(l.to_s)
				stmt.execute!(rt[1], match[1], match[2].to_i)
			end
		end
	end
end


def import_genres
	#D2: The Mighty Ducks (1994)				Family
	genre_re = /^(#{$title}?) \s+ \(([0-9]+)\) (?:\s*[({].*[})])*  \s+(.*?)$/ix
	i = 0
	
	stmt = $db.prepare("INSERT INTO Genres (genre, movie_id) VALUES (?, (SELECT id FROM Movies WHERE title=? AND year=?));")
	$db.transaction do 
		$db.execute "DELETE FROM Genres;"
		
		File.new("data/genres.list").each_line do |l|
			puts i if (i = i + 1) % 5000 == 0
			if match = genre_re.match(l)
				stmt.execute!(match[3], match[1], match[2].to_i)
			end
		end
	end
end


def import_ratings
	#.0.1112000      14   5.9  365 Nights in Hollywood (1934)
	ratings_re = /([0-9.\*]+) \s+ ([0-9]+) \s+ ([0-9.]+) \s+ (#{$title}?) \s+ \(([0-9]+)\)/ix

	stmt = $db.prepare("UPDATE Movies set imdb_votes=?, imdb_rating=?, imdb_rating_votes=? WHERE title=? AND year=?;")
	$db.transaction
	
	File.new("data/ratings.list").each_line do |l|
		if match = ratings_re.match(l)
			rating, votes, outof10, title, year = match[1], match[2], match[3], match[4], match[5]
			stmt.execute!(votes, outof10, rating, title, year)
		end
	end
	$db.commit
	
end

#import_movies
#import_times
#import_budgets
#import_mpaa_ratings
#import_ratings
#import_genres


#puts Movie.count( "budget > 0")
#puts Movie.count( "length > 0")
#puts Movie.count( "budget > 0 and length > 0")
#puts Movie.count( "imdb_votes > 0 and length > 0")
#puts Movie.count( "budget > 0 and length > 0 and imdb_votes > 0")