
#Whitespace margins below, above, left and right of the plot
margin = c(0,0,0,0)

layout = layout.fruchterman.reingold(g)
# layout = layout.star(g) # non-conformable arrays
# layout = layout.bipartite(g, types  = V(g)$type != "user")
plot.igraph(g, 
            # vertex.label = V(g)$realname, 
            vertex.size = 4,
            vertex.label = NA,
            vertex.label.font=1,
            edge.arrow.size = 0.4,
            edge.arrow.width = 0.75,
            layout = layout.fruchterman.reingold
)