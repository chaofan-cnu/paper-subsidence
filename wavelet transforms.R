# Load packages
library(dplyr)
library(tidyr)
library(xlsx)
library(readxl)
library(ggplot2)
library(waveslim)

# read xlsx data
source_data <- read.xlsx("D:/data/xiaobo/1026/xiaobofenjie.xlsx", sheetIndex = 1)
#source_data <- read.csv("D:/data/xiaobo/1026/xiaobofenjie.xlsx", header = TRUE)

# remove negative numbers
new_d <- source_data[,1]
new_v <- source_data[,-1]
new_v <- new_v+100000
source_data <- cbind(new_d,new_v)
# columns count
colnum <- ncol(source_data)
test.env <- new.env()
test.env$first_flag <- TRUE
for (i in 2:colnum)
{
  result <- source_data[,c(1,i)]
  colnames(result) <- c("date","value")
  # log data
  data <- result  %>%
    mutate(lgv = log(value))
  # Calculate first difference of log subside
  data <- data %>%
    mutate(dlgv = lgv - lag(lgv, 1))
  # Get data
  y <- na.omit(data$dlgv)
  # Run the filter
  wave_v <- modwt(y, wf = "la8", n.levels = 5, boundary = "periodic")
  df <- data.frame(d1 = wave_v["d1"], 
                   d2 = wave_v["d2"],
                   d3 = wave_v["d3"],
                   d4 = wave_v["d4"],
                   d5 = wave_v["d5"],
                   s5 = wave_v["s5"])
  # Transform mra-output to data frame
  wave_v <- as_tibble(df)
  # Create data frame for plotting
  temp <- wave_v %>%
    gather(key = "imf", value = "value") %>%
    group_by(imf) %>%
    mutate(date = data$date[-1])
  #d1 d2 d3 d4 d5 s5
  loc<-(which(temp[,1]=="d1"))
  dd1<-temp[loc,c(2,3)]
  loc<-(which(temp[,1]=="d2"))
  dd2<-temp[loc,c(2,3)]
  loc<-(which(temp[,1]=="d3"))
  dd3<-temp[loc,c(2,3)]
  loc<-(which(temp[,1]=="d4"))
  dd4<-temp[loc,c(2,3)]
  loc<-(which(temp[,1]=="d5"))
  dd5<-temp[loc,c(2,3)]
  loc<-(which(temp[,1]=="s5"))
  ss5<-temp[loc,c(2,3)]
  if (get('first_flag', envir=test.env))
  {
    print("first_flag")
    test.env$first_flag <- FALSE
    test.env$total_d1 <- dd1
    test.env$total_d2 <- dd2
    test.env$total_d3 <- dd3
    test.env$total_d4 <- dd4
    test.env$total_d5 <- dd5
    test.env$total_s5 <- ss5
  }
  else
  {
    #print("no_first_flag")
    dt <- dd1[,1]
    test.env$total_d1 <- cbind(test.env$total_d1,dt)
    dt <- dd2[,1]
    test.env$total_d2 <- cbind(test.env$total_d2,dt)
    dt <- dd3[,1]
    test.env$total_d3 <- cbind(test.env$total_d3,dt)
    dt <- dd4[,1]
    test.env$total_d4 <- cbind(test.env$total_d4,dt)
    dt <- dd5[,1]
    test.env$total_d5 <- cbind(test.env$total_d5,dt)
    dt <- ss5[,1]
    test.env$total_s5 <- cbind(test.env$total_s5,dt)
  }
}
# write xlsx d1
t1<-get('total_d1', envir=test.env)
# restore  the Order of magnitude
new_d <- t1[,2]
new_v <- t1[,-2]
new_v <- new_v*10000
t1 <- cbind(new_d,new_v)
write.xlsx(t1, file = "d1.xlsx", sheetName = "Sheet1")

# write xlsx d2
t1<-get('total_d2', envir=test.env)
# restore  the Order of magnitude
new_d <- t1[,2]
new_v <- t1[,-2]
new_v <- new_v*10000
t1 <- cbind(new_d,new_v)
write.xlsx(t1, file = "d2.xlsx", sheetName = "Sheet1")

# write xlsx d3
t1<-get('total_d3', envir=test.env)
# restore  the Order of magnitude
new_d <- t1[,2]
new_v <- t1[,-2]
new_v <- new_v*10000
t1 <- cbind(new_d,new_v)
write.xlsx(t1, file = "d3.xlsx", sheetName = "Sheet1")

# write xlsx d4
t1<-get('total_d4', envir=test.env)
# restore  the Order of magnitude
new_d <- t1[,2]
new_v <- t1[,-2]
new_v <- new_v*10000
t1 <- cbind(new_d,new_v)
write.xlsx(t1, file = "d4.xlsx", sheetName = "Sheet1")

# write xlsx d5
t1<-get('total_d5', envir=test.env)
# restore  the Order of magnitude
new_d <- t1[,2]
new_v <- t1[,-2]
new_v <- new_v*10000
t1 <- cbind(new_d,new_v)
write.xlsx(t1, file = "d5.xlsx", sheetName = "Sheet1")

# write xlsx s4
t1<-get('total_s5', envir=test.env)
# restore  the Order of magnitude
new_d <- t1[,2]
new_v <- t1[,-2]
new_v <- new_v*10000
t1 <- cbind(new_d,new_v)
write.xlsx(t1, file = "s5.xlsx", sheetName = "Sheet1")

# end