# Pacotes -----------------------------------------------------------------

library(tidyverse)
library(dplyr)

# Base de dados -----------------------------------------------------------

imdb <- read_rds("dados/imdb.rds")

# select ------------------------------------------------------------------

# exemplo 1

imdb_titulo <- select(imdb, titulo)
View(imdb)
View(imdb_titulo)

# exemplo 2

select(imdb, titulo, ano, orcamento)

# exemplo 3

select(imdb, starts_with("ator"))
select(imdb, diretor, everything())

# exemplo 4
select(imdb, -starts_with("ator"), -titulo)

# Exercício 1
# Crie uma tabela com apenas as colunas titulo, diretor, 
# e orcamento. Salve em um
# objeto chamado imdb_simples.

imdb_simples <- select(imdb, titulo, diretor, orcamento)
imdb_simples
View(imdb_simples)

# Exercício 2
# Remova as colunas ator_1, ator_2 e ator_3 de 
# três formas diferentes. Salve em um
# objeto chamado imdb_sem_ator.

imdb_sem_ator <- select(imdb, -starts_with("ator"))
imdb_sem_ator <- imdb[,1:12]
imdb_sem_ator <- select(imdb, 1:12)
imdb_sem_ator <- select(imdb, -contains("ator"))
imdb_sem_ator <- select(imdb, -c(ator_1, ator_2, ator_3))
imdb_sem_ator <- select(imdb, -ator_1, -ator_2, -ator_3)
imdb_sem_ator <- select(imdb, titulo:likes_facebook)
imdb_sem_ator <- select(
  imdb, 
  - num_range(prefix = "ator_", range = 1:3)
)

# arrange -----------------------------------------------------------------

# exemplo 1

View(arrange(imdb, orcamento))

# exemplo 2

View(arrange(imdb, desc(orcamento)))

# exemplo 3

View(arrange(imdb, desc(ano), titulo))

# exemplo 4
# NA

df <- tibble(x = c(NA, 2, 1), y = c(1, 2, 3))
arrange(df, desc(x))

# exercício 1
# Ordene os filmes em ordem crescente de ano e 
# decrescente de receita e salve 
# em um objeto chamado filmes_ordenados

filmes_ordenados <- arrange(
  imdb,
  ano,
  desc(receita)
)

View(filmes_ordenados)

# Exercício 2 
# Selecione apenas as colunas título e orçamento 
# e então ordene de forma decrescente pelo orçamento.

imdb_selecionado <- select(imdb, titulo, orcamento)

imdb_selecionado_e_ordenado <- arrange(
  imdb_selecionado,
  desc(orcamento)
)

View(imdb_selecionado_e_ordenado)

arrange(select(imdb, titulo, orcamento), desc(orcamento))

# Pipe (%>%) --------------------------------------------------------------

# g(f(x)) = x %>% f() %>% g()

# Receita de bolo sem pipe. Tente entender o que é preciso fazer.

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

# Veja como o código acima pode ser reescrito utilizando-se o pipe. 
# Agora realmente se parece com uma receita de bolo.

recipiente(rep("farinha", 2), "água", "fermento", "leite", "óleo") %>%
  acrescente("farinha", até = "macio") %>%
  coloque(lugar = "forma", tipo = "grande", untada = TRUE) %>%
  asse(duração = "50min") %>%
  esfrie("geladeira", "20min")

# ATALHO: CTRL + SHIFT + M

# Exercício
# Refaça o exercício 2 do arrange utilizando o %>% 

imdb %>% 
  select(titulo, orcamento) %>% 
  arrange(desc(orcamento))

# filter ------------------------------------------------------------------

# exemplo 1
imdb %>%
  filter(nota_imdb > 9)

# exemplo 2
imdb %>% 
  filter(diretor == "Quentin Tarantino") %>% 
  View()

# exercício 1
# Criar um objeto chamada `filmes_baratos` 
# com filmes com orçamento menor do 
# que 1 milhão de dólares.

filmes_baratos <- imdb %>% 
  filter(orcamento < 10^6)

imdb %>% 
  select(titulo, orcamento, receita) %>% 
  arrange(receita) %>% 
  filter(orcamento > 5000000)

