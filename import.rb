require "RubyGems"
require_gem "ActiveRecord"
include GC

#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
	:adapter => "sqlite",
	:dbfile => "movies.db"
)

class Movie < ActiveRecord::Base
end

def import_movies
	#$100,000 Pyramid, The (2001) (VG)			2001
	title_re = /^([a-zA-z ]+)\s+\([0-9]+\)\s+([0-9]+)$/ix
	File.new("movies.list").each_line do |l|
		if  match = title_re.match(l)
			m = Movie.new("title" => match[1], "year" => match[2].to_i)
			m.save
		
			if m.id % 200 == 0
				puts m.id
				garbage_collect
				sleep 1
			end
		end
	end
end

def import_times
	#"Ballyskillen Opera House, The" (1980)			30	(6 episodes)
	time_re = /^([a-z ]+) \s+ \(([0-9]+)\) \s+ ([0-9]+)/ix 
	File.new("running-times.list").each_line do |l|
		if match = time_re.match(l) 
			title, year, minutes =  match[1], match[2].to_i, match[3]
		
			m = Movie.find_by_title_and_year title, year
			if m
				#puts "#{title} (#{year}) = #{minutes}"
				m.update_attribute("length", minutes)
			end
		
		end
	end
end


def import_budgets
	dashes = "-------------------------------------------------------------------------------"
	title_re = /MV:\s+([a-z ]*?) \s \(([0-9]+)\)/ix
	budget_re = /BT:\s+USD\s+([0-9,.]+)/ix

	File.new("business.list").each(dashes) do |l|
		if match = title_re.match(l)
			if bt = budget_re.match(l)
				title, year, budget = match[1], match[2], bt[1]

				m = Movie.find_by_title_and_year title, year
				if m
					#puts "#{title} $#{budget}"
					m.update_attribute("budget", budget)
				end

			end
		end
	end
end

import_movies
import_times
import_budgets

puts Movie.count( "budget > 0")
puts Movie.count( "length > 0")
puts Movie.count( "budget > 0 and length > 0")