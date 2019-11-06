SET foreign_key_checks = 0;
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
SET foreign_key_checks = 1;

create table employee
 (VAT char(10),
  _name varchar(255),
  birth_date char(10),--  ex.:YYYY-MM-DD
  street varchar(50),
  city varchar(50),
  zip varchar(50),
  IBAN char(10),
  salary numeric(7,2), -- 7 dígitos (total), 2 depois da virgula
  primary key (VAT),
  check(salary > 0),
  unique(IBAN));
-- IC: All employees are either receptionists, nurses or doctors

create table phone_number_employee
 (VAT char(10),
  phone integer,
  primary key(VAT, phone),
  foreign key(VAT) references employee(VAT));

create table receptionist
 (VAT char(10),
  primary key(VAT),
  foreign key(VAT) references employee(VAT));

create table doctor
 (VAT char(10),
  specialization varchar(255),
  biography varchar(255),
  e_mail varchar(255),
  primary key(VAT),
  foreign key(VAT) references employee(VAT),
  unique(e_mail));
-- IC: All doctors are either trainees or permanent

create table nurse
 (VAT char(10),
  primary key(VAT),
  foreign key(VAT) references employee(VAT));

create table client
 (VAT char(10),
  _name varchar(255),
  birth_date char(10),
  street varchar(255),
  city varchar(255),
  zip varchar(255),
  gender char(1),-- ex.:M/F
  age integer,
  primary key(VAT),
  check(age > 0));
-- IC: age derived from birth_date

create table phone_number_client
 (VAT char(10),
  phone integer,
  primary key(VAT, phone),
  foreign key(VAT) references client(VAT));

create table permanent_doctor
 (VAT char(10),
  primary key(VAT),
  foreign key(VAT) references doctor(VAT));

create table trainee_doctor
 (VAT char(10),
  supervisor char(10),
  primary key(VAT),
  foreign key(VAT) references doctor(VAT),
  foreign key(supervisor) references permanent_doctor(VAT));

create table supervision_report
 (VAT char(10),
  date_timestamp char(20),-- ex.:YYYY-MM-DD HH:MM:SS
  _description varchar(255),
  evaluation integer,
  primary key(VAT, date_timestamp),
  foreign key(VAT) references trainee_doctor(VAT),
  check(evaluation between 1 and 5));

create table appointment
 (VAT_doctor char(10),
  date_timestamp char(20),
  _description varchar(255),
  VAT_client char(10),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor) references doctor(VAT),
  foreign key(VAT_client) references client(VAT));

create table consultation
 (VAT_doctor char(10),
  date_timestamp char(20),
  SOAP_S varchar(255),
  SOAP_O varchar(255),
  SOAP_A varchar(255),
  SOAP_P varchar(255),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor, date_timestamp) references appointment(VAT_doctor, date_timestamp));
-- IC: Consultations are always assigned to at least one assistant nurse

create table consultation_assistant
 (VAT_doctor char(10),
  date_timestamp char(20),
  VAT_nurse char(10),
  primary key(VAT_doctor, date_timestamp),
  foreign key(VAT_doctor, date_timestamp) references consultation(VAT_doctor, date_timestamp),
  foreign key(VAT_nurse) references nurse(VAT));

create table diagnostic_code
 (ID char(10),
  _description varchar(255),
  primary key(ID));

create table diagnostic_code_relation
 (ID1 char(10),
  ID2 char(10),
  _type varchar(255),
  primary key(ID1, ID2),
  foreign key(ID1) references diagnostic_code(ID),
  foreign key(ID2) references diagnostic_code(ID));

