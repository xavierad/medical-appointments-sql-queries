
-- 1
--select C.VAT, C.name, PN.phone
--from  client as C, phone_number_client as PN, appointment as A, consultation as C, doctor as D, employee as E
--where C.VAT = A.VAT_client and A.VAT_doctor = C.VAT_doctor and C.VAT_doctor = D.VAT and D.VAT = E.VAT
--order by client.name;
select C.VAT, C.name, PN.phone
from  client as C, phone_number_client as PN, appointment as A
where C.VAT = A.VAT_client and A.VAT_doctor = all(select E.VAT
                                                  from (consultation as C) natural join (employee as E)
                                                  where C.VAT_doctor = E.VAT)
order by client.name;

--2
--select employee.name, trainee_doctor.VAT, employee.name, supervision_report.evaluation, supervision_report.description --employee.name: nome do trainee e nome do doctor
--from supervision_report as  SP, trainee_doctor as TD, permanent_doctor as PD, doctor as D, employee as E
--where (supervision_report.evaluation < 3 or supervision_report.description = '%insufficient') and  SP.VAT = TD.VAT and TD.VAT = D.VAT and D.VAT = E.VAT and TD.supervisor = PD.VAT and PD.VAT = D.VAT and D.VAT = E.VAT
--order by supervision_report.evaluation desc;
select E.name, TD.VAT, E.name, SR.evaluation, SR.description --employee.name: nome do trainee e nome do doctor
from supervision_report as  SR, trainee_doctor as TD, permanent_doctor as PD, doctor as D, employee as E
where (SR.evaluation < 3 or SR.description = '%insufficient') and  SR.VAT = TD.VAT and TD.VAT = D.VAT and D.VAT = E.VAT and TD.supervisor = PD.VAT and PD.VAT = D.VAT and D.VAT = E.VAT
order by SR.evaluation desc;

--3
select client.name, client.city, client.VAT_client
from client, appointment, consultation
where appointment.VAT_doctor = consultation.VAT_doctor and consultation.date_timestamp
