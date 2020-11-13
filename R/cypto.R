#' get_exchanges_cypto
#'
#' @description Get list of crypto currency exchanges which are supported by Polygon.io
#' @param token (string) A valid token for polygonio.
#' @return A tibble.
#' @export
#'
#' @examples
#' \dontrun{
#' library(polygon)
#' token = "YOUR_POLYGON_TOKEN",
#' get_exchanges_cypto(token)
#' }
get_exchanges_cypto <- function(token) {
  if(!is.character(token)) stop("token must be a character")
  url <- httr::modify_url(
    url   = "https://api.polygon.io/v1/meta/crypto-exchanges",
    query = list(
      apiKey = token
    )
  )

  response <- httr::GET(url)
  content <- httr::content(response, "text", encoding = "UTF-8")
  content <- jsonlite::fromJSON(content)
  if(isTRUE(content$status == "ERROR")) stop(content$error)
  tibble::tibble(content)
}
