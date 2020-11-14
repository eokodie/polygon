test_that("get_locales works", {
  expect_error(get_locales(token = 6), "character")
  expect_error(get_locales(token = "test"), "Unauthorized")

})


