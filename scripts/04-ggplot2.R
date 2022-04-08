# Carregar pacotes --------------------------------------------------------

library(tidyverse)

# Ler base IMDB -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

imdb <- imdb %>%
  mutate(lucro = receita - orcamento)


# Gráfico de pontos (dispersão) -------------------------------------------

# Apenas o canvas
imdb %>% 
  ggplot()

# Salvando em um objeto
p <- imdb %>% 
  ggplot()

# Gráfico de dispersão da receita contra o orçamento
imdb %>% 
  ggplot() + # ATENÇÃO, NÃO USAR PIPE DEPOIS DE ggplot()
  geom_point(aes(x = orcamento, y = receita))


# Inserindo a reta x = y
imdb %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita)) +
  geom_abline(intercept = 0, slope = 1, color = "red")

# uma linha reta!
imdb %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita)) +
  geom_abline(intercept = 1000000000, slope = 0, color = "red")



# Observe como cada elemento é uma camada do gráfico.
# Agora colocamos a camada da linha antes da camada
# dos pontos.
imdb %>%
  ggplot() +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  geom_point(aes(x = orcamento, y = receita))

# Atribuindo a variável lucro aos pontos
imdb %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucro))
# color = contorno. 

# Categorizando o lucro antes
imdb %>%
  mutate(
    lucrou = ifelse(lucro <= 0, "Não", "Sim")
  ) %>% 
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucrou))

# Salvando um gráfico em um arquivo
dir.create("graficos_exportados")


imdb %>%
  mutate(
    lucrou = ifelse(lucro <= 0, "Não", "Sim")
  ) %>%
  ggplot() +
  geom_point(aes(x = orcamento, y = receita, color = lucrou))

ggsave("graficos_exportados/meu_grafico.png")


# Filosofia ---------------------------------------------------------------

# Um gráfico estatístico é uma representação visual dos dados 
# por meio de atributos estéticos (posição, cor, forma, 
# tamanho, ...) de formas geométricas (pontos, linhas,
# barras, ...). Leland Wilkinson, The Grammar of Graphics

# Layered grammar of graphics: cada elemento do 
# gráfico pode ser representado por uma camada e 
# um gráfico seria a sobreposição dessas camadas.
# Hadley Wickham, A layered grammar of graphics 

# Gráfico de linhas -------------------------------------------------------

# Nota média dos filmes ao longo dos anos

imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

# Número de filmes por ano 

imdb %>% 
  filter(!is.na(ano), ano != 2020) %>% 
  group_by(ano) %>% 
  summarise(num_filmes = n()) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes)) 

# Nota média do Robert De Niro por ano
imdb %>%
  filter(str_detect(elenco, "Robert De Niro")) %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media))

# Colocando pontos no gráfico
imdb %>% 
  filter(str_detect(elenco, "Robert De Niro")) %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  geom_point(aes(x = ano, y = nota_media))

# Reescrevendo de uma forma mais agradável
imdb %>% 
  filter(str_detect(elenco, "Robert De Niro")) %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_point()

# Colocando as notas no gráfico
imdb %>% 
  filter(str_detect(elenco, "Robert De Niro")) %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  mutate(nota_media = round(nota_media, 1)) %>% 
  ggplot(aes(x = ano, y = nota_media)) +
  geom_line() +
  geom_label(aes(label = nota_media))


# Gráfico de barras -------------------------------------------------------

# Número de filmes das pessoas que dirigiram filmes na base
imdb %>% 
  count(direcao) %>%
  # top_n(10, n) %>% essa funcao está se aposentando
  slice_max(n, n = 10) %>% # essa funcao é a mais indicada agora!
  ggplot() +
  geom_col(aes(x = direcao, y = n))



# o geom bar existe mas só aceita 1 atributo x ou y!
# cuidado para nao confundir!
diretores_top10 <- imdb %>% 
  count(direcao) %>%
  # top_n(10, n) %>% essa funcao está se aposentando
  slice_max(n, n = 10) %>% 
  pull(direcao)

imdb %>% 
  filter(direcao %in% diretores_top10) %>% 
  ggplot() +
  geom_bar(aes(x = direcao))

