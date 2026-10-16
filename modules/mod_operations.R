operationsUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Data Operations",
    
    fluidPage(
      
      h2("Data Operations"),
      
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
        "Sort"
      ),
      
      hr(),
      
      DTOutput(ns("table"))
    )
  )
}

operationsServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    observe({
      
      req(current_data())
      
      columns <- names(
        current_data()
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
        "sort_column",
        choices = columns
      )
    })
    
    
    observeEvent(input$delete_button, {
      
      req(current_data())
      req(input$delete_column)
      
      data <- current_data()
      
      data[[input$delete_column]] <- NULL
      
      current_data(data)
      
      showNotification(
        "Column deleted."
      )
    })
    
    
    observeEvent(input$rename_button, {
      
      req(current_data())
      req(input$rename_column)
      req(input$new_name)
      
      data <- current_data()
      
      names(data)[
        names(data) == input$rename_column
      ] <- input$new_name
      
      current_data(data)
      
      showNotification(
        "Column renamed."
      )
    })
    
    
    observeEvent(input$sort_button, {
      
      req(current_data())
      req(input$sort_column)
      
      data <- current_data()
      
      column <- input$sort_column
      
      
      if (input$sort_order == "Ascending") {
        
        data <- data[
          order(data[[column]]),
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