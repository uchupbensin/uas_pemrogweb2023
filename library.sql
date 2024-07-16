-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 16, 2024 at 08:24 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `list_all_books` ()   BEGIN
    SELECT * FROM books;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_book_title` (IN `p_book_id` INT, IN `p_new_title` VARCHAR(100))   BEGIN
    DECLARE current_title VARCHAR(100);
    SELECT title INTO current_title FROM books WHERE id = p_book_id;
    IF current_title IS NOT NULL THEN
        UPDATE books SET title = p_new_title WHERE id = p_book_id;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_books_by_author` (`author_id` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_books INT;
    SELECT COUNT(*) INTO total_books FROM books WHERE books.author_id = author_id;
    RETURN total_books;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_total_books` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total_books INT;
    SELECT COUNT(*) INTO total_books FROM books;
    RETURN total_books;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `bio` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`id`, `name`, `bio`) VALUES
(1, 'Andrea Hirata', 'Penulis Indonesia terkenal dengan novel Laskar Pelangi'),
(2, 'Pramoedya Ananta Toer', 'Penulis dan jurnalis Indonesia yang terkenal'),
(3, 'Habiburrahman El Shirazy', 'Penulis novel Islami Indonesia'),
(4, 'Tere Liye', 'Penulis novel populer Indonesia'),
(5, 'Ahmad Tohari', 'Penulis novel Ronggeng Dukuh Paruk'),
(6, 'Tereliye', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `published_year` year(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `author_id`, `category_id`, `published_year`) VALUES
(1, 'Update judul buku', 1, 1, '2005'),
(2, 'Bumi Manusia', 2, 2, '1980'),
(3, 'Ayat-Ayat Cinta', 3, 3, '2004'),
(4, 'Hafalan Shalat Delisa', 4, 3, '2005'),
(5, 'Ronggeng Dukuh Paruk', 5, 1, '1982'),
(6, 'New Book', 1, 1, '2022'),
(7, 'Buku baru', 1, 1, '2022'),
(8, 'New Book', NULL, NULL, NULL);

--
-- Triggers `books`
--
DELIMITER $$
CREATE TRIGGER `after_books_delete` AFTER DELETE ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (log_message) VALUES (CONCAT('After delete on books: ', OLD.title));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_books_insert` AFTER INSERT ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (log_message) VALUES (CONCAT('After insert on books: ', NEW.title));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_books_update` AFTER UPDATE ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (log_message) VALUES (CONCAT('After update on books: ', OLD.title, ' to ', NEW.title));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_books_delete` BEFORE DELETE ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (log_message) VALUES (CONCAT('Before delete on books: ', OLD.title));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_books_insert` BEFORE INSERT ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (log_message) VALUES (CONCAT('Before insert on books: ', NEW.title));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_books_update` BEFORE UPDATE ON `books` FOR EACH ROW BEGIN
    INSERT INTO log (log_message) VALUES (CONCAT('Before update on books: ', OLD.title, ' to ', NEW.title));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `book_author_titles`
-- (See below for the actual view)
--
CREATE TABLE `book_author_titles` (
`name` varchar(100)
,`title` varchar(100)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `book_details`
-- (See below for the actual view)
--
CREATE TABLE `book_details` (
`id` int(11)
,`title` varchar(100)
,`author_name` varchar(100)
,`category_name` varchar(50)
);

-- --------------------------------------------------------

--
-- Table structure for table `book_loans`
--

CREATE TABLE `book_loans` (
  `book_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `loan_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book_loans`
--

INSERT INTO `book_loans` (`book_id`, `member_id`, `loan_date`, `return_date`) VALUES
(1, 1, '2023-01-10', '2023-01-24'),
(2, 2, '2023-02-15', '2023-03-01'),
(3, 3, '2023-03-20', '2023-04-03'),
(4, 4, '2023-04-25', '2023-05-09'),
(5, 5, '2023-05-30', '2023-06-13');

-- --------------------------------------------------------

--
-- Stand-in structure for view `book_titles`
-- (See below for the actual view)
--
CREATE TABLE `book_titles` (
`title` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Novel'),
(2, 'Sejarah'),
(3, 'Agama'),
(4, 'Sains'),
(5, 'Biografi');

-- --------------------------------------------------------

--
-- Stand-in structure for view `detailed_book_author_titles`
-- (See below for the actual view)
--
CREATE TABLE `detailed_book_author_titles` (
`name` varchar(100)
,`title` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `indexed_books`
--

CREATE TABLE `indexed_books` (
  `id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `log_id` int(11) NOT NULL,
  `log_message` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`log_id`, `log_message`, `created_at`) VALUES
(1, 'Before insert on books: New Book', '2024-07-16 05:51:06'),
(2, 'After insert on books: New Book', '2024-07-16 05:51:06'),
(3, 'Before update on books: New Book Title to Updated Book Title', '2024-07-16 05:51:06'),
(4, 'After update on books: New Book Title to Updated Book Title', '2024-07-16 05:51:06'),
(6, 'Before insert on books: Buku baru', '2024-07-16 05:55:08'),
(7, 'After insert on books: Buku baru', '2024-07-16 05:55:08'),
(8, 'Before update on books: Updated Book Title to Update judul buku', '2024-07-16 05:55:08'),
(9, 'After update on books: Updated Book Title to Update judul buku', '2024-07-16 05:55:08'),
(10, 'Before insert on books: New Book', '2024-07-16 06:22:42'),
(11, 'After insert on books: New Book', '2024-07-16 06:22:42');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `membership_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `name`, `email`, `membership_date`) VALUES
(1, 'Budi Santoso', 'budi.santoso@example.com', '2021-01-15'),
(2, 'Ayu Lestari', 'ayu.lestari@example.com', '2020-06-22'),
(3, 'Rina Sari', 'rina.sari@example.com', '2019-11-03'),
(4, 'Dewi Anggraeni', 'dewi.anggraeni@example.com', '2022-02-10'),
(5, 'Agus Wirawan', 'agus.wirawan@example.com', '2021-05-27');

-- --------------------------------------------------------

--
-- Structure for view `book_author_titles`
--
DROP TABLE IF EXISTS `book_author_titles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `book_author_titles`  AS SELECT `a`.`name` AS `name`, `b`.`title` AS `title` FROM (`authors` `a` join `books` `b` on(`a`.`id` = `b`.`author_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `book_details`
--
DROP TABLE IF EXISTS `book_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `book_details`  AS SELECT `b`.`id` AS `id`, `b`.`title` AS `title`, `a`.`name` AS `author_name`, `c`.`name` AS `category_name` FROM ((`books` `b` join `authors` `a` on(`b`.`author_id` = `a`.`id`)) join `categories` `c` on(`b`.`category_id` = `c`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `book_titles`
--
DROP TABLE IF EXISTS `book_titles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `book_titles`  AS SELECT `books`.`title` AS `title` FROM `books` ;

-- --------------------------------------------------------

--
-- Structure for view `detailed_book_author_titles`
--
DROP TABLE IF EXISTS `detailed_book_author_titles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detailed_book_author_titles`  AS SELECT `book_author_titles`.`name` AS `name`, `book_author_titles`.`title` AS `title` FROM `book_author_titles`WITH CASCADED CHECK OPTION  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_author_name` (`name`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD KEY `author_id` (`author_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_title_published_year` (`title`,`published_year`);

--
-- Indexes for table `book_loans`
--
ALTER TABLE `book_loans`
  ADD PRIMARY KEY (`book_id`,`member_id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `indexed_books`
--
ALTER TABLE `indexed_books`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_author_category` (`author_id`,`category_id`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `indexed_books`
--
ALTER TABLE `indexed_books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`),
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `book_loans`
--
ALTER TABLE `book_loans`
  ADD CONSTRAINT `book_loans_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  ADD CONSTRAINT `book_loans_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
