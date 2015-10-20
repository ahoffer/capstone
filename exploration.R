#Exploration
g=graph_copy

usethesenodes = c(reviewing_users$user_id, unlist(reviewing_users$friends, use.names=FALSE))
excludethesenodes = setdiff(usethesenodes, V(g)$name)
g = delete_vertices(g, excludethesenodes)


write.graph(g, "g.graphml", format="graphml")


plot.igraph(g, 
            vertex.label = V(g)$realname, 
            vertex.label.font=1,
            edge.arrow.size = 0.4,
            edge.arrow.width = 0.75,
            edge.curved=TRUE,
            # EQUIVALENT
            # layout=layout_as_star,
            #layout=layout.star,
            
            # OTHER
            # layout=layout.davidson.harel,
            # layout=layout.random,
            # layout=layout.gem(g,),
            # layout=layout.graphopt,
            # layout=layout.grid(g),
            #layout=layout.mds(g),
            #layout=layout.sugiyama(g),
            # layout=layout.fruchterman.reingold,
            )

# tot_comp= V(g)[V(g)$type == "user"]$total_compliments
# quantile(V(g)$total_compliments, na.rm = TRUE)
# summary(tot_comp)
# boxplot(log(tot_comp))
# hist(log(tot_comp),breaks = 50)
# tot_comp[order(tot_comp)]
hist(log(V(g)[V(g)$type=="user"]$total_compliments))
