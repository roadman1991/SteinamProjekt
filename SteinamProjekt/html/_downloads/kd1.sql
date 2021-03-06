create database watson_11fi3;
use watson_11fi3;

create table User(
	Anmeldename varchar(30) primary key
) engine = innodb;

create table Computer(
	MAC varchar(30) primary key,
    OSName varchar(40),
    Hostname varchar(40)
) engine = innodb;

create table Report(
	ReportID varchar(30),
    Appname varchar(200),
    EventTime varchar(30),
    BucketID VARCHAR(30),
    ReportType int,
    `User` VARCHAR(30),
    Computer varchar(30),
    foreign key (`User`) references User(Anmeldename),
    foreign key (`Computer`) references Computer(MAC)
) engine = innodb;