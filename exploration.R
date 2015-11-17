#Exploration
g = graph_copy

#scrub city names
V(g)$city = tolower(V(g)$city)

#How about cities?
# cities = V(g)$city
# cities = cities[!is.na(cities)]

#Look at the Chandler area
chandler.vector = (V(g)$type == "user") | (V(g)$city == 'chandler')
chandler.graph = g - V(g)[!chandler.vector]

#Removes uses who have no friends and have not reviewed a business
chandler.graph = chandler.graph - V(chandler.graph)[degree(chandler.graph) == 0]

#How many users?
sum(V(chandler.graph)$type == "user")

#How many businesses?
sum(V(chandler.graph)$type != "user")

#How many edges?
ecount(chandler.graph)

#Still too many nodes and edges to run most graph
#analysis algorithms
#Reduce graph size to ego nets around businesses.
ego.nets = ego(chandler.graph,
               nodes = V(chandler.graph)[type != "user"],
               order = 1)

#Typify the ego nets of the business to establish a baseline
subgraphs = lapply(ego.nets, function(vs) {
  induced.subgraph(chandler.graph, vs)
})

average.number.nodes = mean(sapply(subgraphs, vcount))
average.number.edges = mean(sapply(subgraphs, ecount))

#Investigate the degrees of the different ego nets
degrees = sapply(subgraphs, degree)
average.degrees = sapply(degrees, mean)
hist(average.degrees)
quantile(average.degrees, seq(0, 1, 0.1))
#For ego.net where order = 1 
# 0%       10%       20%       30%       40%       50% 
#   1.000000  1.500000  1.600000  1.666667  1.777778  1.885621 
# 60%       70%       80%       90%      100% 
# 2.000000  2.228205  2.469804  3.000000 14.585366 


#Expand ego nets to 2 edges out from the businesses
ego.nets2 = ego(chandler.graph,
               nodes = V(chandler.graph)[type != "user"],
               order = 2)

subgraphs2 = lapply(ego.nets2, function(vs) {
  induced.subgraph(chandler.graph, vs)
})

quantile(
  sapply(sapply(subgraphs2, degree), mean), 
  seq(0, 1, 0.1))
# 0%        10%        20%        30%        40%        50%        60% 
# 1.000000   2.903812   4.571429   8.173147  15.020925  25.569113  36.095102 
# 70%        80%        90%       100% 
#   45.224641  54.581658  67.746356 123.911243 


# Between centrality
# Run similar calculations as degree
b.centrality = sapply(subgraphs, betweenness)

#This command takes too long to run
# b.centrality2 = sapply(subgraphs2, betweenness

#Explore the user compliments.
quants = seq(0.95,1,0.1)
quantile(V(chandler.graph)[type=="user"]$compliments_funny, quants)
quantile(V(chandler.graph)[type=="user"]$compliments_cool)
quantile(V(chandler.graph)[type=="user"]$total_compliments)

#Explore the review compliments
quantile(E(chandler.graph)$votes_funny, na.rm=T, quants)
quantile(E(chandler.graph)$votes_useful, na.rm=T)
quantile(E(chandler.graph)$votes_cool, na.rm=T)

#Explore businesses
vs.business = V(chandler.graph)[type != "user"]
V(chandler.graph)[type != "user"]$impact =0
V(chandler.graph)[type != "user"]$impact <- vs.business$stars * vs.business$stars *log(vs.business$review_count)
hist(vs.business$impact)
hist(vs.business$stars)
plot(density(log10(vs.business$review_count)))
plot(density(vs.business$impact))


#Number of stars and number of reviews are not (strongly) correlated
cor.test(vs.business$stars, vs.business$review_count)
# Pearson's product-moment correlation
# data:  vs.business$stars and vs.business$review_count
# t = 1.0179, df = 1850, p-value = 0.3089
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
# -0.02191415  0.06913300
# sample estimates:
# cor 
# 0.02365849 

#Does the new impact measure correlate with stars or number of reviews? YES and YES, 
#but not perfectly.
cor.test(vs.business$impact, vs.business$stars)
# data:  vs.business$impact and vs.business$stars
# t = 31.631, df = 1850, p-value < 2.2e-16
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   0.5620729 0.6212384
# sample estimates:
#   cor 
# 0.592454 

cor.test(vs.business$impact, vs.business$review_count)
# data:  vs.business$impact and vs.business$review_count
# t = 35.271, df = 1850, p-value < 2.2e-16
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   0.6060501 0.6605653
# sample estimates:
#   cor 
# 0.634095 





p = ecdf(vs.business$impact)
quantile(vs.business$impact, seq(0,1,0.1))
plot(p)


#Most impactful business


# x=V(chandler.graph)[order(V(chandler.graph)[type=="user"]$compliments_funny, decreasing = T)[1:10]]
# x[[]]
