test_that("get_historic_quotes works", {

  check_errors <- function(token = "tl", ticker = "SQ", date = "2020-11-02"){
    polygon::get_historic_quotes(token, ticker, date)
  }

  expect_error(check_errors(ticker = 2), "character")
  expect_error(check_errors(token = 6), "character")
  expect_error(check_errors(date = 1), "character")
  expect_error(check_errors(), "Unknown API")

})
