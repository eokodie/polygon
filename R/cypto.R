#' Daily Open/Close for Crypto
#'
#' @description Get the open, close prices of a symbol on a certain day.
#'
#' @param from (string) From Symbol of the pair.
#' @param to (string) To Symbol of the pair.
#' @param date (string) Date of the requested open/close.
#'
#' @return A tibble of financial data.
#' @export
#' @examples
#' \dontrun{
#' library(polygon)
#' get_open_close_crypto(
#' from = "BTC",
#' to = "USD",
#' date = "2019-01-01"
#' )
#' }
get_open_close_crypto <- function(from, to, date) {
  stopifnot(is.character(from))
  stopifnot(is.character(to))
  stopifnot(is.character(date))

  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v1/open-close/crypto/{from}/{to}/{date}"
  )
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- clean_response(response)
  content$results
}

#' get_exchanges_cypto
#'
#' @description Get list of crypto currency exchanges which are supported by Polygon.io
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' get_exchanges_cypto()
#' }
get_exchanges_cypto <- function() {
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v1/meta/crypto-exchanges",
    query = list(
      apiKey = polygon_auth()
    )
  )

  response <- httr::GET(url)
  content <- clean_response(response)
  tibble::tibble(content)
}


#' get_snapshot_all_tickers_cypto
#'
#' @description Snapshot allows you to see all Crypto tickers' current
#' minute aggregate, daily aggregate and last trade.
#' As well as previous days aggregate and calculated change for today.
#'
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#'
#' get_snapshot_all_tickers_cypto()
#' }
get_snapshot_all_tickers_cypto <- function() {
  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/snapshot/locale/global/markets/crypto/tickers"
  )
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- clean_response(response)
  tibble::tibble(content$tickers)
}
