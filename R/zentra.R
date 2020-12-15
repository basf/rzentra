#' retrieve authentication token from zentracloud
#' @param username username. Read by default from environment variable `ZC_USERNAME`
#' @param password password. Read by default from environment variable `ZC_PASSWORD`
#' @importFrom httr POST content user_agent status_code http_error
#' @importFrom jsonlite fromJSON
#' @return api token
#' @export
#' @examples
#' \dontrun{
#' token <- zc_token("xxxx", "yyyyy")
#' }
zc_token <- function(username = Sys.getenv("ZC_USERNAME"),
                     password = Sys.getenv("ZC_PASSWORD")) {

  stopifnot(!is.null(username))
  stopifnot(!is.null(password))

  if (nchar(username) == 0)
    stop("public_key is empty. Is the environment variable 'ZC_USERNAME' set?")

  if (nchar(password) == 0)
    stop("private_key is empty. Is the environment variable 'ZC_PASSWORD' set?")

  api <- "https://zentracloud.com"
  qurl <- httr::modify_url(api, path = "/api/v1/tokens")

  Sys.sleep(0.5)
  resp <- httr::POST(qurl,
                     body = list(username  = username, password = password),
                     httr::user_agent("rzentra"))

  parsed <- resp %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = FALSE)

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "Zentracloud API request failed [%s]\n%s",
        httr::status_code(resp),
        parsed$detail
      ),
      call. = FALSE
    )
  }
  return(parsed)
}


#' retrieve settings of a device
#' @rdname zentra
#' @param token (required) authorization token as returned by [zc_token]
#' @param sn (required) the serial number for the device
#' @param start_time Return data with timestamps greater or equal start_time.
#'   Specify start_time in UTC seconds, e.g.
#'   `r as.numeric(as.POSIXct("2020-01-20", origin = "1970-01-01"))`
#' @param end_time Return data with timestamps smaller or equal end_time.
#'   Specify end_time in UTC seconds, , e.g.
#'    `r as.numeric(as.POSIXct("2020-01-20", origin = "1970-01-01"))`
#' @importFrom httr GET add_headers stop_for_status content modify_url
#'   user_agent
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' \dontrun{
#' zc_settings(token = "yourtoken",
#'   sn = "z6-00033",
#'   start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01")))
#' }
zc_settings <- function(token = NULL, sn = NULL,
                        start_time = NULL, end_time = NULL) {
  stopifnot(!is.null(token))
  stopifnot(!is.null(sn))

  api <- "https://zentracloud.com"
  qurl <- httr::modify_url(api, path = "/api/v1/settings")

  Sys.sleep(0.5)
  resp <- httr::GET(qurl,
    query = list(sn = sn, start_time = start_time, end_time = end_time),
    httr::add_headers(Authorization = paste0("token ", token)),
    httr::user_agent("rzentra")
  )

  parsed <- resp %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = FALSE)

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "Zentracloud API request failed [%s]\n%s",
        httr::status_code(resp),
        parsed$detail
      ),
      call. = FALSE
    )
  }

  if (length(parsed) == 1 && names(parsed) == "Error") {
    stop(
      sprintf(
        "Zentracloud API request failed.\n%s",
        parsed$Error
      ),
      call. = FALSE
    )
  }

  parsed <- structure(parsed, class = c("zc_settings", "list"))
  return(parsed)
}

#' retrieve statuses of a device
#' @rdname zentra
#' @importFrom httr GET add_headers stop_for_status content modify_url
#'   user_agent
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' \dontrun{
#' zc_statuses("yourtoken", sn = "z6-00033",
#'   start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01")))
#' }
zc_statuses <- function(token = NULL, sn = NULL,
                        start_time = NULL, end_time = NULL) {
  stopifnot(!is.null(token))
  stopifnot(!is.null(sn))

  api <- "https://zentracloud.com"
  qurl <- httr::modify_url(api, path = "/api/v1/statuses")

  Sys.sleep(0.5)
  resp <- httr::GET(qurl,
    query = list(sn = sn, start_time = start_time, end_time = end_time),
    httr::add_headers(Authorization = paste0("Token ", token)),
    httr::user_agent("rzentra"))

  parsed <- resp %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = FALSE)

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "Zentracloud API request failed [%s]\n%s",
        httr::status_code(resp),
        parsed$detail
      ),
      call. = FALSE
    )
  }

  if (length(parsed) == 1 && names(parsed) == "Error") {
    stop(
      sprintf(
        "Zentracloud API request failed.\n%s",
        parsed$Error
      ),
      call. = FALSE
    )
  }

  parsed <- structure(parsed, class = c("zc_statuses", "list"))
  return(parsed)
}

#' retrieve readings of a device
#' @rdname zentra
#' @param start_mrid Return data with mrids greater or equal start_mrid.
#'   This can be user to query data that has not been received yet,
#'   see [guidelines](https://zentracloud.com/api/v1/guide#APIGuidelines).
#' @importFrom httr GET add_headers stop_for_status content modify_url
#'   user_agent
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' \dontrun{
#' zc_readings("yourtoken", sn = "z6-00033",
#'   start_time = as.numeric(as.POSIXct(Sys.Date(), origin = "1970-01-01")))
#' }
zc_readings <- function(token = NULL, sn = NULL,
                        start_time = NULL, start_mrid = NULL) {
  stopifnot(!is.null(token))
  stopifnot(!is.null(sn))

  api <- "https://zentracloud.com"
  qurl <- httr::modify_url(api, path = "/api/v1/readings")

  Sys.sleep(0.5)
  resp <- httr::GET(qurl,
    query = list(sn = sn, start_time = start_time, start_mrid = start_mrid),
    httr::add_headers(Authorization = paste0("Token ", token)),
    httr::user_agent("rzentra"))

  parsed <- resp %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = FALSE)

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "Zentracloud API request failed [%s]\n%s",
        httr::status_code(resp),
        parsed$detail
      ),
      call. = FALSE
    )
  }

  if (length(parsed) == 1 && names(parsed) == "Error") {
    stop(
      sprintf(
        "Zentracloud API request failed.\n%s",
        parsed$Error
      ),
      call. = FALSE
    )
  }

  parsed <- structure(parsed, class = c("zc_readings", "list"))
  return(parsed)
}
