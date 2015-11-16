source("initialize.R")
start.time = proc.time()
#Random sample
# review_sample = review[sample(nrow(review), 15), ]

#Non random sample
review_sample = review[ ,]

#All users
objects = user

# Set NA compliments to zero
objects$compliments[is.na(objects$compliments)] = 0

# Make empty graph
g = make_empty_graph(directed = FALSE);
# g=make_empty_graph(directed = TRUE);

#Make user nodes
g = g + vertex(
  objects$user_id,
  realname = objects$name,
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
  compliments_list  = objects$compliments$list,
  total_compliments = rowSums(objects$compliments, na.rm = TRUE)
)

#Business nodes
objects = business
g = g + vertex(
  objects$business_id,
  realname =  objects$name,
  color = "blue",
  type = objects$type,
  city = objects$city,
  state = objects$state,
  stars = objects$stars,
  review_count = objects$review_count
)

#Convert NA to zero
review_sample$votes[is.na(review_sample$votes)] = 0
review_sample$stars[is.na(review_sample$stars)] = 0

#Review Edges
g = g +    edge(
 interleave(review_sample$user_id,review_sample$business_id),
  weight = 1,
  votes_funny = review_sample$votes$funny,
  votes_useful = review_sample$votes$useful,
 votes_cool = review_sample$votes$cool,
  name = review_sample$review_id,
  stars = review_sample$stars,
  type="review",
  date = as.POSIXct(review_sample$date)
)

#Clean up
remove(objects)

#Only users involved in reviews. Otherwise, too many edges and computer pukes.
reviewing_users = user[is.element(user$user_id, review_sample$user_id),]

#Friends edges
g = g + edge(friendsPaths(reviewing_users), 
             type="friend",
             weight =1)


#Remove nodes that have no edges
g = g - V(g)[degree(g) == 0]

#Save copy of the graph to restore it when the state gets borked.
graph_copy  = g

proc.time() - start.time