require "csv"
require "import"
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

