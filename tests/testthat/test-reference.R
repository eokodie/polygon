key <- polygon:::get_secret()

test_that("get_locales works", {
  if(!is.na(key)) {
    out <- get_locales(token = key)
    expect_s3_class(out, "tbl_df")
    expect_equal(ncol(out), 2)
  }
  expect_error(get_locales(token = 6), "character")
  expect_error(get_locales(token = "test"), "Unauthorized")

})


