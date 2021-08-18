#' jira UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_jira_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tableOutput(ns("jira_tix"))
  )
}

#' jira Server Functions
#'
#' @noRd
mod_jira_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    issue_tibble <- reactive({
      invalidateLater(60000)
      jiras <- httr::GET("https://issues.apache.org/jira/rest/api/2/search?jql=project%20=%20ARROW%20AND%20resolution%20=%20Unresolved%20AND%20summary%20~%20%22\\\\[R\\\\]%22%20ORDER%20BY%20created%20DESC,%20priority%20DESC,%20updated%20DESC")

      issues <- httr::content(jiras)$issues
      issue_list <- purrr::map(issues, get_relevant_jira_content)
      dplyr::bind_rows(issue_list) %>%
        slice(1:10)
    })

    output$jira_tix <- renderTable({
      issue_tibble()
    })
  })
}

get_relevant_jira_content <- function(issue) {
  tibble::tibble_row(
    name = value_or_na(issue$key),
    summary = value_or_na(issue$fields$summary),
    description = value_or_na(issue$fields$description),
    reporter = value_or_na(issue$reporter$displayName),
    url = value_or_na(paste0("https://issues.apache.org/jira/browse/", issue$key))
  )
}

value_or_na <- function(value) {
  if (is.null(value)) {
    value <- NA
  }
  value
}

## To be copied in the UI
# mod_jira_ui("jira_ui_1")

## To be copied in the server
# mod_jira_server("jira_ui_1")
