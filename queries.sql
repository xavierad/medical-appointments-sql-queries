
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


-- 8