View(filmes_baratos)

# exemplo 3
imdb %>% filter(ano > 2010, nota_imdb > 8.5)
imdb %>% filter(orcamento < 100000, receita > 1000000)
imdb %>% filter(receita > (orcamento + 500000000) | nota_imdb > 9) %>% View

# exemplo 4
imdb %>% filter(receita > orcamento)
imdb %>% filter(receita > orcamento + 500000000)

# exemplo 5
imdb %>% filter(ano > 2010)
imdb %>% filter(!ano > 2010)
imdb %>% filter(ano <= 2010)

c(1, 2)

c(2, 4, 6, 7, 2)

imdb %>%
  filter(!diretor %in% c("Quentin Tarantino", "Steven Spielberg")) %>% 
  View()

imdb %>% 
  filter(
    diretor != "Quentin Tarantino",
    diretor != "Steven Spielberg"
  )

# exercício 2
# Criar um objeto chamado bons_baratos com filmes que tiveram nota no imdb 
# maior do que 8.5 e um orcamento menor do que 1 milhão de dólares.

bons_baratos <- imdb %>% 
  filter(nota_imdb > 8.5, orcamento < 1e6)
View(bons_baratos)

# exercício 3
# Criar um objeto chamado curtos_legais com filmes de 1h30 ou menos de duração 
# e nota no imdb maior do que 8.5.

curtos_legais <- imdb %>% 
  filter(nota_imdb > 8.5, duracao <= 90)
View(curtos_legais)

# exercício 4
# Criar um objeto antigo_colorido com filmes anteriores a 1950 que são 
# coloridos. Crie também um objeto antigo_bw com filmes antigos que não são coloridos.

imdb$cor %>% unique()
imdb$cor %>% table()
imdb %>% distinct(cor)

antigo_colorido <- imdb %>% 
  filter(ano < 1950, cor == "Color")

antigo_bw <- imdb %>% 
  filter(ano < 1950, cor == "Black and White")

# exercício 5
# Criar um objeto ww com filmes do Wes Anderson ou do Woody Allen (diretores).

ww <- imdb %>% 
  filter(diretor == "Wes Anderson" | 
           diretor == "Woody Allen")

ww <- imdb %>% 
  filter(diretor %in% c("Wes Anderson", "Woody Allen"))

# Exercício 6
# Crie uma tabela apenas com filmes do Woody Allen e apenas as colunas titulo e ano,
# ordenada por ano.

filmes_wa <- imdb %>% 
  filter(diretor == "Woody Allen") %>% 
  select(titulo, ano) %>% 
  arrange(ano)

# exemplo 6
# %in%

pitts <- imdb %>% 
  filter(
    ator_1 %in% c('Angelina Jolie Pitt', "Brad Pitt")
  )

# exercicio 6
# Refaça o exercício 5 usando o %in%.

# exemplo 7
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# exemplo 8
# str_detect

imdb %>% View()

imdb %>% filter(generos == "Action") %>% View()

imdb %>% filter(str_detect(generos, "[Aa]ction" )) %>% View

imdb %>% 
  filter(str_detect(generos, "Action"), 
         str_detect(generos, "action"))


str_detect(letters, "a")

# exercício 7
# Identifique os filmes que não possuem informação tanto de receita quanto de orcamento
# e salve em um objeto com nome sem_info.

sem_info <- imdb %>% 
  filter(is.na(receita), is.na(orcamento))

View(sem_info)

# exercício 8
# Salve em um objeto os filmes de Ação e Comédia com nota no imdb maior do que 8.

acao_comedia_bom <- imdb %>% 
  filter(
    str_detect(generos, "Action"),
    str_detect(generos, "Comedy"),
    nota_imdb > 8
  )

imdb %>% 
  filter(
    str_detect(generos, "Action.*Comedy"),
    nota_imdb > 8
  )

View(imdb)
View(acao_comedia_bom)

# mutate ------------------------------------------------------------------

# exemplo 1

imdb %>% mutate(duracao = duracao/60) %>% View()

# exemplo 2

