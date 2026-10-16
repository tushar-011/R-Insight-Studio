regressionUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Regression",
    
    fluidPage(
      
      h2("Linear Regression"),
      
      selectInput(
        ns("x_column"),
        "Independent Variable (X)",
        choices = NULL
      ),
      
      selectInput(
        ns("y_column"),
        "Dependent Variable (Y)",
        choices = NULL
      ),
      
      actionButton(
        ns("run"),
        "Run Regression"
      ),
      
      hr(),
      
      h3("Regression Results"),
      
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

regressionServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    observe({
      
      req(current_data())
      
      data <- current_data()
      
      numeric_columns <- names(data)[
        sapply(data, is.numeric)
      ]
      
      updateSelectInput(
        session,
        "x_column",
        choices = numeric_columns
      )
      
      updateSelectInput(
        session,
        "y_column",
        choices = numeric_columns
      )
    })
    
    
    model <- eventReactive(
      input$run,
      {
        
        req(current_data())
        req(input$x_column)
        req(input$y_column)
        
        data <- current_data()
        
        formula <- as.formula(
          paste(
            input$y_column,
            "~",
            input$x_column
          )
        )
        
        lm(
          formula,
          data = data
        )
      }
    )
    
    
    output$result <- renderPrint({
      
      req(model())
      
      summary(
        model()
      )
    })
    
    
    output$plot <- renderPlot({
      
      req(model())
      
      data <- current_data()
      
      ggplot(
        data,
        aes(
          x = .data[[input$x_column]],
          y = .data[[input$y_column]]
        )
      ) +
        geom_point() +
        geom_smooth(
          method = "lm",
          se = FALSE
        ) +
        labs(
          title = "Linear Regression",
          x = input$x_column,
          y = input$y_column
        )
    })
    
  })
}