exportUI <- function(id) {
  
  ns <- NS(id)
  
  tabPanel(
    "Export",
    
    fluidPage(
      
      h2("Export Dataset"),
      
      p(
        "Download the current cleaned and modified dataset as a CSV file."
      ),
      
      downloadButton(
        ns("download_csv"),
        "Download CSV"
      )
    )
  )
}


exportServer <- function(id, current_data) {
  
  moduleServer(id, function(input, output, session) {
    
    output$download_csv <- downloadHandler(
      
      filename = function() {
        
        paste0(
          "R-Insight-Cleaned-Data-",
          Sys.Date(),
          ".csv"
        )
      },
      
      content = function(file) {
        
        req(current_data())
        
        write.csv(
          current_data(),
          file,
          row.names = FALSE
        )
      }
    )
    
  })
}