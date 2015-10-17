start_time = proc.time()

source("packages.R")
packages("igraph")

# names(alldata$user.json)
# names(alldata$user.json$compliments)
# names(alldata$user.json$votes)

#Are all user names unique? NO.
# unames = alldata$user.json$name
# length(unique(unames)) == length(unames)


#Find users/business when only a subset of the reviews is loaded
r = alldata$review.json
reviews = r[is.element(r$user_id, alldata$user.json$user_id) & is.element(r$business_id, alldata$business.json$business_id),]
print(paste(nrow(reviews), "reviews"))


#User nodes
# objects = alldata$user.json
u = alldata$user.json
objects =u[is.element(u$user_id, reviews$user_id),]
g = make_empty_graph();
g = g + vertex(
#   objects$name,
#   id = objects$user_id,
  objects$user_id,
  realname = objects$user_id,
  color = "red",
  yelping_since = as.Date(objects$yelping_since, "%Y=%m"),
  votes_funny = objects$votes$funny,
  votes_useful = objects$votes$useful,
  votes_cool = objects$votes$cool,
  review_count = objects$review_count,
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
  total_compliments = rowSums(objects$compliments, na.rm =TRUE)
)

#Attribute names
# sapply(names(alldata$business.json$attributes), USE.NAMES = FALSE, function(name) {
#   gsub("\\s", "-", name, perl = TRUE)
# });

#Business nodes
b = alldata$business.json
objects = b[is.element(b$business_id, reviews$business_id),]
g = g + vertex(
#   objects$name,
#   id =  objects$business_id,
  objects$business_id,
  realname =  objects$name,
  color = "pink",
  type = objects$type,
  city = objects$city,
  state = objects$state,
  starts = objects$stars,
  review_count = objects$review_count
)

#Convert NA to zero
reviews$votes[is.na(reviews$votes)] = 0

#Helper function
# getVertexIndexesFrom = function(g, idCollection) {
#   sapply(idCollection, function(id) {
#     which(V(g)$id == id)
#   })
# }

#Make edges
#THIS WORKS, BUT MAKES IT  TOUGHER TO SET EDGE PROPOERTIES
# user_node_index = getVertexIndexesFrom(g, reviews$user_id)
# business_node_index = getVertexIndexesFrom(g, reviews$business_id)
# g[user_node_index,  business_node_index] = 1
          
g = g +    edge(
  reviews$user_id,
  reviews$business_id,
  color = "gray",
  votes_funny = reviews$votes$funny,
  votes_useful = reviews$votes$useful,
  votes_cool = reviews$votes$cool,
  name = reviews$review_id,
  stars = reviews$stars,
  date = as.POSIXct(reviews$date)
)


elapsed_time2 = proc.time() - start_time
print(elapsed_time2)

