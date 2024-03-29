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

delete from employee,
where employee._name = 'Jane Sweettooth';


/* 4-
Find the diagnosis code corresponding to gingivitis.
Create also a new diagnosis code corresponding to periodontitis.
Change the diagnosis from gingivitis to periodontitis for all clients where, for the same
consultation/diagnosis, a dental charting procedure shows a value
above 4 in terms of the average gap between the teeth and the gums */

-- select diagnostic_code.ID from diagnostic_code where diagnostic_code._desc like '%gingivitis';
insert into diagnostic_code values('400', 'It is periodontitis');

update consultation_diagnostic
set ID = (select ID
          from diagnostic_code
          where _description like '%periodontitis')
where consultation_diagnostic.ID = (select ID
                                    from diagnostic_code
                                    where diagnostic_code._description like '%gingivitis')
                                    and exists (select procedure_charting.VAT
                                                from procedure_charting
                                                where consultation_diagnostic.VAT_doctor=procedure_charting.VAT
                                                  and consultation_diagnostic.date_timestamp = procedure_charting.date_timestamp
                                                group by procedure_charting.VAT, procedure_charting.date_timestamp
                                                having avg(procedure_charting.measure)>4.0);


update consultation_diagnostic cd
  set ID = (select ID from diagnostic_code where _description like '%periodontitis')
  where cd.ID = (select ID from diagnostic_code where _description like '%gingivitis')
  and exists (select pc.VAT from procedure_charting as pc where cd.VAT_doctor=pc.VAT and cd.date_timestamp=pc.date_timestamp
  group by pc.VAT, pc.date_timestamp
having avg(measure)>4);
