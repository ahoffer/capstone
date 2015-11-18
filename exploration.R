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

quantile(sapply(sapply(subgraphs2, degree), mean),
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
quantile(V(chandler.graph)[type == "user"]$compliments_funny, quants)
quantile(V(chandler.graph)[type == "user"]$compliments_cool)
quantile(V(chandler.graph)[type == "user"]$total_compliments)

#Explore the review compliments
quantile(E(chandler.graph)$votes_funny, na.rm = T, quants)
quantile(E(chandler.graph)$votes_useful, na.rm = T)
quantile(E(chandler.graph)$votes_cool, na.rm = T)

#Explore businesses
# - - - - - - - - - - - - -
#Create a copy of the businesses
vs.business = V(chandler.graph)[type != "user"]

#Assess impact of a business
V(chandler.graph)[type != "user"]$impact = 0
V(chandler.graph)[type != "user"]$impact <-
  vs.business$stars * vs.business$stars * log(vs.business$review_count)

#Refresh copy of the vbusinesses
vs.business = V(chandler.graph)[type != "user"]

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


#Log of review count increases correlation with impact
cor.test(vs.business$impact, log10(vs.business$review_count))
# data:  vs.business$impact and log10(vs.business$review_count)
# t = 49.775, df = 1850, p-value < 2.2e-16
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#   0.7364717 0.7754622
# sample estimates:
#   cor
# 0.7566389


#Impact has a nicer distribution than reviews (long tail) or stars (little variation)
quantile(vs.business$impact, seq(0,1,0.1))
# 0%        10%        20%        30%        40%        50%        60%        70%        80%        90%       100%
# 1.098612   9.887511  14.986845  21.170645  25.751007  29.518374  35.155593  42.224917  50.848861  62.913099 108.755420


p = ecdf(vs.business$impact)
plot(p)
p = ecdf(log10(vs.business$review_count))
plot(p)


#Most impactful businesses
index.impactful = order(V(chandler.graph)$impact, decreasing = T)
most.impactful.index =  index.impactful[2]
most.impactful.neighborhood.vs = neighborhood(chandler.graph, order = 1, nodes =
                                                most.impactful.index)[[1]]
graph.impact <-
  induced_subgraph(chandler.graph, most.impactful.neighborhood.vs)
E(graph.impact)$starlabel = "?"
logical.vector = !is.nan(E(graph.impact)$stars)
E(graph.impact)[logical.vector]$starlabel = E(graph.impact)[logical.vector]$stars


edgeColorIdx = function(x) {
  #Values less than 1 map to 1
  if (is.nan(x) || is.na(x))
    return(1)
  x  = if (x < 1)
    1
  else
    x
  x = if (x > number.of.colors)
    return(number.of.colors)
  else
    x
  ceiling(x) %% (number.of.colors + 1)
}


colorInterval = function(x) {
  #Values less than 1 map to 1
  x = if (is.nan(x) || is.na(x)) 0 else x 
  x/5
}

edgeColorMapIdx(0)
edgeColorMapIdx(1)
edgeColorMapIdx(2)
edgeColorMapIdx(3)
edgeColorMapIdx(4)
edgeColorMapIdx(4.9)
edgeColorMapIdx(0.0000001)
edgeColorMapIdx(500)
edgeColorMapIdx(500.1)
edgeColorMapIdx(NA)
edgeColorMapIdx(NaN)

edgeColor = function(x) {
  clrs[edgeColorIdx(x)]
}

V(graph.impact)[type=='user']$color = 'mediumorchid2'
V(graph.impact)[type=='user']$size = 4
V(graph.impact)[type!='user']$color = 'navyblue'
V(graph.impact)[type!='user']$size = 8
E(graph.impact)[type == 'friend']$color = 'black'
E(graph.impact)[type !='friend']$color = sapply(E(graph.impact)[type !='friend']$stars, colorInterval)


number.of.colors = 5
clrs = brewer.pal(9,"OrRd")[7:9]
pal <- colorRampPalette(number.of.colors, clrs)
clrs = rev(heat.colors(10, )[1:5])

#Plot of #1 impactful business
plot(
  graph.impact,
  vertex.label = V(graph.impact)$realname,
  # vertex.size = 4,
  vertex.label.font = 1,
  vertex.label.font='Helvetica',
  vertex.frame.color= "white",
  vertex.label.dist = 1,
  # vertex.label.degree = -pi/2,
  edge.width = 2,
  edge.color = sapply(E(graph.impact)$stars, edgeColor),
  edge.arrow.size = 0.4,
  edge.arrow.width = 0.75,
  layout = layout.fruchterman.reingold,
)








