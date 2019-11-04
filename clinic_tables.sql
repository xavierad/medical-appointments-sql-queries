drop table if exists employee;
drop table if exists phone_number_employee;
drop table if exists receptionist;
drop table if exists doctor;
drop table if exists nurse;
drop table if exists client;
drop table if exists phone_number_client;
drop table if exists permanent_doctor;
drop table if exists trainee_doctor;
drop table if exists supervision_report;
drop table if exists appointment;
drop table if exists consultation;
drop table if exists consultation_assistant;
drop table if exists diagnostic_code;
drop table if exists diagnostic_code_relation;
drop table if exists consultation_diagnostic;
drop table if exists medication;
drop table if exists prescription;
drop table if exists procedure; --pôr " "?
drop table if exists procedure_in_consultation;
drop table if exists procedure_radiology;
drop table if exists teeth;
drop table if exists procedure_charting;

create table employee
 (VAT varchar(255), --inteiro ou varchar?
  name varchar(255),
  birth_date varchar(255),--talvez char ou varchar? DEFINIR
  street varchar(255),--há algum problema em pôr em todos 255?
  city varchar(255),
  zip varchar(255),
  IBAN varchar(255),--integer? se sim, com quantos dígitos?
  salary integer,
  primary key (VAT),
  check(salary > 0),
  unique(IBAN));
--falta: ICs, all employees are...

create table phone_number_employee
 (VAT varchar(255), --inteiro, certo?
  phone integer, --ou varchar?
  primary key(VAT, phone),
  foreign key(VAT) references employee);

create table receptionist
 (VAT varchar(255), --inteiro, certo?
  primary key(VAT),
  foreign key(VAT) references employee);

create table doctor
 (VAT varchar(255), --inteiro, certo?
  specialization varchar(255),
  biography varchar(255),--ou mais?
  e-mail varchar(255),
  primary key(VAT),
  foreign key(VAT) references employee,
  unique(e-mail));
--falta ICs: all doctors are...

create table nurse
 (VAT varchar(255), --inteiro, ceto?
  primary key(VAT),
  foreign key(VAT) references employee);

create table client
 (VAT varchar(255), --inteiro, certo?
  name varchar(255),
  birth_date varchar(255),
  street varchar(255),
  city varchar(255),
  zip varchar(255),
  gender varchar(255), --será que são necessários 255? M/F
  age integer,
  primary key(VAT),
  check(age > 0));
--age derived from birth_date, ver como...

create table phone_number_client
 (VAT varchar(255), --ineteiro, certo?
  phone varchar(255),--?
  primary key(VAT, phone),
  foreign key(VAT) references client);

create table permanent_doctor
 (VAT varchar(255),--inteiro,certo?
  primary key(VAT),
  foreign key(VAT) references doctor);

create table trainee_doctor
 (VAT varchar(255), --inteiro, certo?
  supervisor varchar(255),
  primary key(VAT),
  foreign key(VAT) references doctor,
  foreign key(supervisor) references permanent_doctor);

create table supervision_report
 (VAT varchar(255), --inteiro?
  date_timestamp varchar(255),--varchar? ver noutros para alterar
  description varchar(255),
  evaluation integer,
  primary key(VAT, date_timestamp),
  foreign key(VAT) references trainee_doctor,
  check(evaluation between 1 and 5)); --aqui pode-se, certo?

create table appointment
 (VAT_doctor varchar(255), --inteiro?
  date_timestamp varchar(255),
  description varchar(255),
  VAT_client varchar(255),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor) references doctor,
  foreign key(VAT_client) references client);

create table consultation
 (VAT_doctor varchar(255),
  date_timestamp varchar(255),
  SOAP_S varchar(255),
  SOAP_O varchar(255),
  SOAP_A varchar(255),
  SOAP_P varchar(255),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor, date_timestamp) references appointment);
--IC: consultations are always assigned  to at least 1 assistant nurse, como?

create table consultation_assistant
 (VAT_doctor varchar(255),
  date_timestamp varchar(255),
  VAT_nurse varchar(255),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor, date_timestamp) references consultation,
  foreign key(VAT_nurse) references nurse);

create table diagnostic_code
 (ID varchar(255), --confirmar!
  description varchar(255),
  primary key(ID));

create table diagnostic_code_relation
 (ID1 varchar(255),--confirmar!
  ID2 varchar(255),
  type varchar(255)
  primary key(ID1, ID2),
  foreign key(ID1) references diagnostic_code,
  foreign key(ID2) references diagnostic_code);

