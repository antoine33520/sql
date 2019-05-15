CONNECT / AS SYSDBA;

DROP USER olvoyage CASCADE;

CREATE USER olvoyage IDENTIFIED BY oracle;

ALTER USER olvoyage DEFAULT TABLESPACE users
	QUOTA UNLIMITED ON users;

ALTER USER olvoyage TEMPORARY TABLESPACE temp;

GRANT create session,
	create table,
	create procedure,
	create sequence,
	create trigger,
	create view,
	create synonym,
	alter session
TO olvoyage;

GRANT execute ON sys.dbms_stats TO olvoyage;

CONNECT olvoyage/oracle

-- create table,
-- primary key, foreign key,
-- sequence
-- and checking constraint

CREATE TABLE T_PASS (
	pass_id NUMBER(6) NOT NULL,
	pass_name VARCHAR2(30) NOT NULL,
	discount_pct NUMBER(2) NOT NULL,
	discount_we_pct NUMBER(2) NOT NULL,
	price NUMBER(8,2) NOT NULL,
	CONSTRAINT PK_PASS PRIMARY KEY (pass_id)
);

CREATE TABLE T_TICKET (
	ticket_id NUMBER(6) NOT NULL,
	seat NUMBER(3) NOT NULL,
	customer_id NUMBER(6) NOT NULL,
	wag_tr_id NUMBER(6) NOT NULL,
	reservation_id NUMBER(6) NOT NULL,
	direction VARCHAR2(10)
	CONSTRAINT C_C_TICKET CHECK(direction IN('Go','Return')) NOT NULL,
	CONSTRAINT PK_TICKET PRIMARY KEY (ticket_id)
);

CREATE TABLE T_CUSTOMER (
	customer_id NUMBER(6) NOT NULL,
	last_name VARCHAR2(25) NOT NULL,
	first_name VARCHAR2(25) NOT NULL,
	address VARCHAR2(100) NULL,
	phone VARCHAR2(20) NULL,
	gender CHAR(1) NULL,
	birth_date DATE NOT NULL,
	pass_id NUMBER(6) NULL,
	pass_date DATE NULL,
	CONSTRAINT PK_CUSTOMER PRIMARY KEY (customer_id)
);

CREATE TABLE T_EMPLOYEE (
	employee_id NUMBER(6) NOT NULL,
	last_name VARCHAR2(25) NOT NULL,
	first_name VARCHAR2(25) NOT NULL,
	salary NUMBER(8,2) NOT NULL,
	comm_pct NUMBER(2,2) NULL,
	manager_id NUMBER(6) NULL,
	login VARCHAR2(8) NOT NULL,
	pass VARCHAR2(25) NOT NULL,
	CONSTRAINT PK_EMPLOYEE PRIMARY KEY (employee_id)
);

CREATE TABLE T_STATION (
	station_id NUMBER(6) NOT NULL,
	city VARCHAR2(25) NOT NULL,
	open_time DATE NOT NULL,
	close_time DATE NOT NULL,
	CONSTRAINT PK_STATION PRIMARY KEY (station_id)
);

-- Création d'une vue supplémentaire de la table T_STATION
CREATE VIEW VU_STATION AS
	SELECT station_id, city
	FROM T_STATION;

CREATE TABLE T_RESERVATION (
	reservation_id NUMBER(6) NOT NULL,
	employee_id NUMBER(6) NOT NULL,
	creation_date DATE NOT NULL,
	buy_method VARCHAR2(30)
	CONSTRAINT C_C_RESERVATION CHECK(buy_method IN('Credit Card','Cheque','Cash')),
	price NUMBER(8,2) NULL,
	buyer_id NUMBER(6) NOT NULL,
	CONSTRAINT PK_RESERVATION
	PRIMARY KEY (reservation_id)
);

CREATE TABLE T_TRAIN (
	train_id NUMBER(6) NOT NULL,
	departure_station_id NUMBER(6) NOT NULL,
	arrival_station_id NUMBER(6) NOT NULL,
	departure_time DATE NOT NULL,
	arrival_time DATE NOT NULL,
	distance NUMBER(6),
	price NUMBER(8,2) NOT NULL,
	CONSTRAINT PK_TRAIN PRIMARY KEY (train_id)
);

CREATE TABLE T_WAGON (
	wagon_id NUMBER(6) NOT NULL,
	class_pct NUMBER(2) NULL,
	class_type NUMBER(1)
	CONSTRAINT C_C_WAGON CHECK(class_type IN(1,2)) NOT NULL,
	nb_seat NUMBER(3) NOT NULL,
	CONSTRAINT PK_WAGON PRIMARY KEY (wagon_id)
);

CREATE TABLE T_WAGON_TRAIN (
	wag_tr_id NUMBER(6) NOT NULL,
	wagon_id NUMBER(6) NOT NULL,
	train_id NUMBER(6) NOT NULL,
	CONSTRAINT PK_WAGON_TRAIN
	PRIMARY KEY (wag_tr_id)
);


