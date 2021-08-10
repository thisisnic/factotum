#' gha_diff UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_gha_diff_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' gha_diff Server Functions
#'
#' @noRd 
mod_gha_diff_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_gha_diff_ui("gha_diff_ui_1")
    
## To be copied in the server
# mod_gha_diff_server("gha_diff_ui_1")
