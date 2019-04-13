library(RCurl)
library(ggplot2)

x <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Movement_of_industrial_waste2017%20(3).csv")
waste_mnovement_2017 <- read.csv(text = x)

y <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Quantitative_indicators2017.csv")
quantative_indicators_2017 <- read.csv(text = y)

z <- getURL("https://github.com/Garend95/InfoVis_Garen/blob/master/Waste_quantitative_movement_by_classes2017.csv")
waste_quantative_movement_by_classes_2017 <- read.csv(text = z)

e <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_quantity_indicators_and_transportation_2017.csv")
waste_transported2017 <- read.csv(text = e)
waste_transported2017$Region <- gsub ("\\n","",waste_transported2017$Region)

f <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_transported_to_municipal_landfills2017.csv")
waste_transported_to_landfiils <- read.csv(text = f)

marz1 <- which(waste_transported2017$Region %in% c("Yerevan city","Syunik"))
datMod <- waste_transported2017[c(marz1),]


agregTable <- aggregate(datMod$organization.Generated, by = list(datMod$Year), FUN = sum)
agregTable$landfill <- aggregate(datMod$landfil.Transported, by = list(datMod$Year), FUN = sum)

ggplot(datMod, aes(x = datMod$Year)) + geom_bar(aes(y = datMod$organization.Generated, fill = "red"), stat = "identity", position = "dodge") + 
  geom_bar(aes(y = datMod$landfil.Transported, fill = "blue"),stat = "identity", position = "dodge")
