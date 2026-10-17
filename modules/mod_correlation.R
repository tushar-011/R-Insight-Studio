correlationUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Correlation",
    
    fluidPage(
      
      h2("Correlation Analysis"),
      
      fluidRow(
        
        column(
          4,
          
          selectInput(
            ns("column1"),
            "First Numeric Column",
            choices = NULL
          ),
          
          selectInput(
            ns("column2"),
            "Second Numeric Column",
            choices = NULL
          )
        ),
        
        column(
          8,
          
          h3("Correlation Result"),
          
          h2(
            textOutput(
              ns("correlation_value")
            )
          ),
          
          textOutput(
            ns("interpretation")
          )
        )
      ),
      
      hr(),
      
      plotOutput(
        ns("plot"),
        height = "550px"
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
    
    
    correlation_result <- reactive({
      
      req(current_data())
      req(input$column1)
      req(input$column2)
      
      cor(
        current_data()[[input$column1]],
        current_data()[[input$column2]],
        use = "complete.obs"
      )
    })
    
    
    output$correlation_value <- renderText({
      
      paste(
        "r =",
        round(
          correlation_result(),
          3
        )
      )
    })
    
    
    output$interpretation <- renderText({
      
      r <- correlation_result()
      
      strength <- if (
        abs(r) >= 0.7
      ) {
        
        "Strong"
        
      } else if (
        abs(r) >= 0.4
      ) {
        
        "Moderate"
        
      } else {
        
        "Weak"
      }
      
      
      direction <- if (
        r > 0
      ) {
        
        "positive"
        
      } else if (
        r < 0
      ) {
        
        "negative"
        
      } else {
        
        "no"
      }
      
      
      paste(
        strength,
        direction,
        "correlation."
      )
    })
    
    
    output$plot <- renderPlot({
      
      req(current_data())
      
      data <- current_data()
      
      r <- correlation_result()
      
      
      ggplot(
        data,
        aes(
          x = .data[[input$column1]],
          y = .data[[input$column2]]
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
          color = "#D95F02",
          fill = "#FDD0A2",
          linewidth = 1.3
        ) +
        
        labs(
          
          title = paste(
            input$column1,
            "vs",
            input$column2
          ),
          
          subtitle = paste(
            "Pearson Correlation =",
            round(r, 3)
          ),
          
          x = input$column1,
          
          y = input$column2,
          
          caption =
            "Points represent observations. Line represents the linear trend."
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