library(ggplot2)
library(plyr)

iDat <- read.delim("income_clean2.tsv")

## fit the logistic regression of census income on hour per week for each occupation
iFun <- function(x) {
  iFit <- glm(cens ~ hours.per.week, family = binomial(logit), x)
  names(iFit$coefficients) <- c("intercept", "slope")
  names(iFit$deviance) <- ("deviance")
  coefs <- c(iFit$coefficients, iFit$deviance)
  return(coefs)
}
iCoefs <- ddply(iDat, ~ age + occupation, iFun)

## write data to file
write.table(iCoefs, "income_glmFit.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)

## reorder occupation based on slope within age
iCoefs <- arrange(iCoefs, age, slope)

## get the 3 best occupations and the 3 worst occupations based on slope
iCoefs2 <- ddply(iCoefs, ~ age, function(y) {
  rownum <- c(1:3, (nrow(y) - 2):nrow(y))
  cbind(y[rownum, ], note = c(rep("worst-occupation", 3), rep("best-occupation", 3)))
})

## write data to file
write.table(iCoefs2, "income_glmFit_someOccup.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)

## put all the related observations of the interested occupations in to one dataset
iDat_Coef <- merge(iDat, iCoefs2)

## for each age, write stripplot with logistic regression line to file
d_ply(iDat_Coef, ~ age, function(z) {
  theAge <- z$age[1]
  z <- within(z, occupation <- reorder(occupation, slope))
  p <- ggplot(z, aes(x = hours.per.week, y = cens, color = sex, shape = sex)) + geom_point(size = 2) +
    stat_smooth(method = "glm", family = "binomial", se = FALSE) +
    facet_wrap(~ occupation) +
    scale_color_manual(values = c("#FF9900", "#33CCFF"))
    ggtitle(theAge)
  print(p)
  theAge <- gsub(" ", "_", theAge)
  ggsave(paste0("stripplot_incomeByHours_", theAge, ".png"))
})
