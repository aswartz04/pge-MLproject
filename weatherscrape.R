url <- "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php"

zip.all <- paste(as.character(electric.rev$Zip[1:5]),collapse=",")
## Weather Scraping Tool by Zip Code ##

#set the range of dates
start.date <- as.Date("2015-10-01")
end.date <- as.Date("2015-12-31")

date.range <- format(seq.Date(start.date,end.date,by="day"),"%Y/%m/%d")

site.prefix <- "https://www.wunderground.com/history/zipcode/"
site.suffix <- "/DailyHistory.html?format=1"


#testing for just one zip code
temps <- c()
for(i in 1:31){
		weather <- read.csv(paste(site.prefix,loc,"/",
					         date.range[i],site.suffix,sep=""))[-1]
		temps <- c(temps,weather$TemperatureF)
}

		
		

	






