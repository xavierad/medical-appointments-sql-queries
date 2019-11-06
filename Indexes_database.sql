/*
Para melhorar um desempenho da procura na base de dados para as duas primeiras
'queries', sugere-se a utilização de índices para a base de dados.*/

/*
-Query 1:
Para uma análise do desempenho da procura sem a utilização de índices, resolvemos
utilizar o comando 'explain' antes da query. Feito isto, obtivémos uma procura
estimada em todas as linhas de todas as tabelas. Com isto sugerimos indexar apenas
os atributos (colunas) das tabelas que são procurados através de WHEREs
e de JOINs.
Ora como nas 'WHERE clauses' se procura os atributos employee._name, então
criamos os índices nas colunas das tabelas correspondentes. Quando se procura
por um valor de um atributo que seja uma chave primária, então não será
necessário criar um índice, pois são clustered indexes. É o caso das seguintes
chaves utilizadas: client.VAT, phone_number_client.VAT, phone_number_client.phone,
appointment.VAT_client, appointment.date_timestamp, consultation.date_timestamp,
consultation.VAT_doctor. Portanto, a única necessário indexar é employee._name.
As instruções para a implementação dos índices estão escritas abaixo:
*/
create index employeeName_idx on employee(_name);

/*
-Query 2:
Para uma análise do desempenho da procura sem a utilização de índices, resolvemos
utilizar o comando 'explain' antes da query. Feito isto, obtivémos uma procura
estimada em todas as linhas de todas as tabelas. Com isto sugerimos indexar apenas
os atributos (colunas) das tabelas que são procurados através de WHEREs
e de JOINs.
Ora como nas 'WHERE clauses' se procura os atributos employee._name, então
criamos os índices nas colunas das tabelas correspondentes. Quando se procura
por um valor de um atributo que seja uma chave primária ou estrangeira, então
não será necessário criar um índice, pois são clustered indexes. É o caso das
seguintes chaves: employee.VAT, trainee_doctor.VAT e trainee_doctor.supervisor.
Portanto, para optimizar, indexamos: supervision_report.evaluation e
supervision_report._description.
As instruções para a implementação dos índices estão escritas abaixo:
*/
create index srEval_idx on supervision_report(evaluation);
create index srDesc_idx on supervision_report(_description);
