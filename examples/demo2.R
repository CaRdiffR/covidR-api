library(dplyr)
library(ggplot2)
library(forecast)
library(patchwork)

#' Fitting ARIMA model to log of the COVID-19 cases detected in 6 countries

fit_for_country <- function(countryname, pred_len) {
  corona_data <- get_data_by_country(countryname)
  corona_data <- corona_data[order(as.Date(corona_data$reportDate, format="%Y-%m-%d")),]
  y <- log10(as.vector(as.numeric(as.character(corona_data$cases))))
  y %>%
    auto.arima(max.order = 10) %>%
    forecast(h = pred_len) %>%
    autoplot() +
    ggtitle(countryname) + ylab("Log [Count]")
}

p1 <-fit_for_country("Italy", 25)
p2 <-fit_for_country("UK", 15)
p3 <-fit_for_country("Poland", 8)
p4 <-fit_for_country("Spain", 18)
p5 <-fit_for_country("South Korea", 18)
p6 <-fit_for_country("Japan", 24)

p1 + p2 + p3 + p4 + p5 + p6

