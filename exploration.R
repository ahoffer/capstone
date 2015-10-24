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
hist(log10(funny.compliments), xlim=c(0,3))

# Log-Log historgram
h$counts = log10(h$counts)
plot(h, ylab='log10(Frequency)')

#quantile(funny.compliments, probs = c(1:10)/10)
#10%   20%   30%   40%   50%   60%   70%   80%   90%  100% 
#  0     0     0     0     0     0     0     0     1 10254


#Either you are a rockstar or you are nobody
quantile(funny.compliments)
#0%   25%   50%   75%  100% 
#0     0     0     0 10254 




# Look for correlations between degree and fun
#More friends, more reviews = more compliments
#would correlate strongly with the number of compliments
d  = degree(g)
x = log10(d)
y = log10(V(g)$compliments_funny)
plot(x,y, pch=20, col="blue")
df = data.frame("x" = x, "y" = y)
ddf = df[df$x > 1 & df$y> 1 ,]
plot(y~x, data = ddf, pch=20, col="blue")


#Let's look at geopgraphy
states = V(g)$state
states = states[!is.na(states)]

#60,316 users have state data
length(states)

#How about cities?
cities = V(g)$city
cities = cities[!is.na(cities)]

#Make some word clouds
t = table(states)
wordcloud(words = names(t), freq = as.vector(t),  rot.per=0, colors=brewer.pal(5, "Dark2"))
tt= table(cities)
wordcloud(words = names(tt), freq = as.vector(tt),  rot.per=.35, colors=brewer.pal(20, "Dark2"))
