library(shiny)
library(TSstudio)
library(magrittr)
# install.packages("devtools")
# devtools::install_github("RamiKrispin/forecastML")
library(forecastML)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Forecasting with Linear Regression"),

    inputPanel(
        selectInput("select_series", label = "Select the Series:",
                    choices = c("USgas", "USVSales", "AirPassengers"), selected = "USgas",
                    width = "600px"),
        selectInput("select_plot", label = "Plot Type",
                    choices = c("Plot", "Decompose", "Seasonal", "Heatmap","Lags", "P/ACF"), selected = "Plot",
                    width = "600px")
    ),
    
    plotly::plotlyOutput("p1"),
    
    inputPanel(
        checkboxGroupInput(inputId = "features", label = "Select the Model Features",
                           choices = c("Linear Trend", "Seasonal", "Polynomial", "Seasonal Lag", "Log Transformation"), selected = "Linear Trend"),
        
        sliderInput("reg_h", "Set the Forecasting Horizon:",
                    min = 1, max = 60,
                    value = 12),
        
        sliderInput("reg_pol", "Set the Polynomial Level:",
                    min = 0, max = 3,
                    value = 2,
                    step = 0.1)
        
        
        
    ),
    
    
    plotly::plotlyOutput("p2"),
    plotly::plotlyOutput("p3")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

output$p1 <- plotly::renderPlotly({
    if(input$select_series == "USgas"){
        ts.obj <- USgas
    } else if(input$select_series == "USVSales"){
        ts.obj <- USVSales
    } else if(input$select_series == "AirPassengers"){
        ts.obj <- AirPassengers
    }
    
    
    if(input$select_plot == "Plot"){
        p <- TSstudio::ts_plot(ts.obj = ts.obj)
    } else if(input$select_plot == "Decompose"){
        p <- TSstudio::ts_decompose(ts.obj = ts.obj)
    } else if(input$select_plot == "Seasonal"){
        p <- TSstudio::ts_seasonal(ts.obj = ts.obj, type = "all")
    } else if(input$select_plot == "Lags"){
        p <- TSstudio::ts_lags(ts.obj = ts.obj)
    } else if(input$select_plot == "P/ACF"){
        p <- TSstudio::ts_cor(ts.obj = ts.obj, lag.max = 36)
    } else if(input$select_plot == "Heatmap"){
        p <- TSstudio::ts_heatmap(ts.obj = ts.obj)
    }
    return(p)
})    
    
output$p2 <-    plotly::renderPlotly({
        if(input$select_series == "USgas"){
            ts.obj <- USgas
        } else if(input$select_series == "USVSales"){
            ts.obj <- USVSales
        } else if(input$select_series == "AirPassengers"){
            ts.obj <- AirPassengers
        }
        
        
        if("Linear Trend" %in% input$features){
            l_trend <- TRUE
        } else {
            l_trend <- FALSE
        }
        
        if("Seasonal" %in% input$features){
            season <- "month"
        } else {
            season <-NULL
        }
        
        
        if("Polynomial" %in% input$features){
            pol <- input$reg_pol
        } else {
            pol <- FALSE
        }
        
        if("Seasonal Lag" %in% input$features){
            lag <- 12
        } else {
            lag <- NULL
        }
        
        
        if("Log Transformation" %in% input$features){
            scale <- "log"
        } else {
            scale <- NULL
        }
        
        md <- forecastML::trainML(input = ts.obj,
                                  trend = list(linear = l_trend, power = pol),
                                  lags = lag,
                                  seasonal = season,
                                  scale = scale)
        
        p <- forecastML::plot_res(md)
        return(p)
        
        
    })
    
output$p3 <-    plotly::renderPlotly({
        if(input$select_series == "USgas"){
            ts.obj <- USgas
        } else if(input$select_series == "USVSales"){
            ts.obj <- USVSales
        } else if(input$select_series == "AirPassengers"){
            ts.obj <- AirPassengers
        }
        
        
        if("Linear Trend" %in% input$features){
            l_trend <- TRUE
        } else {
            l_trend <- FALSE
        }
        
        if("Seasonal" %in% input$features){
            season <- "month"
        } else {
            season <-NULL
        }
        
        
        if("Polynomial" %in% input$features){
            pol <- input$reg_pol
        } else {
            pol <- FALSE
        }
        
        if("Seasonal Lag" %in% input$features){
            lag <- 12
        } else {
            lag <- NULL
        }
        
        
        if("Log Transformation" %in% input$features){
            scale <- "log"
        } else {
            scale <- NULL
        }
        
        md <- forecastML::trainML(input = ts.obj,
                                  trend = list(linear = l_trend, power = pol),
                                  lags = lag,
                                  seasonal = season,
                                  scale = scale)
        
        fc <- forecastML::forecastML(md, h = input$reg_h)
        p <- forecastML::plot_fc(fc)
        return(p)
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
