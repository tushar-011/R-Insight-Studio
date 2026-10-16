cleaningUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Data Cleaning",
    
    fluidPage(
      
      h2("Data Cleaning"),
      
      # =================================
      # INSPECT DATA
      # =================================
      
      h3("Inspect Data Problems"),
      
      actionButton(
        ns("show_missing"),
        "Show Missing Rows"
      ),
      
      actionButton(
        ns("show_duplicates"),
        "Show Duplicates"
      ),
      
      actionButton(
        ns("show_all"),
        "Show All Data"
      ),
      
      br(), br(),
      
      textOutput(
        ns("view_message")
      ),
      
      DTOutput(
        ns("problem_table")
      ),
      
      hr(),
      
      # =================================
      # MISSING VALUES
      # =================================
      
      h3("Handle Missing Values"),
      
      selectInput(
        ns("column"),
        "Select Column",
        choices = NULL
      ),
      
      selectInput(
        ns("method"),
        "Replace Missing Values With",
        choices = c(
          "Mean",
          "Median",
          "Mode"
        )
      ),
      
      actionButton(
        ns("replace"),
        "Replace Missing Values"
      ),
      
      br(), br(),
      
      actionButton(
        ns("remove_missing"),
        "Remove Rows With Missing Values"
      ),
      
      hr(),
      
      # =================================
      # DUPLICATES
      # =================================
      
      h3("Duplicate Records"),
      
      actionButton(
        ns("remove_duplicates"),
        "Remove Duplicates"
      ),
      
      hr(),
      
      # =================================
      # RESET
      # =================================
      
      h3("Reset"),
      
      actionButton(
        ns("reset"),
        "Reset Dataset"
      )
    )
  )
}



cleaningServer <- function(
    id,
    current_data,
    original_data
) {
  
  moduleServer(
    id,
    function(input, output, session) {
      
      # Stores what type of data
      # should currently be shown
      view_type <- reactiveVal("all")
      
      
      # =================================
      # UPDATE COLUMN LIST
      # =================================
      
      observe({
        
        req(current_data())
        
        updateSelectInput(
          session,
          "column",
          choices = names(
            current_data()
          )
        )
        
      })
      
      
      # =================================
      # MODE FUNCTION
      # =================================
      
      mode_value <- function(x) {
        
        x <- x[
          !is.na(x)
        ]
        
        values <- unique(x)
        
        values[
          which.max(
            tabulate(
              match(x, values)
            )
          )
        ]
      }
      
      
      # =================================
      # VIEW BUTTONS
      # =================================
      
      observeEvent(
        input$show_missing,
        {
          
          view_type("missing")
          
        }
      )
      
      
      observeEvent(
        input$show_duplicates,
        {
          
          view_type("duplicates")
          
        }
      )
      
      
      observeEvent(
        input$show_all,
        {
          
          view_type("all")
          
        }
      )
      
      
      # =================================
      # TABLE TO DISPLAY
      # =================================
      
      displayed_data <- reactive({
        
        req(current_data())
        
        data <- current_data()
        
        
        # Show rows containing NA
        if (
          view_type() == "missing"
        ) {
          
          rows <- apply(
            is.na(data),
            1,
            any
          )
          
          return(
            data[rows, ]
          )
        }
        
        
        # Show duplicate rows
        if (
          view_type() == "duplicates"
        ) {
          
          rows <- duplicated(data) |
            duplicated(
              data,
              fromLast = TRUE
            )
          
          return(
            data[rows, ]
          )
        }
        
        
        # Otherwise show everything
        data
        
      })
      
      
      output$problem_table <- renderDT({
        
        req(displayed_data())
        
        datatable(
          displayed_data(),
          
          options = list(
            pageLength = 10,
            scrollX = TRUE
          )
        )
        
      })
      
      
      # =================================
      # TABLE MESSAGE
      # =================================
      
      output$view_message <- renderText({
        
        req(current_data())
        
        if (
          view_type() == "missing"
        ) {
          
          count <- sum(
            apply(
              is.na(current_data()),
              1,
              any
            )
          )
          
          return(
            paste(
              count,
              "rows contain missing values."
            )
          )
        }
        
        
        if (
          view_type() == "duplicates"
        ) {
          
          rows <- duplicated(
            current_data()
          ) |
            duplicated(
              current_data(),
              fromLast = TRUE
            )
          
          return(
            paste(
              sum(rows),
              "duplicate-related rows found."
            )
          )
        }
        
        
        paste(
          nrow(current_data()),
          "total rows."
        )
        
      })
      
      
      # =================================
      # REPLACE MISSING VALUES
      # =================================
      
      observeEvent(
        input$replace,
        {
          
          req(current_data())
          req(input$column)
          
          data <- current_data()
          
          column <- input$column
          
          
          # No missing values
          if (
            sum(
              is.na(
                data[[column]]
              )
            ) == 0
          ) {
            
            showNotification(
              "Selected column has no missing values.",
              type = "warning"
            )
            
            return()
          }
          
          
          # Mean
          if (
            input$method == "Mean"
          ) {
            
            if (
              !is.numeric(
                data[[column]]
              )
            ) {
              
              showNotification(
                "Mean works only with numeric columns.",
                type = "error"
              )
              
              return()
            }
            
            value <- mean(
              data[[column]],
              na.rm = TRUE
            )
          }
          
          
          # Median
          if (
            input$method == "Median"
          ) {
            
            if (
              !is.numeric(
                data[[column]]
              )
            ) {
              
              showNotification(
                "Median works only with numeric columns.",
                type = "error"
              )
              
              return()
            }
            
            value <- median(
              data[[column]],
              na.rm = TRUE
            )
          }
          
          
          # Mode
          if (
            input$method == "Mode"
          ) {
            
            value <- mode_value(
              data[[column]]
            )
          }
          
          
          data[[column]][
            is.na(
              data[[column]]
            )
          ] <- value
          
          
          current_data(data)
          
          
          showNotification(
            "Missing values replaced."
          )
          
        }
      )
      
      
      # =================================
      # REMOVE MISSING ROWS
      # =================================
      
      observeEvent(
        input$remove_missing,
        {
          
          req(current_data())
          
          data <- current_data()
          
          old_rows <- nrow(data)
          
          data <- na.omit(data)
          
          removed <- old_rows -
            nrow(data)
          
          current_data(data)
          
          
          showNotification(
            paste(
              removed,
              "rows removed."
            )
          )
          
        }
      )
      
      
      # =================================
      # REMOVE DUPLICATES
      # =================================
      
      observeEvent(
        input$remove_duplicates,
        {
          
          req(current_data())
          
          data <- current_data()
          
          old_rows <- nrow(data)
          
          data <- data[
            !duplicated(data),
          ]
          
          removed <- old_rows -
            nrow(data)
          
          current_data(data)
          
          
          showNotification(
            paste(
              removed,
              "duplicate rows removed."
            )
          )
          
        }
      )
      
      
      # =================================
      # RESET DATASET
      # =================================
      
      observeEvent(
        input$reset,
        {
          
          req(original_data())
          
          current_data(
            original_data()
          )
          
          view_type("all")
          
          
          showNotification(
            "Dataset reset."
          )
          
        }
      )
      
    }
  )
}