# Baixa os arquivos .dbc do SINAN Meningite (MENI), Brasil, 2007-2025.

library(purrr)

anos <- 2007:2025

dir.create("Meningite_Bacteriana_IC/data/raw_dbc", recursive = TRUE, showWarnings = FALSE)

url_meni <- function(ano) {
  yy <- substr(as.character(ano), 3, 4)
  pasta <- if (ano <= 2022) "FINAIS" else "PRELIM"
  sprintf(
    "ftp://ftp.datasus.gov.br/dissemin/publicos/SINAN/DADOS/%s/MENIBR%s.dbc",
    pasta, yy
  )
}

baixar_ano <- function(ano) {
  url <- url_meni(ano)
  destino <- file.path("Meningite_Bacteriana_IC/data/raw_dbc", basename(url))

  if (file.exists(destino)) {
    message("Já existe: ", destino)
    return(invisible(destino))
  }

  message("Baixando ", basename(url), " ...")
  utils::download.file(url = url, destfile = destino, mode = "wb", quiet = FALSE)
  invisible(destino)
}

walk(anos, baixar_ano)

message("Download concluído. Por favor, verifique o diretório correspondente.")
message ("Para verificá-lo, verifique no console logo abaixo.")

getwd ()
