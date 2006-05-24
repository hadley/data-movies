require "rubygems"
require_gem "activerecord"

#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3",
	:dbfile => "movies.sqlite3"
)

class Movie < ActiveRecord::Base 
	has_many :genres
	has_many :ratings
	
	def self.genres_of_interest
		["Action", "Animation", "Comedy", "Drama", "Documentary", "Romance", "Short"]
	end
	
	def genres_binary
		Movie.genres_of_interest.map do |genre| 
			genres.detect{|g| g.genre == genre} ? 1 : 0 rescue 0
		end
	end

	def ratings_breakdown
		imdb_rating_votes[2..imdb_rating_votes.length].to_s.split(//).map{|s| s.gsub("*", "10").gsub(".", "NA")} rescue "0000000000"
	end
	
end

class Genre < ActiveRecord::Base
	belongs_to :movie
end

class Ratings < ActiveRecord::Base
end
