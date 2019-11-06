
-- 1
select distinct client.VAT, client._name, PN.phone
from  (client natural join phone_number_client as PN),
      (appointment right outer join consultation on appointment.date_timestamp=consultation.date_timestamp)
where  client.VAT = appointment.VAT_client and consultation.VAT_doctor = all(select employee.VAT
                                                                             from employee
                                                                             where employee._name = 'Jane Sweettooth')
order by client._name;

-- 2
select E_t._name, SR.VAT, E_p._name, SR.evaluation, SR._description
from ((supervision_report as SR) natural left outer join trainee_doctor),
     employee as E_p, employee as E_t
where trainee_doctor.VAT=E_t.VAT
      and trainee_doctor.supervisor = E_p.VAT
      and (SR.evaluation < 3 or SR._description like '%insufficient')
order by SR.evaluation desc;

-- 3
select client._name, client.city, client.VAT
from client, appointment, consultation
where client.VAT=appointment.VAT_client
and appointment.VAT_doctor=consultation.VAT_doctor
and appointment.date_timestamp=consultation.date_timestamp
and (SOAP_O like '%gingivitis' or SOAP_O like '%periodontitis');

-- 4
select client._name, client.VAT, client.street, client.city, client.zip
from client, appointment
left join consultation
on appointment.date_timestamp=consultation.date_timestamp
and appointment.VAT_doctor=consultation.VAT_doctor
where consultation.date_timestamp is null
and consultation.VAT_doctor is null
and client.VAT=appointment.VAT_client;
