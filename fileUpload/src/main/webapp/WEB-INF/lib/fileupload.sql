-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.5.19-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- fileupload 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `fileupload` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `fileupload`;

-- 테이블 fileupload.board 구조 내보내기
CREATE TABLE IF NOT EXISTS `board` (
  `board_no` int(11) NOT NULL AUTO_INCREMENT,
  `board_title` text NOT NULL,
  `member_id` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`board_no`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 fileupload.board:~6 rows (대략적) 내보내기
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` (`board_no`, `board_title`, `member_id`, `createdate`, `updatedate`) VALUES
	(1, 'test', 'test', '2023-05-19 16:36:33', '2023-05-19 16:36:33'),
	(2, 'test6', 'test', '2023-05-19 16:37:24', '2023-05-19 16:37:24'),
	(3, 'test1', 'test', '2023-05-19 16:45:21', '2023-05-19 16:45:21'),
	(4, 'test2', 'test', '2023-05-19 16:54:04', '2023-05-19 16:54:04'),
	(5, 'test4', 'test', '2023-05-19 17:30:46', '2023-05-19 17:30:46'),
	(9, 'test', 'user1', '2023-05-23 23:20:30', '2023-05-23 23:20:30');
/*!40000 ALTER TABLE `board` ENABLE KEYS */;

-- 테이블 fileupload.board_file 구조 내보내기
CREATE TABLE IF NOT EXISTS `board_file` (
  `board_file_no` int(11) NOT NULL AUTO_INCREMENT,
  `board_no` int(11) NOT NULL,
  `origin_filename` text NOT NULL,
  `save_filename` text NOT NULL,
  `path` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`board_file_no`),
  KEY `FK__board` (`board_no`),
  CONSTRAINT `FK__board` FOREIGN KEY (`board_no`) REFERENCES `board` (`board_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 fileupload.board_file:~1 rows (대략적) 내보내기
/*!40000 ALTER TABLE `board_file` DISABLE KEYS */;
INSERT INTO `board_file` (`board_file_no`, `board_no`, `origin_filename`, `save_filename`, `path`, `type`, `createdate`) VALUES
	(8, 9, '도라 202204.png', '도라 202204.png', 'upload', 'image/png', '2023-05-23 23:20:30');
/*!40000 ALTER TABLE `board_file` ENABLE KEYS */;

-- 테이블 fileupload.member 구조 내보내기
CREATE TABLE IF NOT EXISTS `member` (
  `member_id` varchar(50) NOT NULL,
  `member_pw` varchar(50) NOT NULL,
  `updatedate` datetime NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 fileupload.member:~2 rows (대략적) 내보내기
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` (`member_id`, `member_pw`, `updatedate`, `createdate`) VALUES
	('user1', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2023-05-23 17:23:59', '2023-05-23 17:23:59'),
	('user2', '*A4B6157319038724E3560894F7F932C8886EBFCF', '2023-05-23 17:27:20', '2023-05-23 17:27:20');
/*!40000 ALTER TABLE `member` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
