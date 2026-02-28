library(duckdb)
library(DBI)

# 1. Conectar ao banco
con <- dbConnect(duckdb::duckdb(), dbdir = "Meningite_Bacteriana_IC/db/sinan_meningite.duckdb")

# Extrai "Meningite_Bacteriana_IC/db"

db_path <- "Meningite_Bacteriana_IC/db/"
export_dir <- dirname(db_path) 

# 2. Preparar extensões (essencial para Excel)
dbExecute(con, "INSTALL excel;")
dbExecute(con, "LOAD excel;")

# 3. Verificar nomes (ajuda você a preencher o próximo passo)
print(dbListTables(con)) 

# --- A partir daqui, substitua 'sua_tabela' pelo nome real ---

# 4. Exportar Tabela Inteira para Excel
path_xlsx1 <- file.path(export_dir, "sinan_meningite_data.xlsx")
dbExecute(con, "COPY sinan_meningite_data TO 'sinan_meningite_data.xlsx' (FORMAT XLSX);")

# 6. Exportar para CSV (Corrigido o 'e' maiúsculo de dbExecute)
path_csv <- file.path(export_dir, "inan_meningite_data.csv")
dbExecute(con, "COPY sinan_meningite_data TO 'sinan_meningite_data.csv' (HEADER, DELIMITER ',');")

# 7. FECHAR A CONEXÃO (Muito importante para não corromper o arquivo .duckdb)
dbDisconnect(con, shutdown = TRUE)

getwd ()

----- Posteriormente
# 5. Exportar via Query (útil para filtrar dados)
#path_xlsx2 <- file.path(export_dir, "output_query.xlsx")
#dbExecute(con, "COPY (SELECT * FROM sua_tabela) TO 'output_query.xlsx' (FORMAT XLSX);")