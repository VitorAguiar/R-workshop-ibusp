library(magrittr)
library(data.table)
library(dplyr)
library(tidyr)
library(readr)
library(seqinr)
library(stringr)

# read directly from the web
# Gencode mouse gene annotation file
# this takes 1.7Gb of RAM on my Mac laptop
ftp_gtf <- "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M7/gencode.vM7.annotation.gtf.gz"
mouse_annot <- read_delim(ftp_gtf, delim = "\t", comment = "##", col_names = FALSE) 
head(mouse_annot)

# Mouse transcripts fasta
ftp_fasta <- "ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_mouse/release_M7/gencode.vM7.transcripts.fa.gz"
download.file(ftp_fasta, destfile = "data/mouse_transcripts.fasta.gz")

mouse_seqs <- read.fasta("data/mouse_transcripts.fasta.gz", forceDNAtolower = FALSE,
                         as.string = TRUE, set.attributes = FALSE)
length(mouse_seqs)
mouse_seqs[1]

idx <- str_detect(mouse_seqs, "AAGGAAAGAGGATAA") %>% which()
str_locate(mouse_seqs, "AAGGAAAGAGGAT") %>% .[idx, ]

seq_lengths <- data_frame(seq_name = str_extract(names(mouse_seqs), "[^|]+"),
                          seq_len = str_count(mouse_seqs))

seq_lengths

# Mouse vcf file
## To download the data, open this URL in your browser:
## https://mega.nz/#!NoUzQALQ!jYgFWMQmFoLaM5v_ESaBEjJI7SoBJomPHtQv8EzIUOY

header <- 
  scan("data/mouse_500k_snps.vcf", what = "character", sep = "\n", nlines = 100) %>%
  .[grep("^##", .)]

mouse_vcf <- fread("data/mouse_500k_snps.vcf", header = TRUE, 
                   skip = length(header))

dim(mouse_vcf)

names(mouse_vcf)
class(mouse_vcf)

head(mouse_vcf)

mouse_vcf %<>% as_data_frame()

mouse_vcf

mouse_vcf %>% 
  count(`#CHROM`) %>% 
  arrange(desc(n))

mouse_vcf %>% 
  count(FILTER) %>% 
  arrange(desc(n))

mouse_vcf %<>% arrange(`#CHROM`, POS)

mouse_vcf %<>% filter(FILTER == "PASS")

mouse_vcf %<>% filter(ID != ".")

mouse_vcf %<>% select(`#CHROM`, POS, ID, `129P2`:WSBEiJ)

mouse_vcf %<>% mutate_each(funs(. %>% str_extract("^\\d/\\d")), `129P2`:WSBEiJ)

mouse_vcf %>% count(`129P2`)

mouse_vcf %<>% gather(individual, genotype, `129P2`:WSBEiJ)

mouse_vcf

mouse_vcf %>% 
  group_by(`#CHROM`, individual) %>% 
  summarise(n = mean(genotype == "0/0", na.rm = TRUE)) %>%
  arrange(desc(n))

mouse_vcf %>% 
  group_by(`#CHROM`) %>% 
  summarise(n = mean(is.na(genotype))) %>%
  arrange(desc(n))

library(ggplot2)
mouse_vcf %>% 
  group_by(`#CHROM`) %>% 
  summarise(n = mean(is.na(genotype))) %>%
  arrange(desc(n)) %>%
  ggplot(data = ., aes(x = factor(`#CHROM`, levels = c(1:22, "X")), y = n)) + 
  geom_bar(stat = "identity") +
  xlab("chromosome") +
  ylab("proportion of missing data")

mouse_vcf %>% 
  group_by(individual) %>% 
  summarise(n = mean(is.na(genotype))) %>%
  arrange(desc(n)) 

mouse_vcf %>%
  separate(genotype, into = c("allele_1", "allele_2"), sep = "/")

# remind the lapply used above
# with tidy data, we can do:

mouse_vcf %>% 
  count(individual, genotype)

mouse_vcf %>% 
  count(individual, genotype) %>% 
  spread(individual, n)

mouse_vcf %>% 
  count(individual, genotype) %>% 
  filter(!is.na(genotype)) %>% 
  spread(genotype, n)