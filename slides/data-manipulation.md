------------------------------------------------------------------------

> *"Data analysis is the process by which data becomes understanding,
> knowledge, and insight"*

> --<cite>Hadley Wickham</cite>

magrittr operators
------------------

-   %\>%
-   %\<\>%
-   %$%
-   %T\>%

pipe usage
----------

    f(x)

    # is the same as:

    x %>% f()

    ## with two arguments:
    f(x, y)

    # is the same as:
    x %>% f(y)

    ## if you don't want the input to be used as 1st argument:
    f(y, x)

    # is the same as:
    x %>% f(y, .)

dplyr
=====

dplyr verbs
-----------

-   filter
-   slice
-   group\_by
-   summarise
-   select
-   arrange
-   mutate
-   count

------------------------------------------------------------------------

    library(dplyr)

------------------------------------------------------------------------

    data(msleep, package = "ggplot2")

    str(msleep)

    Classes 'tbl_df', 'tbl' and 'data.frame':   83 obs. of  11 variables:
     $ name        : chr  "Cheetah" "Owl monkey" "Mountain beaver" "Greater short-tailed shrew" ...
     $ genus       : chr  "Acinonyx" "Aotus" "Aplodontia" "Blarina" ...
     $ vore        : chr  "carni" "omni" "herbi" "omni" ...
     $ order       : chr  "Carnivora" "Primates" "Rodentia" "Soricomorpha" ...
     $ conservation: chr  "lc" NA "nt" "lc" ...
     $ sleep_total : num  12.1 17 14.4 14.9 4 14.4 8.7 7 10.1 3 ...
     $ sleep_rem   : num  NA 1.8 2.4 2.3 0.7 2.2 1.4 NA 2.9 NA ...
     $ sleep_cycle : num  NA NA NA 0.133 0.667 ...
     $ awake       : num  11.9 7 9.6 9.1 20 9.6 15.3 17 13.9 21 ...
     $ brainwt     : num  NA 0.0155 NA 0.00029 0.423 NA NA NA 0.07 0.0982 ...
     $ bodywt      : num  50 0.48 1.35 0.019 600 ...

count
-----

    msleep %>% count(order)

    Source: local data frame [19 x 2]

                 order     n
                 (chr) (int)
    1     Afrosoricida     1
    2     Artiodactyla     6
    3        Carnivora    12
    4          Cetacea     3
    5       Chiroptera     2
    6        Cingulata     2
    7  Didelphimorphia     2
    8    Diprotodontia     2
    9   Erinaceomorpha     2
    10      Hyracoidea     3
    11      Lagomorpha     1
    12     Monotremata     1
    13  Perissodactyla     3
    14          Pilosa     1
    15        Primates    12
    16     Proboscidea     2
    17        Rodentia    22
    18      Scandentia     1
    19    Soricomorpha     5

filter
------

    msleep %>% filter(order == "Carnivora" & !is.na(brainwt))

    Source: local data frame [7 x 11]

              name        genus  vore     order conservation sleep_total
             (chr)        (chr) (chr)     (chr)        (chr)       (dbl)
    1          Dog        Canis carni Carnivora domesticated        10.1
    2 Domestic cat        Felis carni Carnivora domesticated        12.5
    3    Gray seal Haliochoerus carni Carnivora           lc         6.2
    4       Jaguar     Panthera carni Carnivora           nt        10.4
    5        Genet      Genetta carni Carnivora           NA         6.3
    6   Arctic fox       Vulpes carni Carnivora           NA        12.5
    7      Red fox       Vulpes carni Carnivora           NA         9.8
    Variables not shown: sleep_rem (dbl), sleep_cycle (dbl), awake (dbl),
      brainwt (dbl), bodywt (dbl)

select
------

    msleep %>% 
      filter(order == "Carnivora" & !is.na(brainwt)) %>%
      select(genus, bodywt)

    Source: local data frame [7 x 2]

             genus bodywt
             (chr)  (dbl)
    1        Canis  14.00
    2        Felis   3.30
    3 Haliochoerus  85.00
    4     Panthera 100.00
    5      Genetta   2.00
    6       Vulpes   3.38
    7       Vulpes   4.23

