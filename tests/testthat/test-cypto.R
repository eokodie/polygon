test_that("get_exchanges_cypto works", {
  expect_error(get_exchanges_cypto(token = 6), "character")
  expect_error(get_exchanges_cypto("test"), "Unauthorized")
})

test_that("get_snapshot_all_tickers_cypto works", {
  expect_error(get_snapshot_all_tickers_cypto(token = 6),  "character")
  expect_error(get_snapshot_all_tickers_cypto(token = "test"), "Unauthorized")
})
