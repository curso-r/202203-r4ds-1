# Pacotes -----------------------------------------------------------------

library(tidyverse)
library(dplyr) # esse é o pacote que vamos usar hoje!

# Base de dados -----------------------------------------------------------

# install.packages("devtools")
# devtools::install_github("curso-r/basesCursoR")

# Quais são as bases disponíveis no basesCursoR?
basesCursoR::bases_disponiveis()

# Salvar a base imdb em um objeto
imdb <- basesCursoR::pegar_base("imdb")

# PERGUNTA 1 -------
# Objetivo: descobrir qual o filme mais caro, 
# mais lucrativo e com melhor nota dos anos 2010

filmes_decada_2010 <- imdb %>% 
  filter(ano %in% 2010:2019,
         num_avaliacoes >= 10000) %>% 
  mutate(orcamento_milhoes = orcamento / 1000000,
         lucro = receita - orcamento,
         lucro_milhoes =  lucro / 1000000)


# filme mais caro
filmes_decada_2010 %>% 
  filter(orcamento == max(orcamento, na.rm = TRUE)) %>% 
  select(titulo_original, orcamento_milhoes)

# filme mais lucrativo 
filmes_decada_2010 %>% 
  filter(lucro == max(lucro, na.rm = TRUE)) %>% 
  select(titulo_original, lucro_milhoes)

# filme com a melhor nota

filmes_decada_2010 %>% 
  filter(nota_imdb == max(nota_imdb)) %>% 
  arrange(desc(num_avaliacoes)) %>% 
  slice(1) %>% 
  select(titulo_original, nota_imdb, num_avaliacoes)

# a mesma coisa com slice_max()!
filmes_decada_2010 %>%
  slice_max(nota_imdb, n = 1) %>%
  slice_max(num_avaliacoes, n = 1)


# outros usos de slice!
filmes_decada_2010 %>%
  slice_min(nota_imdb, n = 1) %>% View()

filmes_decada_2010 %>%
  slice_max(nota_imdb, n = 1) %>% 
  rowid_to_column() %>% 
  filter(rowid == 2)

filmes_decada_2010 %>% 
  slice_head(n = 5)

filmes_decada_2010 %>% 
  slice_tail(n = 5)

# exemplo para a próxima prática!
# O EXEMPLO ABAIXO FOI FEITO NA AULA 5 - 28/03
## Fazendo para todas as décadas ##
# filmes com mais de dez mil avaliações

imdb_por_decadas <- imdb %>% 
  filter(!is.na(ano), num_avaliacoes > 10000) %>% 
  mutate(decada = floor(ano/10)*10, .after = ano,
         orcamento_milhoes = orcamento / 1000000,
         lucro = receita - orcamento,
         lucro_milhoes =  lucro / 1000000)
  
# filme mais caro
imdb_por_decadas %>% 
  group_by(decada) %>% 
  filter(orcamento == max(orcamento, na.rm = TRUE)) %>% 
  select(titulo_original, orcamento, decada) %>% 
  arrange(decada)

# filme mais lucrativo
imdb_por_decadas %>% 
  group_by(decada) %>% 
  filter(lucro == max(lucro, na.rm = TRUE)) %>% 
  select(titulo_original, lucro, decada) %>% 
  arrange(decada)

# filme com maior nota
imdb_por_decadas %>% 
  group_by(decada) %>% 
  filter(nota_imdb == max(nota_imdb, na.rm = TRUE)) %>% 
  select(titulo_original, nota_imdb, decada) %>% 
  arrange(decada)