group\_by and summarise
-----------------------

    msleep %>%
      group_by(order) %>%
      summarise(average_sleep = mean(sleep_total))

    Source: local data frame [19 x 2]

                 order average_sleep
                 (chr)         (dbl)
    1     Afrosoricida     15.600000
    2     Artiodactyla      4.516667
    3        Carnivora     10.116667
    4          Cetacea      4.500000
    5       Chiroptera     19.800000
    6        Cingulata     17.750000
    7  Didelphimorphia     18.700000
    8    Diprotodontia     12.400000
    9   Erinaceomorpha     10.200000
    10      Hyracoidea      5.666667
    11      Lagomorpha      8.400000
    12     Monotremata      8.600000
    13  Perissodactyla      3.466667
    14          Pilosa     14.400000
    15        Primates     10.500000
    16     Proboscidea      3.600000
    17        Rodentia     12.468182
    18      Scandentia      8.900000
    19    Soricomorpha     11.100000

group by and summarise by more than 1 variable
----------------------------------------------

    msleep %>% 
      group_by(order, vore) %>%
      summarise(average_sleep = mean(sleep_total), average_bodywt = mean(bodywt))

    Source: local data frame [32 x 4]
    Groups: order [?]

                 order    vore average_sleep average_bodywt
                 (chr)   (chr)         (dbl)          (dbl)
    1     Afrosoricida    omni      15.60000        0.90000
    2     Artiodactyla   herbi       3.60000      320.75900
    3     Artiodactyla    omni       9.10000       86.25000
    4        Carnivora   carni      10.11667       57.70525
    5          Cetacea   carni       4.50000      342.17000
    6       Chiroptera insecti      19.80000        0.01650
    7        Cingulata   carni      17.40000        3.50000
    8        Cingulata insecti      18.10000       60.00000
    9  Didelphimorphia   carni      19.40000        0.37000
    10 Didelphimorphia    omni      18.00000        1.70000
    ..             ...     ...           ...            ...

summarise multiple variables
----------------------------

    msleep %>%
      group_by(order) %>%
      summarise_each(funs(mean(., na.rm = TRUE)), sleep_total, brainwt, bodywt)

    Source: local data frame [19 x 4]

                 order sleep_total    brainwt       bodywt
                 (chr)       (dbl)      (dbl)        (dbl)
    1     Afrosoricida   15.600000 0.00260000    0.9000000
    2     Artiodactyla    4.516667 0.19824000  281.6741667
    3        Carnivora   10.116667 0.09857143   57.7052500
    4          Cetacea    4.500000        NaN  342.1700000
    5       Chiroptera   19.800000 0.00027500    0.0165000
    6        Cingulata   17.750000 0.04590000   31.7500000
    7  Didelphimorphia   18.700000 0.00630000    1.0350000
    8    Diprotodontia   12.400000 0.01140000    1.3600000
    9   Erinaceomorpha   10.200000 0.00295000    0.6600000
    10      Hyracoidea    5.666667 0.01519000    3.0583333
    11      Lagomorpha    8.400000 0.01210000    2.5000000
    12     Monotremata    8.600000 0.02500000    4.5000000
    13  Perissodactyla    3.466667 0.41433333  305.1670000
    14          Pilosa   14.400000        NaN    3.8500000
    15        Primates   10.500000 0.25411111   13.8815000
    16     Proboscidea    3.600000 5.15750000 4600.5000000
    17        Rodentia   12.468182 0.00356800    0.2882273
    18      Scandentia    8.900000 0.00250000    0.1040000
    19    Soricomorpha   11.100000 0.00059200    0.0414000

