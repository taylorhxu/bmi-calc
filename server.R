library(shiny)
library(ggplot2)
library(maps)
library(mapproj)

calculateBMI <- function(feet, inch, weight) {
    if (weight == 0 || (feet == 0 && inch ==0)) {
        return(0)
    }
    
    height <- inch
    if (!is.na(feet) & feet > 0) {
        height <- feet * 12 + inch
    }
    round((weight * 703) / (height^2), 1)
}

getWeightStatus <- function(x) {
    if (x <= 0) {
        "NA"
    } else if (x < 18.5) {
        "underweight"
    } else if (x <= 24.9) {
        "normal weight"
    } else if (x <= 29.9) {
        "overweight"
    } else {
        "obese"
    }               
}

data <- read.csv("bmidata.csv")
prevRange <- function(x) {
    if (x[1] < 20) {       
        "<20%"        
    } else if (x[1] < 25) {
        "20%-<25%"
    } else if (x[1] < 30) {
        "25%-<30%"
    } else if (x[1] < 35) {
        "30%-<35%"
    } else {
        ">=35%"
    }
}

PrevalenceRange <- apply(data, 1, 
                    function(x) {                     
                        if (x[2] < 20) {       
                            "<20%"        
                        } else if (x[2] < 25) {
                            "20%-<25%"
                        } else if (x[2] < 30) {
                            "25%-<30%"
                        } else if (x[2] < 35) {
                            "30%-<35%"
                        } else {
                            ">=35%"
                        }
                    })

df <- data.frame(state = tolower(data$State), prevalence = data$Prevalence, PrevalenceRange)
us_map <- map_data("state")


shinyServer(
    function(input, output) {
        bmi <- reactive({calculateBMI(input$feetFld, input$inchFld, input$weightFld)})
        output$oweight <- renderPrint({input$weightFld})
        output$ofeet <- renderPrint({input$feetFld})
        output$oinch <- renderPrint({input$inchFld})              
        output$obmi <- renderPrint({bmi()})
        output$ostatus <- renderPrint({getWeightStatus(bmi())})
        
        output$prevMap <- renderPlot({
            g <- ggplot(df, aes(map_id = state)) + labs(title="Obesity Prevalence Among U.S. Adults by State", x = "Longitude", y="Latitude")
            g <- g + geom_map(aes(fill = PrevalenceRange), map = us_map) + expand_limits(x = us_map$long, y = us_map$lat) 
            last_plot() + coord_map()
        })
        
        output$ohead <- renderPrint({head(data, 10)})
        output$osummary <- renderPrint({summary(data$Prevalence)})
        output$prevHist <- renderPlot({hist(data$Prevalence, breaks=15, main="Histogram of US Obesity Prevalence in 2013", xlab="Obsetiy Prevalence", xlim=c(20, 36))})
        
    }
)