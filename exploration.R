#Exploration
source("packages.R")
packages("igraph")
packages("tcltk")

edge_density(g)
diameter(g, directed = TRUE)
diameter(g, directed = FALSE)
ecount(g)
vcount(g)
vs = g[order(V(g)$votes_funny, decreasing = TRUE)]

print(vs[1:10], vertex.attributes=TRUE)

V(g)[V(g)$votes_funny > 0]
