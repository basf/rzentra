% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parser.R
\name{zc_timeseries}
\alias{zc_timeseries}
\title{parse readings into a long data.frame}
\usage{
zc_timeseries(readings)
}
\arguments{
\item{readings}{object of class \code{zc_readings} as returned by \code{\link[=zc_readings]{zc_readings()}}}
}
\description{
parse readings into a long data.frame
}
\examples{
\dontrun{
readings <- zc_readings("yourtoken",
  sn = "z6-00033",
  start_time = as.numeric(as.POSIXct(Sys.Date(),origin = "1970-01-01")))
zc_timeseries(readings)
}
}
