source("initialize.R")
start.time = proc.time()

# Set NA compliments to zero
user$compliments[is.na(objects$compliments)] = 0

# Make empty graph
g = make_empty_graph(directed = FALSE);

str2date = function(x) {
  as.Date(paste(x,"01", sep = '-'), "%Y-%m-%d")
}


#Make user nodes
g = g + vertex(
  user$user_id,
  realname = user$name,
  yelping_since = str2date(user$yelping_since),
  votes_funny = user$votes$funny,
  votes_useful = user$votes$useful,
  votes_cool = user$votes$cool,
  review_count = user$review_count,
  fans = user$fans,
  average_stars = user$average_stars,
  type = user$type,
#   compliments_funny = user$compliments$funny,
#   compliments_cute = user$compliments$cute,
#   compliments_plain = user$compliments$plain,
#   compliments_writer = user$compliments$writer,
#   compliments_note = user$compliments$note,
#   compliments_hot = user$compliments$hot,
#   compliments_cool = user$compliments$cool,
#   compliments_more = user$compliments$more,
#   compliments_profile = user$compliments$profile,
#   complimenst_photos = user$compliments$photos,
#   compliments_list  = user$compliments$list,
  total_compliments = rowSums(user$compliments, na.rm = TRUE)
)

#Business nodes
g = g + vertex(
  business$business_id,
  realname =  business$name,
  color = "blue",
  type = business$type,
  city = business$city,
  state = business$state,
  stars = business$stars,
  review_count = business$review_count
)

#Review Edges
g = g + edge(
 interleave(review$user_id,review$business_id),
  weight = 1,
  votes_funny = review$votes$funny,
  votes_useful = review$votes$useful,
 votes_cool = review$votes$cool,
  name = review$review_id,
  stars = review$stars,
  type="review",
  date = as.Date(review$date, '%Y-%m-%d')
)

#Only users involved in reviews. Otherwise, too many edges and computer pukes.
reviewing_users = user[is.element(user$user_id, review$user_id),]

#Friends edges
g = g + edge(friendsPaths(reviewing_users), 
             type="friend",
             weight =1)


#Remove nodes that have no edges
g = g - V(g)[degree(g) == 0]

#Save copy of the graph to restore it when the state gets borked.
graph_copy  = g

proc.time() - start.time

write_graph(g, file="yelp.graphml", format="graphml")
g=read_graph(file="yelp.graphml", format="graphml")