# voltando no geom_col...
# Tirando NA e pintando as barras
imdb %>% 
  count(direcao) %>% 
  filter(!is.na(direcao)) %>% 
  slice_max(n, n = 10) %>%
  ggplot() +
  geom_col(
    # dentro do aes: variáveis da nossa base!
    aes(x = direcao, y = n, fill = direcao), # fill é a cor do preenchimento
    color = "black", # cor da borda
    show.legend = FALSE
  )

imdb %>% 
  count(direcao) %>% 
  filter(!is.na(direcao)) %>% 
  slice_max(n, n = 10) %>%
  ggplot() +
  geom_col(
    aes(x = direcao, y = n), 
    color = "black", # cor da borda
    fill = "lightblue",# fill é a cor do preenchimento 
    # fora do aes todo mundo fica com a mesma cor!
    show.legend = FALSE
  )

# exemplo com escala de cores
imdb %>% 
  count(direcao) %>% 
  filter(!is.na(direcao)) %>% 
  slice_max(n, n = 10) %>%
  ggplot() +
  geom_col(
    # dentro do aes: variáveis da nossa base!
    aes(x = direcao, y = n, fill = direcao), # fill é a cor do preenchimento
    color = "black", # cor da borda
    show.legend = FALSE
  ) +
  scale_fill_viridis_d()

# mapeando as cores! ---
# fill = preencher (pintar dentro) do geom
# color = é o contorno! também é util pra grafico de pontos e linha.

# eles podem ser usados dentro ou fora do aes().
# se for dentro, a gente usa para mapear uma variável/coluna
# se for fora do aes, a gente usa a mesma cor para todos os elementos

# Invertendo as coordenadas
imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  top_n(10, n) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao),
    show.legend = FALSE
  ) 
  

# Ordenando as barras
imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  top_n(10, n) %>%
  mutate(
    direcao = forcats::fct_reorder(direcao, n)
  ) %>%
  #arrange(direcao)
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao),
    show.legend = FALSE
  ) 

# Colocando label nas barras
top_10_direcao <- imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  top_n(10, n) 

top_10_direcao %>%
  mutate(
    direcao = forcats::fct_reorder(direcao, n)
  ) %>% 
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao),
    show.legend = FALSE
  ) +
  geom_label(aes(x = n/2, y = direcao, label = n)) 


# Histogramas e boxplots --------------------------------------------------

# Histograma do lucro dos filmes do Steven Spielberg 
imdb %>% 
  filter(direcao == "Steven Spielberg") %>%
  ggplot() +
  geom_histogram(aes(x = lucro))

# Arrumando o tamanho das bases
imdb %>%
 filter(direcao == "Steven Spielberg") %>%
  mutate(lucro_milhoes = lucro/1000000) %>% 
  ggplot() +
  geom_histogram(aes(x = lucro_milhoes),
                binwidth = 200,
                 color = "white",
                 fill = "lightgreen") + 
  theme_classic()

# Com R base - todos os filmes!
hist(imdb$lucro)

# Boxplot do lucro dos filmes das pessoas que dirigiram
# mais de 15 filmes que sabemos informacao sobre o lucro!
imdb %>% 
  tidyr::drop_na(direcao, lucro) %>% 
  group_by(direcao) %>% 
  filter(n() >= 15) %>%  # exemplo de como o filter respeita o group_by
  ungroup() %>% #desagrupa
 # mutate(lucro = receita - orcamento) %>% 
  ggplot() +
  geom_boxplot(aes(y = direcao, x = lucro))

# Ordenando pela mediana

imdb %>% 
tidyr::drop_na(direcao, lucro) %>% 
  group_by(direcao) %>% 
  filter(n() >= 15) %>%  # exemplo de como o filter respeita o group_by
  ungroup() %>% 
  mutate(
    lucro = receita - orcamento,
    direcao = forcats::fct_reorder(direcao, lucro, na.rm = TRUE)
  ) %>% 
  ggplot() +
  geom_boxplot(aes(y = direcao, x = lucro), 
               outlier.color = "red", 
               outlier.alpha = 0.5)

