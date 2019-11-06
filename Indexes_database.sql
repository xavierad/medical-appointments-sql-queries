/*
Para melhorar um desempenho da procura na base de dados para as duas primeiras
'queries', sugere-se a utilização de índices para a base de dados.

-Query 1:
Para uma análise do desempenho da procura sem a utilização de índices, resolvemos
utilizar o comando 'explain' antes da query. Feito isto, obtivémos uma procura
estimada em todas as linhas de todas as tabelas. Com isto sugerimos indexar apenas
os atributos (colunas) das tabelas que são procurados através de WHEREs
e de JOINs.


*/
