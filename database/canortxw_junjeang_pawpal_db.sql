-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 10, 2026 at 01:25 AM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `canortxw_junjeang_pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `motivation` text NOT NULL,
  `request_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `pet_id`, `user_id`, `motivation`, `request_date`) VALUES
(1, 11, 2, 'because it is cute dog', '2026-01-10 00:56:30');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `donation_type` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `donation_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(1, 10, 2, 'Food', 0.00, '2kg of cat food', '2026-01-10 00:58:19'),
(2, 10, 2, 'Medical', 0.00, 'medical check', '2026-01-10 00:58:40'),
(3, 10, 2, 'Money', 5.50, 'NA', '2026-01-10 00:59:50');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) DEFAULT NULL,
  `pet_gender` varchar(50) NOT NULL,
  `pet_age` int(11) NOT NULL,
  `pet_health` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `pet_gender`, `pet_age`, `pet_health`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 1, 'Boshi', 'Cat', 'Male', 2, 'Healthy', 'Adoption', 'A very nice cat', 'uploads/pet_1_6960321e61512_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:39:26'),
(2, 1, 'Pug', 'Dog', 'Female', 1, 'Sick', 'Donation Request', 'Cute, small size dog', 'uploads/pet_1_69603265ecff7_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:40:37'),
(3, 1, 'Grey Rabbit', 'Rabbit', 'Female', 1, 'Injured', 'Help/Rescue', 'Grey fur, active pet', 'uploads/pet_1_696032c85fc1f_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:42:16'),
(4, 1, 'Beagle', 'Dog', 'Male', 3, 'Sick', 'Donation Request', 'Beagle wiggle', 'uploads/pet_1_6960337674f36_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:45:10'),
(5, 1, 'Murai Kampung', 'Other', 'Female', 3, 'Sick', 'Donation Request', 'Like to sing bird', 'uploads/pet_1_696034634f42c_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:49:07'),
(6, 1, 'Maine Coon', 'Cat', 'Male', 2, 'Healthy', 'Adoption', 'A large size cat', 'uploads/pet_1_696034e3e4331_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:51:15'),
(7, 1, 'Golden', 'Dog', 'Female', 1, 'Healthy', 'Adoption', 'Golden fur, active dog', 'uploads/pet_1_6960353b43309_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:52:43'),
(8, 1, 'White Rabbit', 'Rabbit', 'Female', 1, 'Healthy', 'Adoption', 'White fur very cute rabbit', 'uploads/pet_1_696035ae5bc1b_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:54:38'),
(9, 1, 'Prothonotary Warbler', 'Other', 'Male', 2, 'Healthy', 'Help/Rescue', 'Small yellow bird', 'uploads/pet_1_6960360f7907f_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:56:15'),
(10, 1, 'Oyen', 'Cat', 'Male', 3, 'Injured', 'Donation Request', 'Orange cat', 'uploads/pet_1_69603646321e5_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:57:10'),
(11, 1, 'Pom', 'Dog', 'Female', 1, 'Healthy', 'Adoption', 'Small, furry, cute dog', 'uploads/pet_1_69603680273be_0.jpg', '37.4219983', '-122.084', '2026-01-09 06:58:08');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`) VALUES
(1, 'Danielle', 'Danielle09@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', '2026-01-09 06:29:17'),
(2, 'Mo', 'demo03@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123455555', '2026-01-09 23:28:16');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
