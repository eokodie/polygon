test_that("get_snapshot_all_tickers_forex works", {
  expect_error(get_snapshot_all_tickers_forex(token = 6),  "character")
  expect_error(get_snapshot_all_tickers_forex(token = "test"), "Unauthorized")
})
