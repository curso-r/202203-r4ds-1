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

# exemplo do case_when() -------------

imdb %>% 
  mutate(
    seculo = case_when(
      # teste logico (retornar TRUE/FALSE) ~ O QUE QUEREMOS GUARDAR NA CÉLULA 
      # DA COLUNA CRIADA!
      ano %in% 1800:1899 ~ "Século 19",
      ano %in% 1900:1999 ~ "Século 20",
      ano %in% 2000:2099 ~ "Século 21",
      # o TRUE representa o que sobrou (nao caiu em nenhuma categoria anterior)
      TRUE ~ "Século desconhecido"
    ), .after = ano
  ) %>% 
  group_by(seculo) %>% 
  summarise(
    n_filmes = n(),
    media_notas = mean(nota_imdb, na.rm = TRUE),
    media_orcamento = mean(orcamento, na.rm = TRUE),
    mediana_orcamento = median(orcamento, na.rm = TRUE)
  )

# exemplo com join!
# install.packages("dados")
library(dados)
pixar_avalicao_publico %>% View()
pixar_bilheteria %>% View()
pixar_equipe %>% View()
pixar_generos %>% View()
pixar_oscars %>% View()


pixar_bilheteria %>% 
  left_join(pixar_avalicao_publico, by = "filme")

pixar_bilheteria_avaliacao <- pixar_bilheteria %>% 
  full_join(pixar_avalicao_publico, by = "filme")

pixar_oscar_bilheteria <- pixar_oscars %>% 
  full_join(pixar_bilheteria_avaliacao, by = "filme") 


pixar_oscar_bilheteria %>% 
  count(resultado)

pixar_oscar_vencedores <- pixar_oscar_bilheteria %>% 
  filter(resultado %in% c("Venceu", "Venceu Prêmio Especial"))

pixar_oscar_vencedores %>% 
  count(tipo_premio_indicado, sort = TRUE)


# exemplo esquisse
# install.packages("esquisse")
ggplot(pixar_oscar_vencedores) +
  aes(
    x = bilheteria_mundial,
    y = nota_critics_choice,
    colour = filme
  ) +
  geom_point(shape = "diamond", size = 1.5) +
  scale_color_hue(direction = 1) +
  theme_light() +
  facet_wrap(vars(tipo_premio_indicado))
