require "csv"
require "import"

movies = Movie.find_all 'length > 0 AND budget > 0'

outfile = File.open('movies.csv', 'wb')
	CSV::Writer.generate(outfile) do |csv|
	csv << ['title', 'year', 'budget', 'length', 'rating', 'votes']

	movies.each do |m|
		csv << [m.title, m.year, m.budget, m.length, m.imdb_rating, m.imdb_votes]
	end
 end

 outfile.close
