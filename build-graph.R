source("packages.R")
packages("igraph")
packages("tcltk")



# names(alldata$user.json)
# names(alldata$user.json$compliments)
# names(alldata$user.json$votes)

#Are all user names unique? NO.
unames = alldata$user.json$name
length(unique(unames)) == length(unames)

g = make_empty_graph();
user = alldata$user.json
g = g + vertex(user$name, 
            color="red",
            yelping_since = as.Date(user$yelping_since, "%Y=%m"),
            votes_funny = user$votes$funny,
            votes_useful = user$votes$useful,
            votes_cool = user$votes$cool,
            review_count = user$review_count,
            user_id = user$user_id,
            fans = user$fans,
            average_stars = user$average_stars,
            type = user$type,
            compliments_funny = user$compliments$funny,
            compliments_cute = user$compliments$cute,
            compliments_plain= user$compliments$plain,
            compliments_writer= user$compliments$writer,
            compliments_note= user$compliments$note,
            compliments_hot= user$compliments$hot,
            compliments_cool= user$compliments$cool,
            compliments_more= user$compliments$more,
            compliments_profile= user$compliments$profile,
            complimenst_photos = user$compliments$photos,
            compliment_list  = user$compliments$list, 
            total_compliments = rowSums(user$compliments, na.rm=TRUE)
)