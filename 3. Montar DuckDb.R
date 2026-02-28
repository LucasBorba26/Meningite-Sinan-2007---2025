# Monta o banco DuckDB e cria views úteis.

library(DBI)
library(duckdb)

dir.create("Meningite_Bacteriana_IC/db", recursive = TRUE, showWarnings = FALSE)

# Abre/cria o banco
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "Meningite_Bacteriana_IC/db/sinan_meningite.duckdb")

parquet_dir <- normalizePath("Meningite_Bacteriana_IC/data/parquet", winslash = "/", mustWork = TRUE)
parquet_glob <- paste0(parquet_dir, "/MENIBR*.parquet")

# Camada bruta unificada
DBI::dbExecute(con, sprintf(
  "
  CREATE OR REPLACE VIEW meningite_raw AS
  SELECT *
  FROM read_parquet('%s', union_by_name = true)
  ",
  parquet_glob
))

# Dimensão de códigos: classificação final
DBI::dbExecute(con, "
  CREATE OR REPLACE TABLE dim_classi_fin AS
  SELECT * FROM (VALUES
    ('1', 'Confirmado'),
    ('2', 'Descartado')
  ) AS t(codigo, descricao)
")

# Dimensão de códigos: diagnóstico especificado quando confirmado
DBI::dbExecute(con, "
  CREATE OR REPLACE TABLE dim_con_diages AS
  SELECT * FROM (VALUES
    ('01', 'Meningococcemia'),
    ('02', 'Meningite meningocócica'),
    ('03', 'Meningite meningocócica com meningococcemia'),
    ('04', 'Meningite tuberculosa'),
    ('05', 'Meningite por outras bactérias'),
    ('06', 'Meningite não especificada'),
    ('07', 'Meningite asséptica'),
    ('08', 'Meningite por outra etiologia'),
    ('09', 'Meningite por Hemófilo'),
    ('10', 'Meningite por Pneumococo')
  ) AS t(codigo, descricao)
")

# Dimensão de códigos: evolução
DBI::dbExecute(con, "
  CREATE OR REPLACE TABLE dim_evolucao AS
  SELECT * FROM (VALUES
    ('1', 'Alta'),
    ('2', 'Óbito por meningite'),
    ('3', 'Óbito por outra causa'),
    ('9', 'Ignorado')
  ) AS t(codigo, descricao)
")

# Casos confirmados
DBI::dbExecute(con, "
  CREATE OR REPLACE VIEW vw_meningite_confirmada AS
  SELECT *
  FROM meningite_raw
  WHERE CAST(CLASSI_FIN AS VARCHAR) = '1'
")

# Recorte estrito de meningite bacteriana
DBI::dbExecute(con, "
  CREATE OR REPLACE VIEW vw_meningite_bacteriana_estrita AS
  SELECT *
  FROM meningite_raw
  WHERE CAST(CLASSI_FIN AS VARCHAR) = '1'
    AND LPAD(CAST(CON_DIAGES AS VARCHAR), 2, '0') IN ('02', '03', '04', '05', '09', '10')
")

# Recorte ampliado (inclui meningococcemia isolada)
DBI::dbExecute(con, "
  CREATE OR REPLACE VIEW vw_meningite_bacteriana_ampla AS
  SELECT *
  FROM meningite_raw
  WHERE CAST(CLASSI_FIN AS VARCHAR) = '1'
    AND LPAD(CAST(CON_DIAGES AS VARCHAR), 2, '0') IN ('01', '02', '03', '04', '05', '09', '10')
")

# View legível com rótulos da etiologia
DBI::dbExecute(con, "
  CREATE OR REPLACE VIEW vw_meningite_bacteriana_estrita_legivel AS
  SELECT
    m.*, d.descricao AS descricao_etiologia
  FROM vw_meningite_bacteriana_estrita m
  LEFT JOIN dim_con_diages d
    ON LPAD(CAST(m.CON_DIAGES AS VARCHAR), 2, '0') = d.codigo
")

DBI::dbDisconnect(con)
message("DuckDB criado em Meningite_Bacteriana_IC/db/sinan_meningite.duckdb")

getwd ()
