#' check_http_status
#' @description Check http response messages.
#' @param data An http response object.
#' @keywords internal
check_http_status <- function(data) {
  stopifnot(inherits(data, "response"))
  status_code <- httr::status_code(data)
  switch(
    as.character(status_code),
    "200" = invisible('OK'),
    "401" = stop("Unauthorized - Check our API Key and account status."),
    "404" = stop("The specified resource was not found."),
    "409" = stop("Parameter is invalid or incorrect."),
    "409" = stop("Parameter is invalid or incorrect."),
    "403" = stop("Unauthorized. Upgrade your plan at https://polygon.io/pricing"),
    stop("Unexpected error")
  )
}

#' Check the polygon token environment variable.
#' @details Check that the POLYGON_TOKEN environment variable has been set.
#' You can obtain an API key from the [Polygon.io Website](https://polygon.io/).
#' @export
check_token <- function(){
  if(nchar(Sys.getenv("POLYGON_TOKEN")) ==  0)
    rlang::abort("Set polygon token with Sys.setenv('YOUR_POLYGON_TOKEN').")
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

#' create_friendly_names
#' @param response A response object.
#' @return A tibble.
#' @keywords internal
clean_response <- function(response){
  stopifnot(inherits(response, 'response'))
  check_http_status(response)
  content <- httr::content(response, "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(content)
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

utils::globalVariables(c(".data"))

