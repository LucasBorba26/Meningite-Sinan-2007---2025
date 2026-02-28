---- Apresentação

  O presente projeto foi construído usando R para converter os arquivos MENINBRXX.dbc obtidos no Sinan, convertê-los para .parquet e, então, converter para o formato duckdb. Isso possibilita formar um banco DuckDB a ser consultado. Para fins de teste, foram inclusos os anos 2007 - 2025 no bnao de dados.

  Estão disponíveis alguns scripts:
  
- Baixar packages -> Para baixar os packages necessários para os scripts funcionarem
- Baixar DBC -> Para baixar os arquivos os dados epidemiológicos em formato .dbc do site do DATASUS.
- Converter DBC para parquet -> Para converter os arquivos para o formato parquet. Também corrige eventuais problemas de codificação. 
- Exportar DuckDb -> Para exportar o que está no DuckDb para uma planilha em formato CSV ou XLSX. Pode exportar todo o banco de dados ou, em próximas versões, exportar parcialmente conforme determinadas variáveis.

Também existe um arquivo CV (9. Descrição das variáveis) que contém a descrição de todas as variáveis presentes nos bancos de dados utilizados. Essa planilha em particular foi elaborada com base no "DICIONÁRIO DE DADOS – SINAN NET – VERSÃO 5.0 - Agravo: Meningite". 

Caso opte por simplesmente baixar os arquivos diretamente, sem utilizar o R, acesse: https://drive.google.com/drive/u/0/folders/1cShHl_k80Oz1drD83bRjvN0lucfRVF7I.

Observação: Os anos de 2023 a 2025 entram como arquivos preliminares no FTP do DATASUS, enquanto todos os outros anos entram como arquivos finais. Para entender o que isso significa: https://datasus.saude.gov.br/paineis-de-monitoramento-svs/.
