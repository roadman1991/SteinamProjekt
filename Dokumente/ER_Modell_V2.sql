SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `watson_11fi1_ssg` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `watson_11fi1_ssg` ;

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
  `AppName_idAppName` INT NOT NULL ,
  `ComputerMac` VARCHAR(20) NULL ,
  `UserName` VARCHAR(45) NULL ,
  PRIMARY KEY (`idReport`, `AppName_idAppName`) ,
  INDEX `fk_Report_AppName1_idx` (`AppName_idAppName` ASC) ,
  CONSTRAINT `fk_Report_AppName1`
    FOREIGN KEY (`AppName_idAppName` )
    REFERENCES `watson_11fi1_ssg`.`AppName` (`idAppName` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