summarise with multiple functions
---------------------------------

    msleep %>%
      group_by(order) %>%
      summarise_each(funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE)), 
                     sleep_total, brainwt, bodywt) %>%
      select(starts_with("sleep"), starts_with("brainwt"), starts_with("bodywt"))

    Source: local data frame [19 x 6]

       sleep_total_mean sleep_total_sd brainwt_mean   brainwt_sd  bodywt_mean
                  (dbl)          (dbl)        (dbl)        (dbl)        (dbl)
    1         15.600000             NA   0.00260000           NA    0.9000000
    2          4.516667      2.5119050   0.19824000 1.306969e-01  281.6741667
    3         10.116667      3.5021638   0.09857143 1.100316e-01   57.7052500
    4          4.500000      1.5716234          NaN          NaN  342.1700000
    5         19.800000      0.1414214   0.00027500 3.535534e-05    0.0165000
    6         17.750000      0.4949747   0.04590000 4.963890e-02   31.7500000
    7         18.700000      0.9899495   0.00630000           NA    1.0350000
    8         12.400000      1.8384776   0.01140000           NA    1.3600000
    9         10.200000      0.1414214   0.00295000 7.778175e-04    0.6600000
    10         5.666667      0.5507571   0.01519000 5.031630e-03    3.0583333
    11         8.400000             NA   0.01210000           NA    2.5000000
    12         8.600000             NA   0.02500000           NA    4.5000000
    13         3.466667      0.8144528   0.41433333 2.430336e-01  305.1670000
    14        14.400000             NA          NaN           NA    3.8500000
    15        10.500000      2.2098951   0.25411111 4.232811e-01   13.8815000
    16         3.600000      0.4242641   5.15750000 7.841814e-01 4600.5000000
    17        12.468182      2.8132994   0.00356800 2.383186e-03    0.2882273
    18         8.900000             NA   0.00250000           NA    0.1040000
    19        11.100000      2.7046257   0.00059200 4.744154e-04    0.0414000
    Variables not shown: bodywt_sd (dbl)

mutate: create new variables
----------------------------

    msleep %>%
      select(genus, sleep_total, awake) %>%
      mutate(prop_sleep_awake = sleep_total/awake)

    Source: local data frame [83 x 4]

             genus sleep_total awake prop_sleep_awake
             (chr)       (dbl) (dbl)            (dbl)
    1     Acinonyx        12.1  11.9        1.0168067
    2        Aotus        17.0   7.0        2.4285714
    3   Aplodontia        14.4   9.6        1.5000000
    4      Blarina        14.9   9.1        1.6373626
    5          Bos         4.0  20.0        0.2000000
    6     Bradypus        14.4   9.6        1.5000000
    7  Callorhinus         8.7  15.3        0.5686275
    8      Calomys         7.0  17.0        0.4117647
    9        Canis        10.1  13.9        0.7266187
    10   Capreolus         3.0  21.0        0.1428571
    ..         ...         ...   ...              ...

mutate: modify existing variables
---------------------------------

    msleep %>%
      select(genus, bodywt) %>%
      mutate(bodywt = round(bodywt*2.20462, digits = 2))

    Source: local data frame [83 x 2]

             genus  bodywt
             (chr)   (dbl)
    1     Acinonyx  110.23
    2        Aotus    1.06
    3   Aplodontia    2.98
    4      Blarina    0.04
    5          Bos 1322.77
    6     Bradypus    8.49
    7  Callorhinus   45.17
    8      Calomys    0.10
    9        Canis   30.86
    10   Capreolus   32.63
    ..         ...     ...

mutate: modify multiple existing variables
------------------------------------------

    msleep %>%
      select(genus, sleep_total, awake) %>%
      mutate_each(funs(./24), sleep_total, awake)

    Source: local data frame [83 x 3]

             genus sleep_total     awake
             (chr)       (dbl)     (dbl)
    1     Acinonyx   0.5041667 0.4958333
    2        Aotus   0.7083333 0.2916667
    3   Aplodontia   0.6000000 0.4000000
    4      Blarina   0.6208333 0.3791667
    5          Bos   0.1666667 0.8333333
    6     Bradypus   0.6000000 0.4000000
    7  Callorhinus   0.3625000 0.6375000
    8      Calomys   0.2916667 0.7083333
    9        Canis   0.4208333 0.5791667
    10   Capreolus   0.1250000 0.8750000
    ..         ...         ...       ...

arrange
-------

    msleep %>%
      select(genus, sleep_total, awake) %>%
      mutate_each(funs(./24), sleep_total, awake) %>%
      arrange(sleep_total, awake, genus)

    Source: local data frame [83 x 3]

               genus sleep_total     awake
               (chr)       (dbl)     (dbl)
    1        Giraffa  0.07916667 0.9208333
    2  Globicephalus  0.11250000 0.8895833
    3          Equus  0.12083333 0.8791667
    4      Capreolus  0.12500000 0.8750000
    5          Equus  0.12916667 0.8708333
    6      Loxodonta  0.13750000 0.8625000
    7          Phoca  0.14583333 0.8541667
    8           Ovis  0.15833333 0.8416667
    9        Elephas  0.16250000 0.8375000
    10           Bos  0.16666667 0.8333333
    ..           ...         ...       ...

