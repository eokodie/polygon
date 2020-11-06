test_that("stocks aggregates work", {

  check_errors <- function(token = "test",
                           ticker = "AAPL",
                           multiplier = 1,
                           timespan = "day",
                           from = "2019-01-01",
                           to = "2019-02-01") {
    polygon::get_aggregates(token, ticker, multiplier, timespan, from, to)
  }

  expect_error(check_errors(ticker = 2), "character")
  expect_error(check_errors(multiplier = 1.5), "integer")
  expect_error(check_errors(token = 6), "character")
  expect_error(check_errors(timespan = 5), "character")
  expect_error(check_errors(from = 1), "character")
  expect_error(check_errors(to = 100), "character")
  expect_error(check_errors(), "Unknown API")
  expect_error(check_errors(timespan = "nanoseconds"), "valid")
})


