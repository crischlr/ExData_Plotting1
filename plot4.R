##############################################################################
#
#  plot4.R
#  -------
#
#  This script is for creating a plot with four graphics
#  using the Base Plotting System on the dataset: 
#        “Individual household electric power consumption Data Set."
#
#  DATA SET DESCRIPTION 
#  --------------------
#
#  Description: Measurements of electric power consumption in one household 
#  with a one-minute sampling rate over a period of almost 4 years. 
#  Different electrical quantities and some sub-metering values are available.
#
#  The following descriptions of the 9 variables in the dataset are taken 
#  from the UCI web site: http://archive.ics.uci.edu/ml/
#   
#  - Date: Date in format dd/mm/yyyy
#  - Time: time in format hh:mm:ss
#  - Global_active_power: household global minute-averaged active power 
#                       (in kilowatt)
#  - Global_reactive_power: household global minute-averaged reactive power 
#                         (in kilowatt)
#  - Voltage: minute-averaged voltage (in volt)
#  - Global_intensity: household global minute-averaged current intensity 
#                    (in ampere)
#  - Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
#                  It corresponds to the kitchen, containing mainly a dishwasher, 
#                  an oven and a microwave (hot plates are not electric but gas powered).
#  - Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
#                  It corresponds to the laundry room, containing a washing-machine, 
#                  a tumble-drier, a refrigerator and a light.
#  - Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
#                  It corresponds to an electric water-heater and an air-conditioner.
#
##############################################################################


# Download the file

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file_hpw <- file.path(getwd(), "/household_power_consumption.zip")
download.file(fileURL, file_hpw, mode ="wb")

if (file.exists(file_hpw)) {
  unzip (file_hpw, exdir=".")
}

# Calculate of how much memory the dataset will require in memory.
# The dataset has 2,075,259 rows and 9 columns.
# Types are: char, char, num, num, num, num, num, num, num

estimate_row <- 104 + 104 + 8*7
estimate_mb <- ( estimate_row * 2075259 ) / 2^20
estimate_gb <- estimate_mb / 2^10

# The estimated size is: 522.5 Mb.
# Although it fits in the memory, only the required subset is read from the file
file_hpw <- file.path(getwd(), "/household_power_consumption.txt")
data <- subset(read.table(file_hpw, header=TRUE, sep=";", na.strings="?", 
                          blank.lines.skip=TRUE, as.is = TRUE), 
               Date %in% c("1/2/2007", "2/2/2007"))


# Plot four graphics and save them in file "plot4.png"

Sys.setlocale("LC_TIME", "English")

data$datecomplete <- paste(data$Date, data$Time, sep=" ")
data$datecomplete <- strptime(data$datecomplete, "%d/%m/%Y %H:%M:%S")

png("plot4.png", width=480, height=480)
par(bg="transparent")
par(mfcol=c(2,2))

# First plot
with(data, plot(datecomplete, Global_active_power, type="l", xlab="", 
                ylab="Global Active Power"))

# Second plot
with(data, plot(datecomplete, Sub_metering_1, type="l", xlab="", 
                ylab="Energy sub metering"))
with(data,lines(datecomplete, Sub_metering_2, col="red"))
with(data,lines(datecomplete, Sub_metering_3, col="blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       bty = "n", lty=1, lwd=2, col=c("black", "red", "blue"))

# Third plot
with(data, plot(datecomplete, Voltage, type="l", xlab="", 
                ylab="Voltage", sub="datetime"))

# Fourth plot
with(data, plot(datecomplete, Global_reactive_power, type="l", xlab="", 
                ylab="Global reactive power", sub="datetime"))


dev.off()
