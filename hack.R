library(RCurl)
library(ggplot2)

x <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Movement_of_industrial_waste2017%20(3).csv")
waste_mnovement_2017 <- read.csv(text = x)

y <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Quantitative_indicators2017.csv")
quantative_indicators_2017 <- read.csv(text = y)

z <- getURL("https://github.com/Garend95/InfoVis_Garen/blob/master/Waste_quantitative_movement_by_classes2017.csv")
waste_quantative_movement_by_classes_2017 <- read.csv(text = z)

e <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_quantity_indicators_and_transportation_2017.csv")
waste_quantity_indicators_and_transportation_2017 <- read.csv(text = e)

f <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_transported_to_municipal_landfills2017.csv")
waste_transported_to_landfiils <- read.csv(text = f)

head(waste_transported_to_landfiils)

ggplot(waste_transported_to_landfiils, aes())