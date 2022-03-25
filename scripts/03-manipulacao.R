# Pacotes -----------------------------------------------------------------

library(tidyverse)
library(dplyr) # esse é o pacote que vamos usar hoje!

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

# Jeito de ver a base -----------------------------------------------------

glimpse(imdb)
names(imdb)
View(imdb)


drop_na(imdb)
# equivale à: 
imdb %>% drop_na()

# dplyr: 6 verbos principais
# select()    # seleciona colunas do data.frame
# arrange()   # reordena as linhas do data.frame
# filter()    # filtra linhas do data.frame
# mutate()    # cria novas colunas no data.frame (ou atualiza as colunas existentes)
# summarise() + group_by() # sumariza o data.frame
# left_join   # junta dois data.frames

# select ------------------------------------------------------------------

# Selcionando uma coluna da base

select(imdb, titulo)

# A operação NÃO MODIFICA O OBJETO imdb

imdb

# Selecionando várias colunas

select(imdb, titulo, ano, orcamento)

# o select respeita a ordem!

select(imdb, ano, orcamento, titulo)

# o operador : ajuda a selecionar as sequencias!
select(imdb, titulo:generos)

# Funções auxiliares

select(imdb, starts_with("num")) # comece com

select(imdb, ends_with("cao"))

select(imdb, contains("cri"))

# Principais funções auxiliares

# starts_with(): para colunas que começam com um texto padrão
# ends_with(): para colunas que terminam com um texto padrão
# contains():  para colunas que contêm um texto padrão

# Selecionando colunas por exclusão

select(imdb, -titulo)

select(imdb, -starts_with("num"), -titulo, -ends_with("ao"))

# não funciona bem: misturar regras de inclusão e exclusão!
# select(imdb, -titulo, ano )
# select(imdb, ano, -titulo)

# arrange -----------------------------------------------------------------

notas_dos_filmes <- select(imdb, titulo, nota_imdb)

arrange(notas_dos_filmes, nota_imdb) # por padrão é crescente!

arrange(notas_dos_filmes, desc(nota_imdb))

# Ordenando linhas de forma crescente de acordo com 
# os valores de uma coluna

arrange(imdb, ano) # os NAs ficam no final (valores faltantes!)

# Agora de forma decrescente

arrange(imdb, desc(ano))

# Ordenando de acordo com os valores 
# de duas colunas

View(arrange(imdb, desc(ano), orcamento))

# ordenando textos - por padrão teremos ordem
# alfabética!
arrange(imdb, titulo)
arrange(imdb, desc(titulo))

# O que acontece com o NA?

df <- tibble(x = c(NA, 2, 1),
             y = c(1, 2, 3))
arrange(df, x)
arrange(df, desc(x))
# O NA sempre fica ao final!

# Pipe (%>%) --------------------------------------------------------------

notas_dos_filmes <- select(imdb, titulo, nota_imdb)

arrange(notas_dos_filmes, nota_imdb) # por padrão é crescente!

arrange(notas_dos_filmes, desc(nota_imdb))

# outra forma sem criar o objeto

View(
  arrange(
    select(imdb, titulo, nota_imdb),
    desc(nota_imdb)
  )
)

# |>  é o pipe do R base
# %>% é o pipe do tidyverse! esse veio primeiro :D


# Transforma funçõe aninhadas em funções
# sequenciais

# g(f(x)) = x %>% f() %>% g()

x %>% f() %>% g()   # CERTO
x %>% f(x) %>% g(x) # ERRADO

# Receita de bolo sem pipe. 
# Tente entender o que é preciso fazer.

esfrie(
  asse(
    coloque(
      bata(
        acrescente(
          recipiente(
            rep(
              "farinha", 
              2
            ), 
            "água", "fermento", "leite", "óleo"
          ), 
          "farinha", até = "macio"
        ), 
        duração = "3min"
      ), 
      lugar = "forma", tipo = "grande", untada = TRUE
    ), 
    duração = "50min"
  ), 
  "geladeira", "20min"
)

# Veja como o código acima pode ser reescrito 
# utilizando-se o pipe. 
# Agora realmente se parece com uma receita de bolo.

recipiente(rep("farinha", 2), "água", "fermento", "leite", "óleo") %>%
  acrescente("farinha", até = "macio") %>%
  bata(duração = "3min") %>%
  coloque(lugar = "forma", tipo = "grande", untada = TRUE) %>%
  asse(duração = "50min") %>%
  esfrie("geladeira", "20min")

# ATALHO DO %>%: CTRL (command) + SHIFT + M : %>% 
# antes do pipe
View(arrange(select(imdb, titulo, nota_imdb),
             desc(nota_imdb)))

