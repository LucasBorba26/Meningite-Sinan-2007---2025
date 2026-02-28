library(read.dbc)
library(arrow)
library(purrr)

anos <- 2007:2025

dir_raw_dbc <- "Meningite_Bacteriana_IC/data/raw_dbc"
dir_parquet <- "Meningite_Bacteriana_IC/data/parquet"
dir_log <- "Meningite_Bacteriana_IC/data/logs"

# Ajuste aqui se necessário:
# Para DATASUS, normalmente "latin1" resolve.
# Se aparecer pontuação estranha (aspas/traços), teste "CP1252".
encoding_origem <- "latin1"

dir.create(dir_parquet, recursive = TRUE, showWarnings = FALSE)
dir.create(dir_log, recursive = TRUE, showWarnings = FALSE)

# Verifica se cada elemento é UTF-8 válido
is_valid_utf8 <- function(x) {
  ok <- !is.na(iconv(x, from = "UTF-8", to = "UTF-8", sub = NA))
  ok[is.na(x)] <- TRUE
  ok
}

# Corrige só os valores problemáticos
corrigir_vetor_encoding <- function(x, from = encoding_origem) {
  x <- as.character(x)
  
  ruins <- !is_valid_utf8(x)
  ruins[is.na(ruins)] <- FALSE
  
  if (any(ruins)) {
    x[ruins] <- iconv(x[ruins], from = from, to = "UTF-8", sub = "byte")
  }
  
  x
}

# Aplica a correção em todas as colunas textuais
corrigir_encoding_df <- function(df, from = encoding_origem) {
  is_text <- vapply(
    df,
    function(col) is.character(col) || is.factor(col),
    logical(1)
  )
  
  df[is_text] <- lapply(
    df[is_text],
    function(col) corrigir_vetor_encoding(col, from = from)
  )
  
  df
}

# Diagnóstico por coluna: quantos valores inválidos existem
diagnosticar_utf8_df <- function(df) {
  is_text <- vapply(
    df,
    function(col) is.character(col) || is.factor(col),
    logical(1)
  )
  
  if (!any(is_text)) {
    return(data.frame(
      coluna = character(0),
      invalidos = integer(0),
      stringsAsFactors = FALSE
    ))
  }
  
  data.frame(
    coluna = names(df)[is_text],
    invalidos = vapply(
      df[is_text],
      function(col) sum(!is_valid_utf8(as.character(col))),
      integer(1)
    ),
    stringsAsFactors = FALSE
  )
}

converter_ano <- function(ano) {
  yy <- substr(as.character(ano), 3, 4)
  arq_dbc <- file.path(dir_raw_dbc, sprintf("MENIBR%s.dbc", yy))
  arq_parquet <- file.path(dir_parquet, sprintf("MENIBR%s.parquet", yy))
  arq_log <- file.path(dir_log, sprintf("MENIBR%s_utf8_log.csv", yy))
  
  if (!file.exists(arq_dbc)) {
    stop("Arquivo .dbc não encontrado: ", arq_dbc)
  }
  
  message("Lendo ", basename(arq_dbc), " ...")
  
  # as.is = TRUE evita transformar texto em fator
  df <- read.dbc::read.dbc(arq_dbc, as.is = TRUE)
  
  # Diagnóstico antes da correção
  diag_antes <- diagnosticar_utf8_df(df)
  total_invalidos_antes <- sum(diag_antes$invalidos)
  
  if (total_invalidos_antes > 0) {
    cols_ruins <- diag_antes$coluna[diag_antes$invalidos > 0]
    message(
      "  Corrigindo UTF-8 em ", length(cols_ruins), " coluna(s): ",
      paste(cols_ruins, collapse = ", ")
    )
  } else {
    message("  Nenhum problema de UTF-8 detectado.")
  }
  
  # Corrige encoding
  df <- corrigir_encoding_df(df, from = encoding_origem)
  
  # Diagnóstico depois da correção
  diag_depois <- diagnosticar_utf8_df(df)
  total_invalidos_depois <- sum(diag_depois$invalidos)
  
  if (total_invalidos_depois > 0) {
    warning(
      "Ainda restaram ", total_invalidos_depois,
      " valor(es) problemático(s) em ", basename(arq_dbc),
      ". Veja o log: ", arq_log
    )
  } else {
    message("  UTF-8 corrigido com sucesso.")
  }
  
  # Metadados úteis para auditoria
  df$ano_arquivo <- ano
  df$arquivo_origem <- basename(arq_dbc)
  
  # Salva log do diagnóstico
  log_utf8 <- merge(
    diag_antes,
    diag_depois,
    by = "coluna",
    all = TRUE,
    suffixes = c("_antes", "_depois")
  )
  
  log_utf8$arquivo <- basename(arq_dbc)
  log_utf8$encoding_origem_usado <- encoding_origem
  
  write.csv(log_utf8, arq_log, row.names = FALSE, fileEncoding = "UTF-8")
  
  # Grava Parquet
  if (file.exists(arq_parquet)) unlink(arq_parquet)
  arrow::write_parquet(df, sink = arq_parquet)
  
  message("  Parquet salvo em: ", arq_parquet)
  invisible(arq_parquet)
}

walk(anos, converter_ano)

message("Conversão para Parquet concluída.")
message("Diretório de trabalho: ", getwd())