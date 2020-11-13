#' get_exchanges_cypto
#'
#' @description Get list of crypto currency exchanges which are supported by Polygon.io
#' @param token (string) A valid token for polygonio.
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' token = "YOUR_POLYGON_TOKEN",
#' get_exchanges_cypto(token)
#' }
get_exchanges_cypto <- function(token) {
  if(!is.character(token)) stop("token must be a character")
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v1/meta/crypto-exchanges",
    query = list(
      apiKey = token
    )
  )

  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(isTRUE(content$status == "ERROR")) stop(content$error)
  tibble::tibble(content)
}


#' get_snapshot_all_tickers_cypto
#'
#' @description Snapshot allows you to see all Crypto tickers' current
#' minute aggregate, daily aggregate and last trade.
#' As well as previous days aggregate and calculated change for today.
#'
#' @param token A valid token for polygonio (character string).
#' @param ticker A character string of an appropriate Ticker.
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#'
#' get_snapshot_all_tickers_cypto(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "X:BTCUSD"
#' )
#' }
get_snapshot_all_tickers_cypto <- function(token) {
  # checks
  if(!is.character(token)) stop("token must be a character")

  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/snapshot/locale/global/markets/crypto/tickers"
  )
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = token
    )
  )
  # get response
  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(isTRUE(content$status == "ERROR")) stop(content$error)
  tibble::tibble(content$tickers)
}
