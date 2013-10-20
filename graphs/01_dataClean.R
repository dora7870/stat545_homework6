library(ggplot2)
library(plyr)

iDat <- read.delim("income.tsv")

## remove variables fnlwgt and education.num
iDat[["fnlwgt"]] <- NULL
iDat[["education.num"]] <- NULL
iDat[["workclass"]] <- NULL

## very few observations of PrivHouseServ, remove them
iDat <- droplevels(subset(iDat, occupation != "PrivHouseServ"))

## remove the related observations of capital.gain and capital.loss with values greater than 0
iDat <- droplevels(subset(iDat, capital.gain == 0))
iDat <- droplevels(subset(iDat, capital.loss == 0))

## remove variables capital.gain and capital.loss
iDat[["capital.gain"]] <- NULL
iDat[["capital.loss"]] <- NULL

## don't want to study on education
iDat[["education"]] <- NULL

## add a variable called cens, cens=0 if income is less than 50K, o.w
iDat$cens <- ifelse(iDat$income == "<=50K", 0, 1)

## make a plot of counts of occupation
a <- ggplot(iDat, aes(x = occupation , fill = income)) + 
  geom_histogram(position = position_dodge(width = 0.9))
ggsave("barchart_occu.png")

## make a plot of hours per week on 2 income levels
b <- ggplot(iDat, aes(x = income, y = hours.per.week, color = income)) +
  scale_color_manual(values = c("#66CCFF", "#3333FF")) +
  geom_jitter()
ggsave("stripplot_incomeHour.png")

## replace specific age with agelevels
range(iDat$age)
iDat$age <- ordered(cut(iDat$age, c(15,25,45,65,100)),
                        labels = c("Young", "Middle-aged", "Senior", "Old"))

## change the column order
iDat <- iDat[c(3, 1, 2, 4, 5, 6)]

## write data to file
write.table(iDat, "income_clean1.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)