rename
------

    msleep %>%
      select(genus, sleep_total, awake) %>%
      mutate_each(funs(./24), sleep_total, awake) %>%
      arrange(sleep_total, awake, genus) %>%
      rename(prop_sleep = sleep_total, prop_awake = awake)

    Source: local data frame [83 x 3]

               genus prop_sleep prop_awake
               (chr)      (dbl)      (dbl)
    1        Giraffa 0.07916667  0.9208333
    2  Globicephalus 0.11250000  0.8895833
    3          Equus 0.12083333  0.8791667
    4      Capreolus 0.12500000  0.8750000
    5          Equus 0.12916667  0.8708333
    6      Loxodonta 0.13750000  0.8625000
    7          Phoca 0.14583333  0.8541667
    8           Ovis 0.15833333  0.8416667
    9        Elephas 0.16250000  0.8375000
    10           Bos 0.16666667  0.8333333
    ..           ...        ...        ...

tidyr
=====

tidyr verbs
-----------

-   gather
-   spread
-   separate
-   unite
-   extract

------------------------------------------------------------------------

data:

    monkeys <- paste(sample(1:20), c(rep("ES", 10), rep("MG", 10)), sep = "_")

    monkey_wt <- data_frame(individual = monkeys,
                            "2013/01/01" = rnorm(20, 5, sd = 1),
                            "2014/01/14" = rnorm(20, 7, sd = 1.5),
                            "2015/02/02" = rnorm(20, 10, sd = 2))

    monkey_wt

    Source: local data frame [20 x 4]

       individual 2013/01/01 2014/01/14 2015/02/02
            (chr)      (dbl)      (dbl)      (dbl)
    1        8_ES   5.489443   7.908120  12.325428
    2        7_ES   4.778810   3.465705   9.165969
    3       10_ES   4.490063   8.682786  12.717395
    4       16_ES   4.857295   7.416428   7.295723
    5       15_ES   3.072027   6.066892   6.591667
    6       13_ES   4.094527   5.796239  10.131943
    7        1_ES   6.909618   7.780812  10.936481
    8       11_ES   5.063725   8.164255   9.176331
    9       14_ES   3.877335   5.927900  10.566869
    10       6_ES   3.756489   6.720004  10.477636
    11       9_MG   6.629377   5.077235  10.462844
    12       2_MG   4.786181   7.387037  12.366815
    13      20_MG   5.213118   7.419725   6.137110
    14       4_MG   6.801137   8.266651   7.601706
    15      18_MG   6.511526   6.316992  10.781498
    16       3_MG   5.113881   7.910254   9.548679
    17      17_MG   6.480186   9.143616  11.163529
    18      19_MG   5.894166   7.083740  14.565683
    19      12_MG   4.437540   5.312709  13.915309
    20       5_MG   6.456929   6.167670  12.300427

------------------------------------------------------------------------

    library(magrittr)
    library(tidyr)

gather
------

    monkey_wt %<>%
      gather(key=date, value=weight, 2:4)

    monkey_wt

    Source: local data frame [60 x 3]

       individual       date   weight
            (chr)     (fctr)    (dbl)
    1        8_ES 2013/01/01 5.489443
    2        7_ES 2013/01/01 4.778810
    3       10_ES 2013/01/01 4.490063
    4       16_ES 2013/01/01 4.857295
    5       15_ES 2013/01/01 3.072027
    6       13_ES 2013/01/01 4.094527
    7        1_ES 2013/01/01 6.909618
    8       11_ES 2013/01/01 5.063725
    9       14_ES 2013/01/01 3.877335
    10       6_ES 2013/01/01 3.756489
    ..        ...        ...      ...

