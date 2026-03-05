---- Apresentação

  O presente projeto foi construído usando R para converter os arquivos MENINBRXX.dbc obtidos no Sinan, convertê-los para .parquet e, então, converter para o formato duckdb. Isso possibilita formar um banco DuckDB a ser consultado. Para fins de teste, foram inclusos os anos 2007 - 2025 no bnao de dados.

  Estão disponíveis alguns scripts:
  
- Baixar packages -> Para baixar os packages necessários para os scripts funcionarem.
- Baixar DBC -> Para baixar os arquivos os dados epidemiológicos sobre a meningite em formato .dbc disponíveis no DATASUS.
- Converter DBC para parquet -> Para converter os arquivos para o formato parquet. Também corrige eventuais problemas de codificação, como Latin-1, convertendo tudo para UTF-8. 
- Exportar DuckDb -> Para exportar o que está no DuckDb para uma planilha em formato CSV ou XLSX. Pode exportar todo o banco de dados ou, em próximas versões, exportar parcialmente conforme determinadas variáveis.

No repositório também existem duas planilhas: um arquivo CSV (9. Descrição das variáveis) que contém a descrição de todas as variáveis presentes nos bancos de dados utilizados e outro arquivo XLSX (10. Comparação PDF, XLSX e DUCKDB) que contém algumas comparações entre a planilha fruto da exportação da informação de toda a informação presente no DuckDB e o próprio arquivo duckDB (sinan_meningite). Lembrando que as colunas são baseadas no "DICIONÁRIO DE DADOS – SINAN NET – VERSÃO 5.0 - Agravo: Meningite" e na informação extraída do banco de dados do DATASUS.

Caso opte por simplesmente baixar os arquivos já prontos, sem utilizar os scripts em R, acesse: https://drive.google.com/drive/u/0/folders/1cShHl_k80Oz1drD83bRjvN0lucfRVF7I.

Observação: Os anos de 2023 a 2025 entram como arquivos preliminares no FTP do DATASUS, enquanto todos os outros anos entram como arquivos finais. Para entender o que isso significa: https://datasus.saude.gov.br/paineis-de-monitoramento-svs/.
