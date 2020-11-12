#' get_locales
#'
#' @description Get the list of currently supported locales
#' @param token (string) A valid token for polygonio.
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' libraray(polygon)
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
  if(rlang::is_empty(content$results)) {
    stop("reponse empty. Have you entered a valid ticker?")
  }
  tibble::tibble(content$results)
}


