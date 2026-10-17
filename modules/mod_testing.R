testingUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Hypothesis Testing",
    
    fluidPage(
      
      h2("One-Sample T-Test"),
      
      fluidRow(
        
        column(
          4,
          
          selectInput(
            ns("column"),
            "Select Numeric Column",
            choices = NULL
          ),
          
          numericInput(
            ns("test_mean"),
            "Hypothesized Mean",
            value = 50
          ),
          
          numericInput(
            ns("alpha"),
            "Significance Level",
            value = 0.05,
            min = 0.01,
            max = 0.10,
            step = 0.01
          ),
          
          actionButton(
            ns("run_test"),
            "Run T-Test",
            class = "btn-primary"
          )
        ),
        
        column(
          8,
          
          h3("Result"),
          
          textOutput(
            ns("p_value")
          ),
          
          textOutput(
            ns("decision")
          ),
          
          textOutput(
            ns("mean_result")
          )
        )
      ),
      
      hr(),
      
      plotOutput(
        ns("density_plot"),
        height = "550px"
      ),
      
      hr(),
      
      tags$details(
        
        tags$summary(
          "Show Complete T-Test Output"
        ),
        
        br(),
        
        verbatimTextOutput(
          ns("full_result")
        )
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
        
        x <- x[
          !is.na(x)
        ]
        
        
        t.test(
          x,
          mu = input$test_mean
        )
      }
    )
    
    
    output$p_value <- renderText({
      
      req(test_result())
      
      paste(
        "P-Value:",
        round(
          test_result()$p.value,
          5
        )
      )
    })
    
    
    output$decision <- renderText({
      
      req(test_result())
      
      if (
        test_result()$p.value <
        input$alpha
      ) {
        
        paste(
          "Decision: Reject H0 - statistically significant at alpha =",
          input$alpha
        )
        
      } else {
        
        paste(
          "Decision: Fail to reject H0 - not statistically significant at alpha =",
          input$alpha
        )
      }
    })
    
    
    output$mean_result <- renderText({
      
      req(test_result())
      
      paste(
        "Sample Mean:",
        round(
          test_result()$estimate,
          2
        ),
        "| Hypothesized Mean:",
        input$test_mean
      )
    })
    
    
    output$full_result <- renderPrint({
      
      req(test_result())
      
      test_result()
    })
    
    
    output$density_plot <- renderPlot({
      
      req(test_result())
      
      result <- test_result()
      
      
      # Degrees of freedom
      df <- result$parameter
      
      
      # Calculated t statistic
      test_t <- as.numeric(
        result$statistic
      )
      
      
      # Critical values
      critical <- qt(
        1 - input$alpha / 2,
        df
      )
      
      
      # T distribution
      x_values <- seq(
        -4,
        4,
        length.out = 1000
      )
      
      
      plot_data <- data.frame(
        
        x = x_values,
        
        density = dt(
          x_values,
          df
        )
      )
      
      
      ggplot(
        plot_data,
        aes(
          x = x,
          y = density
        )
      ) +
        
        # Main distribution
        geom_line(
          linewidth = 1.3,
          color = "#2C7FB8"
        ) +
        
        # Left critical region
        geom_area(
          data = subset(
            plot_data,
            x <= -critical
          ),
          fill = "#D73027",
          alpha = 0.65
        ) +
        
        # Right critical region
        geom_area(
          data = subset(
            plot_data,
            x >= critical
          ),
          fill = "#D73027",
          alpha = 0.65
        ) +
        
        # Central region
        geom_area(
          data = subset(
            plot_data,
            x > -critical &
              x < critical
          ),
          fill = "#91BFDB",
          alpha = 0.35
        ) +
        
        # Critical value lines
        geom_vline(
          xintercept = c(
            -critical,
            critical
          ),
          linetype = "dashed",
          linewidth = 1,
          color = "#000000"
        ) +
        
        # Test statistic
        geom_vline(
          xintercept = test_t,
          linewidth = 1.4,
          color = "#F46D43"
        ) +
        
        annotate(
          "text",
          
          x = test_t,
          
          y = max(
            plot_data$density
          ) * 0.9,
          
          label = paste(
            "Test t =",
            round(test_t, 2)
          ),
          
          color = "#F46D43",
          
          angle = 90,
          
          vjust = -0.5
        ) +
        
        labs(
          
          title =
            "T-Test Critical Region",
          
          subtitle = paste(
            "Red = rejection region | Alpha =",
            input$alpha
          ),
          
          x = "T Statistic",
          
          y = "Probability Density",
          
          caption =
            "Orange line = calculated t statistic | Dashed lines = critical values"
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