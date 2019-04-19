library(RCurl)
library(DT)
library(ggplot2)
#install.packages("reshape")
library(reshape)
library(plotly)
x <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Movement_of_industrial_waste2017%20(3).csv")
waste_mnovement_2017 <- read.csv(text = x)

y <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Quantitative_indicators2017.csv")
quantative_indicators_2017 <- read.csv(text = y)

z <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_quantitative_movement_by_classes2017.csv")
waste_quantative_movement_by_classes_2017 <- read.csv(text = z)

e <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_quantity_indicators_and_transportation_2017.csv")
waste_transported2017 <- read.csv(text = e)
waste_transported2017$Region <- gsub ("\\n","",waste_transported2017$Region)
waste_transported2017$Year <- as.numeric(waste_transported2017$Year)

f <- getURL("https://raw.githubusercontent.com/Garend95/InfoVis_Garen/master/Waste_transported_to_municipal_landfills2017.csv")
waste_transported_to_landfiils <- read.csv(text = f)
waste_transported_to_landfiils$Region <- gsub ("\\n","",waste_transported_to_landfiils$Region)


m <- read.csv("test and check.csv")

transported2 <- waste_transported2017[,c(1,2,4,6)]
transported2 <- melt(transported2, id.vars = c("Region","Year"), measure.vars = c("organization.Generated","landfil.Transported"))
transported2 <- transported2[transported2$Region %in% c("Yerevan city","Syunik"),]
transported2 <- transported2[transported2$Year %in% c(2013:2017),]

agregTable <- aggregate(transported2$value, by = list(transported2$Year, transported2$variable), FUN = sum)
colnames(agregTable) <- c("Year", "Category", "Total_waste")
x <- ggplot(agregTable, aes(x = Year, y = Total_waste/1000000, fill = Category)) + 
  geom_bar(stat = "identity", position = "dodge" ) +
  scale_x_continuous(breaks=agregTable$Year)


ggplotly(x)


# 
# mp <- readShapeSpatial("Lori_Marz.shp")
# install.packages("sp")