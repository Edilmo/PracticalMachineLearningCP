pml_write_files = function(x){
        n = length(x)
        for(i in 1:n){
                filename = paste0("problem_id_",i,".txt")
                write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
        }
}

testingBelt <- predict(preProcBelt, testing[,tempNames[grep("_belt", tempNames)]])
testingForearm <- predict(preProcForearm, testing[,tempNames[grep("_forearm", tempNames)]])
testingDumbbell <- predict(preProcDumbbell, testing[,tempNames[grep("_dumbbell", tempNames)]])
testingArm <- predict(preProcArm, testing[,c(tempNames[grep("_arm_", tempNames)], tempNames[grep("_arm$", tempNames)])])

testingAllPCA <- data.frame(testingArm, testingDumbbell, testingForearm, testingBelt)
testingPredAllPCA <- predict(modFitAllPCA,testingAllPCA)


# El tercero fue clasificado como C y estaba malo. Se intento al azar B y es la correcta.
pml_write_files(testingPredAllPCA)
# El tercero fue clasificado como C y estaba malo. Se intento al azar B y es la correcta.



# Some test routines below

modFitBelt <- train(classe ~ ., data=data.frame(trainBelt, total_accel_belt=train$total_accel_belt, classe=train$classe), method="multinom")

modFitForearm <- train(classe ~ ., data=data.frame(trainForearm, total_accel_forearm=train$total_accel_forearm, classe=train$classe), method="multinom")

modFitDumbbell <- train(classe ~ ., data=data.frame(trainDumbbell, total_accel_dumbbell=train$total_accel_dumbbell, classe=train$classe), method="multinom")

modFitArm <- train(classe ~ ., data=data.frame(trainArm, total_accel_arm=train$total_accel_arm, classe=train$classe), method="multinom")


# ----

trainPCA_Acc <- data.frame(trainArm, total_accel_arm=train$total_accel_arm, trainDumbbell, total_accel_dumbbell=train$total_accel_dumbbell, trainForearm, total_accel_forearm=train$total_accel_forearm, trainBelt, total_accel_belt=train$total_accel_belt, classe=train$classe)

modFitPCA_Acc <- train(classe ~ ., data=trainPCA_Acc, method="multinom")

# ----


predBelt <- predict(modFitBelt, data.frame(testBelt, total_accel_belt=test$total_accel_belt))
confMtxBelt <- confusionMatrix(test$classe, predBelt)
predForearm <- predict(modFitForearm, data.frame(testForearm, total_accel_forearm=test$total_accel_forearm))
confMtxForearm <- confusionMatrix(test$classe, predForearm)
predDumbbell <- predict(modFitDumbbell,data.frame(testDumbbell, total_accel_dumbbell=test$total_accel_dumbbell))
confMtxDumbbell <- confusionMatrix(test$classe, predDumbbell)
predArm <- predict(modFitArm,data.frame(testArm, total_accel_arm=test$total_accel_arm))
confMtxArm <- confusionMatrix(test$classe, predArm)



# ----

testAllPCA_Acc <- data.frame(trainArm, total_accel_arm=train$total_accel_arm, trainDumbbell, total_accel_dumbbell=train$total_accel_dumbbell, trainForearm, total_accel_forearm=train$total_accel_forearm, trainBelt, total_accel_belt=train$total_accel_belt, classe=train$classe)


predCombDF <- data.frame(predBelt, predForearm, predDumbbell, predArm, classe=test$classe)
combModFit <- train(classe ~.,method="gam",data=predCombDF)
combPred <- predict(combModFit,predCombDF)
confMtxArm <- confusionMatrix(test$classe, combPred)

# trainPC <- data.frame(trainBelt, trainForearm, trainDumbbell, trainArm, classe=train$classe)


# length(names(train)) - length(names(train)[grep("_belt", names(train))]) - length(names(train)[grep("_forearm", names(train))]) - length(names(train)[grep("_dumbbell", names(train))]) - length(names(train)[grep("_arm_", names(train))]) - length(names(train)[grep("_arm$", names(train))])

# featurePlot(x=train[,names(train)[grep("_belt", names(training))]], y = train$classe, plot="pairs")

# Lets build our model
# modelFit <- train(train$classe ~ .,method="glm",preProcess="pca",data=train)
# confusionMatrix(test$classe,predict(modelFit,test))
