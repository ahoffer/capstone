#Exploration
g=graph_copy

#scrub city names
V(g)$city = tolower(V(g)$city)

#How about cities?
cities = V(g)$city
cities = cities[!is.na(cities)]

#Look at the Chandler area
chandler.vector= (V(g)$type=="user") | (V(g)$city =='chandler')
chandler.graph = g - V(g)[!chandler.vector]

#Removes uses who have no friends or have not reviewed a business
chandler.graph = chandler.graph - V(chandler.graph)[degree(chandler.graph) == 0]

#How many users?
sum(V(chandler.graph)$type == "user")

#How many businesses?
sum(V(chandler.graph)$type != "user")

diameter(chandler.graph)


