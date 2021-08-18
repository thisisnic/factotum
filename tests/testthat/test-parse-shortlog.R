test_that("parse_shortlog_row works as expected", {
  row <- "15\tNic Crane"
  expect_equal(
    parse_shortlog_row(row),
    tibble::tibble(commits = 15, name = "Nic Crane")
  )
})
