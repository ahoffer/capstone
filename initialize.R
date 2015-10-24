set.seed(0)

source("packages.R")
packages("jsonlite")
packages("tcltk")
packages("igraph")
packages("devtools")
packages("wordcloud")
packages("tm")
packages("RColorBrewer")

#Helper method to create R objects from JSON
json2r = function(json_file_name) {
  print(json_file_name)
  stream_in(file(json_file_name))
}

#Helper function
extract_record = function(alldata, datalist, record_number) {
  toJSON(alldata[datalist][[1]][record_number,], pretty = TRUE)
}

#Helper function
interleave <- function(v1,v2) {
  ord1 <- 2 * (1:length(v1)) - 1
  ord2 <- 2 * (1:length(v2))
  c(v1,v2)[order(c(ord1,ord2))]
}

#Helper function
friendsPaths = function(userdataset) {
  unlist(  sapply(userdataset$user_id, function(sourceNodeId) {
    unlist(lapply(unlist(userdataset[userdataset$user_id==sourceNodeId, "friends"]), function(targetNodeId) {
      c(sourceNodeId, targetNodeId)
    }))
  }), use.names = FALSE)
  
}
# ----------------------------SNIPPETS-----------------------------------------
# CODE TO SUBSAMPLE THE DATA
# perl -ne 'print if (rand() < .001)' yelp_academic_dataset_review.json > small_reviews


# ----------------------------SNIPPETS-----------------------------------------
# Print first record of each data set to explore the scheme
# sapply(names(alldata), FUN = function(name) {
#   print(name); print(extract_record(alldata, name, 1)});


# ----------------------------SNIPPETS-----------------------------------------
#Using readlines() instead of stream_in()
# #Read the first record
# first_line = readLines(paste(PATH, "yelp_academic_dataset_business.json", sep=""), n = 1)
#
# #Convert record to an R list
# first_list = fromJSON(first_line)

# ----------------------------SNIPPETS-----------------------------------------
#Attribute names
# sapply(names(alldata$business.json$attributes), USE.NAMES = FALSE, function(name) {
#   gsub("\\s", "-", name, perl = TRUE)
# });

# ----------------------------SNIPPETS-----------------------------------------
#Are all user names unique? NO.
# unames = alldata$user.json$name
# length(unique(unames)) == length(unames)


# ----------------------------SNIPPETS-----------------------------------------
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
