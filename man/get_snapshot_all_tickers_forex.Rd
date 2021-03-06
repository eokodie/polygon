% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/forex.R
\name{get_snapshot_all_tickers_forex}
\alias{get_snapshot_all_tickers_forex}
\title{get_snapshot_all_tickers_forex}
\usage{
get_snapshot_all_tickers_forex()
}
\value{
A tibble of financial data.
}
\description{
Snapshot allows you to see all Forex tickers' current
minute aggregate, daily aggregate and last trade.
As well as previous days aggregate and calculated change for today.
}
\examples{
\dontrun{
library(polygon)

get_snapshot_all_tickers_forex(
ticker = "X:BTCUSD"
)
}
}
