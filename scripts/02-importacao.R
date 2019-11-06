library(tidyverse)
library(readr)
install.packages("readr")

# Caminhos até o arquivo --------------------------------------------------

# 1. Podem ser absolutos
"/home/william/Documents/Curso-R/intro-programacao-em-r-mestre/dados/imdb.csv"

# 2. Podem ser relativos ao diretório de trabalho
getwd()

# Leitura de dados --------------------------------------------------------

# Arquivos de texto
imdb <- read_csv(file = "dados/imdb.csv")
#read.csv

View(imdb)

imdb2 <- read_csv2(file = "dados/imdb2.csv")

imdb2 <- read_delim("dados/imdb.csv", delim = "\t")

rio::import("")

# Excel
library(readxl)
install.packages("readxl")
imdb_excel <- read_excel("dados/imdb.xlsx")



# SQL
# install.packages("RSQLite")

conexao <- src_sqlite("dados/imdb.sqlite", create = TRUE)
# copy_to(conexao, imdb, temporary = FALSE)

imdb_sqlite <- tbl(conexao, "imdb")
imdb_select <- tbl(conexao, sql("SELECT titulo, ano, diretor FROM imdb"))

# trazer para a memória
imdb_sql <- collect(imdb_sqlite)
collect(imdb_select)

# Mais informações: db.rstudio.com


# Outros formatos

library(jsonlite)
imdb_json <- read_json("dados/imdb.json")

library(haven)

imdb_sas <- read_sas("dados/imdb.sas7bdat")
imdb_spss <- read_spss("dados/imdb.sav")


# Gravando dados------------------------------------------------------------

print.AsIs()

# As funções iniciam com 'write'

# csv
write_csv(imdb, path = "imdb.csv")

# Excel
library(writexl)
write_xlsx(imdb, path = "imdb.xlsx")

# rds
write_rds(imdb, path = "imdb.rds", compress = "gz")
read_rds()


# Exemplo várias bases ----------------------------------------------------

arquivos <- list.files("dados/por_ano/", full.names = TRUE)

read_rds(arquivos[1])
read_rds(arquivos[2])
read_rds(arquivos[3])
read_rds(arquivos[4])

library(purrr)

map_dfr(arquivos, read_rds)

# Exercício ---------------------------------------------------------------

library(readxl)

imdb_nomes_colunas <- 
  read_excel("exercicios/imdb_exercicio.xlsx")

imdb <- read_excel(
  path = "exercicios/imdb_exercicio.xlsx",
  sheet = 2,
  skip = 4,
  col_names = FALSE,
  n_max = 3713
)

colnames(imdb) <- imdb_nomes_colunas$nome






