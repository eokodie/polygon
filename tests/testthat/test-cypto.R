test_that("get_exchanges_cypto works", {
  expect_error(get_exchanges_cypto(token = 6), "character")
  expect_error(get_exchanges_cypto("test"), "Unauthorized")
})

test_that("get_snapshot_all_tickers_cypto works", {
  expect_error(get_snapshot_all_tickers_cypto(token = 6),  "character")
  expect_error(get_snapshot_all_tickers_cypto(token = "test"), "Unauthorized")
})


test_that("get_open_close_crypto works", {
  check_errors <- function(token = "test",
                           from = "BTC",
                           to = "USD",
                           date = "2020-11-06") {
    get_open_close_crypto(token, from, to, date)
  }
  expect_error(check_errors(),  "Unauthorized")
  expect_error(check_errors(token = 6),  "character")
  expect_error(check_errors(date = 20201102), "character")
  expect_error(check_errors(from = 52), "character")
})
