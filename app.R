library(shiny)
library(DT)
library(readr)
library(readxl)
library(ggplot2)

# Load modules
source("modules/mod_dashboard.R")
source("modules/mod_explorer.R")
source("modules/mod_cleaning.R")
source("modules/mod_operations.R")
source("modules/mod_statistics.R")
source("modules/mod_visualization.R")
source("modules/mod_correlation.R")
source("modules/mod_regression.R")
source("modules/mod_testing.R")


# -----------------------------
# UI
# -----------------------------

ui <- navbarPage(
  
  "R-Insight Studio",
  
  dashboardUI("dashboard"),
  
  explorerUI("explorer"),
  
  cleaningUI("cleaning"),
  
  operationsUI("operations"),
  
  statisticsUI("statistics"),
  
  visualizationUI("visualization"),
  
  correlationUI("correlation"),
  
  regressionUI("regression"),
  
  testingUI("testing")
)


# -----------------------------
# SERVER
# -----------------------------

server <- function(input, output, session) {
  
  # Original uploaded dataset
  original_data <- reactiveVal(NULL)
  
  # Current working dataset
  current_data <- reactiveVal(NULL)
  
  
  dashboardServer(
    "dashboard",
    current_data,
    original_data
  )
  
  
  explorerServer(
    "explorer",
    current_data
  )
  
  
  cleaningServer(
    "cleaning",
    current_data,
    original_data
  )
  
  
  operationsServer(
    "operations",
    current_data
  )
  
  
  statisticsServer(
    "statistics",
    current_data
  )
  
  
  visualizationServer(
    "visualization",
    current_data
  )
  
  
  correlationServer(
    "correlation",
    current_data
  )
  
  
  regressionServer(
    "regression",
    current_data
  )
  
  
  testingServer(
    "testing",
    current_data
  )
}


# -----------------------------
# RUN APP
# -----------------------------

shinyApp(
  ui = ui,
  server = server
)