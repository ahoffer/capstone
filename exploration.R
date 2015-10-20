#Exploration
g=graph_copy


# write.graph(g, "g.graphml", format="graphml")
# write.graph(g, "777-774.graphml", format="graphml")

#Set common properties
# V(g)[V(g)$type == "user"]$color = "ivory2"
# V(g)[V(g)$type != "user"]$color = "lightcyan"
# V(g)$label.cex = 0.75


#Remove trouble-some vertices
g = g - vertex(which(degree(g) > 100))

#Remove unconnected nodes
g = g - vertex(degree(g) == 0)

#Whitespace margins below, above, left and right of the plot
margin = c(0,0,0,0)

layout = layout.drl(g)
# layout = layout.star(g) # non-conformable arrays
# layout = layout.bipartite(g, types  = V(g)$type != "user")
tkplot(g)
plot.igraph(g, 
            # vertex.label = V(g)$realname, 
            vertex.size = 4,
            # vertex.label = NA,
            vertex.label.font=1,
            edge.arrow.size = 0.4,
            edge.arrow.width = 0.75,
            layout = layout,
            margin=margin,
            rescale = TRUE
            )

# tot_comp= V(g)[V(g)$type == "user"]$total_compliments
# quantile(V(g)$total_compliments, na.rm = TRUE)
# summary(tot_comp)
# boxplot(log(tot_comp))
# hist(log(tot_comp),breaks = 50)
# tot_comp[order(tot_comp)]

all.compliments = V(g)[V(g)$type=="user"]$total_compliments
hist(log(all.compliments),  xlim=c(0,8))
plot(density(log(all.compliments)))
?density
