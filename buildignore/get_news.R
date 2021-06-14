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
  base_url <- glue::glue("{site()}/v2/reference/news")

  url <- httr::modify_url(
    base_url,
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

#' @keywords internal
format_news <- function(content){
  news_tbl <- content$results %>%
    dplyr::select(-publisher) %>%
    dplyr::mutate(
      tickers = .$tickers %>% purrr::map_chr(~glue::glue_collapse(., sep = ", "))
    ) %>%
    dplyr::mutate(
      keywords = .$keywords %>% purrr::map(~ifelse(rlang::is_null(.x), "", .x))
    ) %>%
    dplyr::mutate(
      keywords = .$keywords %>% purrr::map_chr(~glue::glue_collapse(., sep = ", "))
    ) %>%
    tibble::as_tibble()

  out <- dplyr::bind_cols(news_tbl, content$results$publisher) %>%
    dplyr::mutate(timestamp = lubridate::as_datetime(published_utc)) %>%
    dplyr::select(-id)
  out
}


