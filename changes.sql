-- 1
update employee
set street = 'Bodega street', city = 'Alverca', zip = '1234-098'
where _name = 'Jane Sweettooth' and VAT = doctor.VAT; -- certificar que é doutor


-- 2 Change salary (+5%) of all doctors with > 100 appoint. in 2019
update employee
set salary = salary*1.05
where count(select appointment.VAT_doctor
            from appointment
            where extract(year from date_timestamp)='2019') > 100;


-- 3 Del doctor jane sweettoth, removing appoint. & consult.(proced., diagn., prescr.)
delete from (employee natural join doctor), appointment, consultation,
            procedure_in_consultation, procedure_charting, procedure_radiology,
            prescription
where doctor.VAT=(select employee.VAT
                  from employee
                  where employee._name = 'Jane Sweettooth')
