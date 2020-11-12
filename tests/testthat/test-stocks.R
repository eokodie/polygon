test_that("stocks aggregates work", {

  check_errors <- function(token = "test",
                           ticker = "AAPL",
                           multiplier = 1,
                           timespan = "day",
                           from = "2019-01-01",
                           to = "2019-02-01",
                           unadjusted = TRUE,
                           sort = "asc") {
    polygon::get_aggregates(token, ticker, multiplier, timespan, from, to)
  }

  expect_error(check_errors(ticker = 2), "character")
  expect_error(check_errors(multiplier = "one"), "integer")
  expect_error(check_errors(multiplier = 1.5), "integer")
  expect_error(check_errors(token = 6), "character")
  expect_error(check_errors(timespan = 5), "character")
  expect_error(check_errors(from = 1), "character")
  expect_error(check_errors(to = 100), "character")
  expect_error(check_errors(), "Unknown API")
  expect_error(check_errors(timespan = "nanoseconds"), "must be one of")
})

test_that("get_exchanges works", {
  expect_error(get_exchanges(token = 6), "character")
  expect_error(get_exchanges("test"), "Unknown API")
})

test_that("get_historic_quotes works", {
  check_errors <- function(token = "tl", ticker = "SQ", date = "2020-11-02"){
    polygon::get_historic_quotes(token, ticker, date)
  }

  expect_error(check_errors(ticker = 2), "character")
  expect_error(check_errors(token = 6), "character")
  expect_error(check_errors(date = 1), "character")
  expect_error(check_errors(), "Unknown API")

})


test_that("get_previous_close works", {
  expect_error(get_previous_close(token = 6, ticker = "AAPL"),  "character")
  expect_error(get_previous_close(token = "test", ticker = "AAPL"), "Unknown API")
  expect_error(get_previous_close(token = 2, ticker = 100), "character")
})