-- Création des clés étrangères
ALTER TABLE T_CUSTOMER
	ADD CONSTRAINT FK_PASS_CUSTOMER
	FOREIGN KEY (pass_id) REFERENCES T_PASS(pass_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_RESERVATION
	ADD CONSTRAINT FK_CUSTOMER_RESERVATION
	FOREIGN KEY (buyer_id) REFERENCES T_CUSTOMER(customer_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_RESERVATION
	ADD CONSTRAINT FK_EMPLOYEE_RESERVATION
	FOREIGN KEY (employee_id) REFERENCES T_EMPLOYEE(employee_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_EMPLOYEE
	ADD CONSTRAINT FK_EMPLOYEE_EMPLOYEE
	FOREIGN KEY (manager_id) REFERENCES T_EMPLOYEE(employee_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_TICKET
	ADD CONSTRAINT FK_CUSTOMER_TICKET
	FOREIGN KEY (customer_id) REFERENCES T_CUSTOMER(customer_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_TICKET
	ADD CONSTRAINT FK_RESERVATION_TICKET
	FOREIGN KEY (reservation_id) REFERENCES T_RESERVATION(reservation_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_TICKET
	ADD CONSTRAINT FK_WAGON_TRAIN_TICKET
	FOREIGN KEY (wag_tr_id) REFERENCES T_WAGON_TRAIN(wag_tr_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_WAGON_TRAIN
	ADD CONSTRAINT FK_WAGON_WAGON_TRAIN
	FOREIGN KEY (wagon_id) REFERENCES T_WAGON(wagon_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_WAGON_TRAIN
	ADD CONSTRAINT FK_TRAIN_WAGON_TRAIN
	FOREIGN KEY (train_id) REFERENCES T_TRAIN(train_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_TRAIN
	ADD CONSTRAINT FK_STATION_TRAIN_DEPARTURE
	FOREIGN KEY (departure_station_id) REFERENCES T_STATION(station_id) ON DELETE CASCADE
	DISABLE;

ALTER TABLE T_TRAIN
	ADD CONSTRAINT FK_STATION_TRAIN_ARRIVAL
	FOREIGN KEY (arrival_station_id) REFERENCES T_STATION(station_id) ON DELETE CASCADE
	DISABLE;

-- Création des séquences
CREATE SEQUENCE SEQ_T_PASS;
CREATE SEQUENCE SEQ_T_CUSTOMER;
CREATE SEQUENCE SEQ_T_RESERVATION;
CREATE SEQUENCE SEQ_T_EMPLOYEE;
CREATE SEQUENCE SEQ_T_TICKET;
CREATE SEQUENCE SEQ_T_WAGON;
CREATE SEQUENCE SEQ_T_WAGON_TRAIN;
CREATE SEQUENCE SEQ_T_TRAIN;
CREATE SEQUENCE SEQ_T_STATION;

--Insertion des données

INSERT INTO t_pass VALUES(seq_t_pass.nextval,'15-25',50,25,10);
INSERT INTO t_pass VALUES(seq_t_pass.nextval,'Senior',40,20,20);
INSERT INTO t_pass VALUES(seq_t_pass.nextval,'Pro',30,15,30);
COMMIT;

INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,1,1,1,1,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,2,1,4,1,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,4,6,20,2,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,1,25,20,3,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,25,21,3,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,7,23,55,3,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,8,57,55,4,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,6,72,90,5,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,20,72,92,5,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,11,65,101,6,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,12,68,134,7,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,17,60,9,8,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,19,60,15,8,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,16,77,9,8,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,14,67,9,8,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,13,74,9,8,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,9,61,9,8,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,1,80,25,9,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,2,67,35,10,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,5,73,36,11,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,5,73,41,11,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,62,52,12,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,15,46,68,13,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,18,63,109,14,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,19,63,113,14,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,3,43,118,15,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,43,122,15,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,16,47,118,15,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,17,47,122,15,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,18,24,16,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,3,33,84,17,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,33,88,17,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,8,43,115,18,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,13,43,116,18,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,14,53,114,18,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,6,53,116,18,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,14,66,133,19,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,16,59,2,20,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,4,30,22,21,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,6,39,44,22,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,9,46,62,23,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,46,63,23,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,17,75,78,23,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,15,53,97,24,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,2,33,98,25,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,3,45,105,26,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,14,52,126,27,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,7,52,127,27,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,13,59,1,28,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,14,59,5,28,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,7,37,94,29,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,7,41,3,30,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,18,41,7,30,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,3,41,53,30,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,10,41,55,30,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,16,50,1,31,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,8,50,8,31,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,8,72,13,31,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,17,72,17,31,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,17,34,37,32,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,14,39,134,33,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,18,69,10,34,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,16,69,16,34,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,16,15,33,35,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,13,27,59,36,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,15,54,8,37,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,19,77,8,38,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,17,49,12,39,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,15,49,17,39,'Return');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,12,68,127,40,'Go');
INSERT INTO t_ticket VALUES(seq_t_ticket.nextval,6,66,130,41,'Go');
COMMIT;

INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Fleming','Steve','59 Faubourg Saint Honoré - F-75016 Paris','01.94.59.91.81','H',TO_DATE('07/07/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Wayne','Williams','28 rue La Boétie - F-75016 Paris','01.24.72.19.75','H',TO_DATE('07/01/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Richardson','Lauren','94 rue Nationale - F-75004 Paris','01.96.88.39.63','F',TO_DATE('21/02/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Clark','Paul','95 Place de la Madeleine - F-75009 Paris','01.51.53.70.45','H',TO_DATE('20/06/1992', 'dd/mm/yyyy'),1,TO_DATE('09/01/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Reynolds','Philip','05 Faubourg Saint Honoré - F-75016 Paris','01.05.05.05.05','H',TO_DATE('12/03/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Healy','Stacy','06 Faubourg Saint Honoré - F-75016 Paris','01.06.06.06.06','F',TO_DATE('16/10/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Novak','Craig','07 Faubourg Saint Honoré - F-75016 Paris','01.07.07.07.07','H',TO_DATE('18/02/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Barnes','Ted','08 Faubourg Saint Honoré - F-75016 Paris','01.08.08.08.08','H',TO_DATE('05/03/1993', 'dd/mm/yyyy'),2,TO_DATE('25/02/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Oswald','Georges','09 Faubourg Saint Honoré - F-75016 Paris','01.09.09.09.09','H',TO_DATE('15/10/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Collins','Ben','10 Faubourg Saint Honoré - F-75016 Paris','01.10.10.10.10','H',TO_DATE('27/03/1992', 'dd/mm/yyyy'),3,TO_DATE('17/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Hamilton','Melvin','11 Faubourg Saint Honoré - F-75016 Paris','01.11.11.11.11','H',TO_DATE('18/03/1994', 'dd/mm/yyyy'),3,TO_DATE('12/04/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Hancock','Marcia','12 Faubourg Saint Honoré - F-75016 Paris','01.12.12.12.12','F',TO_DATE('15/07/1992', 'dd/mm/yyyy'),2,TO_DATE('23/05/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Dawn','Lane','13 Faubourg Saint Honoré - F-75016 Paris','01.13.13.13.13','F',TO_DATE('05/08/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Wayne','Leonard','14 Faubourg Saint Honoré - F-75016 Paris','01.14.14.14.14','H',TO_DATE('09/03/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Nielsen','Raph','15 Faubourg Saint Honoré - F-75016 Paris','01.15.15.15.15','H',TO_DATE('08/10/1995', 'dd/mm/yyyy'),1,TO_DATE('23/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Alen','Doug','16 Faubourg Saint Honoré - F-75016 Paris','01.16.16.16.16','H',TO_DATE('02/06/1992', 'dd/mm/yyyy'),2,TO_DATE('25/06/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Patterson','Philip','17 Faubourg Saint Honoré - F-75016 Paris','01.17.17.17.17','H',TO_DATE('16/11/1989', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Rice','Joe','18 Faubourg Saint Honoré - F-75016 Paris','01.18.18.18.18','H',TO_DATE('05/07/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Lang','Wayne','19 Faubourg Saint Honoré - F-75016 Paris','01.19.19.19.19','H',TO_DATE('21/02/1991', 'dd/mm/yyyy'),2,TO_DATE('02/07/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Larson','Arthur','20 Faubourg Saint Honoré - F-75016 Paris','01.20.20.20.20','H',TO_DATE('11/03/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Nielsen','Melvin','21 Faubourg Saint Honoré - F-75016 Paris','01.21.21.21.21','H',TO_DATE('26/09/1994', 'dd/mm/yyyy'),2,TO_DATE('18/08/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Miler','Victor','22 Faubourg Saint Honoré - F-75016 Paris','01.22.22.22.22','H',TO_DATE('10/07/1989', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Herman','Smith','23 Faubourg Saint Honoré - F-75016 Paris','01.23.23.23.23','H',TO_DATE('26/10/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Steinbach','Barbra','24 Faubourg Saint Honoré - F-75016 Paris','01.24.24.24.24','F',TO_DATE('03/01/1993', 'dd/mm/yyyy'),3,TO_DATE('21/09/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Gordon','Rosemary','25 Faubourg Saint Honoré - F-75016 Paris','01.25.25.25.25','F',TO_DATE('03/06/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Erickson','Lou','26 Faubourg Saint Honoré - F-75016 Paris','01.26.26.26.26','H',TO_DATE('23/08/1991', 'dd/mm/yyyy'),3,TO_DATE('02/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Dalton','Vance','27 Faubourg Saint Honoré - F-75016 Paris','01.27.27.27.27','H',TO_DATE('21/03/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Cooper','Clarck','28 Faubourg Saint Honoré - F-75016 Paris','01.28.28.28.28','H',TO_DATE('17/06/1994', 'dd/mm/yyyy'),2,TO_DATE('04/11/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Bauer','John','29 Faubourg Saint Honoré - F-75016 Paris','01.29.29.29.29','H',TO_DATE('26/05/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Harris','Brandy','30 Faubourg Saint Honoré - F-75016 Paris','01.30.30.30.30','F',TO_DATE('14/08/1989', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Ferguson','Angie','31 Faubourg Saint Honoré - F-75016 Paris','01.31.31.31.31','F',TO_DATE('12/05/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Cunningham','Dennis','32 Faubourg Saint Honoré - F-75016 Paris','01.32.32.32.32','H',TO_DATE('01/08/1992', 'dd/mm/yyyy'),2,TO_DATE('10/07/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Cunningham','Charles','33 Faubourg Saint Honoré - F-75016 Paris','01.33.33.33.33','H',TO_DATE('08/02/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Fraser','Thomas','34 Faubourg Saint Honoré - F-75016 Paris','01.34.34.34.34','H',TO_DATE('03/08/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Graham','Linda','35 Faubourg Saint Honoré - F-75016 Paris','01.35.35.35.35','F',TO_DATE('12/02/1991', 'dd/mm/yyyy'),1,TO_DATE('23/01/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Barnes','Katherine','36 Faubourg Saint Honoré - F-75016 Paris','01.36.36.36.36','F',TO_DATE('02/08/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Michaels','Timothy','37 Faubourg Saint Honoré - F-75016 Paris','01.37.37.37.37','H',TO_DATE('20/10/1992', 'dd/mm/yyyy'),3,TO_DATE('14/02/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Sattler','Jack','38 Faubourg Saint Honoré - F-75016 Paris','01.38.38.38.38','H',TO_DATE('15/08/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Warren','Paul','39 Faubourg Saint Honoré - F-75016 Paris','01.39.39.39.39','H',TO_DATE('08/04/1992', 'dd/mm/yyyy'),2,TO_DATE('11/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Richards','Paul','40 Faubourg Saint Honoré - F-75016 Paris','01.40.40.40.40','H',TO_DATE('07/06/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Landers','Robert','41 Faubourg Saint Honoré - F-75016 Paris','01.41.41.41.41','H',TO_DATE('17/11/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Powel','Tom','42 Faubourg Saint Honoré - F-75016 Paris','01.42.42.42.42','H',TO_DATE('24/06/1992', 'dd/mm/yyyy'),3,TO_DATE('07/04/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Holmes','Martin','43 Faubourg Saint Honoré - F-75016 Paris','01.43.43.43.43','H',TO_DATE('10/08/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Williams','Megan','44 Faubourg Saint Honoré - F-75016 Paris','01.44.44.44.44','F',TO_DATE('22/10/1989', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Tucker','Gerard','45 Faubourg Saint Honoré - F-75016 Paris','01.45.45.45.45','H',TO_DATE('14/06/1994', 'dd/mm/yyyy'),1,TO_DATE('02/05/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Reynolds','Samantha','46 Faubourg Saint Honoré - F-75016 Paris','01.46.46.46.46','F',TO_DATE('27/05/1995', 'dd/mm/yyyy'),3,TO_DATE('14/06/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Petersen','Melody','47 Faubourg Saint Honoré - F-75016 Paris','01.47.47.47.47','F',TO_DATE('23/05/1993', 'dd/mm/yyyy'),2,TO_DATE('08/07/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Fraser','Faun','48 Faubourg Saint Honoré - F-75016 Paris','01.48.48.48.48','F',TO_DATE('23/11/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Jacobs','Tarryn','49 Faubourg Saint Honoré - F-75016 Paris','01.49.49.49.49','F',TO_DATE('13/06/1992', 'dd/mm/yyyy'),2,TO_DATE('15/08/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Parker','Steve','50 Faubourg Saint Honoré - F-75016 Paris','01.50.50.50.50','H',TO_DATE('01/08/1992', 'dd/mm/yyyy'),2,TO_DATE('13/09/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'White','Elliott','51 Faubourg Saint Honoré - F-75016 Paris','01.51.51.51.51','H',TO_DATE('23/11/1991', 'dd/mm/yyyy'),3,TO_DATE('12/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Miller','Alex','52 Faubourg Saint Honoré - F-75016 Paris','01.52.52.52.52','H',TO_DATE('06/02/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Ross','Lou','53 Faubourg Saint Honoré - F-75016 Paris','01.53.53.53.53','H',TO_DATE('13/07/1991', 'dd/mm/yyyy'),1,TO_DATE('04/11/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Lyons','Gordons','54 Faubourg Saint Honoré - F-75016 Paris','01.54.54.54.54','H',TO_DATE('03/10/1992', 'dd/mm/yyyy'),3,TO_DATE('01/01/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Hamilton','Dory','55 Faubourg Saint Honoré - F-75016 Paris','01.55.55.55.55','F',TO_DATE('13/10/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Sanders','Laurie','56 Faubourg Saint Honoré - F-75016 Paris','01.56.56.56.56','F',TO_DATE('05/02/1992', 'dd/mm/yyyy'),1,TO_DATE('15/02/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Maugard','Gregory','57 Faubourg Saint Honoré - F-75016 Paris','01.57.57.57.57','H',TO_DATE('02/02/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Smith','Kevin','58 Faubourg Saint Honoré - F-75016 Paris','01.58.58.58.58','H',TO_DATE('07/05/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Barnes','Bill','59 Faubourg Saint Honoré - F-75016 Paris','01.59.59.59.59','H',TO_DATE('13/05/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Novak','Jessie','60 Faubourg Saint Honoré - F-75016 Paris','01.60.60.60.60','F',TO_DATE('03/01/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Philips','Rich','61 Faubourg Saint Honoré - F-75016 Paris','01.61.61.61.61','H',TO_DATE('14/02/1991', 'dd/mm/yyyy'),2,TO_DATE('15/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'McDaniels','Wayne','62 Faubourg Saint Honoré - F-75016 Paris','01.62.62.62.62','H',TO_DATE('27/10/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Morris','Tim','63 Faubourg Saint Honoré - F-75016 Paris','01.63.63.63.63','H',TO_DATE('25/01/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Albert','Thomas','64 Faubourg Saint Honoré - F-75016 Paris','01.64.64.64.64','H',TO_DATE('04/01/1992', 'dd/mm/yyyy'),2,TO_DATE('09/04/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Burton','Albert','65 Faubourg Saint Honoré - F-75016 Paris','01.65.65.65.65','H',TO_DATE('10/09/1990', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Quinn','Rosemary','66 Faubourg Saint Honoré - F-75016 Paris','01.66.66.66.66','F',TO_DATE('21/08/1992', 'dd/mm/yyyy'),2,TO_DATE('21/05/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Hess','Katherine','67 Faubourg Saint Honoré - F-75016 Paris','01.67.67.67.67','F',TO_DATE('02/05/1989', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Landers','Philip','68 Faubourg Saint Honoré - F-75016 Paris','01.68.68.68.68','H',TO_DATE('27/11/1993', 'dd/mm/yyyy'),1,TO_DATE('03/06/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Harris','Joe','69 Faubourg Saint Honoré - F-75016 Paris','01.69.69.69.69','H',TO_DATE('16/09/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Hendrix','Charles','70 Faubourg Saint Honoré - F-75016 Paris','01.70.70.70.70','H',TO_DATE('11/06/1991', 'dd/mm/yyyy'),3,TO_DATE('11/07/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'McDaniels','Stacy','71 Faubourg Saint Honoré - F-75016 Paris','01.71.71.71.71','F',TO_DATE('03/06/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Petersen','David','72 Faubourg Saint Honoré - F-75016 Paris','01.72.72.72.72','H',TO_DATE('19/09/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Erickson','Harvey','73 Faubourg Saint Honoré - F-75016 Paris','01.73.73.73.73','H',TO_DATE('05/04/1992', 'dd/mm/yyyy'),2,TO_DATE('02/08/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Erickson','Leonard','74 Faubourg Saint Honoré - F-75016 Paris','01.74.74.74.74','H',TO_DATE('09/08/1991', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Fields','Romain','75 Faubourg Saint Honoré - F-75016 Paris','01.75.75.75.75','H',TO_DATE('07/10/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Barnes','Luann','76 Faubourg Saint Honoré - F-75016 Paris','01.76.76.76.76','H',TO_DATE('04/10/1995', 'dd/mm/yyyy'),1,TO_DATE('24/09/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Burton','Whitney','77 Faubourg Saint Honoré - F-75016 Paris','01.77.77.77.77','F',TO_DATE('03/04/1991', 'dd/mm/yyyy'),3,TO_DATE('16/03/2019','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Oswald','Ty','78 Faubourg Saint Honoré - F-75016 Paris','01.78.78.78.78','H',TO_DATE('24/10/1992', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Gordon','Roy','79 Faubourg Saint Honoré - F-75016 Paris','01.79.79.79.79','H',TO_DATE('06/01/1988', 'dd/mm/yyyy'),NULL,NULL);
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Brooke','Morgan','80 Faubourg Saint Honoré - F-75016 Paris','01.80.80.80.80','F',TO_DATE('21/10/1993', 'dd/mm/yyyy'),1,TO_DATE('04/11/2018','dd/mm/yyyy'));
INSERT INTO t_customer VALUES(seq_t_customer.nextval,'Herman','Tom','81 Faubourg Saint Honoré - F-75016 Paris','01.81.81.81.81','H',TO_DATE('11/06/1992', 'dd/mm/yyyy'),NULL,NULL);
COMMIT;

INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Gladu','Erwan',20000,NULL,NULL,'gladu_e','aduwan');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Desnoyer','Jerome',15000,NULL,1,'desnoy_j','yerome');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Coudert','Reda',9500,.35,4,'couder_r','erteda');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Roy','Thibault',15150,NULL,1,'roy_t','royult');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Langlois','Arnaud',10100,.2,7,'langlo_a','oisaud');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Gousse','Kevin',8000,NULL,10,'gousse_k','ssevin');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Ayot','Davina',15200,NULL,1,'ayot_d','yotina');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Mothe','Francois',7550,.3,4,'mothe_f','theier');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Poissonnier','Maxime',12500,.25,7,'poisso_m','ierime');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Saurel','André',14850,NULL,1,'saurel_a','relrei');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Patenaude','Etienne',9550,.2,10,'patena_e','udenne');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Faubert','Mathieu',7550,NULL,10,'fauber_m','ertieu');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Monrency','Yoan',8500,.1,4,'monren_y','ncyoan');
INSERT INTO t_employee VALUES(seq_t_employee.nextval,'Chalut','Pierre',7000,NULL,7,'chalut_p','lutnry');
COMMIT;

INSERT INTO t_station VALUES(seq_t_station.nextval,'Bordeaux',TO_DATE('06:30','hh24:mi'),TO_DATE('22:00','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Brest',TO_DATE('06:45','hh24:mi'),TO_DATE('21:45','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Calais',TO_DATE('06:15','hh24:mi'),TO_DATE('23:40','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Clermont-Ferrand',TO_DATE('08:00','hh24:mi'),TO_DATE('20:30','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Dijon',TO_DATE('08:15','hh24:mi'),TO_DATE('23:15','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Grenoble',TO_DATE('08:30','hh24:mi'),TO_DATE('20:00','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Le Havre',TO_DATE('07:45','hh24:mi'),TO_DATE('22:15','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Lyon',TO_DATE('06:45','hh24:mi'),TO_DATE('19:45','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Macon',TO_DATE('06:15','hh24:mi'),TO_DATE('23:15','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Marseille',TO_DATE('07:00','hh24:mi'),TO_DATE('22:45','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Montpellier',TO_DATE('06:30','hh24:mi'),TO_DATE('23:00','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Mulhouse',TO_DATE('07:00','hh24:mi'),TO_DATE('22:00','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Nantes',TO_DATE('06:30','hh24:mi'),TO_DATE('23:00','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Nice',TO_DATE('07:15','hh24:mi'),TO_DATE('22:30','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Nimes',TO_DATE('08:00','hh24:mi'),TO_DATE('21:30','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Paris',TO_DATE('06:15','hh24:mi'),TO_DATE('23:45','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Saint-Malo',TO_DATE('09:00','hh24:mi'),TO_DATE('22:45','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Strasbourg',TO_DATE('06:15','hh24:mi'),TO_DATE('21:00','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Toulouse',TO_DATE('07:45','hh24:mi'),TO_DATE('22:30','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Troyes',TO_DATE('06:30','hh24:mi'),TO_DATE('23:30','hh24:mi'));
INSERT INTO t_station VALUES(seq_t_station.nextval,'Valenciennes',TO_DATE('07:00','hh24:mi'),TO_DATE('22:00','hh24:mi'));
COMMIT;

INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,3,TO_DATE('05/11/2018','dd/mm/yyyy'),'Credit Card',289.2,1);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,7,TO_DATE('03/11/2018','dd/mm/yyyy'),'Cheque',165.5,6);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,4,TO_DATE('29/03/2019','dd/mm/yyyy'),'Credit Card',588.4,23);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,7,TO_DATE('25/03/2019','dd/mm/yyyy'),'Cash',257.4,57);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,7,TO_DATE('02/11/2018','dd/mm/yyyy'),'Credit Card',175,72);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,7,TO_DATE('23/03/2019','dd/mm/yyyy'),'Cheque',225,65);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,7,TO_DATE('15/03/2019','dd/mm/yyyy'),'Cheque',37.12,68);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,3,TO_DATE('05/11/2018','dd/mm/yyyy'),'Credit Card',948.64,60);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,3,TO_DATE('05/11/2018','dd/mm/yyyy'),'Cheque',57,80);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,11,TO_DATE('05/11/2018','dd/mm/yyyy'),'Cheque',202.5,67);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,11,TO_DATE('05/11/2018','dd/mm/yyyy'),'Credit Card',202.5,73);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,12,TO_DATE('05/11/2018','dd/mm/yyyy'),'Credit Card',214.5,62);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,13,TO_DATE('08/11/2018','dd/mm/yyyy'),'',NULL,46);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,13,TO_DATE('08/11/2018','dd/mm/yyyy'),'Credit Card',291.6,63);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,13,TO_DATE('01/11/2018','dd/mm/yyyy'),'Cheque',376.8,43);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,2,TO_DATE('15/03/2019','dd/mm/yyyy'),'Credit Card',114,18);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,2,TO_DATE('12/03/2019','dd/mm/yyyy'),'Credit Card',400,33);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,2,TO_DATE('13/03/2019','dd/mm/yyyy'),'',NULL,43);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,9,TO_DATE('10/03/2019','dd/mm/yyyy'),'Credit Card',33,66);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,9,TO_DATE('07/03/2019','dd/mm/yyyy'),'Cheque',120.5,81);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,9,TO_DATE('07/01/2019','dd/mm/yyyy'),'Cheque',165.5,30);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,9,TO_DATE('10/01/2019','dd/mm/yyyy'),'Credit Card',121.5,39);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,9,TO_DATE('11/11/2018','dd/mm/yyyy'),'',NULL,46);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,4,TO_DATE('07/11/2018','dd/mm/yyyy'),'Credit Card',35.62,53);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,4,TO_DATE('08/11/2018','dd/mm/yyyy'),'Cheque',71.25,33);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,10,TO_DATE('08/11/2018','dd/mm/yyyy'),'Credit Card',39.5,45);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,10,TO_DATE('03/12/2018','dd/mm/yyyy'),'Credit Card',66,52);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,10,TO_DATE('10/12/2018','dd/mm/yyyy'),'Credit Card',289.2,77);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,10,TO_DATE('12/11/2018','dd/mm/yyyy'),'Credit Card',61.25,37);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,10,TO_DATE('12/11/2018','dd/mm/yyyy'),'Cheque',712.9,41);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,5,TO_DATE('01/11/2018','dd/mm/yyyy'),'',NULL,19);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,5,TO_DATE('27/03/2019','dd/mm/yyyy'),'Cheque',168.75,34);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,5,TO_DATE('26/03/2019','dd/mm/yyyy'),'Cash',39.6,39);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,6,TO_DATE('05/11/2018','dd/mm/yyyy'),'Cheque',308,69);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,2,TO_DATE('15/11/2018','dd/mm/yyyy'),'Credit Card',31.5,15);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,2,TO_DATE('15/11/2018','dd/mm/yyyy'),'Credit Card',214.5,27);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,2,TO_DATE('16/11/2018','dd/mm/yyyy'),'Cash',84.35,54);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,12,TO_DATE('03/11/2018','dd/mm/yyyy'),'Credit Card',84.35,77);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,12,TO_DATE('20/03/2019','dd/mm/yyyy'),'Cheque',184.8,49);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,12,TO_DATE('28/03/2019','dd/mm/yyyy'),'Credit Card',15,68);
INSERT INTO t_reservation VALUES(seq_t_reservation.nextval,14,TO_DATE('26/03/2019','dd/mm/yyyy'),'Credit Card',24.75,66);
COMMIT;

INSERT INTO t_train VALUES(seq_t_train.nextval,16,1,TO_DATE('21/01/2019 09:00','dd/mm/yyyy hh24:mi'),TO_DATE('21/01/2019 12:00','dd/mm/yyyy hh24:mi'),482,120.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,1,16,TO_DATE('21/01/2019 14:30','dd/mm/yyyy hh24:mi'),TO_DATE('21/01/2019 17:30','dd/mm/yyyy hh24:mi'),482,120.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,16,10,TO_DATE('22/01/2019 12:00','dd/mm/yyyy hh24:mi'),TO_DATE('22/01/2019 15:15','dd/mm/yyyy hh24:mi'),616,154);
INSERT INTO t_train VALUES(seq_t_train.nextval,10,16,TO_DATE('22/01/2019 18:00','dd/mm/yyyy hh24:mi'),TO_DATE('22/01/2019 21:15','dd/mm/yyyy hh24:mi'),616,154);
INSERT INTO t_train VALUES(seq_t_train.nextval,10,13,TO_DATE('21/01/2019 07:15','dd/mm/yyyy hh24:mi'),TO_DATE('21/01/2019 11:00','dd/mm/yyyy hh24:mi'),662,165.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,13,10,TO_DATE('21/01/2019 18:15','dd/mm/yyyy hh24:mi'),TO_DATE('21/01/2019 22:00','dd/mm/yyyy hh24:mi'),662,165.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,8,19,TO_DATE('22/01/2019 09:00','dd/mm/yyyy hh24:mi'),TO_DATE('22/01/2019 11:00','dd/mm/yyyy hh24:mi'),380,95);
INSERT INTO t_train VALUES(seq_t_train.nextval,19,8,TO_DATE('22/01/2019 17:00','dd/mm/yyyy hh24:mi'),TO_DATE('22/01/2019 19:00','dd/mm/yyyy hh24:mi'),380,95);
INSERT INTO t_train VALUES(seq_t_train.nextval,13,8,TO_DATE('23/01/2019 11:00','dd/mm/yyyy hh24:mi'),TO_DATE('23/01/2019 12:30','dd/mm/yyyy hh24:mi'),252,63);
INSERT INTO t_train VALUES(seq_t_train.nextval,8,13,TO_DATE('24/01/2019 09:30','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 11:30','dd/mm/yyyy hh24:mi'),252,63);
INSERT INTO t_train VALUES(seq_t_train.nextval,14,16,TO_DATE('24/01/2019 08:00','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 11:35','dd/mm/yyyy hh24:mi'),675,168.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,16,14,TO_DATE('24/01/2019 16:30','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 20:05','dd/mm/yyyy hh24:mi'),675,168.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,10,15,TO_DATE('23/01/2019 07:40','dd/mm/yyyy hh24:mi'),TO_DATE('23/01/2019 08:10','dd/mm/yyyy hh24:mi'),77,19.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,15,10,TO_DATE('24/01/2019 19:30','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 20:00','dd/mm/yyyy hh24:mi'),77,19.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,18,2,TO_DATE('24/01/2019 11:40','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 16:10','dd/mm/yyyy hh24:mi'),858,214.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,2,18,TO_DATE('24/01/2019 16:20','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 20:20','dd/mm/yyyy hh24:mi'),858,214.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,2,1,TO_DATE('25/01/2019 07:00','dd/mm/yyyy hh24:mi'),TO_DATE('25/01/2019 09:30','dd/mm/yyyy hh24:mi'),511,127.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,1,2,TO_DATE('25/01/2019 18:30','dd/mm/yyyy hh24:mi'),TO_DATE('25/01/2019 21:00','dd/mm/yyyy hh24:mi'),511,127.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,9,1,TO_DATE('24/01/2019 10:00','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 12:10','dd/mm/yyyy hh24:mi'),425,106.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,1,9,TO_DATE('24/01/2019 15:00','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 17:10','dd/mm/yyyy hh24:mi'),425,106.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,19,4,TO_DATE('25/01/2019 12:30','dd/mm/yyyy hh24:mi'),TO_DATE('25/01/2019 14:00','dd/mm/yyyy hh24:mi'),275,68.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,4,19,TO_DATE('25/01/2019 16:30','dd/mm/yyyy hh24:mi'),TO_DATE('25/01/2019 18:00','dd/mm/yyyy hh24:mi'),275,68.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,17,15,TO_DATE('14/01/2019 09:00','dd/mm/yyyy hh24:mi'),TO_DATE('14/01/2019 13:00','dd/mm/yyyy hh24:mi'),800,200);
INSERT INTO t_train VALUES(seq_t_train.nextval,15,17,TO_DATE('14/01/2019 16:00','dd/mm/yyyy hh24:mi'),TO_DATE('14/01/2019 20:00','dd/mm/yyyy hh24:mi'),800,200);
INSERT INTO t_train VALUES(seq_t_train.nextval,17,16,TO_DATE('16/01/2019 10:00','dd/mm/yyyy hh24:mi'),TO_DATE('16/01/2019 12:00','dd/mm/yyyy hh24:mi'),350,87.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,16,17,TO_DATE('16/01/2019 15:30','dd/mm/yyyy hh24:mi'),TO_DATE('16/01/2019 17:30','dd/mm/yyyy hh24:mi'),350,87.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,11,14,TO_DATE('18/01/2019 09:30','dd/mm/yyyy hh24:mi'),TO_DATE('18/01/2019 11:10','dd/mm/yyyy hh24:mi'),285,71.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,14,11,TO_DATE('18/01/2019 19:00','dd/mm/yyyy hh24:mi'),TO_DATE('18/01/2019 20:40','dd/mm/yyyy hh24:mi'),285,71.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,12,2,TO_DATE('20/01/2019 10:00','dd/mm/yyyy hh24:mi'),TO_DATE('20/01/2019 14:30','dd/mm/yyyy hh24:mi'),900,225);
INSERT INTO t_train VALUES(seq_t_train.nextval,2,12,TO_DATE('20/01/2019 15:00','dd/mm/yyyy hh24:mi'),TO_DATE('20/01/2019 19:30','dd/mm/yyyy hh24:mi'),900,225);
INSERT INTO t_train VALUES(seq_t_train.nextval,20,8,TO_DATE('22/01/2019 12:00','dd/mm/yyyy hh24:mi'),TO_DATE('22/01/2019 14:00','dd/mm/yyyy hh24:mi'),316,79);
INSERT INTO t_train VALUES(seq_t_train.nextval,8,20,TO_DATE('22/01/2019 16:00','dd/mm/yyyy hh24:mi'),TO_DATE('22/01/2019 18:00','dd/mm/yyyy hh24:mi'),316,79);
INSERT INTO t_train VALUES(seq_t_train.nextval,21,18,TO_DATE('24/01/2019 11:10','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 13:50','dd/mm/yyyy hh24:mi'),486,121.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,18,21,TO_DATE('24/01/2019 17:00','dd/mm/yyyy hh24:mi'),TO_DATE('24/01/2019 19:40','dd/mm/yyyy hh24:mi'),486,121.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,3,16,TO_DATE('26/01/2019 11:00','dd/mm/yyyy hh24:mi'),TO_DATE('26/01/2019 12:45','dd/mm/yyyy hh24:mi'),290,72.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,16,3,TO_DATE('27/01/2019 13:00','dd/mm/yyyy hh24:mi'),TO_DATE('27/01/2019 14:45','dd/mm/yyyy hh24:mi'),290,72.5);
INSERT INTO t_train VALUES(seq_t_train.nextval,5,21,TO_DATE('28/01/2019 09:00','dd/mm/yyyy hh24:mi'),TO_DATE('28/01/2019 11:35','dd/mm/yyyy hh24:mi'),471,117.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,21,5,TO_DATE('28/01/2019 14:00','dd/mm/yyyy hh24:mi'),TO_DATE('28/01/2019 16:35','dd/mm/yyyy hh24:mi'),471,117.75);
INSERT INTO t_train VALUES(seq_t_train.nextval,6,9,TO_DATE('30/01/2019 08:30','dd/mm/yyyy hh24:mi'),TO_DATE('30/01/2019 09:10','dd/mm/yyyy hh24:mi'),120,30);
INSERT INTO t_train VALUES(seq_t_train.nextval,9,6,TO_DATE('30/01/2019 10:10','dd/mm/yyyy hh24:mi'),TO_DATE('30/01/2019 10:50','dd/mm/yyyy hh24:mi'),120,30);
INSERT INTO t_train VALUES(seq_t_train.nextval,7,16,TO_DATE('01/02/2019 12:10','dd/mm/yyyy hh24:mi'),TO_DATE('01/02/2019 13:00','dd/mm/yyyy hh24:mi'),165,41.25);
INSERT INTO t_train VALUES(seq_t_train.nextval,16,7,TO_DATE('02/02/2019 19:10','dd/mm/yyyy hh24:mi'),TO_DATE('02/02/2019 20:00','dd/mm/yyyy hh24:mi'),165,41.25);
COMMIT;

INSERT INTO t_wagon VALUES(seq_t_wagon.nextval,20,1,20);
INSERT INTO t_wagon VALUES(seq_t_wagon.nextval,20,1,30);
INSERT INTO t_wagon VALUES(seq_t_wagon.nextval,NULL,2,20);
INSERT INTO t_wagon VALUES(seq_t_wagon.nextval,NULL,2,30);
COMMIT;

INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,1);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,1);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,1);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,2);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,2);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,2);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,2);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,2);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,3);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,3);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,3);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,3);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,3);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,3);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,4);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,4);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,4);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,5);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,5);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,5);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,6);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,6);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,6);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,7);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,8);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,8);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,8);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,8);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,8);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,9);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,10);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,10);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,10);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,10);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,11);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,11);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,11);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,11);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,11);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,11);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,12);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,12);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,12);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,12);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,13);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,13);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,13);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,14);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,14);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,14);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,14);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,15);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,15);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,15);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,16);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,16);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,16);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,16);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,16);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,17);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,2,17);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,17);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,18);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,18);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,18);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,18);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,19);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,19);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,20);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,20);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,20);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,20);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,21);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,21);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,21);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,21);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,21);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,21);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,22);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,22);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,22);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,23);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,23);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,23);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,24);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,24);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,24);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,24);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,24);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,25);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,25);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,26);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,26);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,26);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,26);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,27);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,27);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,28);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,28);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,28);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,29);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,29);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,30);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,31);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,31);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,31);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,32);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,32);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,33);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,33);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,33);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,34);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,34);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,35);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,35);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,36);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,36);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,37);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,37);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,37);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,37);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,38);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,38);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,39);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,39);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,39);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,40);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,40);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,41);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,41);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,4,41);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,42);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,3,42);
INSERT INTO t_wagon_train VALUES(seq_t_wagon_train.nextval,1,42);
COMMIT;

