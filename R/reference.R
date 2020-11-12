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
  if(!is.character(token)) stop("token must be a character")
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

