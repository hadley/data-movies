require "rubygems	"
require_gem "activerecord"

#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite",
	:dbfile => "movies.db"
)

class Movie < ActiveRecord::Base
	has_many :genres
	has_many :ratings
end

class Genre < ActiveRecord::Base
	belongs_to :movie
end

class Ratings < ActiveRecord::Base
end
