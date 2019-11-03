
-- 1
select C.VAT, C.name, PN.phone_number
from  client as C, phone_number_client as PN, appointment as A, consultation as C, doctor as D, employee as E
where C.VAT = A.VAT_client and A.VAT_doctor = C.VAT_doctor and C.VAT_doctor = D.VAT and D.VAT = E.VAT 
order by client.name;

--2
select employee.name, trainee_doctor.VAT, employee.name, supervision_report.evaluation, supervision_report.description --employee.name: nome do trainee e nome do doctor
from supervision_report as SP, trainee_doctor as TD, permanent_doctor as PD, doctor as D, employee as E
where (supervision_report.evaluation < 3 or supervision_report.description = '%insufficient') and  SP.VAT = TD.VAT and TD.VAT = D.VAT and D.VAT = E.VAT and TD.supervisor = PD.VAT and PD.VAT = D.VAT and D.VAT = E.VAT
order by supervision_report.evaluation desc;

--3
select client.name, client.city, client.VAT_client
from client, appointment, consultation
where appointment.VAT_doctor = consultation.VAT_doctor and consultation.date_timestamp 