create table consultation_diagnostic
 (VAT_doctor char(10),
  date_timestamp char(20),
  ID char(10),
  primary key(VAT_doctor, date_timestamp, ID),
  foreign key(VAT_doctor, date_timestamp) references consultation(VAT_doctor, date_timestamp),
  foreign key(ID) references diagnostic_code(ID));

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
  dosage varchar(255),-- ex.:8h-8h
  _description varchar(255),
  primary key(_name, lab, VAT_doctor, date_timestamp, ID),
  foreign key(_name, lab) references medication(_name, lab),
  foreign key(VAT_doctor, date_timestamp, ID) references consultation_diagnostic(VAT_doctor, date_timestamp, ID));

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
  foreign key(_name) references _procedure(_name),
  foreign key(VAT_doctor, date_timestamp) references consultation(VAT_doctor, date_timestamp));

create table procedure_radiology
 (_name varchar(255),
  _file varchar(255),
  VAT_doctor char(10),
  date_timestamp char(20),
  primary key(_name, _file, VAT_doctor, date_timestamp),
  foreign key(_name, VAT_doctor, date_timestamp) references procedure_in_consultation(_name, VAT_doctor, date_timestamp));

create table teeth
 (quadrant integer, --  1-4
  _number integer,--  1-8
  _name varchar(255),
  primary key(quadrant, _number));

create table procedure_charting
 (_name varchar(255),
  VAT char(10),
  date_timestamp char(20),
  quadrant integer,
  _number integer,
  _desc varchar(255),
  measure numeric(3,1), -- 3 digiost no total, 1 depois da virgula
  primary key(_name, VAT, date_timestamp, quadrant, _number),
  foreign key(_name, VAT, date_timestamp) references procedure_in_consultation(_name, VAT_doctor, date_timestamp),
  foreign key(quadrant, _number) references teeth(quadrant, _number));


insert into employee values('25001', 'Jane Sweettooth', '1978-09-30', 'Castanheiras Street', 'Lisboa','1100-300', '1234', 1000);-- doutor
insert into employee values('15101', 'André Fernandes', '1978-06-07', 'Técnico Avenue', 'Lisboa', '1110-450', '5323', 2000);-- doutor
insert into employee values('10120', 'Jorge Goodenough', '1938-05-12', 'Cinzeiro Street', 'Lisboa','1100-320', '4321', 1000);-- doutor
insert into employee values('11982', 'Deolinda de Villa Mar', '1967-09-06', 'Grande Campo Street', 'Lisboa','1100-270', '6979', 1000);-- doutor
insert into employee values('12309', 'Ermelinda Boavida', '1945-12-17', 'Cinco Batalhas Street', 'Lisboa', '1110-150', '5901', 2000);-- enferm
insert into employee values('13490', 'Zacarias Fernandes', '1950-02-3', 'Janelas Street', 'Lisboa', '1110-260', '6501', 2000);-- enferm
insert into employee values('15574', 'Joaquim Ahmad', '1965-03-14', 'Linhas de ferro Street', 'Lisboa','1100-100', '0912', 1000);-- recep
insert into employee values('16347', 'Maria Peixeira', '1980-01-02', 'Rés-do-chão Street', 'Lisboa', '1200-230', '6832', 2000);-- recep

insert into phone_number_employee values('25001', 1000);
insert into phone_number_employee values('15101', 1001);
insert into phone_number_employee values('10120', 1002);
insert into phone_number_employee values('11982', 1003);
insert into phone_number_employee values('12309', 1004);
insert into phone_number_employee values('13490', 1005);
insert into phone_number_employee values('15574', 1006);
insert into phone_number_employee values('16347', 1007);

insert into receptionist values('15574');
insert into receptionist values('16347');

insert into doctor values('25001', 'Anesthesiology', 'this is Janes biography', 'janesweettoth@gmail.com');-- permanent
insert into doctor values('15101', 'Pediatric dentistry', 'this is Andres biography','andrefernandes@gmail.com');-- permanent
insert into doctor values('10120', 'Dental public health', 'this is Jorges biography','goodenough@gmail.com');-- trainee
insert into doctor values('11982', 'Implant dentistry','this is Deolindas biography', 'marvilla@gmail.com');-- trainee

