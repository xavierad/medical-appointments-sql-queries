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


insert into employee values('25001', 'Jane Sweettooth', '1978-September-30', 'Castanheiras Street', 'Lisboa','1100-300', '1234', 1000);--doutor
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

insert into client values('14002', 'João Tavares', '1998-12-31', 'Buenos Aires Street', 'Lisbon', '1200-632', 'M', 20);
insert into client values('14003', 'Maria Barracosa', '1999-07-18', 'Poeta Bocage Street', 'Lisbon', '1100-020', 'F', 20);
insert into client values('14004', 'Benedita Alves', '2000-04-18', 'Liberty Avenue', 'Lisbon', '1400-270', 'F', 19);
insert into client values('14005', 'Rosa Mota', '1962-05-31', 'Mota Rosa Street', 'Setubal', '1800-032', 'F', 57);
insert into client values('14006', 'Eusébio Ferreira', '1952-06-07', 'Fernando Pessoa Street', 'Lisbon', '2725-300', 'M', 67);
insert into client values('14007', 'Maria Coluna', '1997-03-13', 'Miguel Torga Street', 'Lisbon', '2725-300', 'F', 22);
insert into client values('14008', 'Adalberto Correia', '1979-08-17', 'Lagos Street', 'Lisbon', '2725-300', 'M', 40);
insert into client values('14009', 'Pedro Martin', '1998-12-07', 'Lumiar Street', 'Lisbon', '1020-780', 'M', 20);
insert into client values('14010', 'Xavier Dias', '1998-02-24', 'Almeida Negreiros Street', 'Sintra', '1300-590', 'M', 59);
insert into client values('14024', 'Maria José', '1960-05-14', 'Alves Redol Street', 'Lisbon', '2725-300', 'F', 59);
insert into client values('17324', 'José Maria Turras', '1998-10-04', 'Marinha Street', 'Lisbon', '1200-400', 'M', 21);
insert into client values('14924', 'Alexandrino Ramos', '1988-12-08', 'Dezembro Street', 'Lisbon', '1225-300', 'M', 31);
insert into client values('14001', 'Rafael Silva', '1989-12-21', 'Seixal Street', 'Lisbon', '1305-400', 'M', 30);

insert into phone_number_client values('14002', 9123);

insert into permanent_doctor values('25001');
insert into permanent_doctor values('15101');

insert into trainee_doctor values('11982', '15101');
insert into trainee_doctor values('10120', '25001');

insert into supervision_report values('11982', '2019-11-04 14:15:03', 'Very good!', 4);
insert into supervision_report values('10120', '2019-12-04 00:10:03', 'Something plus insufficient', 1);

insert into appointment values('25001', '2019-11-04 16:00:00', 'There is nothing more practical than a good practical theory', '17324');
insert into appointment values('25001', '2019-12-04 17:00:00', 'Madness is like gravity, all it needs is a little push!', '14001');

insert into consultation values('25001', '2019-11-04 16:00:00', 'ABCDEFGHIJKLMNOPQRSTUVXZ', 'ABCDEFGHIJKLMNOPQRSTUVXZ', 'ABCDEFGHIJKLMNOPQRSTUVXZ', 'ABCDEFGHIJKLMNOPQRSTUVXZ');

insert into consultation_assistant values('25001', '2019-11-04 16:00:00', '12309');

insert into diagnostic_code values('321', 'ABCDEFGHIJKLMNOPQRSTUVXZ');
insert into diagnostic_code values('334', 'BABYSHARK');


insert into consultation_diagnostic values('25001', '2019-11-04 16:00:00', '321');

insert into medication values('Ben-u-ron', 'Júlio de Matos LAB');

insert into prescription values('Ben-u-ron', 'Júlio de Matos LAB', '25001', '2019-11-04 16:00:00', '321', '8h-8h', 'ABCDEFGHIJKLMNOPQRSTUVXZ');

insert into _procedure values('Tooth extraction', 'Extraction');
insert into _procedure values('Maxillary molar periapical radiograph', 'Radiography exam)');
insert into _procedure values('Root canal treatments', 'Cirurgy');

insert into procedure_in_consultation values('Maxillary molar periapical radiograph', '25001', '2019-11-04 16:00:00', 'Great name');

insert into procedure_radiology values('Maxillary molar periapical radiograph', 'thisfile', '25001', '2019-11-04 16:00:00');

insert into teeth values(1, 8, 'Third molar');

insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-11-04 16:00:00', 1, 8, 32.1);
