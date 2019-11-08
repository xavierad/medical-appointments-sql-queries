-- delete if exists!

-- 1

create view dim_date as
select date_timestamp, day(date_timestamp) as 'Day', month(date_timestamp) as 'Month', year(date_timestamp) as 'Year'
from consultation;

-- 2

create view dim_client as
select VAT as 'VAT client', gender as 'Gender', age as 'Age'
from client;

-- 3
create view dim_location_client as
select zip as 'Zip code', city as 'City'
from client;

-- 4

create view facts_consults as
select
(select VAT from dim_client), (select * from dim_date), (select zip from dim_location_client),
count(select * from _procedure) as num_procedures, count(select * from medication) as num_medications, count(select * from diagnostic_code) as num_diagnostic_codes)
from consultation;

-- outra forma de fazer ?

create view facts_consults as
select dim_client.VAT, dim_date.date_timestamp, dim_location_client.zip
from consultation
-- inner join dim_client on consultation.VAT = dim_client.VAT
inner join dim_date on consultation.date_timestamp = dim_date.date_timestamp
-- inner join dim_location_client on consultation.VAT_client = dim_client.VAT
