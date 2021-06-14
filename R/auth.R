#' Polygon Authentication
#'
#' `polygon_auth()` looks for the environment variable `POLYGON_TOKEN`.
#' We recommend that you set this variable in `.Renviron`.
#'
#' @name polygon_auth
#' @export
polygon_auth <- function(){
  token <- Sys.getenv("POLYGON_TOKEN")
  msg <- paste0(
    "Please set env var POLYGON_TOKEN to your polygon personal access token.\n",
    "If you don't have an API key, you can obtain one from https://polygon.io/"
  )
  if (!nzchar(token)) stop(msg, call. = FALSE)

  token
}


