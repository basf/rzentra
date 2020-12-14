#' parse readings into a long data.frame
#' @param readings object of class `zc_readings` as returned by [zc_readings()]
#' @importFrom purrr map_df
#' @importFrom methods is
#' @export
#' @examples
#' \dontrun{
#' readings <- zc_readings("yourtoken",
#'   sn = "z6-00033",
#'   start_time = as.numeric(as.POSIXct(Sys.Date(),origin = "1970-01-01")))
#' zc_timeseries(readings)
#' }
zc_timeseries <- function(readings) {
  stopifnot(is(readings, "zc_readings"))
  purrr::map_df(readings$device$timeseries, parse_timeseries)
}

#' parse a time series
#' @param timeseries time series object
#' @importFrom purrr map_df
parse_timeseries <- function(timeseries) {
  purrr::map_df(timeseries$configuration$values, parse_timepoint)
}

#' parse a timepoint
#' @importFrom purrr map_df
#' @importFrom dplyr mutate select .data
#' @importFrom lubridate as_datetime
#' @param timepoint timepoint object as in zc_readings object
parse_timepoint <- function(timepoint) {
  # separate data from metadata
  data <- timepoint[seq(4, length(timepoint))]
  # parse each sensor
  res <- purrr::map_df(data, parse_port)
  # add metadata to results
  res$datetime <- lubridate::as_datetime(timepoint[[1]])
  res$mrid <- timepoint[[2]]
  res$rssi <- timepoint[[3]]

  res[, c("datetime", "mrid", "rssi", "value", "units", "description",
           "error")]
}

#' parse a port
#' @importFrom data.table rbindlist
#' @param port port object as in zc_readings object
parse_port <- function(port) {
  p <- data.table::rbindlist(port, fill = TRUE)
  p$units <- trimws(p$units)
  p$value <- as.numeric(p$value)
  p[, c("value", "units", "description", "error")]
}
