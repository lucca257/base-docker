CREATE DATABASE IF NOT EXISTS `example_db` COLLATE 'utf8_general_ci' ;
GRANT ALL ON `example_db`.* TO 'root'@'%' ;

FLUSH PRIVILEGES ;
