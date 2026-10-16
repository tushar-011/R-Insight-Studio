correlationUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Correlation",
    
    fluidPage(
      
      h2("Correlation Analysis"),
      
      selectInput(
        ns("column1"),
        "First Numeric Column",
        choices = NULL
      ),
      
      selectInput(
        ns("column2"),
        "Second Numeric Column",
        choices = NULL
      ),
      
      hr(),
      
      h3("Correlation Result"),
      
      verbatimTextOutput(
        ns("result")
      ),
      
      plotOutput(
        ns("plot"),
        height = "450px"
      )
    )
  )
}

correlationServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    observe({
      
      req(current_data())
      
      data <- current_data()
      
      numeric_columns <- names(data)[
        sapply(data, is.numeric)
      ]
      
      updateSelectInput(
        session,
        "column1",
        choices = numeric_columns
      )
      
      updateSelectInput(
        session,
        "column2",
        choices = numeric_columns
      )
    })
    
    
    output$result <- renderPrint({
      
      req(current_data())
      req(input$column1)
      req(input$column2)
      
      x <- current_data()[[input$column1]]
      
      y <- current_data()[[input$column2]]
      
      result <- cor(
        x,
        y,
        use = "complete.obs"
      )
      
      cat(
        "Correlation:",
        round(result, 3)
      )
    })
    
    
    output$plot <- renderPlot({
      
      req(current_data())
      req(input$column1)
      req(input$column2)
      
      data <- current_data()
      
      ggplot(
        data,
        aes(
          x = .data[[input$column1]],
          y = .data[[input$column2]]
        )
      ) +
        geom_point() +
        geom_smooth(
          method = "lm",
          se = FALSE
        ) +
        labs(
          title = "Correlation Plot",
          x = input$column1,
          y = input$column2
        )
    })
    
  })
}