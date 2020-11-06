library(magrittr)
source("~/.Rprofile")

token <- Sys.getenv("polygon_token")

# Examples
polygon::get_aggregates(
  token,
  ticker = "AAPL",
  multiplier = 1,
  timespan = "day",
  from = "2019-01-01",
  to = "2019-02-01"
)
