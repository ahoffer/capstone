# start_time = proc.time()

# Find users/business when only a subset of the reviews is loaded
print(paste(nrow(review[is.element(review$user_id, user$user_id) &
                          is.element(review$business_id, business$business_id),]), "reviews"))

# User nodes
objects = user[is.element(user$user_id, review$user_id),]

# Set NA compliments to zero
objects$compliments[is.na(objects$compliments)] = 0

# Make empty graph
# g = make_empty_graph(directed = FALSE);
g=make_empty_graph();

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
  compliment_list  = objects$compliments$list,
  total_compliments = rowSums(objects$compliments, na.rm = TRUE)
)

#Business nodes
objects = business[is.element(business$business_id, review$business_id),]
g = g + vertex(
  objects$business_id,
  realname =  objects$name,
  color = "blue",
  type = objects$type,
  city = objects$city,
  state = objects$state,
  starts = objects$stars,
  review_count = objects$review_count
)

#Convert NA to zero
review$votes[is.na(review$votes)] = 0
review$stars[is.na(review$stars)] = 0

#Review Edges
g = g +    edge(
 interleave(review$user_id,review$business_id),
  weight = 1,
  votes_funny = review$votes$funny,
  votes_useful = review$votes$useful,
  votes_cool = review$votes$cool,
  name = review$review_id,
  stars = review$stars,
  date = as.POSIXct(review$date)
)

graph_copy  = g

# elapsed_time2 = proc.time() - start_time
# print(elapsed_time2)