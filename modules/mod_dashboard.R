dashboardUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Dashboard",
    
    fluidPage(
      
      h2("R-Insight Studio"),
      
      p("Upload a dataset and view basic information."),
      
      fileInput(
        ns("file"),
        "Upload Dataset",
        accept = c(".csv", ".xlsx", ".xls")
      ),
      
      fluidRow(
        
        column(
          3,
          wellPanel(
            h4("Rows"),
            textOutput(ns("rows"))
          )
        ),
        
        column(
          3,
          wellPanel(
            h4("Columns"),
            textOutput(ns("columns"))
          )
        ),
        
        column(
          3,
          wellPanel(
            h4("Missing Values"),
            textOutput(ns("missing"))
          )
        ),
        
        column(
          3,
          wellPanel(
            h4("Duplicates"),
            textOutput(ns("duplicates"))
          )
        )
      ),
      
      hr(),
      
      h3("Dataset Preview"),
      
      DTOutput(ns("table"))
    )
  )
}

dashboardServer <- function(id, current_data, original_data) {
  
  moduleServer(id, function(input, output, session) {
    
    observeEvent(input$file, {
      
      req(input$file)
      
      extension <- tools::file_ext(input$file$name)
      
      if (extension == "csv") {
        
        data <- read_csv(
          input$file$datapath,
          show_col_types = FALSE
        )
        
      } else {
        
        data <- read_excel(
          input$file$datapath
        )
      }
      
      data <- as.data.frame(data)
      
      original_data(data)
      current_data(data)
    })
    
    
    output$rows <- renderText({
      
      if (is.null(current_data())) {
        return("0")
      }
      
      nrow(current_data())
    })
    
    
    output$columns <- renderText({
      
      if (is.null(current_data())) {
        return("0")
      }
      
      ncol(current_data())
    })
    
    
    output$missing <- renderText({
      
      if (is.null(current_data())) {
        return("0")
      }
      
      sum(is.na(current_data()))
    })
    
    
    output$duplicates <- renderText({
      
      if (is.null(current_data())) {
        return("0")
      }
      
      sum(duplicated(current_data()))
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