spread
------

    monkey_wt %>% spread(date, weight)

    Source: local data frame [20 x 4]

       individual 2013/01/01 2014/01/14 2015/02/02
            (chr)      (dbl)      (dbl)      (dbl)
    1        1_ES   6.909618   7.780812  10.936481
    2       10_ES   4.490063   8.682786  12.717395
    3       11_ES   5.063725   8.164255   9.176331
    4       12_MG   4.437540   5.312709  13.915309
    5       13_ES   4.094527   5.796239  10.131943
    6       14_ES   3.877335   5.927900  10.566869
    7       15_ES   3.072027   6.066892   6.591667
    8       16_ES   4.857295   7.416428   7.295723
    9       17_MG   6.480186   9.143616  11.163529
    10      18_MG   6.511526   6.316992  10.781498
    11      19_MG   5.894166   7.083740  14.565683
    12       2_MG   4.786181   7.387037  12.366815
    13      20_MG   5.213118   7.419725   6.137110
    14       3_MG   5.113881   7.910254   9.548679
    15       4_MG   6.801137   8.266651   7.601706
    16       5_MG   6.456929   6.167670  12.300427
    17       6_ES   3.756489   6.720004  10.477636
    18       7_ES   4.778810   3.465705   9.165969
    19       8_ES   5.489443   7.908120  12.325428
    20       9_MG   6.629377   5.077235  10.462844

separate
--------

    monkey_wt %<>%  
      separate(individual, into = c("id_number", "state"), sep = "_") %>%
      mutate(id_number = as.numeric(id_number)) %>%
      arrange(id_number, state)

    monkey_wt

    Source: local data frame [60 x 4]

       id_number state       date    weight
           (dbl) (chr)     (fctr)     (dbl)
    1          1    ES 2013/01/01  6.909618
    2          1    ES 2014/01/14  7.780812
    3          1    ES 2015/02/02 10.936481
    4          2    MG 2013/01/01  4.786181
    5          2    MG 2014/01/14  7.387037
    6          2    MG 2015/02/02 12.366815
    7          3    MG 2013/01/01  5.113881
    8          3    MG 2014/01/14  7.910254
    9          3    MG 2015/02/02  9.548679
    10         4    MG 2013/01/01  6.801137
    ..       ...   ...        ...       ...

extract
-------

    monkey_wt %<>%
      extract(date, c("year", "month"), "(\\d+)/(\\d+)")

    monkey_wt

    Source: local data frame [60 x 5]

       id_number state  year month    weight
           (dbl) (chr) (chr) (chr)     (dbl)
    1          1    ES  2013    01  6.909618
    2          1    ES  2014    01  7.780812
    3          1    ES  2015    02 10.936481
    4          2    MG  2013    01  4.786181
    5          2    MG  2014    01  7.387037
    6          2    MG  2015    02 12.366815
    7          3    MG  2013    01  5.113881
    8          3    MG  2014    01  7.910254
    9          3    MG  2015    02  9.548679
    10         4    MG  2013    01  6.801137
    ..       ...   ...   ...   ...       ...

unite
-----

    monkey_wt %>% unite(date, year:month, sep = "/")

    Source: local data frame [60 x 4]

       id_number state    date    weight
           (dbl) (chr)   (chr)     (dbl)
    1          1    ES 2013/01  6.909618
    2          1    ES 2014/01  7.780812
    3          1    ES 2015/02 10.936481
    4          2    MG 2013/01  4.786181
    5          2    MG 2014/01  7.387037
    6          2    MG 2015/02 12.366815
    7          3    MG 2013/01  5.113881
    8          3    MG 2014/01  7.910254
    9          3    MG 2015/02  9.548679
    10         4    MG 2013/01  6.801137
    ..       ...   ...     ...       ...

transpose a data.frame
----------------------

    monkey_wt %>% 
      filter(state == "ES") %>% 
      spread(id_number, weight)

    Source: local data frame [3 x 13]

      state  year month         1         6        7         8        10
      (chr) (chr) (chr)     (dbl)     (dbl)    (dbl)     (dbl)     (dbl)
    1    ES  2013    01  6.909618  3.756489 4.778810  5.489443  4.490063
    2    ES  2014    01  7.780812  6.720004 3.465705  7.908120  8.682786
    3    ES  2015    02 10.936481 10.477636 9.165969 12.325428 12.717395
    Variables not shown: 11 (dbl), 13 (dbl), 14 (dbl), 15 (dbl), 16 (dbl)

------------------------------------------------------------------------

[Rstudio's data manipulation cheat
sheet](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
