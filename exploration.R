#Exploration
g=graph_copy
plot.igraph(g, 
            vertex.label = V(g)$realname, 
            vertex.label.font=2,
            edge.arrow.size = 0.5,
            layout=layout.fruchterman.reingold)

tot_comp= V(g)[V(g)$type == "user"]$total_compliments
quantile(V(g)$total_compliments, na.rm = TRUE)
summary(tot_comp)
boxplot(log(tot_comp))
hist(log(tot_comp),breaks = 50)
tot_comp[order(tot_comp)]
