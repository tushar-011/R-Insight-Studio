regressionUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Regression",
    
    fluidPage(
      
      h2("Linear Regression"),
      
      fluidRow(
        
        column(
          4,
          
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
            "Run Regression",
            class = "btn-primary"
          )
        ),
        
        column(
          8,
          
          h3("Model Result"),
          
          textOutput(
            ns("equation")
          ),
          
          textOutput(
            ns("r_squared")
          )
        )
      ),
      
      hr(),
      
      plotOutput(
        ns("plot"),
        height = "550px"
      ),
      
      hr(),
      
      tags$details(
        
        tags$summary(
          "Show Full Regression Output"
        ),
        
        br(),
        
        verbatimTextOutput(
          ns("full_result")
        )
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
    
    
    output$equation <- renderText({
      
      req(model())
      
      coefficients <- coef(
        model()
      )
      
      paste0(
        "Equation: ",
        input$y_column,
        " = ",
        round(coefficients[1], 3),
        " + ",
        round(coefficients[2], 3),
        " × ",
        input$x_column
      )
    })
    
    
    output$r_squared <- renderText({
      
      req(model())
      
      value <- summary(
        model()
      )$r.squared
      
      paste(
        "R² =",
        round(value, 3)
      )
    })
    
    
    output$full_result <- renderPrint({
      
      req(model())
      
      summary(
        model()
      )
    })
    
    
    output$plot <- renderPlot({
      
      req(model())
      
      data <- current_data()
      
      r2 <- summary(
        model()
      )$r.squared
      
      
      ggplot(
        data,
        aes(
          x = .data[[input$x_column]],
          y = .data[[input$y_column]]
        )
      ) +
        
        geom_point(
          size = 4,
          alpha = 0.7,
          color = "#2C7FB8"
        ) +
        
        geom_smooth(
          method = "lm",
          se = TRUE,
          linewidth = 1.5,
          color = "#D95F02",
          fill = "#FDD0A2"
        ) +
        
        labs(
          
          title = "Linear Regression Model",
          
          subtitle = paste(
            input$y_column,
            "predicted using",
            input$x_column,
            "| R² =",
            round(r2, 3)
          ),
          
          x = input$x_column,
          
          y = input$y_column,
          
          caption =
            "Blue points = observations | Orange line = regression model"
        ) +
        
        theme_minimal(
          base_size = 14
        ) +
        
        theme(
          plot.title = element_text(
            face = "bold",
            size = 18
          )
        )
    })
    
  })
}