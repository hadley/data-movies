require "rubygems"
require "arrayfields"
require "sqlite3"
require "set"

$genres_of_interest = ["Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short"]
$ratings_map = {"." => 0, "0" => 4.5, "1" => 14.5, "2" => 24.5, "3" => 34.5, "4" => 44.5, "5" => 45.5, "6" => 64.5, "7" => 74.5, "8" => 84.5, "9" => 94.5, "*" => 100}


def genres_binary(id, db)
	genres = db.execute("SELECT genre FROM Genres where movie_id = #{id};").flatten.to_set
	$genres_of_interest.map { |genre| (genres.include? genre) ? 1 : 0}
end

def ratings_breakdown(ratings)
	ratings[0..ratings.length].to_s.split(//).map{|s| $ratings_map[s]}
end

db = SQLite3::Database.new( "movies.sqlite3" )
sql = "
	SELECT Movies.* 
	FROM Movies
	WHERE length > 0 and imdb_votes > 0
	ORDER BY title"

i = 0 

File.open("movies.tab", "w") do |out|
	out << [
		'title', 'year', 'length', 'budget', 
		'rating', 'votes', (1..10).map{|i| "r" + i.to_s}, 
		'mpaa', $genres_of_interest
	].flatten.join("\t") + "\n"

	db.execute(sql) do |row| 
		puts i if (i = i + 1) % 5000 == 0

		out << [
			row["title"], 
			row["year"], 
			row["length"], 
			row["budget"], 
			row["imdb_rating"], row["imdb_votes"], ratings_breakdown(row["imdb_rating_votes"]), 
			row["mpaa_rating"], genres_binary(row['id'], db)
		].flatten.join("\t") + "\n" rescue nil
	end
end