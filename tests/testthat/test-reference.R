test_that("get_locales works", {
  expect_error(get_locales("test"), "Unknown API")

})

test_that("get_exchanges works", {
  expect_error(get_exchanges("test"), "Unknown API")

})
