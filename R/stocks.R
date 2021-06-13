#' get_historic_quotes
#'
#' @description Get historic NBBO quotes for a ticker.
#'
#' @param ticker (string) An appropriate Ticker
#' @param date  (Date) Date of the historic ticks to retrieve ('YYYY-MM-DD').
#'
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#'
#' get_historic_quotes(
#' ticker = "AAPL",
#' date = Sys.Date() - 30
#' )
#' }
get_historic_quotes <- function(ticker, date) {
  stopifnot(is.character(ticker))
  stopifnot(inherits(date, 'Date'))
  date <- as.character(date)
  # construct endpoint
  base_url <- glue::glue("{site()}/v2/ticks/stocks/nbbo/{ticker}/{date}")
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- parse_response(response)
  out <- tibble::tibble(content$results)
  create_friendly_names(out)
}


#' get_exchanges
#'
#' @description Get list of stock exchanges which are supported by Polygon.io
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' get_exchanges()
#' }
get_exchanges <- function() {
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v1/meta/exchanges",
    query = list(
      apiKey = polygon_auth()
    )
  )

  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content)
}

#' get_previous_close
#'
#' @description Get the previous day close for the specified ticker
#'
#' @param ticker A character string of an appropriate Ticker.
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#'
#' get_previous_close(
#' ticker = "AAPL"
#' )
#' }
get_previous_close <- function(ticker) {
  stopifnot(is.character(ticker))
  # construct endpoint
  base_url <- glue::glue("{site()}/v2/aggs/ticker/{ticker}/prev")
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- parse_response(response)

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
#' @return A tibble of financial data.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#'
#' get_snapshot_all_tickers_stocks()
#' }
get_snapshot_all_tickers_stocks <- function() {
  # construct endpoint
  base_url <- glue::glue("{site()}/v2/snapshot/locale/us/markets/stocks/tickers")
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content$tickers)
}

#' get_aggregates
#'
#' @description Get OHLC aggregates for a date range, in custom
#' time window sizes for a ticker.
#' @param ticker (string) Ticker symbol of the request.
#' Some tickers require a prefix, see examples below:
#' Stocks: 'AAPL'
#' Currencies: 'C:EURUSD'
#' Crypto: 'X:BTCUSD'
#' @param multiplier (integer) Size of the timespan multiplier.
#' @param timespan (string) Size of the time window.
#' Options include: 'minute', 'hour', 'day', 'week', 'month',
#' 'quarter', 'year'.
#' @param from (Date) From date ('YYYY-MM-DD').
#' @param to (Date) To date ('YYYY-MM-DD').
#'
#' @return A tibble of financial data.
#' @export
#' @examples
#' \dontrun{
#' library(polygon)
#' get_aggregates(
#' ticker = "AAPL",
#' multiplier = 1,
#' timespan = "day",
#' from = Sys.Date() - 20,
#' to = Sys.Date() - 1
#' )
#' }
get_aggregates <- function(
  ticker,
  multiplier,
  timespan = c('minute', 'hour', 'day', 'week', 'month', 'quarter', 'year'),
  from,
  to
) {
  timespan <- rlang::arg_match(timespan)
  stopifnot(is.character(ticker))
  stopifnot(rlang::is_integerish(multiplier))
  stopifnot(inherits(from, 'Date'))
  stopifnot(inherits(to, 'Date'))

  from <- as.character(from)
  to <- as.character(to)
  # construct endpoint
  base_url <- glue::glue(
    "{site()}/v2/aggs/ticker/{ticker}/range/{multiplier}/{timespan}/{from}/{to}"
  )
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- parse_response(response)

  # clean response
  old_names <- c("v", "o", "c", "h", "l", "t")
  new_names <- c("volume", "open", "close", "high", "low", "time")
  out <- tibble::tibble(content$results) %>%
    dplyr::select(dplyr::one_of(old_names)) %>%
    dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
    magrittr::set_colnames(new_names)
  out
}

#' get_grouped_daily_bars
#'
#' @description Get the daily OHLC for entire markets..
#'
#' @param locale (string) Locale of the aggregates. Run `get_locales()` to get
#' a list of all possible locales.
#'
#' @param market (integer) Market of the aggregates. Run `get_locales()` to get
#' a list of all possible locales.
#' options include: "STOCKS", "CRYPTO", "BONDS", "MF", "MMF", "INDICES", "FX".
#' @param date (Date) From date ('YYYY-MM-DD').
#'
#' @return A tibble of financial data.
#' @export
#' @examples
#' \dontrun{
#' library(polygon)
#' get_aggregates(
#' date = Sys.Date() - 1
#' )
#' }
get_grouped_daily_bars <- function(date){
  stopifnot(inherits(date, 'Date'))
  date <- as.character(date)

  # construct endpoint
  base_url <- glue::glue("{site()}/v2/aggs/grouped/locale/us/market/stocks/{date}")
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  # get response
  response <- httr::GET(url)
  content <- parse_response(response)
  out <- tibble::tibble(content$results)
  stopifnot(nrow(out) > 0)

  # clean response
  old_names <- c("T", "v", "vw", "o", "c", "h", "l", "t")
  new_names <- c("ticker", "volume","weighted volume",
                 "open", "close", "high", "low", "time")
  out <- dplyr::select(out, dplyr::one_of(old_names)) %>%
    dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
    magrittr::set_colnames(new_names)
  out
}

#' get_gainers_and_loser
#' @description Get the current snapshot of the top 20 gainers or losers
#' of the day.
#' @param direction (string) Direction we want. Options include: "gainers" and
#' "losers".
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' get_gainers_and_loser("gainers")
#' }
get_gainers_and_loser <- function(direction = c("gainers", "losers")) {
  rlang::arg_match(direction)
  # construct endpoint
  base_url <- glue::glue(
    "{site()}/v2/snapshot/locale/us/markets/stocks/{direction}"
  )
  url <- httr::modify_url(
    base_url,
    query = list(
      apiKey = polygon_auth()
    )
  )
  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content$tickers)
}

