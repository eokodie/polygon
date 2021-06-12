key <- polygon:::get_secret()

test_that("get_exchanges_cypto works", {
  if(!is.na(key)) {
    out <- get_exchanges_cypto(token = key)
    expect_s3_class(out, "tbl_df")
    expect_equal(ncol(out), 5)
  }
  expect_error(get_exchanges_cypto("test"), "Unauthorized")
})

test_that("get_snapshot_all_tickers_cypto works", {
  out <- get_snapshot_all_tickers_cypto()
  expect_s3_class(out, "tbl_df")
  expect_equal(ncol(out), 8)
})


test_that("get_open_close_crypto works", {
  check_errors <- function(from = "BTC",
                           to = "USD",
                           date = "2020-11-06") {
    get_open_close_crypto(token, from, to, date)
  }
  expect_error(check_errors(date = 20201102), "character")
  expect_error(check_errors(from = 52), "character")
})