# depois do pipe! fica melhor para ler!

imdb %>%
  select(titulo, nota_imdb) %>%
  arrange(desc(nota_imdb)) %>%
  View()


# atalhos para formatar o código:
# CTRL + SHIFT + A
# ou usar o pacote styler: install.packages("styler")
# selecionar o código e usar o addin "Style Selection"

# exemplo <- tibble(x = c(1, 2, 3), y = c(4, 5, 6))

# Conceitos importantes para filtros! --------------------------------------

## Comparações lógicas -------------------------------

x <- 1 

# Testes com resultado verdadeiro
x == 1
"a" == "a"

# Testes com resultado falso
x == 2
"a" == "b"

# Maior
x > 3
x > 0

# Maior ou igual
x > 1
x >= 1

# Menor
x < 3
x < 0

# Menor ou igual
x < 1
x <= 1

# Diferente
x != 1
x != 2

# operador %in% - super útil!
x %in% c(1, 2, 3)
"a" %in% c("b", "c")

2022 %in% c(imdb$ano) # 2022 faz parte desse conjunto? 
# tem filme de 2022 na base?

2012 %in% c(imdb$ano)

"Matt Reeves" %in% c(imdb$direcao)

"Domee Shi" %in% c(imdb$direcao)

## Operadores lógicos -------------------------------

## & - E - Para ser verdadeiro, os dois lados 
# precisam resultar em TRUE

x <- 5
x >= 3 & x <=7
# TRUE & TRUE = TRUE


y <- 2
y >= 3 & y <= 7
# FALSE & TRUE = FALSE

## | - OU - Para ser verdadeiro, apenas um dos 
# lados precisa ser verdadeiro

y <- 2
y >= 3 | y <=7
# FALSE | TRUE = TRUE

y <- 1
y >= 3 | y == 0
# FALSE | FALSE = FALSE

## ! - Negação - É o "contrário": o que é verdadeiro vira falso, 
# e vice-e-versa!

!TRUE

!FALSE

w <- 5
(!w < 4)


# negar o in:
!"a" %in% c("b", "c")

# vai ser util nos filtros
x <- c(1, 2, 3, NA)
is.na(x)
!is.na(x)


# filter ------------------------------------------------------------------

# Filtrando uma coluna da base

imdb_recortado <- imdb %>% 
  select(titulo, direcao, nota_imdb, num_avaliacoes) %>% 
  drop_na()

imdb_recortado %>%
  filter(direcao == "Quentin Tarantino")

# mostrar exemplo do detect!

imdb_recortado %>% filter(nota_imdb > 9)
imdb_recortado %>% filter(num_avaliacoes > 10000)

# filtrando com & - basta usar a vírgula!
imdb_recortado %>% 
  filter(num_avaliacoes > 100000,
         nota_imdb >= 9) %>% 
  arrange(desc(nota_imdb))

# filtrando com OU |
imdb_recortado %>% 
  filter(num_avaliacoes > 100000 |
         nota_imdb >= 9) %>% 
  arrange(desc(nota_imdb))


# Vendo categorias de uma variável
unique(imdb$pais) # saída é um vetor
imdb %>% distinct(pais) # saída é uma tibble

# detect
# install.packages("devtools")
# devtools::install_github("curso-r/basesCursoR")
imdb_original <- basesCursoR::pegar_base("imdb")

imdb_original %>% 
  filter(pais == "Brazil") %>% View()

imdb_original %>% 
  filter(str_detect(pais, "Brazil")) 

# str_view_all(imdb_original$pais, "Spain")

# Filtrando duas colunas da base

## Recentes e com nota alta
imdb %>% filter(nota_imdb >= 9, num_avaliacoes > 10000) %>% View()
imdb %>% filter(ano > 2010, nota_imdb > 8.5) %>% View()
imdb %>% filter(ano > 2010 & nota_imdb > 8.5) %>% View()

## Gastaram menos de 100 mil, faturaram mais de 1 milhão
imdb %>% filter(orcamento < 100000, receita > 1000000) %>% View()

## Lucraram
imdb %>% filter(receita - orcamento > 0) %>% View()

## Lucraram mais de 500 milhões OU têm nota muito alta
imdb %>% filter(receita - orcamento > 500000000 | nota_imdb > 9) %>% View()



# O operador %in%
# podemos fazer com OU |
imdb %>% 
  filter(direcao == "Matt Reeves" | 
           direcao == "Christopher Nolan" | 
           direcao == "Quentin Tarantino")

# mas com %in% fica mais elegante!
imdb %>% filter(direcao %in% c('Matt Reeves', 
                               "Christopher Nolan", 
                               "Quentin Tarantino")) %>% View()
