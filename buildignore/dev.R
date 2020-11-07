library(magrittr)
source("~/.Rprofile")

token <- Sys.getenv("polygon_token")

# # Examples

new_col_names <- c(
  "volume", "weighted_volume", "open",
  "close", "high", "low", "time"
)

ticker = "AAPL"

polygon::get_aggregates(
  token,
  ticker = ticker,
  multiplier = 5,
  timespan = "minute",
  from = "2020-11-06",
  to = "2020-11-06",
  unadjusted = TRUE,
  sort = "asc"
) %>%
  # dplyr::mutate(t1 = as.Date(as.POSIXct(t/1000, origin="1970-01-01"))) %>%
  # dplyr::mutate(t2 = anytime::anydate(t/1000)) %>%
  dplyr::mutate(t = lubridate::as_datetime(t/1000)) %>%
  magrittr::set_colnames(new_col_names) %>%
  dplyr::mutate(ticker = ticker) %>%
  dplyr::select(ticker, dplyr::everything())
  View()

  # process    real
  # 15.6ms 242.6ms

get_historic_quotes(
  token,
  ticker = "AAPL",
  date = "2020-11-02"
)

source("~/.Rprofile")
travis_token = Sys.getenv("travis_token")
covr::codecov(token = travis_token)

c("volum")
