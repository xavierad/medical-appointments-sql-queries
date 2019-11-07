
-- 1
select distinct client.VAT, client._name as name, PN.phone
from  (client natural join phone_number_client as PN),
      (appointment right outer join consultation on appointment.date_timestamp=consultation.date_timestamp)
where  client.VAT = appointment.VAT_client and consultation.VAT_doctor = all(select employee.VAT
                                                                             from employee
                                                                             where employee._name = 'Jane Sweettooth')
order by client._name;
-- index: employee._name

-- 2
select E_t._name as trainee_name, SR.VAT as trainee_VAT, E_p._name as permanent_name, SR.evaluation, SR._description as description
from ((supervision_report as SR) natural left outer join trainee_doctor),
     employee as E_p, employee as E_t
where (SR.evaluation < 3 or SR._description like '%insufficient')
      and trainee_doctor.supervisor = E_p.VAT
      and trainee_doctor.VAT=E_t.VAT
order by SR.evaluation desc;
-- indexes: SR.evaluation, SR._description

-- 3
select client._name as name, client.city, client.VAT
from client, appointment, consultation
where client.VAT=appointment.VAT_client
and appointment.VAT_doctor=consultation.VAT_doctor
and appointment.date_timestamp=consultation.date_timestamp
and (SOAP_O like '%gingivitis' or SOAP_O like '%periodontitis');

-- 4
select client._name as name, client.VAT, client.street, client.city, client.zip
from client, appointment
left join consultation
on appointment.date_timestamp=consultation.date_timestamp
and appointment.VAT_doctor=consultation.VAT_doctor
where consultation.date_timestamp is null
and consultation.VAT_doctor is null
and client.VAT=appointment.VAT_client;

-- 5
select distinct diagnostic_code.ID, diagnostic_code._description, prescription._name
from diagnostic_code, consultation_diagnostic, prescription
where diagnostic_code.ID=consultation_diagnostic.ID
and consultation_diagnostic.VAT_doctor=prescription.VAT_doctor
and consultation_diagnostic.date_timestamp=prescription.date_timestamp
and consultation_diagnostic.ID=prescription.ID
order by prescription._name;

-- 6
select  '>= 18' as group_ ,count(consultation_assistant.VAT_NURSE)/(select count(*) from nurse) as AVG_nurse,
        count(consultation_diagnostic.ID)/(select count(*) from consultation_diagnostic) as AVG_diagnostic_code,
        count(procedure_in_consultation.date_timestamp)/(select count(*) from procedure_in_consultation) as AVG_procedure,
        count(prescription.date_timestamp)/(select count(*) from prescription) as AVG_prescription
from consultation inner join appointment on consultation.date_timestamp = appointment.date_timestamp
    inner join client on appointment.VAT_CLIENT=client.VAT
    inner join consultation_assistant on consultation_assistant.date_timestamp = consultation.date_timestamp
    inner join consultation_diagnostic on consultation_diagnostic.date_timestamp = consultation.date_timestamp
    inner join procedure_in_consultation on procedure_in_consultation.date_timestamp = consultation.date_timestamp
    inner join prescription on prescription.date_timestamp = consultation.date_timestamp
    inner join _procedure on _procedure._name = procedure_in_consultation._name
where  procedure_in_consultation.date_timestamp like '2019%' and client.age >= 18

Union all

select  '<  18' as group_ ,count(consultation_assistant.VAT_NURSE)/(select count(*) from nurse) as AVG_nurse,
        count(consultation_diagnostic.ID)/(select count(*) from consultation_diagnostic) as AVG_diagnostic_code,
        count(procedure_in_consultation.date_timestamp)/(select count(*) from procedure_in_consultation) as AVG_procedure,
        count(prescription.date_timestamp)/(select count(*) from prescription) as AVG_prescription
from consultation inner join appointment on consultation.date_timestamp = appointment.date_timestamp
    inner join client on appointment.VAT_CLIENT=client.VAT
    inner join consultation_assistant on consultation_assistant.date_timestamp = consultation.date_timestamp
    inner join consultation_diagnostic on consultation_diagnostic.date_timestamp = consultation.date_timestamp
    inner join procedure_in_consultation on procedure_in_consultation.date_timestamp = consultation.date_timestamp
    inner join prescription on prescription.date_timestamp = consultation.date_timestamp
    inner join _procedure on _procedure._name = procedure_in_consultation._name
where  procedure_in_consultation.date_timestamp like '2019%' and client.age < 18;


-- 7
select count_dcode._name as 'medication name', count_dcode.dcode_ID as 'ID diagnostic_code'
from
     (select diagnostic_code.ID as dcode_ID, prescription._name, count(prescription._name) as count_name
      from prescription
      right join diagnostic_code on prescription.ID = diagnostic_code.ID
      group by diagnostic_code.ID) as count_dcode

inner join
      (select max_dcode.dcode_ID, max(max_dcode.count_name) as max_count_name
       from
          (select diagnostic_code.ID as dcode_ID, prescription._name, count(prescription._name) as count_name
           from prescription
           right join diagnostic_code on prescription.ID = diagnostic_code.ID
           group by diagnostic_code.ID) as max_dcode
       group by max_dcode.dcode_ID) as max_count_dcode

on count_dcode.dcode_ID = max_count_dcode.dcode_ID
and count_dcode.count_name = max_count_dcode.max_count_name;


-- 8
select _name, lab
from prescription
where (_name, lab) in
(
  select prescription._name, prescription.lab
  from diagnostic_code
  inner join prescription
  on prescription.ID = diagnostic_code.ID
  and prescription.date_timestamp like '2019%'
)
and (_name, lab) not in
(
  select prescription._name, prescription.lab
  from diagnostic_code
  inner join prescription
  on prescription.ID = diagnostic_code.ID
  and prescription.date_timestamp like '2019%'
)
order by _name, lab;


-- 9
select client._name, client.street, client.city, client.zip
from client
inner join appointment
on client.VAT = appointment.VAT_client
where client.VAT not in (
        select client.VAT
        from consultation
        right join appointment
          on consultation.VAT_doctor = appointment.VAT_doctor
          and consultation.date_timestamp = appointment.date_timestamp
        inner join client
          on client.VAT = appointment.VAT_client
        where consultation.VAT_doctor is NULL and consultation.date_timestamp is NULL
          and appointment.date_timestamp like '2019%'
)
and appointment.date_timestamp like '2019%'
group by client.VAT;
