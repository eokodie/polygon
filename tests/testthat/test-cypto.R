test_that("get_exchanges_cypto works", {
  expect_error(get_exchanges_cypto(token = 6), "character")
  expect_error(get_exchanges_cypto("test"), "Unknown API")
})
