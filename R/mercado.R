library(rvest)
library(tidyverse)
library(dplyr)
library(stringr)
mercado <-read_html("https://steamcommunity.com/market/")

nome_mercado <- mercado %>%
  html_elements(".market_listing_item_name") %>%
  html_text2()

preco_mercado <- mercado %>%
  html_elements(".market_table_value") %>%
  html_elements("span.normal_price") %>%
  html_text2() %>%
  strsplit(split = " ") %>%
  repair_names() %>%
  as.tibble() %>%
  slice(1) %>%
  gather(Moeda, Preços) %>%
  transmute(Preço = paste0(Preços))


quantidade_mercado <- mercado %>%
  html_elements(".market_listing_num_listings_qty") %>%
  html_text2()


tabela_mercado <- data.frame(Nome=c(nome_mercado),
                         Quantidade=c(quantidade_mercado),
                         Preco=c(preco_mercado)) %>%
  as_tibble()
write.table(tabela_mercado, 'mercado.csv',sep = "," , row.names = FALSE)


