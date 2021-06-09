#' Polygon Authentication
#'
#' `polygon_auth()` looks for the environment variable `POLYGON_TOKEN`.
#' We recommend that you set this variable in `.Renviron`.
#'
#' @name polygon_auth
#' @export
polygon_auth <- function(){
  token <- Sys.getenv("POLYGON_TOKEN")
  if(nchar(token) ==  0)
    rlang::abort("Set POLYGON_TOKEN environment variable.")
  token
}