imdb %>% 
  mutate(duracao_horas = duracao/60) %>% 
  #select(duracao, duracao_horas) %>% 
  View()

# exercício 1
# Crie uma variável chamada lucro. 
# Salve em um objeto chamado imdb_lucro.

imdb_lucro <- imdb %>% 
  mutate(lucro = receita - orcamento)

# exercicio 2
# Modifique a variável lucro para ficar na 
# escala de milhões de dólares.

imdb_lucro <- imdb_lucro %>% 
  mutate(lucro = lucro/1e6)

View(imdb_lucro)

imdb_lucro %>% rename(lucro_em_milhoes = lucro) %>% View()

# exercício 3
# Filtre apenas os filmes com prejuízo maior do que 3 milhões de dólares. 
# Deixe essa tabela ordenada com o maior prejuízo primeiro. Salve o resultado em 
# um objeto chamado filmes_prejuizo.

imdb_lucro %>% 
  filter(lucro < -3) %>%
  arrange(lucro) %>% 
  summarise(lucro_medio = mean(lucro, na.rm  = TRUE)) %>% 
  View()

# exemplo 3
# gêneros

# install.packages("gender")
library(gender)

gender(c("William"), years = 2012)
gender(c("Amanda"), years = 2012)
gender(c("Robin"), years = 2012)

gender(c("Madison", "Hillary"), years = 1930, method = "ssa")
gender(c("Madison", "Hillary"), years = 2010, method = "ssa")

gender("Matheus", years = 1920)
gender("Matheus", years = 2012)

# Base com o gênero dos diretores
imdb_generos <- read_rds("dados/imdb_generos.rds")
View(imdb_generos)

# Pacote análogo para nomes brasileiros
# https://github.com/meirelesff/genderBR

# summarise ---------------------------------------------------------------

# exemplo 1

imdb_sumarizado <- imdb %>% 
  summarise(
    media_orcamento = mean(orcamento, na.rm = TRUE)
  )

View(imdb_sumarizado)

# exemplo 2

imdb %>% summarise(
  media_orcamento = mean(orcamento, na.rm = TRUE),
  mediana_orcamento = median(orcamento, na.rm = TRUE),
  numero_de_filmes = n(),
  numero_de_diretores = n_distinct(diretor)
) %>% 
  View()

# exemplo 3

imdb_generos %>%
  summarise(
    n_diretora = sum(genero == "female", na.rm = TRUE)
  )

imdb_generos %>%
  summarise(
    n_diretora = mean(genero == "female", na.rm = TRUE)
  )

as.numeric(imdb_generos$genero == "female")

# exercício 1
# Use o `summarise` para calcular a proporção 
# de filmes com diretoras.

imdb_generos %>% 
  summarise(
    prop_diretoras = mean(genero == "female", na.rm = TRUE)
  )

# exercício 2
# Calcule a duração média e mediana dos filmes da base.

imdb %>% 
  summarise(
    duracao_media = mean(duracao, na.rm = TRUE),
    duracao_mediana = median(duracao, na.rm = TRUE)
  )

# exercício 3
# Calcule o lucro médio dos filmes com duracao < 60 minutos. 
# E o lucro médio dos filmes com
# mais de 2 horas.

imdb %>% 
  filter(duracao < 60) %>% 
  mutate(lucro = receita - orcamento) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE))

imdb %>% 
  filter(duracao > 120) %>% 
  mutate(lucro = receita - orcamento) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE))

imdb_lucro %>% 
  summarise(
    lucro_medio_curtos = mean(lucro[duracao < 60], na.rm = TRUE),
    lucro_medio_longos = mean(lucro[duracao > 120], na.rm = TRUE)
  )

# group_by + summarise ----------------------------------------------------

# exemplo 1

imdb %>% 
  group_by(ano)

# exemplo 2

imdb %>% 
  group_by(ano) %>% 
  summarise(qtd_filmes = n()) %>% 
  View()

# exemplo 3

imdb %>% 
  group_by(diretor) %>% 
  summarise(qtd_filmes = n()) %>% 
  View()


# exercício 1
# Crie uma tabela com apenas o nome dos 
# diretores com mais de 10 filmes.

