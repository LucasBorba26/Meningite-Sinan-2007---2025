# Lê cada .dbc com read.dbc e salva um Parquet por ano.

library(read.dbc)
library(arrow)
library(purrr)

anos <- 2007:2025

dir.create("Meningite_Bacteriana_IC/data/parquet", recursive = TRUE, showWarnings = FALSE)

converter_ano <- function(ano) {
  yy <- substr(as.character(ano), 3, 4)
  arq_dbc <- file.path("Meningite_Bacteriana_IC/data/raw_dbc", sprintf("MENIBR%s.dbc", yy))
  arq_parquet <- file.path("Meningite_Bacteriana_IC/data/parquet", sprintf("MENIBR%s.parquet", yy))

  if (!file.exists(arq_dbc)) {
    stop("Arquivo .dbc não encontrado: ", arq_dbc)
  }

  message("Lendo ", basename(arq_dbc), " ...")
  df <- read.dbc::read.dbc(arq_dbc)

  # Evita inconsistências com fatores entre anos
  df[] <- lapply(df, function(x) if (is.factor(x)) as.character(x) else x)

  # Metadados úteis para auditoria
  df$ano_arquivo <- ano
  df$arquivo_origem <- basename(arq_dbc)

  if (file.exists(arq_parquet)) unlink(arq_parquet)
  arrow::write_parquet(df, sink = arq_parquet)

  invisible(arq_parquet)
}

walk(anos, converter_ano)

message("Conversão para Parquet concluída. Por favor, verifique o diretório correspondente.")
message ("Para verificá-lo, verifique no console logo abaixo.")

getwd ()


