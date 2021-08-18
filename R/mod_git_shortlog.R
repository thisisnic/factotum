library(stringr)
library(tibble)
library(purrr)
library(dplyr)
library(tidyr)
library(ggplot2)

#' git_shortlog UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_git_shortlog_ui <- function(id){
  ns <- NS(id)
  tagList(
   
      valueBoxOutput(ns("shortlog_total")),
      plotOutput(ns("shortlog_bar"))
        
    

  )
}
    
#' git_shortlog Server Functions
#'
#' @noRd 
mod_git_shortlog_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    shortlog_data <- reactive({
      # refresh every hour
      invalidateLater(3600000)
      shortlog <- system("cd ../arrow; git shortlog -sne apache-arrow-5.0.0..HEAD", intern = TRUE)

      parse_shortlog_row <- function(row){
        components <- stringr::str_split(stringr::str_trim(row), "\t")[[1]]
        tibble::tibble(commits = as.double(components[1]), name = components[2])
      }
  
      shortlog %>%
        map(parse_shortlog_row) %>%
        bind_rows() %>%
        separate(name, into = c("name", "email"), sep = "<") %>%
        mutate(
          email = str_remove(email, ">$"),
          name = str_trim(name)
        ) %>%
        group_by(email) %>%
        summarise(commits = sum(commits)) %>%
        arrange(desc(commits)) %>%
        mutate(highlight = ifelse(email == "thisisnic@gmail.com", TRUE, FALSE))
    
    })
    
    
    output$shortlog_bar <- renderPlot({
      ggplot(data = slice(shortlog_data(), 1:10), aes(x = reorder(email, commits), y = commits, fill = highlight)) +
        geom_col() +
        coord_flip() + 
        xlab("name") +
        scale_fill_manual(values = c("TRUE"="tomato", "FALSE"="gray"), guide = "none") + 
        theme_minimal()
    })
    
    output$shortlog_total <- renderValueBox({
      total <- filter(shortlog_data(), email == "thisisnic@gmail.com") %>%
        select(commits) %>%
        pull()
      
      valueBox(
        value = total,
        "PRs since last release",
        icon = icon("code-branch"),
        color = "maroon",
        width = 2
      )
    })
    
  })
}
    
## To be copied in the UI
# mod_git_shortlog_ui("git_shortlog_ui_1")
    
## To be copied in the server
# mod_git_shortlog_server("git_shortlog_ui_1")
