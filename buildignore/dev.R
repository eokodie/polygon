
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

### get daily bars
check_http_status =polygon:::check_http_status
get_grouped_daily_bars(
  token,
  locale="US",
  market="CRYPTO",
  date = "2020-11-06"
)

get_open_close_crypto(
token ,
from = "BTC",
to = "USD",
date = "2018-5-9"
)

source("~/.Rprofile")
token <- Sys.getenv("polygon_token")

ws <- polygon::WebSocket$new(cluster = "stocks", token)
ws$subscribe("Q.AAPL")
ws$unsubscribe("T.AAPL")
ws$close()
