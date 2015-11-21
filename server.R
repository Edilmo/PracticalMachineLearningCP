library(shiny)

# Loading the data sets
training <- read.csv("pml-training.csv")
# Deleting sumarization variables in the training data
training <- training[,-grep("kurtosis", names(training))]
training <- training[,-grep("skewness", names(training))]
training <- training[,-grep("max", names(training))]
training <- training[,-grep("min", names(training))]
training <- training[,-grep("amplitude", names(training))]
training <- training[,-grep("var", names(training))]
training <- training[,-grep("avg", names(training))]
training <- training[,-grep("stddev", names(training))]
# Deleting timestamp data from both data sets
training <- training[,-grep("timestamp", names(training))]
# Deleting window data from both data sets
training <- training[,-grep("window", names(training))]
# Deleting X variable from both data sets
training <- training[,-1]
# Deleting User Name variable from both data sets
training <- training[,-1]
# Factor total_accel variables
training$total_accel_belt <- factor(training$total_accel_belt)
training$total_accel_arm <- factor(training$total_accel_arm)
training$total_accel_dumbbell <- factor(training$total_accel_dumbbell)
training$total_accel_forearm <- factor(training$total_accel_forearm)
library(caret)
set.seed(32343)

# Let's create our cross validation data sets
inTrain <- createDataPartition(y=training$classe,
                               p=0.60, list=FALSE)
train <- training[inTrain,]
testTemp <- training[-inTrain,]
inTest <- createDataPartition(y=testTemp$classe,
                              p=0.50, list=FALSE)
test <- testTemp[-inTest,]
validate <- testTemp[-inTest,]

library(ggplot2)
tempNames <- names(train)[-grep("total_accel", names(train))]


shinyServer(function(input, output) {
        kmeansReactive <- reactive({
                t <- switch(input$sensor,
                       "Arm" = "_arm_",
                       "Forearm" = "_forearm",
                       "Dumbbell" = "_dumbbell",
                       "Belt" = "_belt")
                currentNames <<- tempNames[grep(t, tempNames)]
                if(t == "_arm_"){
                        currentNames <<- c(currentNames, tempNames[grep("_arm$", tempNames)])
                }
                kmeans(train[,currentNames], centers = input$clusters)
        })
        
        pcaReactive <- reactive({
                preProcBelt <<- preProcess(train[,tempNames[grep("_belt", tempNames)]],method="pca", thresh = input$thresh)
                preProcForearm <<- preProcess(train[,tempNames[grep("_forearm", tempNames)]],method="pca", thresh = input$thresh)
                preProcDumbbell <<- preProcess(train[,tempNames[grep("_dumbbell", tempNames)]],method="pca", thresh = input$thresh)
                preProcArm <<- preProcess(train[,c(tempNames[grep("_arm_", tempNames)], tempNames[grep("_arm$", tempNames)])],method="pca", thresh = input$thresh)
        })

        output$viewHistClusters <- renderPlot({
                qplot(classe, 
                      data = data.frame(classe=train$classe, cluster=factor(kmeansReactive()$cluster)), 
                      fill = cluster, binwidth = 2, main = paste0("Classes by cluster for ", input$sensor," Sensor"))
        })
        
        output$viewHeatmapClusters <- renderPlot({
                data <- kmeansReactive()
                image(t(train[,currentNames])[, order(data$cluster)], yaxt = "n", main = paste0("Clustered Data for ", input$sensor," Sensor"))
        })
        
        output$armPCAoutput <- renderText({
                pcaReactive()
                paste0(preProcArm$numComp, " components of 12 original dimensions.")
                })
        output$forearmPCAoutput <- renderText({
                pcaReactive()
                paste0(preProcForearm$numComp, " components of 12 original dimensions.")
                })
        output$dumbbellPCAoutput <- renderText({
                pcaReactive()
                paste0(preProcDumbbell$numComp, " components of 12 original dimensions.")
                })
        output$beltPCAoutput <- renderText({
                pcaReactive()
                paste0(preProcBelt$numComp, " components of 12 original dimensions.")
                })
})


