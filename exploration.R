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
a= quantile(V(chandler.graph)[type=="user"]$compliments_funny)
b= quantile(V(chandler.graph)[type=="user"]$compliments_cool)
c= quantile(V(chandler.graph)[type=="user"]$total_compliments)

#Explore the review compliments
d= quantile(V(chandler.graph)[type !="user"]$votes_funny)
e= quantile(V(chandler.graph)[type !="user"]$votes_useful)
f= quantile(V(chandler.graph)[type !="user"]$votes_cool)

#Select some cool users and businesses



