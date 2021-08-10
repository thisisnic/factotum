#' gh_notifications UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @import shinydashboard
mod_gh_notifications_ui <- function(id){
  ns <- NS(id)
  tagList(
    valueBoxOutput(ns("github_notifications"), width = 2)
  )
}
    
#' gh_notifications Server Functions
#'
#' @import shinydashboard
#'
#' @noRd 
mod_gh_notifications_server <- function(id){
  
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    notifications <- reactive({
      invalidateLater(15000)
      notifications <- gh::gh("GET /notifications")
      length(notifications)
    })
  
    output$github_notifications <- renderValueBox({
      valueBox(
        value = notifications(),
        subtitle = "GH Notifications",
        icon = icon("github-square "),
        color = "light-blue",
        href = "https://github.com/notifications"
      )
    })
 
  })
}