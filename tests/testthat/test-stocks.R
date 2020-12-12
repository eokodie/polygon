test_that("stocks aggregates work", {

  check_errors <- function(token = "test",
                           ticker = "AAPL",
                           multiplier = 1,
                           timespan = "day",
                           from = "2019-01-01",
                           to = "2019-02-01",
                           unadjusted = TRUE,
                           sort = "asc") {
    get_aggregates(token, ticker, multiplier, timespan, from, to)
  }

  expect_error(check_errors(ticker = 2), "character")
  expect_error(check_errors(multiplier = "one"), "integer")
  expect_error(check_errors(multiplier = 1.5), "integer")
  expect_error(check_errors(token = 6), "character")
  expect_error(check_errors(timespan = 5), "character")
  expect_error(check_errors(from = 1), "character")
  expect_error(check_errors(to = 100), "character")
  expect_error(check_errors(), "Unauthorized")
  expect_error(check_errors(timespan = "nanoseconds"), "must be one of")

  key <- polygon:::get_secret()
  if(!is.na(key)) {
    out <- get_aggregates(
      token = key,
      ticker = "AAPL",
      multiplier = 1,
      timespan = "day",
      from = "2019-01-01",
      to = "2019-02-01"
    )
    expect_s3_class(out, "tbl_df")
    expect_equal(ncol(out), 6)

    col_names <- c("volume", "open", "close", "high", "low", "time")
    expect_named(out, c("volume", "open", "close", "high", "low", "time"))
    expect_identical(colnames(out), col_names)
  }
})

test_that("get_exchanges works", {
  expect_error(get_exchanges(token = 6), "character")
  expect_error(get_exchanges("test"), "Unauthorized")
})

test_that("get_historic_quotes works", {
  check_errors <- function(token = "tl", ticker = "SQ", date = "2020-11-02"){
    polygon::get_historic_quotes(token, ticker, date)
  }

  expect_error(check_errors(ticker = 2), "character")
  expect_error(check_errors(token = 6), "character")
  expect_error(check_errors(date = 1), "character")
  expect_error(check_errors(), "Unauthorized")

})


test_that("get_previous_close works", {
  expect_error(get_previous_close(token = 6, ticker = "AAPL"),  "character")
  expect_error(get_previous_close(token = "test", ticker = "AAPL"), "Unauthorized")
  expect_error(get_previous_close(token = 2, ticker = 100), "character")
})

test_that("get_snapshot_all_tickers_stocks works", {
  expect_error(get_snapshot_all_tickers_stocks(token = 6),  "character")
  expect_error(get_snapshot_all_tickers_stocks(token = "test"), "Unauthorized")
})

test_that("get_grouped_daily_bars works", {
  check_errors <- function(token = "test",
                           locale="US",
                           market="STOCKS",
                           date = "2020-11-06") {
    get_grouped_daily_bars(token, locale, market, date)
  }
  expect_error(check_errors(),  "Unauthorized")
  expect_error(check_errors(token = 6),  "character")
  expect_error(check_errors(date = 20201102), "character")
  expect_error(check_errors(locale = "test"), "must be one of")
  expect_error(check_errors(market = "test"), "must be one of")
})

test_that("get_gainers_and_loser works", {
  expect_error(get_gainers_and_loser("test", direction = "g"), "must be one of")
  expect_error(get_gainers_and_loser(5, "gainers"), "character")
  expect_error(get_previous_close("test", "gainers"), "Unauthorized")
})
