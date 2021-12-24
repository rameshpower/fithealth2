CREATE DATABASE `fithealthdb`;
use  `fithealthdb`;

CREATE TABLE `patient` (
  `patient_no` int NOT NULL AUTO_INCREMENT,
  `patient_nm` varchar(45) DEFAULT NULL,
  `mobile_nbr` varchar(45) DEFAULT NULL,
  `email_address` varchar(45) DEFAULT NULL,
  `age` int DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`patient_no`)
);
