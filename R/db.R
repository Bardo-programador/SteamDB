library(rvest)
library(tidyverse)
library(dplyr)
library(stringr)

steam <- read_html("https://store.steampowered.com/search/?filter=topsellers&specials=1")
novidades <- read_html("https://store.steampowered.com/explore/new/")

precos<- steam %>%
  html_elements("div.search_price") %>%
  html_text2 %>%
  strsplit(split=" ") %>%
  repair_names() %>%
  as.data.frame() %>%
  as.tibble()%>%
  slice(4) %>%
  gather(Moeda, Preços) %>%
  mutate(Moeda = "R$",Preço = Preços
         ) %>%
  transmute(Preço = paste(Moeda,Preço))
nomes <- steam %>%
  html_elements(".title") %>%
  html_text()
tabela_ofertas <- data.frame(Nome=c(nomes),Preço=c(precos)) %>%
  as.tibble()
write.table(tabela_ofertas, 'ofertas.csv',sep = "," , row.names = FALSE)

nov_nomes <- novidades %>%
  html_elements(".tab_item_name") %>%
  html_text2()
nov_precos <- novidades %>%
  html_elements("div#tab_newreleases_content") %>%
  html_elements("div.discount_final_price") %>%
  html_text2()
tabela_novidades_populares <- data.frame(Nome=c(nov_nomes),Preço=c(nov_precos)) %>%
    as.tibble()
write.table(tabela_novidades_populares, 'novidades.csv',sep = "," , row.names = FALSE)

  tabela_novidades_populares
  tabela_ofertas
