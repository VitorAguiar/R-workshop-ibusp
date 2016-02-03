library(tidyr)

df2 <- read.table(text = "ind   sex control trt1    trt2
        1   m   7.9 12.3    10.7
        2   f   6.3 10.6    11.1
        3   f   9.5 13.1    13.8
        4   m   11.5    13.4    12.9", header = TRUE)

df2 <- df2 %>% gather(treatment, value, 3:5)
