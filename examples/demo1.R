library(dplyr)
library("nls.multstart")
library(ggplot2)

#' Fitting the logistic function

corona_data <- get_data_by_country("Italy")
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
