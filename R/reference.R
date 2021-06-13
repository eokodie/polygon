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
    url   = "https://api.polygon.io/v2/reference/locales",
    query = list(
      apiKey = polygon_auth()
    )
  )
  response <- httr::GET(url)
  content <- parse_response(response)
  tibble::tibble(content$results)
}