insert into nurse values('12309');
insert into nurse values('13490');

insert into client values('14001', 'Rafael Silva', '1989-12-21', 'Seixal Street', 'Lisbon', '1305-400', 'M', 30);
insert into client values('14002', 'João Tavares', '1998-12-31', 'Buenos Aires Street', 'Lisbon', '1200-632', 'M', 20);
insert into client values('14003', 'Maria Barracosa', '1999-07-18', 'Poeta Bocage Street', 'Lisbon', '1100-020', 'F', 20);
insert into client values('14004', 'Benedita Alves', '2000-04-18', 'Liberty Avenue', 'Lisbon', '1400-270', 'F', 19);
insert into client values('14005', 'Rosa Mota', '1962-05-31', 'Mota Rosa Street', 'Setubal', '1800-032', 'F', 57);
insert into client values('14006', 'Eusébio Ferreira', '1952-06-07', 'Fernando Pessoa Street', 'Lisbon', '2725-300', 'M', 67);
insert into client values('14007', 'Maria Coluna', '1997-03-13', 'Miguel Torga Street', 'Lisbon', '2725-300', 'F', 22);
insert into client values('14008', 'Adalberto Correia', '1979-08-17', 'Lagos Street', 'Lisbon', '2725-300', 'M', 40);
insert into client values('14009', 'Pedro Martin', '1998-12-07', 'Lumiar Street', 'Lisbon', '1020-780', 'M', 20);
insert into client values('14010', 'Xavier Dias', '1998-02-24', 'Almada Negreiros Street', 'Sintra', '1300-590', 'M', 59);
insert into client values('14011', 'Maria José', '1960-05-14', 'Alves Redol Street', 'Lisbon', '2725-300', 'F', 59);
insert into client values('14012', 'José Maria Turras', '1998-10-04', 'Marinha Street', 'Lisbon', '1200-400', 'M', 21);
insert into client values('14013', 'Alexandrino Ramos', '1988-12-08', 'Dezembro Street', 'Lisbon', '1225-300', 'M', 31);

insert into phone_number_client values('14001', 2001);
insert into phone_number_client values('14002', 2002);
insert into phone_number_client values('14003', 2003);
insert into phone_number_client values('14004', 2004);
insert into phone_number_client values('14005', 2005);
insert into phone_number_client values('14006', 2006);
insert into phone_number_client values('14007', 2007);
insert into phone_number_client values('14008', 2008);
insert into phone_number_client values('14009', 2009);
insert into phone_number_client values('14010', 2010);
insert into phone_number_client values('14011', 2011);
insert into phone_number_client values('14012', 2012);
insert into phone_number_client values('14013', 2013);

insert into permanent_doctor values('25001');
insert into permanent_doctor values('15101');

insert into trainee_doctor values('11982', '15101');
insert into trainee_doctor values('10120', '25001');

insert into supervision_report values('11982', '2019-09-04 14:15:03', 'Very good!', 4);
insert into supervision_report values('10120', '2019-10-04 00:10:03', 'Something plus insufficient', 4);
insert into supervision_report values('11982', '2019-11-04 14:15:03', 'Very bad!', 1);
insert into supervision_report values('10120', '2019-12-04 00:10:03', 'Insufficient plus something', 2);

insert into appointment values('25001', '2019-11-04 16:00:00', 'There is nothing more practical than a good practical theory', '14010');
insert into appointment values('25001', '2019-11-04 17:00:00', 'Madness is like gravity, all it needs is a little push!', '14001');
insert into appointment values('15101', '2019-11-05 17:25:00', 'Madness is like ...', '14007');
insert into appointment values('11982', '2019-11-05 12:25:00', 'My madness....', '14003');-- não ocorre
insert into appointment values('25001', '2019-12-05 16:05:00', 'My madness....', '14009');
insert into appointment values('25001', '2019-12-14 13:05:00', 'My madness....', '14013');
insert into appointment values('25001', '2019-12-15 19:05:00', 'My madness....', '14005');-- não ocorre

