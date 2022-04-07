library(magrittr)
library(dplyr)
library(httr)
library(lubridate)


date_to_download <- lubridate::today("US/Central") - 1


date_to_download <- format(date_to_download, '%m-%d-%Y')

base_URL <- paste0('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/',
                   date_to_download,
                   '.csv')

if(httr::http_error(base_URL)){
  message('There is no Data.')
}else{
  data <- readr::read_csv(base_URL) %>%
    suppressWarnings() %>%
    suppressMessages() %>%
    subset(Country_Region == "US") %>%
    subset(select = c('Province_State', 'Confirmed', 'Deaths')) %>%
    group_by(Province_State)%>%
    summarise_at(vars(Confirmed, Deaths), list(mean)) %>%
    mutate(Confirmed = floor(Confirmed),
           Deaths = floor(Deaths))%>%
    dplyr::rename(State = Province_State,
                  Avg_Confirmed = Confirmed,
                  Avg_Deaths = Deaths) %>%
    mutate(Date = date_to_download) %>%
    subset(., select = c('Date', 'State', 'Avg_Confirmed', 'Avg_Deaths'))
  if(file.exists('data/test_data.csv'){
     old_data <- readr::read_csv('data/test_data.csv')
    if(date_to_download %in% old_data$Date){
      
    }else{
    data <- rbind(old_data, data)
    }
    }else{
    }
    
    
    

    write.csv(data, 'data/test_data.csv')
    
    
  }
