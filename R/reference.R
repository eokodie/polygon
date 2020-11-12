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
#' get_locales(token)
#' }
get_locales <- function(token) {
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v2/reference/locales",
    query = list(
      apiKey = token
    )
  )

  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(isTRUE(content$status == "ERROR")) stop(content$error)
  tibble::tibble(content$results)
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
#' get_exchanges(token)
#' }
get_exchanges <- function(token) {
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v1/meta/exchanges",
    query = list(
      apiKey = token
    )
  )

  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(isTRUE(content$status == "ERROR")) stop(content$error)
  tibble::tibble(content$results)
}
