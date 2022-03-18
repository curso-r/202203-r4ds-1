# Importacao de dados da PMSP ---------
library(readxl)

url <- "http://orcamento.sf.prefeitura.sp.gov.br/orcamento/uploads/2022/basedadosexecucao2022.xlsx"
destfile <- "pratica/basedadosexecucao2022.xlsx"
curl::curl_download(url, destfile)

basedadosexecucao2022 <- read_excel(destfile)
View(basedadosexecucao2022)

library(dplyr)
glimpse(basedadosexecucao2022)
# > glimpse(basedadosexecucao2022)
# Rows: 4,859
# Columns: 48
# $ DataExtracao                <dttm> 2022-03-17 02:37:27, 2…



# pego a base, filtro apenas fauna, 
# calcula quanto foi gasto naquele ano,
# faz um grafico por anos


# ---------
# google sheets
library(googlesheets4)
url_g <- "https://docs.google.com/spreadsheets/d/19hfxa7unzP_rCfXORbC0Qs52xX8Qmy_jyebRIwxQgnU/edit#gid=0"

# importar a primeira aba
base_nomes <- read_sheet(url_g)

# ver nomes das tabelas
sheet_names(url_g)

# importar a aba de jogos
base_jogos <- read_sheet(url_g, sheet = "jogos")
