#' Daily Open/Close for Crypto
#'
#' @description Get the open, close prices of a symbol on a certain day.
#'
#' @param from (String) From Symbol of the pair.
#' @param to (String) To Symbol of the pair.
#' @param date (Date) Date of the requested open/close.
#'
#' @return A tibble of financial data.
#' @export
#' @examples
#' \dontrun{
#' library(polygon)
#' get_open_close_crypto(
#' from = "BTC",
#' to = "USD",
#' date = Sys.Date() - 1
#' )
#' }
get_open_close_crypto <- function(from, to, date) {
  stopifnot(is.character(from))
  stopifnot(is.character(to))
  stopifnot(inherits(date, 'Date'))

  date <- as.character(date)
  url <- httr::modify_url(
    url   = site(),
    path  = glue::glue("/v1/open-close/crypto/{from}/{to}/{date}"),
    query = list(
      apiKey = polygon_auth()
    )
  )

  response <- httr::GET(url)
  content <- parse_response(response)
  content
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
    url   = site(),
    path  = "v1/meta/crypto-exchanges",
    query = list(
      apiKey = polygon_auth()
    )
  )
  response <- httr::GET(url)
  content <- parse_response(response)
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
  url <- httr::modify_url(
    url   = site(),
    path  = "v2/snapshot/locale/global/markets/crypto/tickers",
    query = list(
      apiKey = polygon_auth()
    )
  )

  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content$tickers)
}
