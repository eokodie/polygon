key <- polygon:::get_secret()

test_that("get_snapshot_all_tickers_forex works", {
  if(!is.na(key)) {
    out <- get_snapshot_all_tickers_forex(token = key)
    expect_s3_class(out, "tbl_df")
    expect_equal(ncol(out), 8)
  }

  expect_error(get_snapshot_all_tickers_forex(token = 6),  "character")
  expect_error(get_snapshot_all_tickers_forex(token = "test"), "Unauthorized")
})
