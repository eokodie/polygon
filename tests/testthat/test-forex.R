key <- polygon:::get_secret()

test_that("get_snapshot_all_tickers_forex works", {
    out <- get_snapshot_all_tickers_forex()
    expect_s3_class(out, "tbl_df")
    expect_equal(ncol(out), 8)
})
