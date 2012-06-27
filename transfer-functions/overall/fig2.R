library(reshape2)
library(ggplot2)

library(tikzDevice)
setTikzDefaults()
options("tikzLatexPackages"=c(getOption("tikzLatexPackages"),"\\usepackage{siunitx}","\\usepackage{amsmath}"))
# otherwise everytime you run this it adds another usepackage statement!

# load data
acovs <- read.table("../../flow/distribution/acovariances.csv",header=TRUE,sep=",")
ameans <- read.table("../../flow/distribution/ameans.csv",header=TRUE,sep=",")
ncovs <- read.table("../../force/distribution/ncovariances.csv",header=TRUE,sep=",")
nmeans <- read.table("../../force/distribution/nmeans.csv",header=TRUE,sep=",")
modeldata <- read.table("../../setup-data/models.csv",header=TRUE,sep=",")
lscales <- read.table("../../flow/lscale/alscale.csv",header=TRUE,sep=",")

# subset and cast ameans
ameans <- ameans[,c(3,5,6,8)]
ameans <- dcast(ameans,treatname+spd~channel,mean,value.var="mean")
lscales <- lscales[,c(3,5,6)]
names(lscales)
#lscales <- dcast(lscales,treatname+spd~.,mean,value.var="lscale")

# subset and cast nmeans
nmeans <- nmeans[,c(1,2,3,5,6,8)]
nmeans <- dcast(nmeans,run+modelname+treatname+spd~channel,mean,value.var="mean")

# subset and cast acovs
acovs <- acovs[,c(3,5,6,7,9)]
acovs$channel <- paste(acovs$from,acovs$to,sep="")
acovs <- acovs[,c(1,2,5,6)]
acovs <- dcast(acovs,treatname+spd~channel,mean,value.var="cov")

# subset and cast ncovs
ncovs <- ncovs[,c(1,2,3,5,6,7,9)]
ncovs$channel <- paste(ncovs$from,ncovs$to,sep="")
ncovs <- ncovs[,c(1,2,3,4,7,8)]
ncovs <- dcast(ncovs,run+modelname+treatname+spd~channel,mean,value.var="cov")

# merge anemometer and force/torque measurements
avs <- merge(nmeans,ameans,by=c("treatname","spd"))
all <- merge(ncovs,acovs,by=c("treatname","spd"))
all <- merge(all,avs,by=c("run","modelname","treatname","spd"))
all <- merge(all,lscales,by=c("treatname","spd"))
all <- merge(all,modeldata,by=c("modelname"))

# cleanup
rm(acovs)
rm(ameans)
rm(nmeans)
rm(ncovs)
rm(modeldata)

# subset and melt
all <- subset(all,(series == "new")) # new or bird, fish, solid
all <- subset(all,(treatname == "med") | (treatname == "sml"))
#all <- subset(all,(modelname != "rect890"))
#meltall <- melt(all,id=c("run","modelname","treatname","spd"))

theme_set(theme_bw(base_size=8))






# Dimensional plot of dforce vs dvelocity
fig2 <- ggplot(data=all,aes(x=sqrt(UU),y=sqrt(FZFZ),colour=as.factor(AR),shape=as.factor(treatname)))+geom_point()
fig2 <- fig2+scale_colour_grey()
fig2 <- fig2+ylim(0,0.04)+xlim(0,0.6)
fig2 <- fig2+xlab("$u'_{y,rms}, \\si{\\meter\\per\\second}$")+ylab("$f'_{y,rms}, \\si{\\newton}$")


# save raw stand-in PDF version
pdf("fig2raw.pdf",width=3,height=2,family="Times")
print(fig2)
dev.off()

# preview latex version
tikz("fig2.tex",standAlone=TRUE,width=3,height=2)
print(fig2+opts(legend.position="none"))
dev.off()






# Nondimensional plot of dforce vs dvelocity
rho=1.2
nu = 15e-6
all$intensity <- sqrt(all$UU)/abs(all$V)
all$NDforce <- sqrt(all$FZFZ)/(0.5*rho*all$V^2*all$plan.area)
all$Re <- sqrt(all$UU)*all$lscale/nu
fig2nd <- ggplot(data=all,aes(x=Re,y=NDforce,shape=treatname,colour=as.factor(AR)))+geom_point()
fig2nd <- fig2nd+scale_colour_grey()
fig2nd <- fig2nd+xlab("$\\mbox{Re}$")+ylab("$f'_{y,rms}/(0.5\\rho \\overline{u}^2 A)$")
fig2nd <- fig2nd+ylim(0,0.8)


# save raw stand-in PDF version
pdf("fig2ndraw.pdf",width=3,height=2,family="Times")
print(fig2nd)
dev.off()

# preview latex version
tikz("fig2nd.tex",standAlone=TRUE,width=3,height=2)
print(fig2nd+opts(legend.position="none"))
dev.off()
