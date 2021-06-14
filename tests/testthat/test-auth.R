test_that(" polygon_auth()", {
  withr::local_envvar(c(POLYGON_TOKEN = NA))
  expect_error(
    polygon_auth(),
    "you don't have an API key"
  )
})
