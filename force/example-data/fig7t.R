library(ggplot2)
library(reshape2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load data and select columns
flow <- read.table("nhistdata.csv",header=TRUE,sep=",")
flow <- flow[,c(1,2,3,5,6,7,8)]

# recast data?
flow <- dcast(flow, ... ~ channel,mean)

# subset a single example
example <- subset(flow,(modelname=="rect6"))
example <- subset(example,(spd==250))
example <- subset(example,(treatname=="sml"))
example$TX <- example$TX/1000

# remelt
melted <- melt(example, id=c("run","modelname","treatname","spd","t"))
melted <- subset(melted,(variable %in% c("TX")))
melted$variable <- factor(melted$variable,levels=c("FZ","FY","FX","TZ","TY","TX"),labels=c("$f_x$","$f_y$","$f_z$","$t_x$","$t_y$","$t_z$"))

theme_set(theme_bw(base_size=8))

# make time plot(s)
fig7a <- ggplot(data=melted,aes(x=t,y=value,colour=variable))+geom_line()
fig7a <- fig7a+scale_color_grey()
fig7a <- fig7a+xlim(0,1)
#+xlim(10,26) # same length as FFT window? 
fig7a <- fig7a+xlab("$t, \\si{\\second}$")
fig7a <- fig7a+ylab("$\\tau, \\si{\\newton\\meter}$")
fig7a <- fig7a+facet_grid(variable~.,scales="free")

# save raw stand-in PDF version
pdf("fig7atraw.pdf",width=3,height=2,family="Times")
print(fig7a)
dev.off()

# pretty latex version
tikz("fig7at.tex",standAlone=TRUE,width=3,height=2)
print(fig7a+opts(legend.position="none"))
dev.off()






# make histogram
fig7b <- ggplot(data=melted,aes(value,fill=variable))+geom_histogram(binwidth=0.0005)+facet_grid(variable~.,scales="free")
fig7b <- fig7b+scale_fill_grey()
fig7b <- fig7b+xlab("$\\tau, \\si{\\newton\\meter}$")
fig7b <- fig7b+ylab("$\\mbox{count}$")

# save raw stand-in PDF version
pdf("fig7btraw.pdf",width=3,height=1,family="Times")
print(fig7b)
dev.off()

# pretty latex version
tikz("fig7bt.tex",standAlone=TRUE,width=3,height=1)
print(fig7b+opts(legend.position="none"))
dev.off()



