#' get_aggregates
#'
#' @description Get OHLC aggregates for a date range, in custom
#' time window sizes for a ticker.
#'
#' @param token (string) A valid token for polygonio.
#' @param ticker (string) Ticker symbol of the request.
#' Some tickers require a prefix, see examples below:
#' Stocks: 'AAPL'
#' Currencies: 'C:EURUSD'
#' Crypto: 'X:BTCUSD'
#' @param multiplier (integer) Size of the timespan multiplier.
#' @param timespan (string) Size of the time window.
#' Options include: 'minute', 'hour', 'day', 'week', 'month',
#' 'quarter', 'year'.
#' @param from (string) From date ('YYYY-MM-DD').
#' @param to (string) To date ('YYYY-MM-DD').
#' @param unadjusted (logical) Set to TRUE if the results
#' should NOT be adjusted for splits.
#' @param sort (string) sort by timestamp. Options include: "asc" and "desc".
#'
#' @return A tibble of financial data.
#' @export
#' @examples
#' \dontrun{
#' libraray(polygon)
#' get_aggregates(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "AAPL",
#' multiplier = 1,
#' timespan = "day",
#' from = "2019-01-01",
#' to = "2019-02-01"
#' )
#' }
get_aggregates <- function(token,
                           ticker,
                           multiplier,
                           timespan,
                           from,
                           to,
                           unadjusted = TRUE,
                           sort = "asc") {
  # checks
  if(!is.character(token)) stop("token must be a character")
  if(!is.character(ticker)) stop("ticker must be a character")
  if(!is.character(timespan)) stop("timespan must be a character")
  if(!is.character(from)) stop("from must be a character")
  if(!is.character(to)) stop("to must be a character")
  if(!is.numeric(multiplier)) stop("multiplier must be an integer")
  if(multiplier %% 1 != 0) stop("multiplier must be an integer")

  span <- c('minute', 'hour', 'day', 'week', 'month', 'quarter', 'year')
  msg <- glue::glue_collapse(span, sep = ", ", last = " and ")
  if(!timespan %in% span) stop(glue::glue("valid timespans include: {msg}"))

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
  if(content$status == "ERROR") stop(content$error)

  # clean response
  new_col_names <- c(
    "volume", "weighted_volume", "open",
    "close", "high", "low", "time"
  )
  out <- tibble::tibble(content$results) %>%
    dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
    magrittr::set_colnames(new_col_names) %>%
    dplyr::mutate(ticker = ticker) %>%
    dplyr::select(ticker, dplyr::everything())
  out
}


#' get_historic_quotes
#'
#' @description Get historic NBBO quotes for a ticker.
#'
#' @param token A valid token for polygonio (character string).
#' @param ticker A character string of an appropriate Ticker.
#' @param date  (string) Date of the historic ticks to retrieve ('YYYY-MM-DD').
#'
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' libraray(polygon)
#'
#' get_historic_quotes(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "AAPL",
#' date = "2019-01-01"
#' )
#' }
get_historic_quotes <- function(token, ticker, date) {

  # checks
  if(!is.character(token)) stop("token must be a character")
  if(!is.character(ticker)) stop("ticker must be a character")
  if(!is.character(date)) stop("date must be a character")

  # construct endpoint
  url <- "https://api.polygon.io"
  url <- glue::glue(
    "{url}/v2/ticks/stocks/nbbo/{ticker}/{date}"
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
  if(content$status == "ERROR") stop(content$error)
  tibble::tibble(content$results)
}
