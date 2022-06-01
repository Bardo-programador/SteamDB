library(rvest)
library(tidyverse)
library(dplyr)
library(stringr)
maior_preco <- read_html("https://steamcommunity.com/market/search?q=#p1_price_desc")
mercado <-read_html("https://steamcommunity.com/market/")

nome_mercado <- mercado %>%
  html_elements(".market_listing_item_name") %>%
  html_text2()

preco_mercado <- mercado %>%
  html_elements(".market_table_value") %>%
  html_elements("span.normal_price") %>%
  html_text2()

quantidade_mercado <- mercado %>%
  html_elements(".market_listing_num_listings_qty") %>%
  html_text2()


tabela_mercado <- tibble(Nome=c(nome_mercado),
                            Quantidade=c(quantidade_mercado),
                            Preço=c(preco_mercado))
tabela_mercado

