---- Apresentação

  O presente projeto foi construído usando R para converter os arquivos MENINBRXX.dbc obtidos no Sinan, convertê-los para .parquet e, então, converter para o formato duckdb. Isso possibilita formar um banco DuckDB a ser consultado. Para fins de teste, foram inclusos os anos 2007 - 2025 no bnao de dados.

  Estão disponíveis alguns scripts:
  
- Baixar packages -> Para baixar os packages necessários para os scripts funcionarem
- Baixar DBC -> Para baixar os arquivos .dbc 
- Converter DBC para parquet -> Para baixar os arquivos para o formato parquet (uma alternativa mais eficaz ao formato csv)
- Banco de dados DuckDb -> Para montar o banco de dados

Caso opte por simplesmente baixar os arquivos diretamente, sem utilizar o R, acesse: https://drive.google.com/drive/folders/11CrMAtVXaDeB4O90CyYvt_JR5fi7kSCy?usp=sharing

Também existe um arquivo .xlsx que contém a descrição de todas as variáveis presentes nos bancos de dados utilizados. Essa planilha foi elaborada com base no "DICIONÁRIO DE DADOS – SINAN NET – VERSÃO 5.0 - Agravo: Meningite". 

Observação: Os anos de 2023 a 2025 entram como arquivos preliminares no FTP do DATASUS, enquanto todos os outros anos entram como arquivos finais. Para entender o que isso significa: https://datasus.saude.gov.br/paineis-de-monitoramento-svs/.
