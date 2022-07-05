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
  transmute(Preço = paste(Moeda,Preço)) %>%
  mutate(Preço = gsub("R\\$","",Preço)) %>%
  mutate(Preço = as.numeric(gsub(",",".",Preço)))
nomes <- steam %>%
  html_elements(".title") %>%
  html_text()
tabela_ofertas <- data.frame(Nome=c(nomes),Preço=c(precos)) %>%
  as.tibble() %>%


write.table(tabela_ofertas, 'ofertas.csv',sep = "," , row.names = FALSE)

nov_nomes <- novidades %>%
  html_elements(".tab_item_name") %>%
  html_text2()
nov_precos <- novidades %>%
  html_elements("div#tab_newreleases_content") %>%
  html_elements("div.discount_final_price") %>%
  html_text2()%>%
  as.tibble() %>%
  transmute(Preço = gsub("R\\$","", value)) %>%
  mutate(Preço = gsub(",",".",Preço)) %>%
  mutate(Preço = gsub("Free","0.00",Preço)) %>%
  mutate(Preço = gsub("To Play","",Preço)) %>%
  mutate(Preço = as.numeric(gsub("to Play","",Preço)))
tabela_novidades_populares <- data.frame(Nome=c(nov_nomes),Preço=c(nov_precos)) %>%
  as.tibble()
write.table(tabela_novidades_populares, file = 'novidades.csv',sep = "," , row.names = FALSE)
