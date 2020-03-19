library(dplyr)
library("nls.multstart")
library(ggplot2)
library(forecast)
library(patchwork)

corona_data <- get_data_by_country("United Kingdom")
corona_data <- corona_data[order(as.Date(corona_data$reportDate, format="%Y-%m-%d")),]

y <- as.vector(as.numeric(as.character(corona_data$cases)))
x <- seq(1, length(y))

plot(x, y)

log.ss <- nls(y ~ SSlogis(x, phi1, phi2, phi3))

C <- summary(log.ss)$coef[1]
A <- exp((summary(log.ss)$coef[2]) * (1/summary(log.ss)$coef[3]))
K <- (1 / summary(log.ss)$coef[3])

xx <- seq(1, 2*length(y))

plot(y ~ x, main = "Logistic Function", xlab = xx)
plot(0:max(xx), predict(log.ss, data.frame(x = 0:max(xx))), col="red")

fit_for_country <- function(countryname, order){
  corona_data <- get_data_by_country(countryname)
  corona_data <- corona_data[order(as.Date(corona_data$reportDate, format="%Y-%m-%d")),]
  y <- as.vector(as.numeric(as.character(corona_data$cases)))
  y %>%
    auto.arima() %>%
    forecast(h = order) %>%
    autoplot() +
      ggtitle(countryname) + ylab("Count")
}

p1 <-fit_for_country("Italy", 25)
p2 <-fit_for_country("UK", 15)
p3 <-fit_for_country("Poland", 8)
p4 <-fit_for_country("Spain", 18)
p5 <-fit_for_country("South Korea", 18)
p6 <-fit_for_country("Japan", 24)

p1 + p2 + p3 + p4 + p5 + p6
