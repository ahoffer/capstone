# CODE TO SUBSAMPLE THE DATA
# perl -ne 'print if (rand() < .001)' yelp_academic_dataset_review.json > small_reviews

# EXAMPLE 
# #Read the first record
# first_line = readLines(paste(PATH, "yelp_academic_dataset_business.json", sep=""), n = 1)
# 
# #Convert record to an R list
# first_list = fromJSON(first_line)
# 
# #Show the record in JSON format. 
# #Use something like http://www.jsoneditoronline.org/ 
# #to view the data hierarchically 
# toJSON(first_list, pretty = TRUE)

source("packages.R")
packages("jsonlite")

#Path to directory with JSON files
PATH = ""
PATH = "/Users/aaronhoffer/Downloads/yelp_dataset_challenge_academic_dataset/"

#Helper method to create R objects from JSON
json2r = function(json_file_name) {
  print(json_file_name)
  stream_in(file(paste(PATH, json_file_name, sep="")))
}

extract_record = function(alldata, datalist, record_number) {
  toJSON(alldata[datalist][[1]][record_number, ], pretty=TRUE)
}

# allfilenanmes = c("business.json", "checkin.json", "review.json", "tip.json", "user.json")
allfilenanmes = c("business.json", "review.json", "user.json")
alldata = sapply(allfilenanmes, json2r, USE.NAMES = TRUE)
save(alldata, file="alldata.RData")

# garbage = sapply(names(alldata), FUN = function(name) { print(name); print(extract_record(alldata, name, 1))})

 

