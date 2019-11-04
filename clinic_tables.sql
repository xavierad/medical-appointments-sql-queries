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
drop table if exists _procedure; 
drop table if exists procedure_in_consultation;
drop table if exists procedure_radiology;
drop table if exists teeth;
drop table if exists procedure_charting;

create table employee
 (VAT char(10), 
  _name varchar(255),
  birth_date char(10),--ex.:YYYY-MM-DD
  street varchar(50),
  city varchar(50),
  zip varchar(50),
  IBAN char(10),
  salary numeric(5,2),
  primary key (VAT),
  check(salary > 0),
  unique(IBAN));
--IC: All employees are either receptionists, nurses or doctors

create table phone_number_employee
 (VAT char(10),
  phone integer,
  primary key(VAT, phone),
  foreign key(VAT) references employee);

create table receptionist
 (VAT char(10),
  primary key(VAT),
  foreign key(VAT) references employee);

create table doctor
 (VAT char(10),
  specialization varchar(255),
  biography varchar(255),
  e_mail varchar(255),
  primary key(VAT),
  foreign key(VAT) references employee,
  unique(e_mail));
--IC: All doctors are either trainees or permanent

create table nurse
 (VAT char(10),
  primary key(VAT),
  foreign key(VAT) references employee);

create table client
 (VAT char(10),
  _name varchar(255),
  birth_date varchar(255),
  street varchar(255),
  city varchar(255),
  zip varchar(255),
  gender char(1),--ex.:M/F
  age integer,
  primary key(VAT),
  check(age > 0));
--IC: age derived from birth_date

create table phone_number_client
 (VAT char(10),
  phone integer,
  primary key(VAT, phone),
  foreign key(VAT) references client);

create table permanent_doctor
 (VAT char(10),
  primary key(VAT),
  foreign key(VAT) references doctor);

create table trainee_doctor
 (VAT char(10),
  supervisor char(10),
  primary key(VAT),
  foreign key(VAT) references doctor,
  foreign key(supervisor) references permanent_doctor);

create table supervision_report
 (VAT char(10),
  date_timestamp char(20),--ex.:YYYY-MM-DD HH:MM:SS
  _description varchar(255),
  evaluation integer,
  primary key(VAT, date_timestamp),
  foreign key(VAT) references trainee_doctor,
  check(evaluation between 1 and 5));

create table appointment
 (VAT_doctor char(10),
  date_timestamp char(20),
  _description varchar(255),
  VAT_client char(10),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor) references doctor,
  foreign key(VAT_client) references client);

create table consultation
 (VAT_doctor char(10),
  date_timestamp char(20),
  SOAP_S varchar(255),
  SOAP_O varchar(255),
  SOAP_A varchar(255),
  SOAP_P varchar(255),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor, date_timestamp) references appointment);
--IC: Consultations are always assigned to at least one assistant nurse

create table consultation_assistant
 (VAT_doctor char(10),
  date_timestamp char(20),
  VAT_nurse char(10),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor, date_timestamp) references consultation,
  foreign key(VAT_nurse) references nurse);

create table diagnostic_code
 (ID char(10),
  _description varchar(255),
  primary key(ID));

create table diagnostic_code_relation
 (ID1 char(10),
  ID2 char(10),
  _type varchar(255),
  primary key(ID1, ID2),
  foreign key(ID1) references diagnostic_code,
  foreign key(ID2) references diagnostic_code);

create table consultation_diagnostic
 (VAT_doctor char(10),
  date_timestamp char(20),
  ID char(10),
  primary key(VAT_doctor, date_timestamp, ID),
  foreign key(VAT_doctor, date_timestamp) references consultation,
  foreign key(ID) references diagnostic_code);

create table medication
 (_name varchar(255),
  lab varchar(255),
  primary key(_name, lab));

create table prescription
 (_name varchar(255),
  lab varchar(255),
  VAT_doctor char(10),
  date_timestamp char(20),
  ID char(10),
  dosage varchar(255),--ex.:8h-8h
  _description varchar(255),
  primary key(_name, lab, VAT_doctor, date_timestamp, ID),
  foreign key(VAT_doctor, date_timestamp, ID) references consultation_diagnostic,
  foreign key(_name, lab) references medication);

