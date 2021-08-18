#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  mod_gh_notifications_server("gh_notifications_ui_1")
  mod_jira_server("jira_ui_1")
   mod_git_shortlog_server("git_shortlog_ui_1")
  # mod_gmail_search_server("gmail_search_ui_1")
}
