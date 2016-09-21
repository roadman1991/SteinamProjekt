SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';



create database watson_11fi1_ssg;
use watson_11fi1_ssg;


-- -----------------------------------------------------
-- Table `watson_11fi1_ssg`.`Computer`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `watson_11fi1_ssg`.`Computer` (
  `idComputer` INT NOT NULL ,
  `ComputerMac` VARCHAR(20) NULL ,
  PRIMARY KEY (`idComputer`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `watson_11fi1_ssg`.`User`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `watson_11fi1_ssg`.`User` (
  `idUser` INT NOT NULL ,
  `UserName` VARCHAR(100) NULL ,
  PRIMARY KEY (`idUser`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `watson_11fi1_ssg`.`AppName`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `watson_11fi1_ssg`.`AppName` (
  `idAppName` INT NOT NULL ,
  `AppName` VARCHAR(300) NULL ,
  PRIMARY KEY (`idAppName`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `watson_11fi1_ssg`.`Report`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `watson_11fi1_ssg`.`Report` (
  `idReport` INT NOT NULL ,
  `ReportType` INT NOT NULL ,
  `ReportDate` DATETIME NULL ,
  `AppPath` VARCHAR(400) NULL ,
  `User_idUser` INT NOT NULL ,
  `AppName_idAppName` INT NOT NULL ,
  `Computer_idComputer` INT NOT NULL ,
  PRIMARY KEY (`idReport`, `User_idUser`, `AppName_idAppName`, `Computer_idComputer`) ,
  INDEX `fk_Report_User1_idx` (`User_idUser` ASC) ,
  INDEX `fk_Report_AppName1_idx` (`AppName_idAppName` ASC) ,
  INDEX `fk_Report_Computer1_idx` (`Computer_idComputer` ASC) ,
  CONSTRAINT `fk_Report_User1`
    FOREIGN KEY (`User_idUser` )
    REFERENCES `watson_11fi1_ssg`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Report_AppName1`
    FOREIGN KEY (`AppName_idAppName` )
    REFERENCES `watson_11fi1_ssg`.`AppName` (`idAppName` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Report_Computer1`
    FOREIGN KEY (`Computer_idComputer` )
    REFERENCES `watson_11fi1_ssg`.`Computer` (`idComputer` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
