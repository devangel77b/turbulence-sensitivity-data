library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise it adds more every time you run


# load psd data
tob <- read.table("../../flow/spectrak/atobk.csv",header=TRUE,sep=",")
tob <- tob[,c(3,5,6,8,9)]
tob <- dcast(tob,treatname+spd+kcenterfreq~from,mean,value.var="value")

# there is no model data for this; just for a given flow
all <- tob

# subset
all <- subset(all,(treatname=="med"))
all <- subset(all,(spd %in% c(0,50,100,150,200,250)))

theme_set(theme_bw(base_size=8))


# dimensional plot of Pxx vs f
fig3d <- ggplot(data=all,aes(x=as.factor(kcenterfreq),y=U,colour=as.factor(spd)))+geom_point()+geom_line(aes(group=as.factor(spd)))
fig3d <- fig3d+scale_x_discrete(labels=c(".02",".03",".06",".13",".25",".5","1","2","4","8","16","32","64","128"))
fig3d <- fig3d+scale_y_log10()#breaks=c(1e-6,1e-5,1e-4,1e-3,1e-2),labels=c("$10^{-6}$","$10^{-5}$","$10^{-4}$","$10^{-3}$","$10^{-2}$"))
fig3d <- fig3d+scale_colour_grey()
fig3d <- fig3d+xlab("third-octave-band center wavenumber, \\si{\\per\\meter}")+ylab("signal power, $(\\si{\\meter\\per\\second})^2$")

# save raw stand-in PDF version
pdf("fig3draw.pdf",width=3,height=2,family="Times")
print(fig3d)
dev.off()

# latex version
tikz("fig3d.tex",standAlone=TRUE,width=3,height=2)
print(fig3d+opts(legend.position="none"))
dev.off()


