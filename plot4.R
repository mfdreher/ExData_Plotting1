#Read in table...start at row 60,000 and only read 25,000 lines...to cut down on load times
x <- read.table("./data/household_power_consumption.txt", 
                sep = ";", 
                skip=60000,
                nrows=25000, 
                header=TRUE, 
                na.strings=c("NA","?"), 
                stringsAsFactors = FALSE)

#Combine Date & Tome variables and convert to POSIXt
datetime <- paste(x[[1]], x[[2]])
datetime <- strptime(datetime, "%d/%m/%Y %H:%M:%S")

#create new data frame with POSIXt datetime variable, exclude "date" and "time" variables from original dataset
df <- data.frame(datetime, globalactive, x[ ,4:9])

#Create column names. Column names weren't included in table load as the file started at record 60,000
colnames(df) <- c("datetime", "globalactive", "globalreactive", "voltage", "globalintensity", 
                  "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

#Subset dataframe by selecting only records on or after 2/1/2007
start <- df$datetime >= "2007-02-01"
starttb <- df[start, ]

#Subset subsetted dataframe by selecting only records on or before 2/2/2007
end <- starttb$datetime < "2007-02-03"
finishtb <- starttb[end, ]

#Plot line graph with all three sub metering variables
png(file="plot3.png",  width = 480, height = 480, bg="transparent")


#Plot 2 columns and 2 rows of graphs
png(file="plot4.png",  width = 480, height = 480, bg="transparent")

par(mfrow= c(2,2))
plot(finishtb$datetime, finishtb$globalactive, xlab="", ylab = "Global Active Power", type="l")
plot(finishtb$datetime, finishtb$voltage, xlab="datetime", ylab = "Voltage", type="l")
plot(finishtb$datetime, finishtb$Sub_metering_1, type="l", xlab="", ylab = "Energy sub metering")
        lines(finishtb$datetime, finishtb$Sub_metering_2, col="red")
        lines(finishtb$datetime, finishtb$Sub_metering_3, col="blue")
        legend("topright", bty="n", lwd=2, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(finishtb$datetime, finishtb$globalreactive, xlab="datetime", ylab = "Global_reactive_power", type="l")

dev.off()
