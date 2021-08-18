library(shinydashboard)

#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shinydashboard
#' @noRd
app_ui <- function(request) {
  
    dashboardPage(
      dashboardHeader(title="factotum"),
      dashboardSidebar(),
      dashboardBody(
        # Leave this function for adding external resources
        golem_add_external_resources(),

        fluidRow(
          mod_gh_notifications_ui("gh_notifications_ui_1"),
          mod_git_shortlog_ui("git_shortlog_ui_1")
        ),
        fluidRow(
          # mod_jira_ui("jira_ui_1")
        )
      )
    )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www", app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "factotum"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