# Remover os outliers do boxplot
imdb %>% 
  tidyr::drop_na(direcao, lucro) %>% 
  group_by(direcao) %>% 
  filter(n() >= 15) %>%  # exemplo de como o filter respeita o group_by
  ungroup() %>% 
  mutate(
    lucro = receita - orcamento,
    direcao = forcats::fct_reorder(direcao, lucro, na.rm = TRUE)
  ) %>% 
  ggplot() +
  geom_boxplot(aes(y = direcao, x = lucro), outlier.shape = NA)

# Título e labels ---------------------------------------------------------

# Labels
imdb %>%
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita, color = lucro)) +
  labs(
     x = "Orçamento ($)",
     y = "Receita ($)",
     color = "Lucro ($)",
     
     # opcoes gerais que podem ser usadas em todos os gráficos
    title = "Gráfico de dispersão",
    subtitle = "Receita vs Orçamento",
    caption = "Fonte: imdb.com"
  )

# outro exemplo - usando a função expression()

imdb %>% 
  ggplot() + 
  geom_point(aes(x = orcamento, y = receita)) +
  labs(x = expression(Área~(m^2)),
       y = expression(R[2]))


# Escalas
imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1890, 2030, 20)) +
  scale_y_continuous(breaks = seq(0, 10, 1))

# Visão do gráfico
imdb %>% 
  group_by(ano) %>% 
  summarise(nota_media = mean(nota_imdb, na.rm = TRUE)) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = nota_media)) +
  scale_x_continuous(breaks = seq(1890, 2030, 10)) +
  scale_y_continuous(breaks = seq(0, 10, 2)) +
  coord_cartesian(ylim = c(0, 10), xlim = c(1900,2022))

# Cores -------------------------------------------------------------------

# Escolhendo cores pelo nome
imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  top_n(5, n) %>%
  mutate(direcao = forcats::fct_reorder(direcao, n)) %>% 
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao), 
    show.legend = FALSE
  ) +
  scale_fill_manual(values = c("darkturquoise", "royalblue", "purple", "salmon", "darkred"))
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

# Escolhendo pelo hexadecimal
imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  top_n(5, n) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao), 
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c("#0586AD", "#4CC2E6", "#07AEE0", "#4A6770", "#0586AD")
  )

# viridis - paleta de cores acessível
imdb %>% 
  count(direcao) %>%
  filter(!is.na(direcao)) %>% 
  top_n(5, n) %>%
  ggplot() +
  geom_col(
    aes(x = n, y = direcao, fill = direcao), 
    show.legend = FALSE
  ) +
  scale_fill_viridis_d(option = "D")



# Mudando textos da legenda
imdb %>% 
  select(ano, titulo, nota_imdb) %>% 
  mutate(sucesso_nota = case_when(nota_imdb >= 7 ~ "sucesso_nota_imbd",
                                  TRUE ~ "sem_sucesso_nota_imdb")) %>%
  group_by(ano, sucesso_nota) %>% 
  summarise(num_filmes = n()) %>% 
  ggplot() +
  geom_line(aes(x = ano, y = num_filmes, color = sucesso_nota)) +
  scale_color_discrete(labels = c("Nota menor que 7", "Nota maior ou igual à 7"))

# Definiando cores das formas geométricas
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita), color = "#1B405E")

# Tema --------------------------------------------------------------------

# Temas prontos
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
   theme_bw() 
  # theme_light()
  # theme_classic() 
  # theme_dark()
  # theme_minimal()
  # theme_void()
  
  

# A função theme()
imdb %>% 
  ggplot() +
  geom_point(mapping = aes(x = orcamento, y = receita)) +
  labs(
    title = "Gráfico de dispersão ",
    subtitle = "Receita vs Orçamento"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, 
                              colour = "red",
                              size = 15,
                              family = "Star Jedi"
                              ),
    plot.subtitle = element_text(hjust = 0.5)
  ) 


# Mais conteúdo sobre a função theme() no curso de
# visualizacao de dados
# https://loja.curso-r.com/visualizac-o-de-dados.html

# uso dos :: 
dplyr::count(imdb, direcao)
stats::median(imdb$nota_imdb)
datasets::airquality
magrittr::`%>%`(imdb, count(direcao))
