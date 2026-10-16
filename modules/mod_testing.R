testingUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Hypothesis Testing",
    
    fluidPage(
      
      h2("Hypothesis Testing"),
      
      h3("One-Sample T-Test"),
      
      selectInput(
        ns("column"),
        "Select Numeric Column",
        choices = NULL
      ),
      
      numericInput(
        ns("test_mean"),
        "Test Mean",
        value = 50
      ),
      
      actionButton(
        ns("run_test"),
        "Run T-Test"
      ),
      
      hr(),
      
      h3("Test Result"),
      
      verbatimTextOutput(
        ns("result")
      )
    )
  )
}

testingServer <- function(id, current_data) {
  
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
    
    
    test_result <- eventReactive(
      input$run_test,
      {
        
        req(current_data())
        req(input$column)
        
        x <- current_data()[[
          input$column
        ]]
        
        t.test(
          x,
          mu = input$test_mean
        )
      }
    )
    
    
    output$result <- renderPrint({
      
      req(test_result())
      
      test_result()
    })
    
  })
}