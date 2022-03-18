library(tidyverse)

# Caminhos até o arquivo --------------------------------------------------
"dados/imdb.csv" # USE TAB ENTRE ASPAS!

# Caminhos absolutos
"/home/william/Documents/Curso-R/main-r4ds-1/dados/imdb.csv"

# caminho_pinguins <- "~/GitHub/2022-curso-de-verao-ime-usp-relatorios/docs/dados/pinguins.csv"

# "~/Downloads/"
# pinguins <- read_csv(caminho_pinguins)

# Caminhos relativos
"dados/imdb.csv"


# também dá pra usar URLS!
read.csv("https://github.com/curso-r/main-r4ds-1/raw/master/dados/imdb.csv")

"dados/por_ano/imdb_1952.rds"



# (cara(o) professora(o), favor lembrar de falar da dica 
# de navegação entre as aspas)

# Tibbles -----------------------------------------------------------------

airquality
class(airquality)

as_tibble(airquality)
class(as_tibble(airquality))

# Lendo arquivos de texto -------------------------------------------------

library(readr) # readr faz parte do tidyverse!

# CSV, separado por vírgula
imdb_csv <- read_csv("dados/imdb.csv")

# CSV, separado por ponto-e-vírgula
imdb_csv2 <- read_csv2(file = "dados/imdb2.csv")

# Experimentem o import dataset -> from text (readr). 
# Fica na aba environment.



# TXT, separado por tabulação (tecla TAB)
imdb_txt <- read_delim(file = "dados/imdb.txt", delim = "\t")


# A função read_delim funciona para qualquer tipo de separador
imdb_delim <- read_delim("dados/imdb.csv", delim = ",")
imdb_delim2 <- read_delim("dados/imdb2.csv", delim = ";")

# direto da internet
imdb_csv_url <- read_csv("https://raw.githubusercontent.com/curso-r/main-r4ds-1/master/dados/imdb.csv")


# Interface point and click do RStudio também é útil!

# Lendo arquivos do Excel -------------------------------------------------

library(readxl)

excel_sheets("dados/imdb.xlsx")

imdb_excel <- read_excel("dados/imdb.xlsx")
excel_sheets("dados/imdb.xlsx")

read_excel("dados/imdb.xlsx", sheet = "Sheet1")

# Salvando dados ----------------------------------------------------------

# As funções iniciam com 'write'

imdb <- imdb_csv

# CSV
write_csv(imdb, file = "imdb.csv")
write_csv2(imdb, file = "imdb2.csv")

# Excel
# install.packages("writexl")
library(writexl)
write_xlsx(imdb, path = "imdb-excel.xlsx")

# O formato rds -----------------------------------------------------------

# .rds são arquivos binários do R
# Você pode salvar qualquer objeto do R em formato .rds

imdb_rds <- readr::read_rds("dados/imdb.rds")
# dir.create("dados_exportados")
readr::write_rds(imdb_rds, file = "dados_exportados/imdb_rds.rds")

# x <- 1:10
# readr::write_rds(x, "x.rds")
# readr::read_rds("x.rds")
