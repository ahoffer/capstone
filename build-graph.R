start_time = proc.time()

source("packages.R")
packages("igraph")

# names(alldata$user.json)
# names(alldata$user.json$compliments)
# names(alldata$user.json$votes)

#Are all user names unique? NO.
# unames = alldata$user.json$name
# length(unique(unames)) == length(unames)

#User nodes
g = make_empty_graph();
objects = alldata$user.json
g = g + vertex(
  objects$name,
  color = "red",
  yelping_since = as.Date(objects$yelping_since, "%Y=%m"),
  votes_funny = objects$votes$funny,
  votes_useful = objects$votes$useful,
  votes_cool = objects$votes$cool,
  review_count = objects$review_count,
  id = objects$user_id,
  fans = objects$fans,
  average_stars = objects$average_stars,
  type = objects$type,
  compliments_funny = objects$compliments$funny,
  compliments_cute = objects$compliments$cute,
  compliments_plain = objects$compliments$plain,
  compliments_writer = objects$compliments$writer,
  compliments_note = objects$compliments$note,
  compliments_hot = objects$compliments$hot,
  compliments_cool = objects$compliments$cool,
  compliments_more = objects$compliments$more,
  compliments_profile = objects$compliments$profile,
  complimenst_photos = objects$compliments$photos,
  compliment_list  = objects$compliments$list,
  total_compliments = rowSums(objects$compliments, na.rm =
                                TRUE)
)

#Attribute names
# sapply(names(alldata$business.json$attributes), USE.NAMES = FALSE, function(name) {
#   gsub("\\s", "-", name, perl = TRUE)
# });

#Business nodes
objects = alldata$business.json
g = g + vertex(
  objects$name,
  color = "pink",
  type = objects$type,
  id =  objects$business_id,
  city = objects$city,
  state = objects$state,
  starts = objects$stars,
  review_count = objects$review_count
)

#Direct edge from a user to his/her review of a business
r = alldata$review.json
reviews = r[is.element(r$user_id, V(g)$id) & is.element(r$business_id, V(g)$id),]
print(paste("Creating", nrow(reviews), "reviews"))

#Convert NA to zero
reviews$votes[is.na(reviews$votes)] = 0

g = g +    edge(reviews$user_id,
  V(g)[id == reviews$business_id],
  color = "gray",
  votes_funny = reviews$votes$funny,
  votes_useful = reviews$votes$useful,
  votes_cool = reviews$votes$cool,
  name = reviews$review_id,
  stars = reviews$stars,
  date = as.POSIXct(reviews$date)
)

elapsed_time = proc.time() - start_time
print(elapsed_time)

#Add friend relationships