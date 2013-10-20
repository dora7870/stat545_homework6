## clean out any previous work
outputs <- c("income_clean1.tsv",            # 01_dataClean.R
             "income_clean2.tsv",            # 02_filterReorder.R
             "income_glmFit.tsv",            # 03_dataAggregate.R
             "income_glmFit_someOccup.tsv",  # 03_dataAggregate.R
             list.files(pattern = "*.png$"))
file.remove(outputs)

## run my scripts
source("01_dataClean.R")
source("02_filterReorder.R")
source("03_dataAggregate.R")
