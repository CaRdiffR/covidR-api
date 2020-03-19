#' COVID-19 api link: https://github.com/GregVes/covid-19-api-server
API_URL = "https://covid-api-server.herokuapp.com"

#' Sends request to COVID-19 API
#' 
#' details on API syntax: \url{https://github.com/GregVes/covid-19-api-server}
#'
#' @param request character with request to api, eg. "?country=Spain" if you
#' want to display data for Spain
#' @return list with response and parsed response from json
#' 
#' @importFrom httr GET add_headers content
#' @importFrom jsonlite fromJSON
#' @export
#' @examples{ 
#' covid_api_request("?country=Spain")
#' }
covid_api_request <- function(request){
  query <- paste(API_URL, "/reports", request, sep="")
  resp <- GET(query)
  parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8"),
                               simplifyVector = FALSE)
  .check_response_status(resp, 200)
  return(list(resp=resp, parsed=parsed))
}

#' Returns all available countries
#'
#' @return vector with country names
#' @export
get_country_list <- function() {
  resp <- covid_api_request("/countries")
  unlist(resp$parsed)
}

#' Returns all available countries
#'
#' @param country_name character with country name, eg. "Italy". For list of
#' available countris check \code{get_country_list}.
#' @param date character with day of interests, eg. "2020-03-15", default NULL
#' @param from character with start date, eg. "2020-03-15", default NULL, if
#' \code{data} given it will be ignored
#' @param to character with start date, eg. "2020-04-01", default NULL, if
#' \code{data} given it will be ignored
#' @return data.frame with data per country
#' @importFrom glue glue
#' 
#' @export
#' @examples{
#'  get_data_by_country("Italy")
#'  get_data_by_country("Poland", date = "2020-03-15")
#' }
get_data_by_country <- function(country_name, date = NULL,
                                from = NULL, to = NULL) {
  request <- glue("?country={country_name}")
  if (!is.null(date))
    request <- paste0(request, glue("&date={date}"))
  else {
    if (!is.null(from))
      request <- paste0(request, glue("&start={from}"))
    if (!is.null(to))
      request <- paste0(request, glue("&end={to}"))
  }
  resp <- covid_api_request(request)
  listed_data <- resp$parsed
  df_data <- data.frame(matrix(unlist(listed_data),
                               nrow = length(listed_data), byrow = T))
  names(df_data) <- names(listed_data[[1]])
  df_data
}
