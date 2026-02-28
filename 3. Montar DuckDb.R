library(DBI)
library(duckdb)

# 1. Cria o diretório se não existir
dir.create("Meningite_Bacteriana_IC/db", recursive = TRUE, showWarnings = FALSE)

# 2. Abre/cria o banco
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "Meningite_Bacteriana_IC/db/sinan_meningite.duckdb")

# 3. Define os caminhos
parquet_dir <- normalizePath("Meningite_Bacteriana_IC/data/parquet", winslash = "/", mustWork = TRUE)
parquet_glob <- paste0(parquet_dir, "/MENIBR*.parquet")

# 4. Camada de ingestão (Criação de TABELA física)
# Usamos CREATE TABLE para persistir os dados
DBI::dbExecute(con, sprintf(
  "
  CREATE OR REPLACE TABLE sinan_meningite_data AS
  SELECT *
  FROM read_parquet('%s', union_by_name = true)
  ",
  parquet_glob
))

# 5. Força a escrita no disco e desconecta
DBI::dbExecute(con, "CHECKPOINT;")
DBI::dbDisconnect(con, shutdown = TRUE)

message("Dados mesclados com sucesso em: Meningite_Bacteriana_IC/db/sinan_meningite.duckdb")