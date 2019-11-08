-- delete if exists!
drop view if exists dim_date;
drop view if exists dim_client;
drop view if exists dim_location_client;
drop view if exists facts_consults;

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
select client.VAT, consultation.date_timestamp, client.zip,
         (select count(*) from procedure_in_consultation) as num_procedures,
         (select count(*) from prescription) as num_medications,
         (select count(*) from consultation_diagnostic) as num_diagnostic_codes
  from consultation
  inner join procedure_in_consultation on procedure_in_consultation.date_timestamp = consultation.date_timestamp
                                       and procedure_in_consultation.VAT_doctor = consultation.VAT_doctor
  inner join appointment on consultation.date_timestamp = appointment.date_timestamp
                         and consultation.VAT_doctor = appointment.VAT_doctor
  inner join client on appointment.VAT_client = client.VAT