imdb %>% 
  group_by(diretor) %>% 
  summarise(
    num_filmes = n()
  ) %>% 
  filter(num_filmes > 10, !is.na(diretor)) %>% 
  arrange(num_filmes)

# exercício 2
# Crie uma tabela com a receita média 
# e mediana dos filmes por ano.

imdb %>% 
  group_by(ano) %>% 
  summarise(
    num_filmes = n(),
    receita_media = mean(receita, na.rm = TRUE),
    receita_mediana = median(receita, na.rm = TRUE)
  ) %>%
  filter(
    !is.na(receita_media),
    !is.na(receita_mediana)
  )

mean(c(NA, NA, NA), na.rm = TRUE)
median(c(NA, NA), na.rm = TRUE)
sum(c(NA,NA,NA), na.rm = TRUE)

# exercício 3
# Crie uma tabela com a nota média do 
# imdb dos filmes por classificacao etária.

imdb %>% 
  group_by(classificacao) %>% 
  summarise(
    nota_media = mean(nota_imdb, na.rm = TRUE)
  )

# exemplo 4

imdb %>%
  filter(str_detect(generos, "Action"), !is.na(diretor)) %>%
  group_by(diretor) %>%
  summarise(qtd_filmes = n()) %>%
  arrange(desc(qtd_filmes)) %>% View()

# exemplo 5

imdb %>% 
  filter(ator_1 %in% c("Brad Pitt", "Angelina Jolie Pitt")) %>%
  group_by(ator_1) %>%
  summarise(
    orcamento = mean(orcamento), 
    receita = mean(receita), 
    qtd = n()
  ) %>% View()

# left join ---------------------------------------------------------------

# exemplo 1

imdb %>% View
View(imdb_generos)

imdb_generos2 <- imdb_generos %>% 
  rename(diretor_2 = diretor)

imdb_completa <- left_join(
  imdb, 
  imdb_generos2, 
  by = c("diretor" = "diretor_2", "ano")
)

imdb_completa <- imdb %>%
  left_join(imdb_generos, by = c("diretor", "ano"))

View(imdb_completa)

left_join(
  imdb, 
  imdb_generos, 
  by = "diretor"
) %>% View()

bind_cols(mtcars, mtcars) %>% View()

# exemplo 2

depara_cores <- tibble(
  cor = c("Color", "Black and White"),
  cor2 = c("colorido", "pretoEbranco")
)

View(imdb)

imdb_cor <- left_join(
  imdb, 
  depara_cores, 
  by = c("cor")
)

View(depara_cores)

View(imdb_cor)

# exercicio 1
# Calcule a média dos orçamentos e 
# receitas para filmes feitos por
# gênero do diretor.

imdb %>% 
  left_join(
    imdb_generos,
    by = c("diretor", "ano")
  ) %>% 
  group_by(genero) %>% 
  summarise(
    orcamento_medio = mean(orcamento, na.rm = TRUE),
    receita_media = mean(receita, na.rm = TRUE)
  ) %>% 
  filter(!is.na(genero)) %>% 
  View()

ler_bases <- function(path) {
  read_delim(path, delim = "\t") %>% 
    mutate(arquivo = path)
}

base_completa <- map_dfr(files, ler_bases)

base_completa %>% 
  select(gene, tpm, arquivo) %>%
  spread(arquivo, tpm)

# gather ------------------------------------------------------------------

imdb_simples <- imdb %>% 
  select(titulo, starts_with("ator")) %>% 
  slice(1:3)

View(imdb_simples)

# exemplo 1

imdb_gather <- gather(
  imdb_simples, 
  "importancia_ator", 
  "nome_ator", 
  starts_with("ator")
)

imdb_gather <- gather(
  imdb, 
  "importancia_ator", 
  "nome_ator", 
  starts_with("ator")
)

imdb %>% 
  gather(
    "importancia_ator", 
    "nome_ator", 
    starts_with("ator")
  )

View(imdb_gather)

# spread ------------------------------------------------------------------

# exemplo 1

imdb <- spread(imdb_gather, importancia_ator, nome_ator)

