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
simple=titanic_full[c("Embarked","Age","Fare")]
set.seed(123)
library(mice)
imputed=complete(mice(simple))

titanic_full$Embarked <- imputed$Embarked
titanic_full$Age <- imputed$Age
titanic_full$Fare <- imputed$Fare

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

#Survived equation
survived_eq<-"Survived~Pclass+Sex+Age+Fare+SibSp+Parch+Embarked"

#Survived formula casting
survival<-as.formula(survived_eq)

#Random Forest package
install.packages("randomForest")
library(randomForest)

#Creating the model using RF
model<-randomForest(formula=survival, data=train, ntree=500,mtry=3,nodesize=0.01*nrow(train)) 


features_eq<-"Pclass+Sex+Age+Fare+SibSp+Parch+Embarked"

#Prediction of Survival 
Survived<-predict(model, newdata=test)


#Creating the prediction and new data frame
PassengerId<-test$PassengerId
output2.df<-as.data.frame(PassengerId)          #New data frame created 
output2.df$Survived<-Survived 

write.csv(output2.df, file="output2.csv", row.names = FALSE)







