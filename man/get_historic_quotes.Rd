% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stocks.R
\name{get_historic_quotes}
\alias{get_historic_quotes}
\title{get_historic_quotes}
\usage{
get_historic_quotes(ticker, date)
}
\arguments{
\item{ticker}{(string) An appropriate Ticker}

\item{date}{(Date) Date of the historic ticks to retrieve ('YYYY-MM-DD').}
}
\value{
A tibble of financial data.
}
\description{
Get historic NBBO quotes for a ticker.
}
\examples{
\dontrun{
library(polygon)

get_historic_quotes(
ticker = "AAPL",
date = Sys.Date() - 30
)
}
}
