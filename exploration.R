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
subgraphs = lapply(ego.nets[1:10], function(vs) {
  induced.subgraph(chandler.graph, vs)
})

degrees = sapply(subgraphs, degree)

