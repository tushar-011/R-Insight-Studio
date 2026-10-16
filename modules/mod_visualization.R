visualizationUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Visualization",
    
    fluidPage(
      
      h2("Data Visualization"),
      
      fluidRow(
        
        column(
          4,
          
          selectInput(
            ns("chart_type"),
            "Select Chart",
            choices = c(
              "Histogram",
              "Bar Chart",
              "Box Plot",
              "Scatter Plot",
              "Line Chart",
              "Pie Chart"
            )
          ),
          
          selectInput(
            ns("x_column"),
            "Select X Column",
            choices = NULL
          ),
          
          selectInput(
            ns("y_column"),
            "Select Y Column",
            choices = NULL
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


visualizationServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    # ---------------------------------
    # UPDATE COLUMN LIST
    # ---------------------------------
    
    observe({
      
      req(current_data())
      
      columns <- names(current_data())
      
      updateSelectInput(
        session,
        "x_column",
        choices = columns
      )
      
      updateSelectInput(
        session,
        "y_column",
        choices = columns
      )
    })
    
    
    # ---------------------------------
    # CREATE GRAPH
    # ---------------------------------
    
    output$plot <- renderPlot({
      
      req(current_data())
      req(input$x_column)
      
      data <- current_data()
      
      x <- input$x_column
      y <- input$y_column
      
      
      # =================================
      # HISTOGRAM
      # =================================
      
      if (input$chart_type == "Histogram") {
        
        validate(
          need(
            is.numeric(data[[x]]),
            "Histogram requires a numeric column."
          )
        )
        
        ggplot(
          data,
          aes(x = .data[[x]])
        ) +
          
          geom_histogram(
            bins = 10,
            fill = "steelblue",
            color = "white"
          ) +
          
          geom_text(
            stat = "bin",
            bins = 10,
            aes(
              label = after_stat(count)
            ),
            vjust = -0.5
          ) +
          
          labs(
            title = paste(
              "Distribution of",
              x
            ),
            
            subtitle = "Frequency distribution of selected values",
            
            x = x,
            
            y = "Frequency"
          ) +
          
          theme_minimal()
      }
      
      
      # =================================
      # BAR CHART
      # =================================
      
      else if (input$chart_type == "Bar Chart") {
        
        ggplot(
          data,
          aes(x = .data[[x]])
        ) +
          
          geom_bar(
            fill = "steelblue"
          ) +
          
          geom_text(
            stat = "count",
            
            aes(
              label = after_stat(count)
            ),
            
            vjust = -0.4
          ) +
          
          labs(
            title = paste(
              "Count by",
              x
            ),
            
            subtitle = "Number of records in each category",
            
            x = x,
            
            y = "Number of Records"
          ) +
          
          theme_minimal() +
          
          theme(
            axis.text.x = element_text(
              angle = 45,
              hjust = 1
            )
          )
      }
      
      
      # =================================
      # BOX PLOT
      # =================================
      
      else if (input$chart_type == "Box Plot") {
        
        validate(
          need(
            is.numeric(data[[x]]),
            "Box Plot requires a numeric column."
          )
        )
        
        ggplot(
          data,
          aes(
            y = .data[[x]]
          )
        ) +
          
          geom_boxplot(
            fill = "skyblue"
          ) +
          
          geom_jitter(
            width = 0.1,
            alpha = 0.4
          ) +
          
          labs(
            title = paste(
              "Box Plot of",
              x
            ),
            
            subtitle =
              "Shows median, spread and possible outliers",
            
            x = "",
            
            y = x
          ) +
          
          theme_minimal()
      }
      
      
      # =================================
      # SCATTER PLOT
      # =================================
      
      else if (input$chart_type == "Scatter Plot") {
        
        req(y)
        
        validate(
          
          need(
            is.numeric(data[[x]]),
            "X column must be numeric."
          ),
          
          need(
            is.numeric(data[[y]]),
            "Y column must be numeric."
          )
        )
        
        ggplot(
          data,
          aes(
            x = .data[[x]],
            y = .data[[y]]
          )
        ) +
          
          geom_point(
            size = 3,
            alpha = 0.7
          ) +
          
          geom_smooth(
            method = "lm",
            se = FALSE
          ) +
          
          labs(
            title = paste(
              x,
              "vs",
              y
            ),
            
            subtitle =
              "Each point represents one record",
            
            x = x,
            
            y = y
          ) +
          
          theme_minimal()
      }
      
      
      # =================================
      # LINE CHART
      # =================================
      
      else if (input$chart_type == "Line Chart") {
        
        req(y)
        
        validate(
          
          need(
            is.numeric(data[[y]]),
            "Y column must be numeric."
          )
        )
        
        
        # Average Y for each X value
        line_data <- aggregate(
          data[[y]],
          
          by = list(
            X = data[[x]]
          ),
          
          FUN = mean,
          na.rm = TRUE
        )
        
        
        names(line_data) <- c(
          "X",
          "Y"
        )
        
        
        line_data <- line_data[
          order(line_data$X),
        ]
        
        
        ggplot(
          line_data,
          aes(
            x = X,
            y = Y,
            group = 1
          )
        ) +
          
          geom_line(
            linewidth = 1.2,
            color = "steelblue"
          ) +
          
          geom_point(
            size = 3
          ) +
          
          geom_text(
            aes(
              label = round(Y, 1)
            ),
            
            vjust = -0.7
          ) +
          
          labs(
            title = paste(
              y,
              "by",
              x
            ),
            
            subtitle =
              "Line shows average values",
            
            x = x,
            
            y = paste(
              "Average",
              y
            )
          ) +
          
          theme_minimal()
      }
      
      
      # =================================
      # PIE CHART
      # =================================
      
      else if (input$chart_type == "Pie Chart") {
        
        pie_table <- table(
          data[[x]],
          useNA = "ifany"
        )
        
        
        pie_data <- data.frame(
          
          Category = names(
            pie_table
          ),
          
          Count = as.numeric(
            pie_table
          )
        )
        
        
        pie_data$Percentage <- round(
          pie_data$Count /
            sum(pie_data$Count) *
            100,
          1
        )
        
        
        pie_data$Label <- paste0(
          pie_data$Percentage,
          "%"
        )
        
        
        ggplot(
          pie_data,
          
          aes(
            x = "",
            y = Count,
            fill = Category
          )
        ) +
          
          geom_col(
            width = 1,
            color = "white"
          ) +
          
          coord_polar(
            theta = "y"
          ) +
          
          geom_text(
            
            aes(
              label = Label
            ),
            
            position = position_stack(
              vjust = 0.5
            )
          ) +
          
          labs(
            title = paste(
              "Distribution of",
              x
            ),
            
            subtitle =
              "Percentage share of each category",
            
            fill = x
          ) +
          
          theme_void()
      }
      
    })
    
  })
}