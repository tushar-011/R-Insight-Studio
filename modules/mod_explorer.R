explorerUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Data Explorer",
    
    fluidPage(
      
      h2("Data Explorer"),
      
      # -------------------------
      # DATASET SUMMARY
      # -------------------------
      
      h3("Dataset Summary"),
      
      tableOutput(
        ns("summary_table")
      ),
      
      hr(),
      
      # -------------------------
      # TECHNICAL STRUCTURE
      # -------------------------
      
      tags$details(
        
        tags$summary(
          "Show Technical Dataset Structure"
        ),
        
        br(),
        
        verbatimTextOutput(
          ns("structure")
        )
      )
    )
  )
}


explorerServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    # Simple summary table
    output$summary_table <- renderTable({
      
      req(current_data())
      
      data <- current_data()
      
      data.frame(
        
        Information = c(
          "Total Rows",
          "Total Columns",
          "Numeric Columns",
          "Text Columns",
          "Missing Values",
          "Duplicate Rows"
        ),
        
        Value = c(
          nrow(data),
          
          ncol(data),
          
          sum(
            sapply(data, is.numeric)
          ),
          
          sum(
            sapply(data, function(x) {
              is.character(x) || is.factor(x)
            })
          ),
          
          sum(
            is.na(data)
          ),
          
          sum(
            duplicated(data)
          )
        )
      )
      
    })
    
    
    # Technical structure
    output$structure <- renderPrint({
      
      req(current_data())
      
      str(
        current_data()
      )
      
    })
    
  })
}

