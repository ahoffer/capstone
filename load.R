source("initialize.R")


#-----FILENAMES----------------------------------------------------------------
# allfilenanmes = c("business.json", "checkin.json", "review.json", "tip.json", "user.json")
# allfilenanmes = c("business.json", "review.json", "user.json")

#-----JSON -> R OBJECTS--------------------------------------------------------
# alldata = sapply(allfilenanmes, json2r, USE.NAMES = TRUE)
review=json2r("./count30/review.json")
business.json=json2r("./percent100/business.json")
user=json2r("./percent100/user.json")

#-----SAVING-------------------------------------------------------------------
save(business, file = "percent100/business.RData")
save(review, file = "percent100/review.RData")
save(user, file = "percent100/user.RData")
save(review, file="count30/review.RData")
#-----LOADING------------------------------------------------------------------
load("count30/review.RData") 
load("percent100/user.RData")
load("percent100/business.RData")

