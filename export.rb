require "rubygems"
require "arrayfields"
require "FasterCSV"
require "sqlite3"

$genres_of_interest = ["Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short"]
$ratings_map = {"." => 0, "0" => 4.5, "1" => 14.5, "2" => 24.5, "3" => 34.5, "4" => 44.5, "5" => 45.5, "6" => 64.5, "7" => 74.5, "8" => 84.5, "9" => 94.5, "*" => 10}


def genres_binary(genres)
	genres = genres.to_set
	$genres_of_interest.map { |genre| genres.include? genre}
	end
end

def ratings_breakdown(ratings)
	ratings[2..ratings.length].to_s.split(//).map{|s| $ratings.map[s]}
end


db = SQLite3::Database.new( "movies.sqlite3" )

default = [0] * $genres_of_interest.length
db.create_aggregate( "genres", 1 ) do
	step do |func, value|
		func[ :total ] ||= default.clone
		func[ :total ][$genres_of_interest.index(value.to_s)] = 1 if $genres_of_interest.index(value.to_s) rescue nil
	end

	finalize do |func|
		if (func[ :total ])
			func.set_result( func[ :total ].join(",") )
		else
			func.set_result( default.join(",") )
		end
		func[:total] = nil
	end
end

sql = "SELECT *, (select genres(genre) from Genres where movie_id = Movies.id) as g FROM Movies WHERE length >0 and imdb_votes > 0"


db.execute(sql + " limit 500;") do |row|
	puts row["id"]
end

FasterCSV.open("movies.csv", "w") do |csv|
 	csv << [
 		'title', 'year', 'budget', 'length', 
 		'rating', 'votes', (1..10).map{|i| "r" + i.to_s}, 
 		'mpaa', $genres_of_interest].flatten

 	db.execute(sql) do |row| 
 		csv << [
 			row["title"], row["year"], row["budget"], row["length"], 
 			row["imdb_rating"], row["imdb_votes"], ratings_breakdown(row["imdb_rating_votes"]), 
 			row["mpaa_rating"], row["g"].split()
 		].flatten rescue nil
 	end
end
