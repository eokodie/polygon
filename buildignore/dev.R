library(magrittr)
source("~/.Rprofile")

token <- Sys.getenv("polygon_token")

# # Examples
polygon::get_aggregates(
  token,
  ticker = "AAPL",
  multiplier = 1,
  timespan = "day",
  from = "2019-01-01",
  to = "2019-02-01"
)

get_historic_quotes(
  token,
  ticker = "AAPL",
  date = "2020-11-02"
)


############
# checks
if(!is.character(token)) stop("token must be a character")
if(!is.character(ticker)) stop("ticker must be a character")
if(!is.character(date)) stop("date must be a character")

# construct endpoint
url <- "https://api.polygon.io"
url <- glue::glue(
  "{url}/v2/ticks/stocks/nbbo/{ticker}/{date}"
)
url <- httr::modify_url(
  url,
  query = list(
    apiKey = token
  )
)

# get response
response <- httr::GET(url)
content <- httr::content(response, "text", encoding = "UTF-8")
content <- jsonlite::fromJSON(content)
if(content$status == "ERROR") stop(content$error)
