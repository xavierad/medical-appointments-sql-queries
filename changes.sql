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
    else employee.salary -- necessario, senao preenche com NULLs
  end;


-- 3 Del doctor jane sweettoth, removing appoint. & consult.(proced., diagn., prescr.)
-- a corrigir!!
delete from _procedure
where (select count(*)
          from procedure_in_consultation
          where procedure_in_consultation.VAT_doctor=(select employee.VAT
                                                      from employee
                                                     where employee._name='Jane Sweettooth')
          group by procedure_in_consultation._name)=1;

delete from diagnostic_code
where 1=
  case
    when (select count(*)
          from consultation_diagnostic
          where consultation_diagnostic.VAT_doctor=(select employee.VAT
                                                      from employee
                                                      where employee._name='Jane Sweettooth')
          group by consultation_diagnostic.ID)=1 then 1
    else 0
  end;

delete from employee, _procedure
where employee._name = 'Jane Sweettooth';
