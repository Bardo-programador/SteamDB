library(rvest)
library(tidyverse)
library(dplyr)
library(stringr)

steam <- read_html("https://store.steampowered.com/search/?filter=topsellers&specials=1")

ofertas_especiais_precos <- steam %>%
  html_elements("div.search_price") %>%
  html_text2 %>%
  strsplit(split=" ") %>%
  repair_names()

precos <- as.tibble(ofertas_especiais_precos)%>%
  slice(4) %>%
  gather(Moeda, Preços) %>%
  transmute(Preço = Preços)

nomes <- steam %>%
  html_elements(".title") %>%
  html_text()
tabela <- data.frame(nomes=c(nomes),preços=c(precos)) %>%
  as.tibble()
tabela
