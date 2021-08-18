#' gmail_search UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_gmail_search_ui <- function(id) {
  ns <- NS(id)
  tagList(
    dataTableOutput(ns("emails"))
  )
}

#' gmail_search Server Functions
#'
#' @noRd
#' @import purrr
mod_gmail_search_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    email_ids <- reactive({
      invalidateLater(15000)
      msgs <- gmailr::gm_messages(search = "to:dev@arrow.apache.org label:unread")
      unlist(map(msgs[[1]]$messages, "id"))
    })

    output$emails <- renderDataTable({
      emails <- purrr::map(email_ids(), gmailr::gm_message)
      tibble::tibble(emails)

      subject <- tibble::tibble(subject = lapply(emails, function(email) {
        lapply(email$payload$headers, function(x) {
          if (x$name == "Subject") {
            x$value
          }
        }) %>%
          unlist()
      }) %>%
        unlist())

      subject
    })
  })
}





## To be copied in the UI
#

## To be copied in the server
#
