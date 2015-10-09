7323/17898
x= json2r("yelp_academic_dataset_user.json")
names = x[x$votes$funny > 10000, c("name")]
names[order(names)]

df = x
df$fanfactor = "one_zero_fans"
df$fanfactor[df$fans > 1] <- "multiple_fans"
df$funnyfactor = "one_zero_funny"
df$funnyfactor[df$compliments$funny > 1] = "multiple_funny"
df$fanfactor = factor(df$fanfactor)
df$funnyfactor = factor(df$funnyfactor)
#myOtherTable = table(df$funnyfactor, df$fanfactor)
myOtherTable = table(df$fanfactor, df$funnyfactor)
fisher.test(myOtherTable)