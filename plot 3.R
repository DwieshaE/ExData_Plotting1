setwd("/Users/Desktop/Datascience")
install.packages("data.table")
library("data.table")

unzip('./exdata%2Fdata%2Fhousehold_power_consumption.zip')

housedata <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

## Format date to Type Date
housedata$Date <- as.Date(housedata$Date, "%d/%m/%Y")

## Filter data set from Feb. 1, 2007 to Feb. 2, 2007
housedata <- subset(housedata,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))

## Remove incomplete observation
housedata <- housedata[complete.cases(t),]

## Combine Date and Time column
dateTime <- paste(housedata$Date, housedata$Time)

## Name the vector
dateTime <- setNames(dateTime, "DateTime")

## Remove Date and Time column
housedata <- housedata[ ,!(names(housedata) %in% c("Date","Time"))]

## Add DateTime column
housedata <- cbind(dateTime, housedata)

## Format dateTime Column
housedata$dateTime <- as.POSIXct(dateTime)

##PLOT 3
## Create Plot 3
with(housedata, {
  plot(Sub_metering_1~dateTime, type="l",
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~dateTime,col='Red')
  lines(Sub_metering_3~dateTime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()