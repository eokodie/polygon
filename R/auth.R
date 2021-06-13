#' Polygon Authentication
#'
#' `polygon_auth()` looks for the environment variable `POLYGON_TOKEN`.
#' We recommend that you set this variable in `.Renviron`.
#'
#' @name polygon_auth
#' @export
polygon_auth <- function(){
  token <- Sys.getenv("POLYGON_TOKEN")
  if(!nzchar(token))
    stop(
      "Set POLYGON_TOKEN environment variable. \nIf you don't have an API key,",
      " you can obtain one from the [Polygon.io Website](https://polygon.io/)."
    )
  token
}


