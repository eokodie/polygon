#' parse_response
#' @param response A response object.
#' @return A tibble.
#' @export
parse_response <- function(response){
  if (httr::http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  out <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

  if (httr::http_error(response)) {
    stop(
      sprintf(
        "Polygon API request failed [%s]\n%s",
        httr::status_code(response),
        out$message
      ),
      call. = FALSE
    )
  }
  out
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
    dplyr::filter(.data$old_names  %in% names(out))

  # Rename response cols using the lookup table
  names(out)[match(lookup_tbl$old_names, names(out))] <- lookup_tbl$new_names
  out
}

#' @keywords internal
get_secret <- function() {
  tryCatch({
    out <- secret::get_secret(
      name  = "polygon_key",
      key   = Sys.getenv("polygon_public_key"),
      vault = file.path(here::here(), ".github/.vault")
    )
    out$polygon_token
  },
  error = function(e) NA_character_
  )
}

#' @keywords internal
site <- function() {
  "https://api.polygon.io"
}
