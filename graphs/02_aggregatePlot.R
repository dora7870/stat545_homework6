library(ggplot2)
library(plyr)

iDat <- read.delim("income_clean1.tsv")

## make a plot of agelevel with counts of income greater thann 50K
a <- ggplot(iDat, aes(x = age, weight = cens, fill = sex)) + 
  geom_histogram(position = position_dodge(width = 0.9))
ggsave("barchart_agecount.png")

## since old don't have income greater than 50K, remove the related observations of old
iDat <- droplevels(subset(iDat, age != "Old"))

## reorder agelevel based on maximum of hours per week
iDat <- within(iDat, age <- reorder(age, hours.per.week, max))

## make a plot of hours per week on age for male and female
b <- ggplot(iDat, aes(x = age, y = hours.per.week, color = income)) + 
  geom_jitter(alpha = 0.6, position = position_jitter(width = 0.1)) +
  scale_color_manual(values = c("#0066CC", "#FF9900"))
  facet_wrap(~ sex)
ggsave("stripplot_agehourbysex.png")

## make a plot of hours per week on occupation within age
c <- ggplot(iDat, aes(x = occupation, y = hours.per.week, color = income)) + 
  geom_jitter(alpha = 0.6, position = position_jitter(width = 0.1)) +
  facet_wrap(~ age)
ggsave("stripplot_occuhourbyage.png")

## reorder data
iDat <- arrange(iDat, sex, age, hours.per.week, income)

## write data to file
write.table(iDat, "income_clean2.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)
