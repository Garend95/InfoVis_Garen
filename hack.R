library(RCurl)
library(ggplot2)
install.packages("reshape")
library(reshape)
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

transported2 <- waste_transported2017[,c(1,2,4,6)]
transported2 <- melt(transported2, id.vars = c("Region","Year"), measure.vars = c("organization.Generated","landfil.Transported"))

agregTable <- aggregate(datMod$organization.Generated, by = list(datMod$Year), FUN = sum)
agregTable$landfill <- aggregate(datMod$landfil.Transported, by = list(datMod$Year), FUN = sum)

ggplot(transported2, aes(x = Year, y = value, fill = variable)) + geom_bar(stat = "identity", position = "dodge")