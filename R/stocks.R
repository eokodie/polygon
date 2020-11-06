#' get_aggregates
#'
#' @description Get aggregates for a date range, in custom time window sizes.
#' @param token A character string of an appropriate Ticker symbol of the request.
#' @param ticker An integer for the size of the timespan multiplier.
#' @param multiplier A character string  of the size of the time window.
#' Options include: 'minute', 'hour', 'day', 'week', 'month', 'quarter', 'year'.
#'
#' @param timespan
#' @param from
#' @param to
#'
#' @return A dataframe.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' libraray(polygon)
#'
#' get_aggregates(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "AAPL",
#' multiplier = 1,
#' timespan = "day",
#' from = "2019-01-01",
#' to = "2019-02-01"
#' )
#' }
#'
get_aggregates <- function(token, ticker, multiplier, timespan, from, to) {
  url <- "https://api.polygon.io"
  url <- glue::glue(
    "{url}/v2/aggs/ticker/{ticker}/range/{multiplier}/{timespan}/{from}/{to}"
  )
  url <- httr::modify_url(
    url,
    query = list(
      apiKey = token
    )
  )

  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(content$status != "OK") stop(content$message)

  tibble::tibble(content$results)
}
