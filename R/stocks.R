#' get_aggregates
#'
#' @description Get stocks aggregates for a date range, in custom
#' time window sizes for a given
#' @param token A valid token for polygonio (character string).
#' @param ticker A character string of an appropriate Ticker
#' symbol of the request.
#' @param multiplier A number for the size of the timespan multiplier.
#'
#' @param timespan A character string  of the size of the time window.
#' Options include: 'minute', 'hour', 'day', 'week', 'month',
#' 'quarter', 'year'.
#'
#' @param from (string) From date.
#' @param to (string) To date.
#'
#' @return A tibble of financial data.
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

  # checks
  if(!is.character(token)) stop("token must be a character")
  if(!is.character(ticker)) stop("ticker must be a character")
  if(!is.numeric(multiplier)) stop("multiplier must be a numeric")
  if(!is.character(timespan)) stop("timespan must be a character")
  if(!is.character(from)) stop("from must be a character")
  if(!is.character(to)) stop("to must be a character")


  # construct endpoint
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

  # get response
  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(content$status != "OK") stop(content$message)

  tibble::tibble(content$results)
}
