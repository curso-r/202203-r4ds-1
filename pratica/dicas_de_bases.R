# projeto base dos dados ------
# O base dos dados tem bases grandes e "da vida real!"
# https://staging.basedosdados.org/dataset?resource_type=bdm_table&order_by=score

# https://blog.curso-r.com/posts/2021-05-28-basedosdados/
# https://www.youtube.com/watch?v=8D4jK-YCxLU&t=2688s

#  pacote dados -------
#
# install.packages("dados")
library(dados)
dados::dados_starwars %>% View()

dados::pinguins %>% View()
dados::pixar_bilheteria %>% View()
dados::pixar_filmes %>% View()


# pacote da Curso-R

# install.packages("devtools")
# devtools::install_github("curso-r/basesCursoR")

# Quais são as bases disponíveis no basesCursoR?
basesCursoR::bases_disponiveis()

# Salvar a base em um objeto
airbnb_rj <- basesCursoR::pegar_base("airbnb_rj")

# Kaggle ----
# https://www.kaggle.com/datasets

# R base ------
datasets::airquality

# tidytuesday ---
# https://github.com/rfordatascience/tidytuesday#datasets

jogos_ratings <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-25/ratings.csv')
jogos_details <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-01-25/details.csv')
