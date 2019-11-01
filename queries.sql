
-- 1
select client.VAT, client.name, phone_number_client.phone_number
from  consultation natural join doctor on VAT_doctor
where doctor.VAT = employee.VAT and employee.name = 'Jane Sweettooth';

--2
