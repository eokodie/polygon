#' check_http_status
#' @description Check http response messages.
#' @param data An http response object.
#' @keywords internal
check_http_status <- function(data) {
  stopifnot(inherits(data, "response"))
  status_code <- httr::status_code(data)
  switch(
    as.character(status_code),
    "200" = "OK",
    "401" = stop("Unauthorized - Check our API Key and account status."),
    "404" = stop("The specified resource was not found."),
    "409" = stop("Parameter is invalid or incorrect."),
    stop("Unexpected error")
  )
}

#' create_friendly_names
#' @param data A tibble.
#' @return A tibble.
#' @keywords internal
create_friendly_names <- function(data) {
  stopifnot(inherits(data, "data.frame"))
  out <- data
  # user-friendly lookup table
  lookup_tbl <- tibble::tribble(
    ~old_names,           ~new_names,
    "T",                    "ticker",
    "t",             "sip_timestamp",
    "y",        "exchange_timestamp",
    "f",        "trf_unix_timestamp",
    "q",           "sequence_number",
    "c",                "conditions",
    "i",                "indicators",
    "p",                 "bid_price",
    "x",           "bid_exchange_id",
    "s",                  "bid_size",
    "P",                 "ask_price",
    "X",           "ask_exchange_id",
    "S",                  "ask_size",
    "z", "tape_where_trade_occurred"
  ) %>%
    dplyr::filter(old_names %in% names(out))

  # Rename response cols using the lookup table
  names(out)[match(lookup_tbl$old_names, names(out))] <- lookup_tbl$new_names
  out
}

