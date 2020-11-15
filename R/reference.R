#' get_locales
#'
#' @description Get the list of currently supported locales
#' @param token (string) A valid token for polygonio.
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' token = "YOUR_POLYGON_TOKEN",
#' get_locales(token)
#' }
get_locales <- function(token) {
  stopifnot(is.character(token))
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v2/reference/locales",
    query = list(
      apiKey = token
    )
  )
  response <- httr::GET(url)
  check_http_status(response)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  tibble::tibble(content$results)
}

