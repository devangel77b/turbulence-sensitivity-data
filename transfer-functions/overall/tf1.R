library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise everytime you run this it adds another usepackage statement!

# load data
ameans <- read.table("../../flow/distribution/ameans.csv",header=TRUE,sep=",")
nmeans <- read.table("../../force/distribution/nmeans.csv",header=TRUE,sep=",")
modeldata <- read.table("../../setup-data/models.csv",header=TRUE,sep=",")

# subset and cast ameans
ameans <- ameans[,c(3,5,6,8)]
ameans <- dcast(ameans,treatname+spd~channel,mean)

# subset and cast nmeans
nmeans <- nmeans[,c(1,2,3,5,6,8)]
nmeans <- dcast(nmeans,run+modelname+treatname+spd~channel,mean)

# merge anemometer and force/torque measurements
all <- merge(nmeans,ameans,by=c("treatname","spd"))
all <- merge(all,modeldata,by=c("modelname"))
droplevels(all)

# cleanup
rm(ameans)
rm(nmeans)
rm(modeldata)

# subset and melt
all <- subset(all,(series == "new")) # or bird, fish, solid
all <- subset(all,(treatname == "no"))
meltall <- melt(all,id=c("run","modelname","treatname","spd"))

theme_set(theme_bw(base_size=8))

# Dimensional plot of force vs velocity
fig1 <- ggplot(data=all,aes(x=abs(V),y=abs(FY),colour=as.factor(AR)))+geom_point()+xlab("$\\overline{u_x}, \\si{\\meter\\per\\second}$")+ylab("$\\overline{f_x}, \\si{\\newton}$")+scale_colour_grey()

# save raw stand-in PDF version
pdf("fig1raw.pdf",width=3,height=2,family="Times")
print(fig1)
dev.off()

# save nice latex version
tikz("fig1.tex",standAlone=TRUE,width=3,height=2)
print(fig1+opts(legend.position="none"))
dev.off()






# Dimensionless plot of Cd vs Re
rho = 1.2
nu = 15e-6
all$Re = abs(all$V)*all$length/nu
all$Cd = abs(all$FY)/(0.5*rho*all$V^2*(2*all$plan.area))
fig1nd <- ggplot(data=all,aes(x=Re,y=Cd,colour=as.factor(AR)))+geom_point()+scale_y_log10(limits=c(0.01,1))+scale_x_log10(limits=c(1000,100000),breaks=c(1000,2000,5000,10000,20000,50000,100000),labels=c("$10^3$","","","$10^4$","","","$10^5$"))+scale_colour_grey()+xlab("$\\mbox{Re}_L$")+ylab("${\\overline{f_x}}/{0.5\\rho \\overline{u_x}^2 A}$")
# How to trick ggplot2 to give me nicely labeled axes on loglog. 

# save raw stand-in PDF version
pdf("fig1ndraw.pdf",width=3,height=2,family="Times")
print(fig1nd)
dev.off()

# save nice latex version
tikz("fig1nd.tex",standAlone=TRUE,width=3,height=2)
print(fig1nd+opts(legend.position="none"))
dev.off()

