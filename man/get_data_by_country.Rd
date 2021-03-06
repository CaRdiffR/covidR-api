% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_data_by_country}
\alias{get_data_by_country}
\title{Returns all available countries}
\usage{
get_data_by_country(country_name, date = NULL, from = NULL, to = NULL)
}
\arguments{
\item{country_name}{character with country name, eg. "Italy". For list of
available countris check \code{get_country_list}.}

\item{date}{character with day of interests, eg. "2020-03-15", default NULL}

\item{from}{character with start date, eg. "2020-03-15", default NULL, if
\code{data} given it will be ignored}

\item{to}{character with start date, eg. "2020-04-01", default NULL, if
\code{data} given it will be ignored}
}
\value{
data.frame with data per country
}
\description{
Returns all available countries
}
\examples{
{
 get_data_by_country("Italy")
 get_data_by_country("Poland", date = "2020-03-15")
}
}
