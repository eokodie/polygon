
# code cov ----------------------------------------------------------------

source("~/.Rprofile")
travis_token = Sys.getenv("travis_token")
covr::codecov(token = travis_token)


# -----------------------
library(magrittr)
source("~/.Rprofile")

token <- Sys.getenv("polygon_token")

# # Examples


ticker = "AAPL"
polygon::get_aggregates(
  token,
  ticker = ticker,
  multiplier = 5,
  timespan = "minute",
  from = "2020-11-06",
  to = "2020-11-06"
)

  # process    real
  # 15.6ms 242.6ms

get_historic_quotes(
  token,
  ticker = "AAPL",
  date = "2020-11-09"
)



# examples ----------------------------------------------------------------
df <- polygon::get_aggregates(
  token,
  ticker = "AAPL",
  multiplier = 5,
  timespan = "minute",
  from = "2020-10-06",
  to = "2020-10-06"
) %>%
  tail(20)

df
candle_plot <- plot_candlestick(df, title = "Apple Inc.")
candle_plot
ggplot2::ggsave("man/figures/candlestick.png", candle_plot, width = 10, height = 6)


get_locales(token)

library(magrittr)
source("~/.Rprofile")

token <- Sys.getenv("polygon_token")
# get_exchanges(token)
# get_exchanges_cypto(token)

get_snapshot_all_tickers_stocks(token)
get_snapshot_all_tickers_cypto(token)
get_snapshot_all_tickers_forex(token)