imdb %>% 
  filter(direcao != "Andrew Stanton") %>% View()

# Negação
imdb %>% filter(direcao %in% c("Quentin Tarantino", "Steven Spielberg"))
imdb %>% filter(!direcao %in% c("Quentin Tarantino", "Steven Spielberg")) %>% View()


# Super filtro!
# detect
# detect com mais de um valor!
# negacao
imdb %>% 
  filter(!str_detect(direcao, "Quentin Tarantino|Steven Spielberg")) %>% View()

# O que acontece com o NA?
df <- tibble(x = c(1, NA, 3))

filter(df, x > 1) # por padrao, o filter REMOVEU os NAs!

# aqui estou sendo explicita dizendo
# que eu quero que o NA seja mantido!
filter(df, is.na(x) | x > 1)

# Filtrando texto sem correspondência exata
# A função str_detect()
textos <- c("a", "aa","abc", "bc", "A", NA)

str_detect(textos, pattern = "a")
str_view_all(textos, pattern = "a")

## Pegando os seis primeiros valores da coluna "generos"
imdb$generos[1:6]

str_detect(
  string = imdb$generos[1:6],
  pattern = "Drama"
)

imdb %>% 
  filter(str_detect(
    generos, "Sci-Fi"
  )) %>% View()

## Pegando apenas os filmes que 
## tenham o gênero ação
imdb %>% filter(str_detect(generos, "Action")) %>% View()

# mutate ------------------------------------------------------------------

# Modificando uma coluna

# base %>% 
# mutate(nome_que_a_coluna_vai_ficar = operacao_que_queremos_fazer)

imdb %>% 
  mutate(duracao = duracao/60) %>% 
  View()

# Criando uma nova coluna

imdb %>% 
  mutate(duracao_horas = duracao/60) %>% 
  View()

imdb %>% 
  mutate(lucro = receita - orcamento) %>% 
  View()


imdb %>% 
  drop_na(receita, orcamento) %>% 
  mutate(lucro = receita - orcamento) %>% 
  View()
  
  
# A função ifelse é uma ótima ferramenta
# para fazermos classificação binária

imdb %>%
  drop_na(receita, orcamento) %>% 
  mutate(
  lucro = receita - orcamento,
  houve_lucro = ifelse(test = lucro > 0, # teste que faremos
                       yes = "Sim", # se for verdadeiro
                       no =  "Não" # se for falso!
                       )
) %>% 
  View()



# summarise ---------------------------------------------------------------

# Sumarizando uma coluna

imdb %>% 
  summarise(media_orcamento = mean(orcamento, na.rm = TRUE))

# repare que a saída ainda é uma tibble


# Sumarizando várias colunas
imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  media_lucro = mean(receita - orcamento, na.rm = TRUE)
)

# Diversas sumarizações da mesma coluna
imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  mediana_orcamento = median(orcamento, na.rm = TRUE),
  variancia_orcamento = var(orcamento, na.rm = TRUE)
)

# Tabela descritiva
imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  media_receita = mean(receita, na.rm = TRUE),
  qtd = n(),
  qtd_direcao = n_distinct(direcao)
)


# funcoes que transformam -> N valores
log(1:10)
sqrt()
str_detect()

# funcoes que sumarizam -> 1 valor
mean(c(1, NA, 2))
mean(c(1, NA, 2), na.rm = TRUE)
n_distinct()


# group_by + summarise ----------------------------------------------------

# Agrupando a base por uma variável.

imdb %>% group_by(producao)

# Agrupando e sumarizando
imdb %>% 
  group_by(producao) %>% 
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE),
    media_receita = mean(receita, na.rm = TRUE),
    qtd = n(),
    qtd_direcao = n_distinct(direcao)
  ) %>%
  arrange(desc(qtd)) 
  
  
# left join ---------------------------------------------------------------

# A função left join serve para juntarmos duas
# tabelas a partir de uma chave. 
# Vamos ver um exemplo bem simples.

band_members
band_instruments

band_members %>% left_join(band_instruments)
band_instruments %>% left_join(band_members)

# o argumento 'by'
band_members %>% left_join(band_instruments, by = "name")

# OBS: existe uma família de joins

band_instruments %>% left_join(band_members)
band_instruments %>% right_join(band_members)
band_instruments %>% inner_join(band_members)
band_instruments %>% full_join(band_members)


# Um exemplo usando a outra base do imdb

imdb <- read_rds("dados/imdb.rds")
imdb_avaliacoes <- read_rds("dados/imdb_avaliacoes.rds")

imdb %>% 
  left_join(imdb_avaliacoes, by = "id_filme") %>%
  View()

