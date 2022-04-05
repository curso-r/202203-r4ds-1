# Exemplo do clean names
library(readxl)
library(tidyverse)
# install.packages("janitor")
library(janitor)

basedadosexecucao2022 <- read_excel("pratica/basedadosexecucao2022.xlsx")

base_prefeitura <- basedadosexecucao2022 %>% 
  clean_names()

names(basedadosexecucao2022)
names(base_prefeitura)

# Prática ----------

library(tidyverse)
library(readr)
mananciais <-
  read_delim(
    "https://github.com/beatrizmilz/mananciais/raw/master/inst/extdata/mananciais.csv",
    delim = ";",
    escape_double = FALSE,
    locale = locale(decimal_mark = ",",
                    grouping_mark = "."),
    trim_ws = TRUE
  )
View(mananciais)

mananciais <- mananciais %>% 
  mutate(data = lubridate::as_date(data),
         ano = lubridate::year(data))

dplyr::glimpse(mananciais)

# niveis dos reservatorios

data_atualizacao <- max(mananciais$data) %>% format("%d/%m/%Y")

plot_mananciais <- mananciais %>% 
  filter(ano == 2022) %>% 
  ggplot() +
  geom_line(aes(x = data, y = volume_porcentagem, color = sistema)) + 
  scale_y_continuous(breaks = c(0, 25, 50, 75, 100, 125), limits = c(0, 105))+ 
  labs(x = "Mês", y = "Volume operacional (%)", color = "Sistema",
      title = "Volume operacional em 2022",
      subtitle = "Sistemas de abastecimento da RMSP operados pela SABESP",
      caption = paste0("Fonte: Dados do site mananciais SABESP, \n atualizados até ",
                       data_atualizacao)
      ) + 
  theme_classic() +
  theme(
    legend.position = "bottom",
    text = element_text(family = "Star Jedi", size = 10)
  )
  
plot_mananciais

# exemplo de como salvar o gráfico mudando o tamanho!
ggsave(filename = "graficos_exportados/grafico_mananciais.png",
  plot = plot_mananciais)

ggsave(filename = "graficos_exportados/grafico_mananciais2.png",
       plot = plot_mananciais,
       dpi = 600,
       width = 7,
       height = 5)

# filename é onde salva
# plot é o grafico
# width é largura
# height é altura


# dúvidas ggplot2/prática

# Como eu posso mudar o nome dos eixos "Orçamento" com "ç"  do gráfico 
# sem alterar o banco de dados?

imdb %>% 
  mutate(#receita_milhoes = receita/1000000,
         receita_milhoes = receita/1e6,
         orcamento_milhoes = orcamento/1000000) %>% 
  ggplot() + # ATENÇÃO, NÃO USAR PIPE DEPOIS DE ggplot()
  geom_point(aes(x = orcamento_milhoes, y = receita_milhoes, color = lucro)) +
  labs(x = "Orçamento (em milhões de $)", 
       y = "Receita (em milhões de $)", 
       color = "Lucro",
       title = "Gráfico de dispersão: Orçamento e receita",
       subtitle = "De filmes entre 1984 até 2020",
       caption = "Fonte: Dados extraídos do site IMDB"
       ) #+
  # scale_y_continuous(labels = scales::dollar) +
  # scale_x_continuous(labels = scales::dollar)

# É possível escrever valores no código com notação cientifica?

imdb %>% 
  ggplot() + # ATENÇÃO, NÃO USAR PIPE DEPOIS DE ggplot()
  geom_point(aes(x = orcamento, y = receita)) +
  labs(x = expression(Área~(m^2)),
       y = expression(R[2])
      # y = expression(sigma,
      #               lambda,
      #                 omega )
    
        )


# é possível denotar 1 milhão como "1 mi" e 1 bilhão como "1 bi". 
# Ou melhor, dá pra personalizar?
imdb %>% 
  group_by(ano) %>% 
  summarise(receita_media = mean(receita, na.rm = TRUE)) %>% 
  mutate(receita_media_milhoes = receita_media/1000000) %>%
  ggplot() +
  geom_line(aes(x = ano, y = receita_media_milhoes)) + 
  scale_y_continuous(label = function(x) paste0(x, " mi"))

# Como distanciar o titulo do eixo y ou x?

# usando \n
imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  theme_minimal() + 
  labs(y = "Nota média \n", x = "\n Ano")

# usando a funcao theme() - (e olhando na documentacao!)
library(ggplot2)
imdb %>%
  group_by(ano) %>%
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>%
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  theme_minimal() +
  theme(axis.title.x = element_text(margin = margin(t = 10)),
        axis.title.y = element_text(margin = margin(r = 10))
        )

# bom livro!
# https://ggplot2-book.org/index.html



# preciso fazer um gráfico assim (dispersao com uma reta) pro trabalho e 
# nomear os pontos  que ficaram acima da reta :)


# A gente pode escolher a cor do fill dentro do aes?