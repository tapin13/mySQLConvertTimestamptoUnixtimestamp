DELIMITER $$

USE `databaseName`$$ #change to your DB name

DROP PROCEDURE IF EXISTS `convertTimestamptoUnixtimestamp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `convertTimestamptoUnixtimestamp`(
    tableName VARCHAR(255)
    , fieldName VARCHAR(255)
)
BEGIN

    SET @query = CONCAT("ALTER TABLE `", `tableName`, "` ADD COLUMN `tmp_123456` TIMESTAMP DEFAULT '0000-00-00 00:00:00' NULL");
PREPARE stmt FROM @query;
EXECUTE stmt;

    SET @query = CONCAT("UPDATE `", `tableName`, "` SET tmp_123456 = `", fieldName, "`");
PREPARE stmt FROM @query;
EXECUTE stmt;

    SET @query = CONCAT("ALTER TABLE `", `tableName`, "` CHANGE `", fieldName, "` `", fieldName, "` INT UNSIGNED DEFAULT 0 NOT NULL");
PREPARE stmt FROM @query;
EXECUTE stmt;

    SET @query = CONCAT("UPDATE `", `tableName`, "` SET `", fieldName, "` = UNIX_TIMESTAMP(`tmp_123456`)");
PREPARE stmt FROM @query;
EXECUTE stmt;

    SET @query = CONCAT("ALTER TABLE `", `tableName`, "` DROP COLUMN `tmp_123456`");
PREPARE stmt FROM @query;
EXECUTE stmt;
        
END$$

DELIMITER ;
