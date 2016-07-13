./00-download.sh
gunzip ./data/*
sqlite3 movies.sqlite3 ".read 01-movies.sql"
ruby 02-import.rb
ruby 03-export.rb
