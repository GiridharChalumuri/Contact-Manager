DROP DATABASE IF EXISTS Contactmanager;
CREATE DATABASE Contactmanager;

-- Creating Company Schema
USE Contactmanager;

CREATE TABLE person (
	pid     int(10) auto_increment,
	dob     date not null, 
	gender  char(1) not null, 
	fname 	varchar(100) not null,
	minit 	varchar(100),
	lname 	varchar(100),
    check (year(dob)>year(now())),
	CONSTRAINT pk_person primary key (pid)
);

CREATE TABLE email(
	pid int(10),
    mail_type varchar(100) not null,
    mail_id  varchar(100) not null,
    constraint fk_email foreign key(pid) references person(pid) on update cascade,
    constraint ck_email primary key(pid,mail_type)
);

CREATE TABLE phonenumber(
	pid int(10),
	ph_areacode int(10) not null,
    ph_number int(10) not null,
    ph_type  varchar(30) not null,
    constraint fk_phonenumber foreign key(pid) references person(pid) on update cascade,
    constraint ck_phonenumber primary key(pid,ph_number)
);

CREATE TABLE address(
	pid int(10),
    streetno varchar(100) not null,
    streetname varchar(300),
    aptno varchar(300),
	city varchar(200) not null,
    zipcode varchar(100) not null,
    state varchar(10) not null,
    address_type varchar(100) not null,
    constraint fk_address foreign key(pid) references person(pid) on update cascade,
    constraint ck_address primary key(pid, address_type)
);

CREATE TABLE meetings(
	pid int(10),
	meeting_date date not null,
    meeting_time time not null,
    place varchar(200),
    notes varchar(300),
    constraint fk_meetings foreign key(pid) references person(pid) on update cascade,
    constraint ck_meetings primary key(pid, meeting_date, meeting_time)
);

CREATE TABLE groups(
	pid int(10),
    group_name varchar(200) not null,
    constraint fk_groups foreign key(pid) references person(pid) on update cascade,
    constraint ck_groups primary key(pid, group_name)
);

CREATE INDEX index_person ON person (fname,lname);

DELIMITER $$

DROP TRIGGER IF EXISTS check_dob$$
CREATE TRIGGER `check_dob` BEFORE INSERT ON `person` FOR EACH ROW
BEGIN
	if year(new.dob) > year(now()) then
		signal sqlstate '45000' SET MESSAGE_TEXT = "Future date is not accepted";
	end if;
	if year(new.dob) <1900 then
        signal sqlstate '45000' SET MESSAGE_TEXT = "Year should be greater than 1970";	
    end if;
END$$
DELIMITER ;

DELIMITER $$

DROP PROCEDURE EXECUTE_STMT$$

CREATE PROCEDURE EXECUTE_STMT (IN querystr varchar(255))
BEGIN
execute querystr;
END$$

DELIMITER ;