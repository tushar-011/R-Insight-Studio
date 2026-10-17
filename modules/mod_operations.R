operationsUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Data Operations",
    
    fluidPage(
      
      h2("Data Operations"),
      
      # ==================================
      # FILTER ROWS
      # ==================================
      
      h3("Filter Rows"),
      
      selectInput(
        ns("filter_column"),
        "Select Column",
        choices = NULL
      ),
      
      selectInput(
        ns("filter_operator"),
        "Condition",
        choices = c(
          "Equal to" = "==",
          "Not equal to" = "!=",
          "Greater than" = ">",
          "Less than" = "<",
          "Greater than or equal to" = ">=",
          "Less than or equal to" = "<="
        )
      ),
      
      textInput(
        ns("filter_value"),
        "Value"
      ),
      
      actionButton(
        ns("filter_button"),
        "Apply Filter"
      ),
      
      hr(),
      
      
      # ==================================
      # ADD COLUMN
      # ==================================
      
      h3("Add New Column"),
      
      textInput(
        ns("new_column_name"),
        "New Column Name"
      ),
      
      textInput(
        ns("new_column_value"),
        "Default Value"
      ),
      
      actionButton(
        ns("add_column_button"),
        "Add Column"
      ),
      
      hr(),
      
      
      # ==================================
      # DELETE COLUMN
      # ==================================
      
      h3("Delete Column"),
      
      selectInput(
        ns("delete_column"),
        "Select Column",
        choices = NULL
      ),
      
      actionButton(
        ns("delete_button"),
        "Delete Column"
      ),
      
      hr(),
      
      
      # ==================================
      # RENAME COLUMN
      # ==================================
      
      h3("Rename Column"),
      
      selectInput(
        ns("rename_column"),
        "Select Column",
        choices = NULL
      ),
      
      textInput(
        ns("new_name"),
        "New Column Name"
      ),
      
      actionButton(
        ns("rename_button"),
        "Rename Column"
      ),
      
      hr(),
      
      
      # ==================================
      # CHANGE DATA TYPE
      # ==================================
      
      h3("Change Data Type"),
      
      selectInput(
        ns("type_column"),
        "Select Column",
        choices = NULL
      ),
      
      selectInput(
        ns("new_type"),
        "Convert To",
        choices = c(
          "Numeric",
          "Character",
          "Factor"
        )
      ),
      
      actionButton(
        ns("type_button"),
        "Change Data Type"
      ),
      
      hr(),
      
      
      # ==================================
      # SORT DATA
      # ==================================
      
      h3("Sort Dataset"),
      
      selectInput(
        ns("sort_column"),
        "Select Column",
        choices = NULL
      ),
      
      selectInput(
        ns("sort_order"),
        "Sort Order",
        choices = c(
          "Ascending",
          "Descending"
        )
      ),
      
      actionButton(
        ns("sort_button"),
        "Sort Dataset"
      ),
      
      hr(),
      
      h3("Current Dataset"),
      
      DTOutput(
        ns("table")
      )
    )
  )
}


operationsServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    # ==================================
    # UPDATE COLUMN LISTS
    # ==================================
    
    observe({
      
      req(current_data())
      
      columns <- names(
        current_data()
      )
      
      updateSelectInput(
        session,
        "filter_column",
        choices = columns
      )
      
      updateSelectInput(
        session,
        "delete_column",
        choices = columns
      )
      
      updateSelectInput(
        session,
        "rename_column",
        choices = columns
      )
      
      updateSelectInput(
        session,
        "type_column",
        choices = columns
      )
      
      updateSelectInput(
        session,
        "sort_column",
        choices = columns
      )
      
    })
    
    
    # ==================================
    # FILTER ROWS
    # ==================================
    
    observeEvent(input$filter_button, {
      
      req(current_data())
      req(input$filter_column)
      req(input$filter_value)
      
      data <- current_data()
      
      column <- input$filter_column
      
      value <- input$filter_value
      
      
      # Convert value to number
      # when selected column is numeric
      if (is.numeric(data[[column]])) {
        
        value <- as.numeric(value)
        
        if (is.na(value)) {
          
          showNotification(
            "Please enter a numeric value.",
            type = "error"
          )
          
          return()
        }
      }
      
      
      # Apply selected condition
      
      if (input$filter_operator == "==") {
        
        data <- data[
          data[[column]] == value,
        ]
        
      } else if (input$filter_operator == "!=") {
        
        data <- data[
          data[[column]] != value,
        ]
        
      } else if (input$filter_operator == ">") {
        
        data <- data[
          data[[column]] > value,
        ]
        
      } else if (input$filter_operator == "<") {
        
        data <- data[
          data[[column]] < value,
        ]
        
      } else if (input$filter_operator == ">=") {
        
        data <- data[
          data[[column]] >= value,
        ]
        
      } else if (input$filter_operator == "<=") {
        
        data <- data[
          data[[column]] <= value,
        ]
      }
      
      
      current_data(data)
      
      
      showNotification(
        paste(
          nrow(data),
          "rows remain after filtering."
        )
      )
      
    })
    
    
    # ==================================
    # ADD COLUMN
    # ==================================
    
    observeEvent(input$add_column_button, {
      
      req(current_data())
      req(input$new_column_name)
      
      data <- current_data()
      
      new_name <- input$new_column_name
      
      
      if (new_name %in% names(data)) {
        
        showNotification(
          "A column with this name already exists.",
          type = "error"
        )
        
        return()
      }
      
      
      data[[new_name]] <-
        input$new_column_value
      
      
      current_data(data)
      
      
      showNotification(
        "New column added."
      )
      
    })
    
    
    # ==================================
    # DELETE COLUMN
    # ==================================
    
    observeEvent(input$delete_button, {
      
      req(current_data())
      req(input$delete_column)
      
      data <- current_data()
      
      
      # Prevent deleting last column
      if (ncol(data) == 1) {
        
        showNotification(
          "The last column cannot be deleted.",
          type = "error"
        )
        
        return()
      }
      
      
      data[[input$delete_column]] <- NULL
      
      
      current_data(data)
      
      
      showNotification(
        "Column deleted."
      )
      
    })
    
    
    # ==================================
    # RENAME COLUMN
    # ==================================
    
    observeEvent(input$rename_button, {
      
      req(current_data())
      req(input$rename_column)
      req(input$new_name)
      
      data <- current_data()
      
      
      if (
        input$new_name %in% names(data)
      ) {
        
        showNotification(
          "That column name already exists.",
          type = "error"
        )
        
        return()
      }
      
      
      names(data)[
        names(data) ==
          input$rename_column
      ] <- input$new_name
      
      
      current_data(data)
      
      
      showNotification(
        "Column renamed."
      )
      
    })
    
    
    # ==================================
    # CHANGE DATA TYPE
    # ==================================
    
    observeEvent(input$type_button, {
      
      req(current_data())
      req(input$type_column)
      
      data <- current_data()
      
      column <- input$type_column
      
      
      if (input$new_type == "Numeric") {
        
        data[[column]] <-
          as.numeric(
            data[[column]]
          )
        
      } else if (
        input$new_type == "Character"
      ) {
        
        data[[column]] <-
          as.character(
            data[[column]]
          )
        
      } else if (
        input$new_type == "Factor"
      ) {
        
        data[[column]] <-
          as.factor(
            data[[column]]
          )
      }
      
      
      current_data(data)
      
      
      showNotification(
        paste(
          column,
          "converted to",
          input$new_type
        )
      )
      
    })
    
    
    # ==================================
    # SORT DATASET
    # ==================================
    
    observeEvent(input$sort_button, {
      
      req(current_data())
      req(input$sort_column)
      
      data <- current_data()
      
      column <- input$sort_column
      
      
      if (
        input$sort_order ==
        "Ascending"
      ) {
        
        data <- data[
          order(
            data[[column]]
          ),
        ]
        
      } else {
        
        data <- data[
          order(
            data[[column]],
            decreasing = TRUE
          ),
        ]
      }
      
      
      current_data(data)
      
      
      showNotification(
        "Dataset sorted."
      )
      
    })
    
    
    # ==================================
    # DATASET TABLE
    # ==================================
    
    output$table <- renderDT({
      
      req(current_data())
      
      datatable(
        current_data(),
        
        options = list(
          pageLength = 10,
          scrollX = TRUE
        )
      )
      
    })
    
  })
}