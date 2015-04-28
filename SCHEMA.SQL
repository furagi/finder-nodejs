SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `finder` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `finder` ;

-- -----------------------------------------------------
-- Table `finder`.`user`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `finder`.`user` (
  `user_id` INT NOT NULL AUTO_INCREMENT ,
  `email` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(64) NOT NULL ,
  `is_admin` TINYINT(1) NOT NULL DEFAULT false ,
  PRIMARY KEY (`user_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finder`.`girl`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `finder`.`girl` (
  `girl_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL ,
  `description` VARCHAR(1000) NOT NULL ,
  `raiting` INT NOT NULL DEFAULT 0 ,
  `profile_photo` TEXT NOT NULL ,
  PRIMARY KEY (`girl_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finder`.`category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `finder`.`category` (
  `category_id` INT NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL ,
  PRIMARY KEY (`category_id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finder`.`file`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `finder`.`file` (
  `file_id` INT NOT NULL AUTO_INCREMENT ,
  `type` ENUM('photo', 'video') NOT NULL ,
  `size` INT UNSIGNED NOT NULL ,
  `path` TEXT NOT NULL ,
  `is_main` TINYINT(1) NOT NULL DEFAULT false ,
  `girl_id` INT NULL ,
  PRIMARY KEY (`file_id`) ,
  INDEX `fk_file_girl_idx` (`girl_id` ASC) ,
  CONSTRAINT `fk_file_girl`
    FOREIGN KEY (`girl_id` )
    REFERENCES `finder`.`file` (`file_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finder`.`girl_to_category`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `finder`.`girl_to_category` (
  `girl_id` INT NOT NULL ,
  `category_id` INT NOT NULL ,
  INDEX `fk_girl_to_category_category_id_idx` (`category_id` ASC) ,
  INDEX `fk_girl_to_category_girl_id_idx` (`girl_id` ASC) ,
  CONSTRAINT `fk_girl_to_category_girl_id`
    FOREIGN KEY (`girl_id` )
    REFERENCES `finder`.`girl` (`girl_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_girl_to_category_category_id`
    FOREIGN KEY (`category_id` )
    REFERENCES `finder`.`category` (`category_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `finder` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
