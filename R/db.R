library(rvest)
library(tidyverse)
library(dplyr)
library(stringr)

steam <- read_html("https://store.steampowered.com/search/?filter=topsellers&specials=1")

precos<- steam %>%
  html_elements("div.search_price") %>%
  html_text2 %>%
  strsplit(split=" ") %>%
  repair_names() %>%
  as.data.frame() %>%
  as.tibble()%>%
  slice(4) %>%
  gather(Moeda, Preços) %>%
  transmute(Preço = Preços)

nomes <- steam %>%
  html_elements(".title") %>%
  html_text()
tabela <- data.frame(Nome=c(nomes),Preço=c(precos)) %>%
  as.tibble()
tabela
