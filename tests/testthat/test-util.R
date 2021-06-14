test_that("create_friendly_names works", {

  expect_error(create_friendly_names(2), "data.frame")

  input_tbl <- tibble::tribble(
                          ~t,          ~y,       ~q, ~c, ~z,     ~p, ~s,
                 1.60431e+18, 1.60431e+18, 14221701, 81,  1,    157,  1,
                 1.60431e+18, 1.60431e+18, 15315801, 81,  1,  157.2,  1,
                 1.60431e+18, 1.60431e+18, 16199401, 81,  1, 156.85,  2,
                 1.60431e+18, 1.60431e+18, 17533601, 81,  1, 156.85,  2,
                 1.60431e+18, 1.60431e+18, 18145201, 81,  1,  157.8,  1,
                 1.60431e+18, 1.60431e+18, 19170501, 81,  1, 156.85,  2
                 )
  out <- create_friendly_names(input_tbl)
  expect_s3_class(out, "tbl_df")

  new_names <- c(
    "ticker", "sip_timestamp", "exchange_timestamp", "trf_unix_timestamp",
    "sequence_number", "conditions", "indicators", "bid_price",
    "bid_exchange_id", "bid_size", "ask_price", "ask_exchange_id",
    "ask_size", "tape_where_trade_occurred"
  )
  testthat::expect_true(
    rlang::is_empty(dplyr::setdiff(names(out), new_names))
  )
})
