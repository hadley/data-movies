require "movies"

def import_movies
	#$100,000 Pyramid, The (2001) (VG)			2001
	title_re = /^([a-zA-z ]+)\s+\([0-9]+\)\s+([0-9]+)$/ix
	File.new("movies.list").each_line do |l|
		if  match = title_re.match(l)
			m = Movie.new("title" => match[1], "year" => match[2].to_i)
			m.save
		
			if m.id % 200 == 0
				puts m.id
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
				title, year, budget = match[1], match[2], bt[1].gsub!(",","").to_i

				m = Movie.find_by_title_and_year title, year
				if m
					#puts "#{title} $#{budget}"
					m.update_attribute("budget", budget)
				end

			end
		end
	end
end

def import_mpaa_ratings
	dashes = "-------------------------------------------------------------------------------"
	title_re = /MV:\s+([a-z ]*?) \s \(([0-9]+)\)/ix
	rating_re = /RE: Rated (.*?) /i

	File.new("mpaa-ratings-reasons.list").each(dashes) do |l|
		if match = title_re.match(l)
			if rt = rating_re.match(l)
				title, year, rating = match[1], match[2], rt[1]

				m = Movie.find_by_title_and_year title, year
				if m
					puts "#{title} #{rating}"
					m.update_attribute("mpaa_rating", rating)
				end

			end
		end
	end
end


def import_genres
#D2: The Mighty Ducks (1994)				Family
	genre_re = /^([a-z ]*?)\s+\(([0-9]+)\)\s+(.*?)$/ix

	File.new("genres.list").each_line do |l|
		if match = genre_re.match(l)
			title, year, genre = match[1], match[2], match[3]

			m = Movie.find_by_title_and_year title, year
			if m
				#puts "#{title} $#{genre}"
				m.genres.create({"genre" => genre})
			end
		end
	end
end

def import_ratings
#.0.1112000      14   5.9  365 Nights in Hollywood (1934)
	ratings_re = /([0-9.]+) \s+ ([0-9]+) \s+ ([0-9.]+) \s+ ([a-z ]+?) \s+ \(([0-9]+)\)/ix
	f = File.new("ratings.list")
	f.each_line do |l|
		if match = ratings_re.match(l)
			rating, votes, outof10, title, year = match[1], match[2], match[3].to_f, match[4], match[5]
		

			m = Movie.find_by_title_and_year title, year
			if m
				#puts "#{title} #{rating} #{outof10} #{votes}";
				m.update_attributes({
					'imdb_votes' => votes, 
					'imdb_rating' => outof10,
					'imdb_rating_votes' => rating})
			end
		
			if f.lineno % 1000 == 0
				puts "#{title} #{outof10} #{votes}";
				puts f.lineno
			end
		end
	end
end

#import_movies
#import_ratings
#import_times
#import_mpaa_ratings
#import_budgets
#import_genres


puts Movie.count( "budget > 0")
puts Movie.count( "length > 0")
puts Movie.count( "budget > 0 and length > 0")
puts Movie.count( "imdb_votes > 0 and length > 0")
puts Movie.count( "budget > 0 and length > 0 and imdb_votes > 0")