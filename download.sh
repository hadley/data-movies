#!/bin/sh

wget -q ftp://ftp.fu-berlin.de/pub/misc/movies/database/business.list.gz
wget -q ftp://ftp.fu-berlin.de/pub/misc/movies/database/genres.list.gz
wget -q ftp://ftp.fu-berlin.de/pub/misc/movies/database/movies.list.gz
wget -q ftp://ftp.fu-berlin.de/pub/misc/movies/database/mpaa-ratings-reasons.list.gz
wget -q ftp://ftp.fu-berlin.de/pub/misc/movies/database/ratings.list.gz
wget -q ftp://ftp.fu-berlin.de/pub/misc/movies/database/running-times.list.gz

gzip -d *.gz