require "csv"
require "movies"
require "FileUtils"


def export(filename, movies)
	puts "Exporting #{movies.length} movies to #{filename}"
	File.open(filename, 'wb') do |f|
		CSV::Writer.generate(f) do |csv|
			csv << ['title', 'year', 'budget', 'length', 'rating', 'votes']

			movies.each do |m|
				csv << [m.title, m.year, m.budget, m.length, m.imdb_rating, m.imdb_votes]
			end
		end
	end
end

movies = Movie.find_all 'length > 0 AND budget > 0 AND imdb_rating > 0'

FileUtils.mkdir_p "csv"
export("csv/all.csv", movies)
export("csv/comedy.csv", movies.find_all{|m| m.genres.detect{|g| g.genre == "Comedy"} })
export("csv/action.csv", movies.find_all{|m| m.genres.detect{|g| g.genre == "Action"} })
export("csv/romance.csv", movies.find_all{|m| m.genres.detect{|g| g.genre == "Romance"} })
export("csv/animation.csv", movies.find_all{|m| m.genres.detect{|g| g.genre == "Animation"} })
export("csv/drama.csv", movies.find_all{|m| m.genres.detect{|g| g.genre == "Drama"} })


