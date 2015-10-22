#Exploration
g=graph_copy

#Remove trouble-some vertices
g = g - vertex(which(degree(g) > 100))

#Remove unconnected nodes
g = g - V(g)[degree(g) == 0]

tkplot(g)

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

# Log histogram
funny.compliments = V(g)[V(g)$type=="user"]$compliments_funny
h = hist(log10(funny.compliments), plot=F)
hist(log10(funny.compliments), xlim=c(0,4))

# Log-Log historgram
h$counts = log10(h$counts)
plot(h, ylab='log10(Frequency)')

quantile(funny.compliments, probs = c(1:10)/10)
# 10%     20%     30%     40%     50%     60%     70%     80%     90%    100% 
# 0.0     0.0     0.0     1.0     3.0     6.0    12.0    27.0    86.7 10254.0 


# Look for correlations between degree and fun
#Very, very little correlations. Surprising because you think more friends, more reviews 
#would correlate strongly with the number of compliments
d  = degree(g)
x = log10(d)
y = log10(V(g)$compliments_funny)
plot(x,y, pch=20, col="blue")
df = data.frame("x" = x, "y" = y)
ddf = df[df$x > 1 & df$y> 1 ,]

plot(y~x, data = ddf, pch=20, col="blue")