insert into consultation values('25001', '2019-11-04 16:00:00', 'This is my s-soap', 'gingivitis', 'This is my a-soap', 'This is my p-soap');
insert into consultation values('25001', '2019-11-04 17:00:00', 'This is my s-soap', 'This is my o-soap', 'This is my a-soap', 'This is my p-soap');
insert into consultation values('15101', '2019-11-05 17:25:00', 'This is my s-soap', 'periodontitis', 'This is my a-soap', 'This is my p-soap');
insert into consultation values('25001', '2019-12-05 16:05:00', 'This is my s-soap', 'This is my o-soap', 'This is my a-soap', 'This is my p-soap');
insert into consultation values('25001', '2019-12-14 13:05:00', 'This is my s-soap', 'gingivitis and periodontitis', 'This is my a-soap', 'This is my p-soap');

insert into consultation_assistant values('25001', '2019-11-04 16:00:00', '12309');
insert into consultation_assistant values('25001', '2019-11-04 17:00:00', '13490');
insert into consultation_assistant values('15101', '2019-11-05 17:25:00', '12309');
insert into consultation_assistant values('25001', '2019-12-05 16:05:00', '12309');
insert into consultation_assistant values('25001', '2019-12-14 13:05:00', '13490');

insert into diagnostic_code values('301', 'You are going to die');
insert into diagnostic_code values('302', 'You only have 3 more... 2, 1, 0...');
insert into diagnostic_code values('321', 'arranjar uma descricao');
insert into diagnostic_code values('334', 'arranjar uma descricao');

insert into diagnostic_code_relation values('321', '334', 'Includes');
insert into diagnostic_code_relation values('301', '302', 'Includes');

insert into consultation_diagnostic values('25001', '2019-11-04 16:00:00', '301');
insert into consultation_diagnostic values('25001', '2019-11-04 17:00:00', '301');
insert into consultation_diagnostic values('15101', '2019-11-05 17:25:00', '302');
insert into consultation_diagnostic values('25001', '2019-12-05 16:05:00', '301');
insert into consultation_diagnostic values('25001', '2019-12-14 13:05:00', '302');

insert into medication values('Ben-u-ron', 'Júlio de Matos LAB');
insert into medication values('Brufen', 'Chemistry LAB');

insert into prescription values('Ben-u-ron', 'Júlio de Matos LAB', '25001', '2019-11-04 16:00:00', '301', '8h-8h', 'Be careful with overdoses...');
insert into prescription values('Brufen', 'Chemistry LAB', '15101', '2019-11-05 17:25:00', '302', '12h-12h', 'Be careful with overdoses...');

insert into _procedure values('Tooth extraction', 'Extraction');
insert into _procedure values('Maxillary molar periapical radiograph', 'Radiography exam');
insert into _procedure values('Root canal treatments', 'Cirurgy');
insert into _procedure values('Dental charting', 'Dental evaluation');

insert into procedure_in_consultation values('Maxillary molar periapical radiograph', '25001', '2019-11-04 16:00:00', 'Good maxillar!');
insert into procedure_in_consultation values('Maxillary molar periapical radiograph', '25001', '2019-11-04 17:00:00', 'Good maxillar!');
insert into procedure_in_consultation values('Root canal treatments', '15101', '2019-11-05 17:25:00', 'What a root!');
insert into procedure_in_consultation values('Tooth extraction', '25001', '2019-12-05 16:05:00', 'Not so great teeth!');
insert into procedure_in_consultation values('Dental charting', '25001', '2019-12-14 13:05:00', 'Great teeth!');

insert into procedure_radiology values('Maxillary molar periapical radiograph', 'thisfile1', '25001', '2019-11-04 16:00:00');
insert into procedure_radiology values('Maxillary molar periapical radiograph', 'thisfile2', '25001', '2019-11-04 17:00:00');

