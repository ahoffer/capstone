

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


#Make some word clouds
t = table(states)
wordcloud(words = names(t), freq = as.vector(t),  rot.per=0, colors=brewer.pal(5, "Dark2"))
tt= table(cities)
wordcloud(words = names(tt), freq = as.vector(tt),  rot.per=.35, colors=brewer.pal(20, "Dark2"))
