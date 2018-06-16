#Data input and cleaning------------------------------------------------------------------------------#

#Read the data
train=read.csv("train.csv", stringsAsFactors = FALSE)
test=read.csv("test.csv", stringsAsFactors = FALSE)

#Distinguish the dataframes
train$istrain<-TRUE
test$istrain<-FALSE

#add in the "survived" col to test to have same no. of vars in test and train
test$Survived<-NA     

#Combine the dataframes
titanic_full<-rbind(train,test)

#Data Cleaning, removing NA
titanic_full[titanic_full$Embarked=='', "Embarked"] <-"S"
titanic_full[is.na(titanic_full$Age), "Age"] <-median(titanic_full$Age, na.rm=TRUE)
titanic_full[is.na(titanic_full$Fare), "Fare"] <-median(titanic_full$Fare, na.rm=TRUE)

#Categorical casting
titanic_full$Pclass<-as.factor(titanic_full$Pclass)
titanic_full$Sex<-as.factor(titanic_full$Sex)
titanic_full$Embarked<-as.factor(titanic_full$Embarked)



#Split the data back
train=subset(titanic_full, istrain==TRUE)
test=subset(titanic_full, istrain==FALSE)

#Variable survived turned to factor
train$Survived<-as.factor(train$Survived)

#Prediction and Modeling---------------------------------------------------------------------------------#






