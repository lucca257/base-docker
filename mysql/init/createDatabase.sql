CREATE DATABASE IF NOT EXISTS `taskuro_db` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `taskuro_db`.* TO 'root'@'%' ;

CREATE DATABASE IF NOT EXISTS `turnoverbnb_db` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `turnoverbnb_db`.* TO 'root'@'%' ;

CREATE DATABASE IF NOT EXISTS `booking_db` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `booking_db`.* TO 'root'@'%' ;

FLUSH PRIVILEGES ;
