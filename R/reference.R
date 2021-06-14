#' get_locales
#'
#' @description Get the list of currently supported locales
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' get_locales()
#' }
get_locales <- function() {
  url <- httr::modify_url(
    url   = site(),
    path  = "v2/snapshot/locale/global/markets/crypto/tickers",
    query = list(
      apiKey = polygon_auth()
    )
  )
  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content$results)
}

#' Get news from polygon API
#'
#' @description Get the most recent news articles relating to a
#' stock ticker symbol, including a summary of the article
#' and a link to the original source.
#' @param ticker (string) Stock ticker symbol of interest.
#' @param publish_date (Date) Publish date. Return articles publish at or
#' after this date.
#' @param limit (Integer) The maximum number of results returned.
#'
#' @export
#' @examples
#' \dontrun{
#' get_news('AAPL')
#' }
get_news <- function(ticker, publish_date = Sys.Date()-1, limit = 100){
  stopifnot(is.numeric(limit))
  url <- httr::modify_url(
    url   = site(),
    path  = "/v2/reference/news",
    query = list(
      limit             = as.character(limit),
      order             = "descending",
      sort              = "published_utc",
      published_utc.gte = as.character(publish_date),
      apiKey            = polygon_auth()
    )
  )

  response <- httr::GET(url)
  content <- parse_response(response)
  format_news(content)
}
