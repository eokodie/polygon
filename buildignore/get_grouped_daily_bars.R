#' get_grouped_daily_bars
#'
#' @description Get the daily OHLC for entire markets..
#'
#' @param token (string) A valid token for polygonio.
#' @param locale (string) Locale of the aggregates. Run `get_locales()` to get
#' a list of all possible locales.
#'
#' @param market (integer) Market of the aggregates. Run `get_locales()` to get
#' a list of all possible locales.
#' options include: "STOCKS", "CRYPTO", "BONDS", "MF", "MMF", "INDICES", "FX".
#' @param date (string) From date ('YYYY-MM-DD').
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
get_grouped_daily_bars <- function(token,
                    locale = c("G", "US", "GB", "CA", "NL", "GR", "SP",
                               "DE", "BE", "DK", "FI", "IE", "PT", "IN",
                               "MX", "FR", "CN", "CH", "SE"),
                    market = c("STOCKS", "CRYPTO", "BONDS",
                               "MF", "MMF", "INDICES", "FX"),
                    date){
  local <- rlang::arg_match(locale)
  market <- rlang::arg_match(market)
  if(!is.character(date)) stop("date must be a character")

  # construct endpoint
  base_url <- glue::glue(
    "https://api.polygon.io",
    "/v2/aggs/grouped/locale/{locale}/market/{market}/{date}"
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
  if(nrow(out) == 0) stop("Unexpected Error.")

  # clean response
  old_names <- c("T", "v", "vw", "o", "c", "h", "l", "t")
  new_names <- c("ticker", "volume","weighted volume",
                 "open", "close", "high", "low", "time")
  dplyr::select(out, dplyr::one_of(old_names)) %>%
    dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
    magrittr::set_colnames(new_names)
  out
}

check_http_status =polygon:::check_http_status
get_grouped_daily_bars(
  token,
  locale="US",
  market="CRYPTO",
  date = "2020-11-06"
)

# get_grouped_daily_bars -> function(
#   token,
#   locale = c("G", "US", "GB", "CA", "NL", "GR", "SP", "DE", "BE", "DK", "FI", "IE", "PT", "IN", "MX", "FR", "CN", "CH", "SE"),
#   market = c("STOCKS", "CRYPTO", "BONDS", "MF", "MMF", "INDICES", "FX"),
#   date){
#   return(1)
# }

  # # clean response
  # old_names <- c("v", "o", "c", "h", "l", "t")
  # new_names <- c("volume", "open", "close", "high", "low", "time")
  # out <- tibble::tibble(content$results) %>%
  #   dplyr::select(dplyr::one_of(old_names)) %>%
  #   dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
  #   magrittr::set_colnames(new_names)
  # out

