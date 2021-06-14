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

