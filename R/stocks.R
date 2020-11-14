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
#' library(polygon)
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
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/ticks/stocks/nbbo/{ticker}/{date}"
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
  out <- tibble::tibble(content$results)
  create_friendly_names(out)
}


#' get_exchanges
#'
#' @description Get list of stock exchanges which are supported by Polygon.io
#' @param token (string) A valid token for polygonio.
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' token = "YOUR_POLYGON_TOKEN",
#' get_exchanges(token)
#' }
get_exchanges <- function(token) {
  if(!is.character(token)) stop("token must be a character")
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v1/meta/exchanges",
    query = list(
      apiKey = token
    )
  )

  response <- httr::GET(url)
  check_http_status(response)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  tibble::tibble(content)
}

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
#'
#' @return A tibble of financial data.
#' @export
#' @examples
#' \dontrun{
#' library(polygon)
#' get_aggregates(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "AAPL",
#' multiplier = 1,
#' timespan = "day",
#' from = "2019-01-01",
#' to = "2019-02-01"
#' )
#' }
get_aggregates <- function(
  token,
  ticker,
  multiplier,
  timespan = c('minute', 'hour', 'day', 'week', 'month', 'quarter', 'year'),
  from,
  to
) {
  # checks
  timespan <- rlang::arg_match(timespan)
  if(!is.character(token)) stop("token must be a character")
  if(!is.character(ticker)) stop("ticker must be a character")
  if(!is.character(timespan)) stop("timespan must be a character")
  if(!is.character(from)) stop("from must be a character")
  if(!is.character(to)) stop("to must be a character")
  if(!rlang::is_integerish(multiplier)) stop("multiplier must be an integer")

  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/aggs/ticker/{ticker}/range/{multiplier}/{timespan}/{from}/{to}"
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

  # clean response
  old_names <- c("v", "o", "c", "h", "l", "t")
  new_names <- c("volume", "open", "close", "high", "low", "time")
  out <- tibble::tibble(content$results) %>%
    dplyr::select(dplyr::one_of(old_names)) %>%
    dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
    magrittr::set_colnames(new_names)
  out
}

#' get_previous_close
#'
#' @description Get the previous day close for the specified ticker
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
#' get_previous_close(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "AAPL"
#' )
#' }
get_previous_close <- function(token, ticker) {
  # checks
  if(!is.character(token)) stop("token must be a character")
  if(!is.character(ticker)) stop("ticker must be a character")

  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/aggs/ticker/{ticker}/prev"
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
  out <- tibble::tibble(content$results)

  # clean response
  old_names <- c("T", "v", "o", "c", "h", "l", "t")
  new_names <- c("ticker", "volume", "open", "close", "high", "low", "time")
  out <- tibble::tibble(content$results) %>%
    dplyr::select(dplyr::one_of(old_names)) %>%
    dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
    magrittr::set_colnames(new_names)
  out
}



#' get_snapshot_all_tickers_stocks
#'
#' @description Snapshot allows you to see all Stock tickers' current
#' minute aggregate, daily aggregate and last trade.
#' As well as previous days aggregate and calculated change for today.
#'
#' @param token A valid token for polygonio (character string).
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#'
#' get_snapshot_all_tickers_stocks(
#' token = "YOUR_POLYGON_TOKEN",
#' ticker = "AAPL"
#' )
#' }
get_snapshot_all_tickers_stocks <- function(token) {
  if(!is.character(token)) stop("token must be a character")
  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/snapshot/locale/us/markets/stocks/tickers"
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
