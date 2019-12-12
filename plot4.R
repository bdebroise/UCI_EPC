#
# EXPLORATORY DATA ANALYSIS
#
# PLOT 2 : GLOBAL ACTIVE POWER
#

#  Project_folder (UCI_EPC)     -> working directory      
#     DATA_SET                  -> dataset folder with .gitignore
#     R files                   -> all R files     
#     PNG files                 -> all plot images 


# Set working directory
setwd("~/PROJETS/RPROJECTS/UCI_EPC/")


# Load data.table in order to use fread function.
library("data.table")

# Pre-ptocess data with Grep to get only the required dates - (Date in format dd/mm/yyyy)
# Input  : file data set.
# Output : data.table with all rows and columns for the selected dates without header.
epcDataSet <- fread("grep -w '^[1,2]/2/2007'   DATA_SET/household_power_consumption.txt")


# Get header from dataset :
header <- read.table("DATA_SET/household_power_consumption.txt",nrows = 1,sep=";",header=FALSE,stringsAsFactors = FALSE)

# Adding header 
names(epcDataSet) <- as.character(header[1,])

# Remove rows with NA / if needed
#epcDataSet <- epcDataSet[complete.cases(epcDataSet), ]


# Load Dplyr in order to :
# 1/ convert date and time form string to date/time format.
# 2/ convert number values to numeric data type

library("dplyr")

# Add full date (= date + Time) in a new column
tbl_epc <- epcDataSet %>% as_tibble() %>% mutate(fulldatetime = as.POSIXct(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S")))

#
# convert numeric dimensions data type
tbl_epc <- tbl_epc %>% mutate(Global_active_power=as.numeric(Global_active_power),
                              Global_reactive_power = as.numeric(Global_reactive_power),
                              Voltage = as.numeric(Voltage),
                              Global_intensity = as.numeric(Global_intensity),
                              Sub_metering_1 = as.numeric(Sub_metering_1),
                              Sub_metering_2 = as.numeric(Sub_metering_2),
                              Sub_metering_3 = as.numeric(Sub_metering_3)
                              )



# PLOT
png("Plot4.png", width = 480, height = 480)


par(mfrow=c(2,2))

#1
plot(tbl_epc$fulldatetime,tbl_epc$Global_active_power,type="l",ylab = "Global Active Power",xlab="")


#2
plot(tbl_epc$fulldatetime,tbl_epc$Voltage,type="l",ylab = "Voltage",xlab="datetime")


#3
plot(tbl_epc$fulldatetime,tbl_epc$Sub_metering_1,type="l",ylab = "Energy sub metering",xlab="")

points(tbl_epc$fulldatetime,tbl_epc$Sub_metering_2,type="l",col="red")

points(tbl_epc$fulldatetime,tbl_epc$Sub_metering_3,type="l",col="blue")

legend("topright", lty =1 , col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3") )


#4
plot(tbl_epc$fulldatetime,tbl_epc$Global_reactive_power,type="l",ylab = "Global Reactive Power",xlab="datetime")



dev.off()  ## Don't forget to close the PNG device!


#END OF THE FILE



