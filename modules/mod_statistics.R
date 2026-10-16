statisticsUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Statistics",
    
    fluidPage(
      
      h2("Descriptive Statistics"),
      
      selectInput(
        ns("column"),
        "Select Numeric Column",
        choices = NULL
      ),
      
      hr(),
      
      tableOutput(
        ns("stats_table")
      )
    )
  )
}

statisticsServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    observe({
      
      req(current_data())
      
      data <- current_data()
      
      numeric_columns <- names(data)[
        sapply(data, is.numeric)
      ]
      
      updateSelectInput(
        session,
        "column",
        choices = numeric_columns
      )
    })
    
    
    output$stats_table <- renderTable({
      
      req(current_data())
      req(input$column)
      
      x <- current_data()[[input$column]]
      
      
      data.frame(
        
        Statistic = c(
          "Mean",
          "Median",
          "Minimum",
          "Maximum",
          "Variance",
          "Standard Deviation"
        ),
        
        Value = c(
          mean(x, na.rm = TRUE),
          median(x, na.rm = TRUE),
          min(x, na.rm = TRUE),
          max(x, na.rm = TRUE),
          var(x, na.rm = TRUE),
          sd(x, na.rm = TRUE)
        )
      )
      
    })
    
  })
}