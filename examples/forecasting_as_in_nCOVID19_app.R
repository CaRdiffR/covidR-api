# code to reproduce plot on forecast tab in nCov2019 app
library(nCov2019)
library(lubridate)
library(forecast)

# from https://github.com/GuangchuangYu/nCov2019/inst/shinyapps/e/global.R
xgithub <- load_nCov2019(lang="en", source = "github") #load historical data

tem <- table(xgithub$global$country)
tem2 <- xgithub$global %>%
  group_by(country) %>%
  summarise(max = max(cum_confirm)) %>%
  arrange(desc(max)) %>%
  filter(max > 30) %>%
  pull(country)

contriesPrediction <- xgithub$global %>%
  filter(  country %in%  names(tem)[tem > 20]    ) %>% # only keep contries with 20 more data points.
  filter(  country %in%  tem2   ) %>%  # at least 20 cases
  filter (time > as.Date("2020-2-1")) %>%
  rename(dead = cum_dead, confirm = cum_confirm, heal = cum_heal)

meanImput <- function (x, n = 2) {
  ix <- is.na(x)
  x2 <- x
  for( ixx in which(ix)) {
    start <- ixx-n;
    if(start < 1)
      start <- 1;
    end <- ixx + n;
    if(start > length(x))
      start <- length(x);
    x2[ixx] <- mean( x[ start:end], na.rm = T  ) }
  return( x2 )
}

input <- list()
input$selectCountry <- "Italy"
input$daysForcasted <- 7
# from https://github.com/GuangchuangYu/nCov2019/inst/shinyapps/e/server.R
d2 <- contriesPrediction %>%
  arrange(time) %>%
  filter( country == input$selectCountry)
nRep = sum( d2$confirm == d2$confirm[2]) 
if(nRep > 3) 
  d2 <- d2[-(1:(nRep-3)),]

par(mar = c(4, 3, 0, 2))
# missing data with average of neighbors
d2$confirm<- meanImput(d2$confirm, 2)

confirm <- ts(d2$confirm, # percent change
              start = c(year(min(d2$time)), yday(min(d2$time))  ), frequency=365  )
forecasted <- forecast(ets(confirm), input$daysForcasted)
plot(forecasted, xaxt="n", main="", 
     ylab = "Confirmed cases",
     xlab = ""            
)

a = seq(as.Date(min(d2$time)), by="days", length=input$daysForcasted + nrow(d2) -1 )
axis(1, at = decimal_date(a), labels = format(a, "%b %d"))
}, width = plotWidth - 100 ) 

# xlab somthing like this, not sure how it is worked out it app
xlab <- paste0(input$selectCountry, " is expected to have ", round(forecasted$mean[input$daysForcasted],0), 
               " confirmed cases by ", " 95% CI [",
               round(forecasted$lower[input$daysForcasted],0), "-",round(forecasted$upper[input$daysForcasted],0),"]")