create table _procedure
 (_name varchar(255),
  _type varchar(255),
  primary key(_name));

create table procedure_in_consultation
 (_name varchar(255),
  VAT_doctor char(10),
  date_timestamp char(20),
  _description varchar(255),
  primary key(_name, VAT_doctor, date_timestamp),
  foreign key(_name) references _procedure,
  foreign key(VAT_doctor, date_timestamp) references consultation);

create table procedure_radiology
 (_name varchar(255),
  _file varchar(255),
  VAT_doctor char(10),
  date_timestamp char(20),
  primary key(_name, _file, VAT_doctor, date_timestamp),
  foreign key(_name, VAT_doctor, date_timestamp) references procedure_in_consultation);

create table teeth
 (quadrant integer, -- 1-4
  _number integer,-- 1-8
  _name varchar(255),
  primary key(quadrant, _number));

create table procedure_charting
 (_name varchar(255),
  VAT char(10),
  date_timestamp char(20),
  quadrant integer,
  _number integer,
  _desc varchar(255),
  measure numeric(2,1),
  primary key(_name, VAT, date_timestamp, quadrant, _number),
  foreign key(_name, VAT, date_timestamp) references procedure_in_consultation,
  foreign key(quadrant, _number) references teeth);


--vats, de que ordem de grandeza?
insert into employee values('25001', 'Jane Sweettooth', '30/September/78', 'Castanheiras Street', 'Lisboa','1100-300', '1234', 1000);--doutor
insert into employee values('15101', 'André Fernandes', '7/June/78', 'Técnico Avenue', 'Lisboa', '1110-450', '5323', 2000);--doutor
insert into employee values('10120', 'Jorge Goodenough', '12/May/38', 'Cinzeiro Street', 'Lisboa','1100-320', '4321', 1000);--doutor
insert into employee values('11982', 'Deolinda de Villa Mar', '6/September/67', 'Grande Campo Street', 'Lisboa','1100-270', '6979', 1000);--doutor
insert into employee values('12309', 'Ermelinda Boavida', '17/December/45', 'Cinco Batalhas Street', 'Lisboa', '1110-150', '5901', 2000);--enferm
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

insert into client values('14002', 'João Tavares', '31/December/98', 'Buenos Aires Street', 'Lisbon', '1200-632', 'Male', '20');
insert into client values('14003', 'Maria Barracosa', '18/July/99', 'Poeta Bocage Street', 'Lisbon', '1100-020', 'Female', '20');
insert into client values('14004', 'Benedita Rosa', '18/April/00', 'Liberty Avenue', 'Lisbon', '1400-270', 'Female', '19');
insert into client values('14005', 'Rosa Mota', '31/May/62', 'Mota Rosa Street', 'Setubal', '1800-032', 'Female', '57');
insert into client values('14006', 'Eusébio Ferreira', '07/June/52', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '67');
insert into client values('14007', 'Mário Coluna', '13/March/97', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '22');
insert into client values('14008', 'Adalberto Correia', '17/August/79', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '40');              
insert into client values('14009', 'Pedro Martin', '07/December/98', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');
insert into client values('14010', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14011', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14021', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14022', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14023', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');
insert into client values('14024', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14025', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14026', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14027', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14028', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
insert into client values('14029', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');              
              
              
              
insert into client values('14024', 'Maria José', '14/May/60', 'Lagos Street', 'Lisbon', '2725-300', 'Female', '59');
insert into client values('17324', 'José Maria', '4/October/98', 'Marinha Street', 'Lisbon', '1200-400', 'Male', '21');
insert into client values('14924', 'Alexandre Ramos', '8/December/88', 'Dezembro Street', 'Lisbon', '1225-300', 'Male', '31');            
insert into client values('14001', 'Rafael Silva', '21/December/89', 'Seixal Street', 'Lisbon', '1305-400', 'Male', '30');
