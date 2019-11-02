
-- 1
select C.VAT, C.name, PN.phone_number
from  client as C, phone_number_client as PN, appointment as A, consultation as C, doctor as D, employee as E
where C.VAT = A.VAT_client and A.VAT_doctor = C.VAT_doctor and C.VAT_doctor = D.VAT and D.VAT = E.VAT 
order by client.name;

--2
select employee.name, trainee_doctor.VAT, employee.name --?  
from supervision_report as SP, 
where supervision_report.evaluation < 3 or supervision_report.description = 'insufficient';
