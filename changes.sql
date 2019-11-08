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
-- ADICIONAR MAIS DADOS PARA TESTAR!!
delete proc from _procedure proc
  join procedure_in_consultation as pc on proc._name=pc._name
  join doctor as d on pc.VAT_doctor=d.VAT
  join employee on d.VAT=employee.VAT
where employee._name='Jane Sweettooth' and
      not exists(select *
                 from (select *
                       from _procedure) as p natural join procedure_in_consultation
                 where p._name=proc._name and procedure_in_consultation.VAT_doctor<>d.VAT);

delete dcode from diagnostic_code dcode
 join consultation_diagnostic as consd on dcode.ID=consd.ID
 join doctor as d on consd.VAT_doctor=d.VAT
 join employee on d.VAT=employee.VAT
where employee._name='Jane Sweettooth' and
     not exists(select *
                from (select *
                      from diagnostic_code) as dcode1 natural join consultation_diagnostic
                where dcode1.ID=dcode.ID and consultation_diagnostic.VAT_doctor<>d.VAT);

delete from employee, _procedure
where employee._name = 'Jane Sweettooth';


-- 4 find diag. code gingivitis, create diagnostic_code correspond to periodontitis, change diagnosis from gingivitis to periodontitis