create table consultation_diagnostic
 (VAT_doctor varchar(255),
  date_timestamp varchar(255),
  ID varchar(255),
  primary key(VAT_doctor, date_timestamp, ID),
  foreign key(VAT_doctor, date_timestamp) references consultation,
  foreign key(ID) references diagnostic_code);

create table medication
 (name varchar(255),
  lab varchar(255),
  primary key(name, lab));

create table prescription
 (name varchar(255),
  lab varchar(255),
  VAT_doctor varchar(255),
  date_timestamp varchar(255),
  ID varchar(255),
  dosage varchar(255), --como? como se fosse uma descrição
  description varchar(255),
  primary key(name, lab, VAT_doctor, date_timestamp, ID),
  foreign key(VAT_doctor, date_timestamp, ID) references consultation_diagnostic,
  foreign key(name, lab) references medication);

create table procedure
 (name varchar(255),
  type varchar(255),
  primary key(name));

create table procedure_in_consultation
 (name varchar(255),
  VAT_doctor varchar(255),
  date_timestamp varchar(255),
  description varchar(255),
  primary key(name, VAT_doctor, date_timestamp),
  foreign key(name) references procedure,
  foreign key(VAT_doctor, date_timestamp) references consultation);

create table procedure_radiology
 (name varchar(255),
  file varchar(255),
  VAT_doctor varchar(255),
  date_timestamp varchar(255),
  primary key(name, file, VAT_doctor, date_timestamp),
  foreign key(name, VAT_doctor, date_timestamp) references procedure_in_consultation);

create table teeth
 (quadrant integer, --varchar ou integer?: 1,2,3,4 quadrant
  number integer,
  name varchar(255),
  primary key(quadrant, number));

create table procedure_charting
 (name varchar(255),
  VAT varchar(255),
  date_timestamp varchar(255),
  quadrant integer(255), --varchar ou integer?: 1,2,3,4 quadrant
  number integer,
  desc varchar(255), --o que é desc?? descrição?
  measure varchar(255), --confirmar! float
  primary key(name, VAT, date_timestamp, quadrant, number),
  foreign key(name, VAT, date_timestamp) references procedure_in_consultation,
  foreign key(quadrant, number) references teeth);


--vats, de que ordem de grandeza?
insert into employee values('25001', 'Jane Sweettooth', '30/September/78', 'Castanheiras Street', 'Lisboa','1100-300', '1234', 1000);--doutor
insert into employee values('15101', 'André Fernandes', '7/June/78', 'Técnico Avenue', 'Lisboa', '1110-450', '5323', 2000);--doutor
insert into employee values('10120', 'Jorge Goodenough', '12/May/38', 'Cinzeiro Street', 'Lisboa','1100-320', '4321', 1000);--doutor
insert into employee values('11982', 'Deolinda de Villa Mar', '6/September/67', 'Grande Campo Street', 'Lisboa','1100-270', '6979', 1000);--doutor
insert into employee values('12309', 'Hermelinda Boavida', '17/December/45', 'Cinco Batalhas Street', 'Lisboa', '1110-150', '5901', 2000);--enferm
insert into employee values('13490', 'Zacarias Fernandes', '3/February/50', 'Janelas Street', 'Lisboa', '1110-260', '6501', 2000);--enferm
insert into employee values('14574', 'Joaquim Ahmad', '14/March/65', 'Linhas de ferro Street', 'Lisboa','1100-100', '0912', 1000);--recep
insert into employee values('16347', 'Maria Peixeira', '2/January/80', 'Rés-do-chão Street', 'Lisboa', '1200-230', '6832', 2000);--recep

insert into phone_number_employee values('25001', 1234);
insert into phone_number_employee values('15101', 5678);
insert into phone_number_employee values('10120', 9102);
insert into phone_number_employee values('11982', 3456);
insert into phone_number_employee values('12309', 7890);
insert into phone_number_employee values('13490', 0123);
insert into phone_number_employee values('14574', 4567);
insert into phone_number_employee values('16347', 8901);

insert into receptionist values('14574');
insert into receptionist values('16347');

insert into doctor values('25001', 'Anesthesiology', 'janesweettoth@gmail.com');
insert into doctor values('15101', 'Pediatric dentistry', 'andrefernandes@gmail.com');
insert into doctor values('10120', 'Dental public health', 'goodenough@gmail.com');
insert into doctor values('11982', 'Implant dentistry', 'marvilla@gmail.com');

insert into nurse values('12309');
insert into nurse values('13490');

insert into client values('14024', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');
insert into client values('17324', 'José Maria', '4/October/98', 'Marinha Street', 'Lisbon', '1200-400', 'Male', '21');
insert into client values('14924', 'Alexandre Ramos', '8/December/88', 'Dezembro Street', 'Lisbon', '1225-300', 'Male', '31');
