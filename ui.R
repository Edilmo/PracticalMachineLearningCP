shinyUI(fluidPage(
        titlePanel("Practical Machine Learning Project - A Simple Analysis Tool"),
        fluidRow(
                column(12,
                       h1("Introduction"),
                       p("The porpuse of this simple application is to assit in the exploratory data analysis process required to accomplish the project of the Practical Machine Learning Course of the Data Science Specialization of Coursera."),
                       p("The project is based in the data of [the following study](http://groupware.les.inf.puc-rio.br/har)."),
                       h1("Data Description"),
                       p("Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E)."),
                       p("Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes."),
                       h1('Hypothesis'),
                       p("Given:"),
                       p("- Fact 1 - Each sensor is independent: this means that every sensor is not connected to the other and it is positioned in a way that is only capturing information about the downbell or just one of the body parts important for the study."),
                       p("- Fact 2 - Each output category points to specific and independent movements: this means that the movement asociated with one category it is not present in the movement of the others."),
                       p("Our hypothesis is: the presence of one movement can be detected with a specific subset of measures in a specific subset of sensors.")
                )
        ),
        sidebarLayout(
                sidebarPanel(
                        h1('Cluster Analysis by Sensor'),
                        p("Use this section to perform a cluster analysis using k-means."),
                        selectInput("sensor", "Select Sensor to Analyze:", 
                                    choices = c("Arm", "Forearm", "Dumbbell", "Belt"),
                                    selected = "Belt"),
                        sliderInput("clusters", "Select the Number of Clusters:", 
                                    min = 2, max = 20, step = 1, value = 5),
                        h1('Dimensionality Analysis by Sensor'),
                        p("Use this section to perform a dimensionality analysis using PCA."),
                        sliderInput("thresh", "Cumulative percent of variance to be retained:", 
                                    min = 0.10, max = 0.95, step = 0.05, value = 0.80),
                        h2("Amount of PCA components retained for the Tresh selected:"),
                        h3("Arm Sensor Components:"),
                        verbatimTextOutput("armPCAoutput"),
                        h3("Forearm Sensor Components:"),
                        verbatimTextOutput("forearmPCAoutput"),
                        h3("Dumbbell Sensor Components:"),
                        verbatimTextOutput("dumbbellPCAoutput"),
                        h3("Belt Sensor Components:"),
                        verbatimTextOutput("beltPCAoutput")
                ),
                mainPanel(
                        plotOutput("viewHistClusters"),
                        plotOutput("viewHeatmapClusters")
                )
        )
))