-- 1
update employee, doctor
set employee.street = 'Livro Street', employee.city = 'Alverca', employee.zip = '1234-098'
where employee._name = 'Jane Sweettooth' and employee.VAT = doctor.VAT; -- certificar que é doutor


-- 2 Change salary (+5%) of all doctors with > 100 appoint. in 2019
update employee
set employee.salary =
  case
    when (select count(*)
          from appointment
          where extract(year from appointment.date_timestamp)='2019' and employee.VAT=appointment.VAT_doctor
          group by appointment.VAT_doctor) > 100 then employee.salary*1.05
    else employee.salary
  end;


-- 3 Del doctor jane sweettoth, removing appoint. & consult.(proced., diagn., prescr.)
delete from (employee natural join doctor), appointment, consultation,
            procedure_in_consultation, procedure_charting, procedure_radiology,
            prescription
where doctor.VAT=(select employee.VAT
                  from employee
                  where employee._name = 'Jane Sweettooth')