insert into teeth values(1, 1, 'Central incisor');
insert into teeth values(1, 2, 'Lateral incisor');
insert into teeth values(1, 3, 'Canine');
insert into teeth values(1, 4, 'First premolar');
insert into teeth values(1, 5, 'Second premolar');
insert into teeth values(1, 6, 'First molar');
insert into teeth values(1, 7, 'Second molar');
insert into teeth values(1, 8, 'Third molar');
insert into teeth values(2, 1, 'Central incisor');
insert into teeth values(2, 2, 'Lateral incisor');
insert into teeth values(2, 3, 'Canine');
insert into teeth values(2, 4, 'First premolar');
insert into teeth values(2, 5, 'Second premolar');
insert into teeth values(2, 6, 'First molar');
insert into teeth values(2, 7, 'Second molar');
insert into teeth values(2, 8, 'Third molar');
insert into teeth values(3, 1, 'Central incisor');
insert into teeth values(3, 2, 'Lateral incisor');
insert into teeth values(3, 3, 'Canine');
insert into teeth values(3, 4, 'First premolar');
insert into teeth values(3, 5, 'Second premolar');
insert into teeth values(3, 6, 'First molar');
insert into teeth values(3, 7, 'Second molar');
insert into teeth values(3, 8, 'Third molar');
insert into teeth values(4, 1, 'Central incisor');
insert into teeth values(4, 2, 'Lateral incisor');
insert into teeth values(4, 3, 'Canine');
insert into teeth values(4, 4, 'First premolar');
insert into teeth values(4, 5, 'Second premolar');
insert into teeth values(4, 6, 'First molar');
insert into teeth values(4, 7, 'Second molar');
insert into teeth values(4, 8, 'Third molar');

insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 1,'Damn good teeth you´ve got there sir!', 3.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 2,'Damn good teeth you´ve got there sir!', 2.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 3,'Damn good teeth you´ve got there sir!', 1.3);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 4,'Damn good teeth you´ve got there sir!', 0.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 5,'Damn good teeth you´ve got there sir!', 1.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 6,'Damn good teeth you´ve got there sir!', 2.0);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 7,'Damn good teeth you´ve got there sir!', 3.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 1, 8,'Damn good teeth you´ve got there sir!', 2.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 1,'Damn good teeth you´ve got there sir!', 1.3);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 2,'Damn good teeth you´ve got there sir!', 0.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 3,'Damn good teeth you´ve got there sir!', 1.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 4,'Damn good teeth you´ve got there sir!', 2.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 5,'Damn good teeth you´ve got there sir!', 3.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 6,'Damn good teeth you´ve got there sir!', 2.3);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 7,'Damn good teeth you´ve got there sir!', 1.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 2, 8,'Damn good teeth you´ve got there sir!', 0.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 1,'Damn good teeth you´ve got there sir!', 1.0);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 2,'Damn good teeth you´ve got there sir!', 2.0);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 3,'Damn good teeth you´ve got there sir!', 3.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 4,'Damn good teeth you´ve got there sir!', 2.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 5,'Damn good teeth you´ve got there sir!', 1.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 6,'Damn good teeth you´ve got there sir!', 0.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 7,'Damn good teeth you´ve got there sir!', 1.3);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 3, 8,'Damn good teeth you´ve got there sir!', 2.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 1,'Damn good teeth you´ve got there sir!', 3.0);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 2,'Damn good teeth you´ve got there sir!', 2.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 3,'Damn good teeth you´ve got there sir!', 1.3);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 4,'Damn good teeth you´ve got there sir!', 0.2);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 5,'Damn good teeth you´ve got there sir!', 1.1);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 6,'Damn good teeth you´ve got there sir!', 2.0);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 7,'Damn good teeth you´ve got there sir!', 3.3);
insert into procedure_charting values('Maxillary molar periapical radiograph', '25001', '2019-12-14 13:05:00', 4, 8,'Damn good teeth you´ve got there sir!', 2.2);
