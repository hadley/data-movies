require "csv"
require "movies"
require "FileUtils"
require "pp"


def export(filename, movies)
	puts "Exporting #{movies.length} movies to #{filename}"
	File.open(filename, 'wb') do |f|
		CSV::Writer.generate(f) do |csv|
			csv << ['title', 'year', 'budget', 'length', 'rating', 'votes', (1..10).map{|i| "r" + i.to_s}, 'mpaa',  Movie.genres_of_interest].flatten
	
			movies.each do |m|
 				csv << [m.title, m.year, m.budget, m.length, m.imdb_rating, m.imdb_votes, m.ratings_breakdown, m.mpaa_rating, m.genres_binary].flatten
			end
		end
	end
end

movies = Movie.find_all 'length > 0 AND imdb_rating > 0'
export("movies.csv", movies)
