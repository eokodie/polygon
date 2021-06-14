#' get_snapshot_all_tickers_forex
#'
#' @description Snapshot allows you to see all Forex tickers' current
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
#' get_snapshot_all_tickers_forex(
#' ticker = "X:BTCUSD"
#' )
#' }
get_snapshot_all_tickers_forex <- function() {
  url <- httr::modify_url(
    url   = site(),
    path  = glue::glue("v2/snapshot/locale/global/markets/forex/tickers"),
    query = list(
      apiKey = polygon_auth()
    )
  )
  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content$tickers)
}
