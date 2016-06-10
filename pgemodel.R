## Project 2 ##

##fourth quarter totals of electricy usage
pge <- read.csv("PGE_2015_Q4_ElectricUsageByZip.csv",stringsAsFactors=F)

#general picture of the data
str(pge)

#using combined, filter out missing data and remove unncessary variables
pge.rev <- pge[!is.element(pge$Combined,"Y"),]
pge.rev <- pge.rev[,-c(1:3,5)]

#remove part of the string
pge.rev$CustomerClass <- sapply(strsplit(pge.rev$CustomerClass,split="- ",
				        fixed=T),function(x)(x[2]))

#the breakdown of variables to be classified
summary(pge.rev)
prop.table(table(pge.rev$CustomerClass))

##subsetting a training and validation set
#normalize to prepare for knn
normalize <- function(x){return((x-min(x))/(max(x)-min(x)))}
pge.n <- as.data.frame(lapply(pge.rev[2:4],normalize))
pge.n <- cbind(pge.n,pge.rev$CustomerClass)
colnames(pge.n) <- c("TotalCustomers","TotalkWh","AveragekWh","CustomerClass")
summary(pge.n)

#split dataset into 60 percent train 40 percent test
train.sub <- createDataPartition(pge.n$CustomerClass,p=0.60,list=F)
train.pge <- pge.n[train.sub,]
test.pge <- pge.n[-train.sub,]

prop.table(table(train.pge$CustomerClass))
prop.table(table(train.pge$CustomerClass))

##modelling and evaluating
#model with knn
ctrl <- trainControl(method="cv",number=10,selectionFunction="oneSE")
grid <- expand.grid(.k=c(3,5,7,9,11,13,15))

model <- train(CustomerClass~.,data=train.pge,method="knn",metric="Kappa",
		   trControl=ctrl,tuneGrid=grid)
model

p <- predict(model,test.pge)
CrossTable(x=test.pge$CustomerClass,y=p,prop.chisq=F,prop.c=F,prop.r=F,
	     dnn=c("Actual Customer Class","Predicted Customer Class"))

##improving the model
#using C5.0 decision trees
improved.train.pge <- pge.rev[train.sub,]
improved.test.pge <- pge.rev[-train.sub,]

ctrl <- trainControl(method="repeatedcv",number=10,repeats=10)
improved.model <- train(CustomerClass~.,data=improved.train.pge,method="C5.0",
			      metric="Kappa",trControl=ctrl)
improved.model

improved.p <- predict(improved.model,improved.test.pge)
CrossTable(x=improved.test.pge$CustomerClass,y=improved.p,prop.chisq=F,
	     prop.c=F,dnn=c("Actual Customer Class","Predicted Customer Class"))






