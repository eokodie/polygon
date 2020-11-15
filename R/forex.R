#' get_snapshot_all_tickers_forex
#'
#' @description Snapshot allows you to see all Forex tickers' current
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
#' get_snapshot_all_tickers_forex(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "X:BTCUSD"
#' )
#' }
get_snapshot_all_tickers_forex <- function(token) {
  stopifnot(is.character(token))
  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/snapshot/locale/global/markets/forex/tickers"
  )
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = token
    )
  )
  # get response
  response <- httr::GET(url)
  check_http_status(response)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  tibble::tibble(content$tickers)
}
