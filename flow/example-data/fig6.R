library(ggplot2)
library(reshape2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load data and select columns
flow <- read.table("histdata.csv",header=TRUE,sep=",")
flow <- flow[,c(1,2,3,5,6,7,8)]

# recast data?
flow <- dcast(flow, ... ~ channel,mean)

# subset a single example
#example <- subset(flow,(modelname=="rect6"))
example <- subset(flow,(spd==250))
example <- subset(example,(treatname=="sml"))

# remelt
melted <- melt(example, id=c("run","modelname","treatname","spd","t"))
melted <- subset(melted,(variable %in% c("U","V")))
melted$variable <- factor(melted$variable,levels=c("V","U","W"),labels=c("$u_x$","$u_y$","$u_z$"))

theme_set(theme_bw(base_size=8))

# make time plot(s)
fig6a <- ggplot(data=melted,aes(x=t,y=-value,colour=variable))+geom_line()
fig6a <- fig6a+scale_color_grey()
fig6a <- fig6a+xlim(10,26) # same length as FFT window? 
fig6a <- fig6a+xlab("$t, \\si{\\second}$")
fig6a <- fig6a+ylab("$u, \\si{\\meter\\per\\second}$")
#fig6a <- fig6a+facet_grid(variable~.)

# save raw stand-in PDF version
pdf("fig6araw.pdf",width=3,height=2,family="Times")
print(fig6a)
dev.off()

# pretty latex version
tikz("fig6a.tex",standAlone=TRUE,width=3,height=2)
print(fig6a+opts(legend.position="none"))
dev.off()






# make histogram
fig6b <- ggplot(data=melted,aes(value,fill=variable))+geom_histogram(binwidth=0.1)+facet_grid(variable~.)
fig6b <- fig6b+scale_fill_grey()
fig6b <- fig6b+xlab("$u, \\si{\\meter\\per\\second}$")
fig6b <- fig6b+ylab("$\\mbox{count}/1000$")

# save raw stand-in PDF version
pdf("fig6braw.pdf",width=3,height=2,family="Times")
print(fig6b)
dev.off()

# pretty latex version
tikz("fig6b.tex",standAlone=TRUE,width=3,height=2)
print(fig6b+opts(legend.position="none"))
dev.off()