-- Activation des contraintes
ALTER TABLE T_PASS
	ENABLE CONSTRAINT PK_PASS;

ALTER TABLE T_CUSTOMER
	ENABLE CONSTRAINT PK_CUSTOMER;

ALTER TABLE T_CUSTOMER
	ENABLE CONSTRAINT FK_PASS_CUSTOMER;

ALTER TABLE T_STATION
	ENABLE CONSTRAINT PK_STATION;

ALTER TABLE T_WAGON
	ENABLE CONSTRAINT PK_WAGON;

ALTER TABLE T_WAGON_TRAIN
	ENABLE CONSTRAINT PK_WAGON_TRAIN;

ALTER TABLE T_WAGON_TRAIN
	ENABLE CONSTRAINT FK_TRAIN_WAGON_TRAIN;

ALTER TABLE T_WAGON_TRAIN
	ENABLE CONSTRAINT FK_WAGON_WAGON_TRAIN;

ALTER TABLE T_RESERVATION
	ENABLE CONSTRAINT PK_RESERVATION;

ALTER TABLE T_RESERVATION
	ENABLE CONSTRAINT FK_CUSTOMER_RESERVATION;

ALTER TABLE T_RESERVATION
	ENABLE CONSTRAINT FK_EMPLOYEE_RESERVATION;

ALTER TABLE T_EMPLOYEE
	ENABLE CONSTRAINT PK_EMPLOYEE;

ALTER TABLE T_EMPLOYEE
	ENABLE CONSTRAINT FK_EMPLOYEE_EMPLOYEE;

ALTER TABLE T_TICKET
	ENABLE CONSTRAINT PK_TICKET;

ALTER TABLE T_TICKET
	ENABLE CONSTRAINT FK_CUSTOMER_TICKET;

ALTER TABLE T_TICKET
	ENABLE CONSTRAINT FK_WAGON_TRAIN_TICKET;

ALTER TABLE T_TICKET
	ENABLE CONSTRAINT FK_RESERVATION_TICKET;

ALTER TABLE T_TRAIN
	ENABLE CONSTRAINT PK_TRAIN;

ALTER TABLE T_TRAIN
	ENABLE CONSTRAINT FK_STATION_TRAIN_DEPARTURE;

ALTER TABLE T_TRAIN
	ENABLE CONSTRAINT FK_STATION_TRAIN_ARRIVAL;