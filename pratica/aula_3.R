# antes de começar, vamos limpar a sessão!
# Session -> Restart R

## Objetivo: ler uma base,
# filtrar filmes com mais de dez mil avaliacoes!
# selecionar duas colunas (titulo e nota)
# ordenar por das variáveis (crescente e descrescente)
# e salvar a tabela em um arquivo excel!

library(tidyverse)
library(writexl)


imdb <- read_rds("dados/imdb.rds")

glimpse(imdb)

imdb_filtrado <- imdb %>% 
  filter(num_avaliacoes >= 10000) %>% 
  select(titulo, nota_imdb) 

imdb_filtrado %>%
  arrange(nota_imdb) %>% 
  write_xlsx("dados_exportados/imdb_nota_crescente.xlsx")

imdb_filtrado %>% 
  arrange(desc(nota_imdb)) %>% 
  write_xlsx("dados_exportados/imdb_nota_decrescente.xlsx")
  
# e se a gente quiser os 10 filmes com maiores notas?
# (e tendo mais do que 10 mil avaliacoes)

imdb_filtrado %>%
  arrange(desc(nota_imdb)) %>% 
  head(10) %>% 
  write_csv2("dados_exportados/top10filmes.csv")
  
# Sugestões da classe! -----------------------------------------
# filme com maior orçamento!

max(imdb$orcamento, na.rm = TRUE)

imdb %>% 
  select(titulo, orcamento) %>% 
  arrange(desc(orcamento)) %>% 
  filter(orcamento == max(orcamento, na.rm = TRUE))

imdb %>% 
  select(titulo, orcamento) %>% 
  arrange(desc(orcamento)) %>% 
  head(1)

imdb %>% 
  arrange(orcamento) %>% 
  view()

# filme com menor receita!

min(imdb$receita, na.rm = TRUE)


imdb %>% 
  select(titulo, receita, ano) %>% 
  arrange(receita) %>% 
  filter(receita == min(receita, na.rm = TRUE))


# filme que custou pouco, mas que lucrou muito!
imdb %>% 
  select(titulo, ano, receita, orcamento, nota_imdb) %>% 
  # criar colunas!
  mutate(lucro = receita - orcamento,
         orcamento_sobre_receita = orcamento/receita) %>% 
  drop_na(lucro) %>% # remover NAs!
  arrange(orcamento_sobre_receita) %>% 
  View()

# ---- pipe!

# com vetores
imdb$nota_imdb %>% 
  mean() %>% 
  round(1)

round(mean(imdb$nota_imdb),1)

round(5.55555, 1)


# Pergunta sobre os NAs aparecerem na exportação: 


imdb %>% 
  select(titulo, receita, orcamento) %>% 
  write_csv2("dados_exportados/exemplo_writetable.csv",
             na = "") 


