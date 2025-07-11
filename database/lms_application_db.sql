-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 11, 2025 at 04:48 AM
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
-- Database: `lms_application_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `description`, `ip_address`, `created_at`, `updated_at`) VALUES
(1, 2, 'Sick', 'Tody, I\'m sick stay at home.', '192.168.1.100', '2025-07-03 06:49:08', '2025-07-03 06:49:08'),
(2, 2, 'Headahe', 'Tody, I\'m sick stay at home.', '192.168.1.100', '2025-07-03 18:26:34', '2025-07-03 18:26:34');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `head_user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `head_user_id`, `created_at`, `updated_at`) VALUES
(1, 'Software Engineer', 6, '2025-07-03 06:45:46', '2025-07-07 00:33:45'),
(2, 'Web developer', 6, '2025-07-03 06:46:00', '2025-07-09 05:11:41'),
(5, 'HR', 2, '2025-07-04 03:03:03', '2025-07-04 03:03:03'),
(6, 'Security', 2, '2025-07-04 04:00:13', '2025-07-07 00:33:30'),
(9, 'Data Analyzis', 18, '2025-07-06 18:43:26', '2025-07-10 15:41:47'),
(10, 'web', 7, '2025-07-10 18:59:13', '2025-07-10 18:59:13');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(2, '2025_07_03_131946_create_roles_table', 1),
(3, '2025_07_03_132033_create_permission_types_table', 2),
(4, '2025_07_03_132113_create_departments_table', 3),
(5, '2025_07_03_132144_create_users_table', 4),
(6, '2025_07_03_132300_create_permission_access_table', 5),
(7, '2025_07_03_133229_create_permission_requests_table', 6),
(8, '2025_07_03_133306_create_permission_approvals_table', 7),
(9, '2025_07_03_133336_create_notifications_table', 8),
(10, '2025_07_03_133407_create_audit_logs_table', 9),
(11, '2025_07_03_133446_add_head_user_fk_to_departments', 10);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission_access`
--

CREATE TABLE `permission_access` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `permission_type_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_access`
--

INSERT INTO `permission_access` (`id`, `role_id`, `permission_type_id`, `created_at`, `updated_at`) VALUES
(1, 4, 1, '2025-03-13 09:18:26', '2025-03-04 13:44:49');

-- --------------------------------------------------------

--
-- Table structure for table `permission_approvals`
--

CREATE TABLE `permission_approvals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `permission_request_id` bigint(20) UNSIGNED NOT NULL,
  `approved_by` bigint(20) UNSIGNED NOT NULL,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission_requests`
--

CREATE TABLE `permission_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `permission_type_id` bigint(20) UNSIGNED NOT NULL,
  `reason` text DEFAULT NULL,
  `date_leave` date DEFAULT NULL,
  `leave_morning` tinyint(1) DEFAULT 0,
  `leave_afternoon` tinyint(1) DEFAULT 0,
  `date_back` date DEFAULT NULL,
  `back_morning` tinyint(1) DEFAULT 0,
  `back_afternoon` tinyint(1) DEFAULT 0,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_requests`
--

INSERT INTO `permission_requests` (`id`, `user_id`, `permission_type_id`, `reason`, `date_leave`, `leave_morning`, `leave_afternoon`, `date_back`, `back_morning`, `back_afternoon`, `status`, `created_at`, `updated_at`) VALUES
(28, 7, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.', NULL, 0, 0, NULL, 0, 0, 'pending', '2025-07-07 00:34:32', '2025-07-10 06:11:26'),
(31, 2, 2, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.', NULL, 0, 0, NULL, 0, 0, 'approved', '2025-07-07 00:54:58', '2025-07-07 00:59:43'),
(36, 2, 2, 'I want to go outside with my friends.', NULL, 0, 0, NULL, 0, 0, 'approved', '2025-07-09 20:29:20', '2025-07-09 20:29:20'),
(42, 7, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.', NULL, 0, 0, NULL, 0, 0, 'pending', '2025-07-10 06:21:15', '2025-07-10 06:21:48'),
(43, 2, 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.', NULL, 0, 0, NULL, 0, 0, 'rejected', '2025-07-10 06:25:53', '2025-07-10 06:25:53'),
(45, 6, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.', '2025-07-12', 1, 0, '2025-07-19', 1, 0, 'pending', '2025-07-10 07:55:05', '2025-07-10 07:55:05'),
(49, 18, 5, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.', '2025-07-10', 1, 0, '2025-07-12', 1, 0, 'pending', '2025-07-10 08:49:55', '2025-07-10 08:49:55'),
(50, 22, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,', '2025-07-11', 0, 1, '2025-07-15', 0, 1, 'pending', '2025-07-10 09:10:10', '2025-07-10 09:10:10'),
(51, 18, 4, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,', '2025-07-11', 1, 0, '2025-07-17', 0, 1, 'pending', '2025-07-10 09:28:50', '2025-07-10 09:28:50'),
(53, 23, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,', '2025-07-12', 0, 1, '2025-07-14', 0, 1, 'pending', '2025-07-10 15:39:13', '2025-07-10 15:39:13'),
(54, 18, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,', '2025-07-11', 0, 1, '2025-07-12', 0, 1, 'pending', '2025-07-10 19:00:11', '2025-07-10 19:00:11'),
(55, 6, 1, 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,', '2025-07-11', 0, 1, '2025-07-12', 1, 0, 'pending', '2025-07-10 19:02:46', '2025-07-10 19:02:46');

-- --------------------------------------------------------

--
-- Table structure for table `permission_types`
--

CREATE TABLE `permission_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission_types`
--

INSERT INTO `permission_types` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Khmer New Years', 'I want to stay at home.', '2025-03-13 09:18:26', '2025-07-09 20:01:17'),
(2, 'Go Outside Country', 'I want get the medicinse', '2025-07-04 00:36:01', '2025-07-09 20:02:25'),
(4, 'Training', 'Ea id ad commodi sed Magna ab iste except', '2025-07-04 19:19:43', '2025-07-09 20:01:55'),
(5, 'Trip with team', 'I want to trip outside.', '2025-07-09 20:00:52', '2025-07-10 08:49:32');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 12, 'apptoken', 'eaab85914bfc0f892cdb92c2736ae89928f54ab9b2a01da5e1ebac8ac8bf1268', '[\"*\"]', NULL, NULL, '2025-07-07 18:24:35', '2025-07-07 18:24:35'),
(3, 'App\\Models\\User', 19, 'apptoken', '802de4aba217e59aa317a1b3e05009814e618f09e05dc639050854b69f699493', '[\"*\"]', NULL, NULL, '2025-07-08 21:14:08', '2025-07-08 21:14:08'),
(9, 'App\\Models\\User', 18, 'apptoken', '5f4de718f5b4d04329f65764b9a262180fa9281904ae0e8b8d400ea4b73db0ab', '[\"*\"]', '2025-07-09 09:01:30', NULL, '2025-07-09 08:34:57', '2025-07-09 09:01:30'),
(10, 'App\\Models\\User', 18, 'apptoken', '544c238907c9d8ac1d9e29cbce95bfb77d3e45810e5d69b8b3c9766a9090e849', '[\"*\"]', NULL, NULL, '2025-07-09 16:13:13', '2025-07-09 16:13:13'),
(11, 'App\\Models\\User', 18, 'apptoken', '663983fedf443fe3d04523927b0da42bc24e883e7387ea37230f28e7477a6a3c', '[\"*\"]', NULL, NULL, '2025-07-09 16:13:47', '2025-07-09 16:13:47'),
(12, 'App\\Models\\User', 18, 'apptoken', '23459a9f1ccc8bde1143768ba7eabeeac00cb5fbd63774362c2f18234dd659d4', '[\"*\"]', NULL, NULL, '2025-07-09 16:15:17', '2025-07-09 16:15:17'),
(13, 'App\\Models\\User', 18, 'apptoken', '8c871b367d66d39bd737107ef9fffab20e377851854dd4959282cea1faa2c41d', '[\"*\"]', NULL, NULL, '2025-07-09 16:20:47', '2025-07-09 16:20:47'),
(14, 'App\\Models\\User', 18, 'apptoken', 'ff5b5b5243d695f9b76ffd64903efb041d61ef8cade7031c8698fcafbdaf1143', '[\"*\"]', NULL, NULL, '2025-07-09 16:21:26', '2025-07-09 16:21:26'),
(15, 'App\\Models\\User', 18, 'apptoken', '25f4f124332228471b2ebbc3b9658d6801eaf0e03fb8261a798d4eb4534fb270', '[\"*\"]', NULL, NULL, '2025-07-09 16:22:33', '2025-07-09 16:22:33'),
(16, 'App\\Models\\User', 18, 'apptoken', '64f22811b8d50b3468a0446e016c347810771ea8e1a394a63ae4564c9ab497c6', '[\"*\"]', NULL, NULL, '2025-07-09 16:22:34', '2025-07-09 16:22:34'),
(17, 'App\\Models\\User', 18, 'apptoken', '7649e7d51d2c95a473b84969018a7f6e3e3572eb0f91f68f51f00f5d3c55888c', '[\"*\"]', NULL, NULL, '2025-07-09 16:22:35', '2025-07-09 16:22:35'),
(18, 'App\\Models\\User', 18, 'apptoken', '7996b898ede51238c8e10cbd7cdd56a78c427c622fcff513d6737f994dba1061', '[\"*\"]', NULL, NULL, '2025-07-09 16:22:35', '2025-07-09 16:22:35'),
(19, 'App\\Models\\User', 18, 'apptoken', '6ffcb354542c412befea908e44f5aba56f347db17df30561a3d616a331131852', '[\"*\"]', NULL, NULL, '2025-07-09 16:22:43', '2025-07-09 16:22:43'),
(20, 'App\\Models\\User', 18, 'apptoken', '22a7eddb81eafec5ccc17fc0c3e60ee33ea7a255f21c99719e2fa16e6e15c3fc', '[\"*\"]', NULL, NULL, '2025-07-09 16:22:50', '2025-07-09 16:22:50'),
(21, 'App\\Models\\User', 18, 'apptoken', '212eab7d6ca86a451fc532805423799aef39826518beee9b50a83aaf154fcd4d', '[\"*\"]', NULL, NULL, '2025-07-09 16:23:21', '2025-07-09 16:23:21'),
(22, 'App\\Models\\User', 18, 'apptoken', 'e895d6d1e5a221de60116c9025127e0640742b948779b6270b6b5c335bcfa8d5', '[\"*\"]', NULL, NULL, '2025-07-09 16:25:33', '2025-07-09 16:25:33'),
(23, 'App\\Models\\User', 18, 'apptoken', '5014877bc6ae9fa0d774fbcba4cc99e2a4cae015fa12a567fbf40f64d5e5d0d6', '[\"*\"]', NULL, NULL, '2025-07-09 16:26:37', '2025-07-09 16:26:37'),
(25, 'App\\Models\\User', 6, 'apptoken', '92b294e5f71ea950661e4cbe61e7949fef2aadb04d1bccd8425d7b92c527f017', '[\"*\"]', '2025-07-09 16:37:54', NULL, '2025-07-09 16:37:40', '2025-07-09 16:37:54'),
(27, 'App\\Models\\User', 6, 'apptoken', 'efaff0040bc5acca206c78ef78059800c8c76b8e544fc1a2963fbd77a5ec8e93', '[\"*\"]', '2025-07-09 17:16:11', NULL, '2025-07-09 16:46:42', '2025-07-09 17:16:11'),
(29, 'App\\Models\\User', 6, 'apptoken', '470ac93dd40dc59d8fb36a21816b08d01f46f4f4da99a3c591f8e1452727a77b', '[\"*\"]', '2025-07-09 19:34:34', NULL, '2025-07-09 19:26:04', '2025-07-09 19:34:34'),
(31, 'App\\Models\\User', 6, 'apptoken', 'ebf0809a57c31d6d967447cee849deb53bb438b3f335d99d6504d5a8d3f64b90', '[\"*\"]', '2025-07-09 19:59:16', NULL, '2025-07-09 19:42:59', '2025-07-09 19:59:16'),
(33, 'App\\Models\\User', 6, 'apptoken', '406806e643e293cc714daefcc2235236d8f946137f9269e2ff47aee0e078bce1', '[\"*\"]', '2025-07-09 20:08:34', NULL, '2025-07-09 20:03:12', '2025-07-09 20:08:34'),
(35, 'App\\Models\\User', 6, 'apptoken', '93cc79b892a85ba7d260490105a60e64b771a115469deb02a053ee2f800174ab', '[\"*\"]', '2025-07-09 20:42:00', NULL, '2025-07-09 20:35:21', '2025-07-09 20:42:00'),
(37, 'App\\Models\\User', 6, 'apptoken', '9f2f20560afb027bd3247141e11a80a4c87d94e3ad9d26a1f9341d0b229af25f', '[\"*\"]', '2025-07-09 20:49:21', NULL, '2025-07-09 20:49:20', '2025-07-09 20:49:21'),
(39, 'App\\Models\\User', 6, 'apptoken', '38e77d43d3fc5b18b9c97756e17178ace6c91c4cd792fc97f57075bf11278ffc', '[\"*\"]', '2025-07-09 21:12:31', NULL, '2025-07-09 20:56:01', '2025-07-09 21:12:31'),
(41, 'App\\Models\\User', 6, 'apptoken', '39197fa32534a409b67da26e840156ffc7fe39d860f3bd123ddc8d5e22e52790', '[\"*\"]', '2025-07-09 21:14:48', NULL, '2025-07-09 21:13:54', '2025-07-09 21:14:48'),
(44, 'App\\Models\\User', 6, 'apptoken', 'f3326c6141c13c6e0dc1924622dc606663da45ca748459ad0ec4b142d637dac1', '[\"*\"]', '2025-07-09 21:20:05', NULL, '2025-07-09 21:18:26', '2025-07-09 21:20:05'),
(46, 'App\\Models\\User', 6, 'apptoken', '03b2ef4487addfa7cc6fe7b0b6a4a796545d3f2d5a75da9df4f57344792c549c', '[\"*\"]', '2025-07-09 21:52:59', NULL, '2025-07-09 21:49:09', '2025-07-09 21:52:59'),
(48, 'App\\Models\\User', 6, 'apptoken', '1b55492ff5e080f73a18c939629d4ca7299dd515cc02e51be3d49fd9e998176d', '[\"*\"]', '2025-07-09 23:02:02', NULL, '2025-07-09 23:02:00', '2025-07-09 23:02:02'),
(50, 'App\\Models\\User', 6, 'apptoken', 'f1afa9d0a1426dee025d5091319a5c5255bae5518d8d94321e90a63d2a73bebc', '[\"*\"]', '2025-07-09 23:04:54', NULL, '2025-07-09 23:04:49', '2025-07-09 23:04:54'),
(52, 'App\\Models\\User', 6, 'apptoken', '5c0d084f93371959bead529931b8b5f358723b103ae5a6a9a8365c57237e6f37', '[\"*\"]', '2025-07-09 23:08:56', NULL, '2025-07-09 23:07:44', '2025-07-09 23:08:56'),
(54, 'App\\Models\\User', 6, 'apptoken', 'c9b3f198848465bca466d7533105c26cfb158c06594b6b6502a617fb3745b2af', '[\"*\"]', '2025-07-10 01:33:00', NULL, '2025-07-10 01:32:58', '2025-07-10 01:33:00'),
(58, 'App\\Models\\User', 6, 'apptoken', '138b05d810523836f458258238b1d989e93e10fa8caada7e66e0823696c71a07', '[\"*\"]', '2025-07-10 06:49:27', NULL, '2025-07-10 06:48:59', '2025-07-10 06:49:27'),
(61, 'App\\Models\\User', 6, 'apptoken', '80d94e87502d31033885b3f596532d4a5c4b9735a8d254d5d746dee87cd842b2', '[\"*\"]', '2025-07-10 07:56:44', NULL, '2025-07-10 07:51:55', '2025-07-10 07:56:44'),
(63, 'App\\Models\\User', 6, 'apptoken', '0a4227ea4c903a2ba72fce5e6773c9af4644cb31901b3852b4da7b21fd6ba13d', '[\"*\"]', '2025-07-10 08:21:29', NULL, '2025-07-10 08:18:09', '2025-07-10 08:21:29'),
(65, 'App\\Models\\User', 6, 'apptoken', '12182eb8416cd01f0ffcbade969b5fa1da67d073ce35cea77b32d709612b4c2c', '[\"*\"]', '2025-07-10 08:40:41', NULL, '2025-07-10 08:31:59', '2025-07-10 08:40:41'),
(68, 'App\\Models\\User', 22, 'apptoken', 'b765c27be009a051ed0fd9d619d357e1ab109493e9e716badda425489e60290c', '[\"*\"]', '2025-07-10 09:10:40', NULL, '2025-07-10 09:09:17', '2025-07-10 09:10:40'),
(74, 'App\\Models\\User', 6, 'apptoken', '8366ef826de86f4d5f0ab5ad6c30b717ab8e95883294a05462e9a8ba2093e7f5', '[\"*\"]', '2025-07-10 10:30:26', NULL, '2025-07-10 10:30:18', '2025-07-10 10:30:26'),
(76, 'App\\Models\\User', 6, 'apptoken', '3f3856673fe007fe2c0fca35549af74dd2792ffed1d4b65ce5a8465122967c4e', '[\"*\"]', '2025-07-10 10:36:04', NULL, '2025-07-10 10:36:02', '2025-07-10 10:36:04'),
(80, 'App\\Models\\User', 23, 'apptoken', 'd47cbefda2b2746f36ea531d3b570a2bb07be7f4f02d2f1a746dd86e7076155e', '[\"*\"]', '2025-07-10 15:40:08', NULL, '2025-07-10 15:38:19', '2025-07-10 15:40:08'),
(82, 'App\\Models\\User', 6, 'apptoken', '67df01e8567226d1da0a53b93f0aca25e437b9a0dbb3c74ab758a0eee2d19a85', '[\"*\"]', '2025-07-10 16:22:30', NULL, '2025-07-10 15:56:52', '2025-07-10 16:22:30'),
(94, 'App\\Models\\User', 18, 'apptoken', '23ce41bca5ea327d0b2caa6edb340d882c0fa0fa2bfd075fbdad74b20022d703', '[\"*\"]', '2025-07-10 19:44:14', NULL, '2025-07-10 19:04:04', '2025-07-10 19:44:14');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_name` enum('admin','director','manager','employee') NOT NULL,
  `level` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`, `level`, `description`, `created_at`, `updated_at`) VALUES
(1, 'admin', 2, 'I want to make the admin.', '2025-07-03 06:24:04', '2025-07-03 06:24:04'),
(2, 'director', 2, 'I want to make the director.', '2025-07-03 06:24:25', '2025-07-03 06:24:25'),
(3, 'manager', 2, 'I want to make the manager.', '2025-07-03 06:24:38', '2025-07-03 06:24:38'),
(4, 'employee', 2, 'I want to make the employee.', '2025-07-03 06:24:50', '2025-07-03 06:24:50');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `department_id` bigint(20) UNSIGNED DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `image`, `role_id`, `department_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(2, 'Kin Doung', 'kin.doung@gmail.com', '$2y$12$OqclaeQbpEbSL70.dqoURuz9fMUskH8XBEZwltgSSZr80xk7.k21i', 'users/Ho14VGEPzuKu6p0WXdi4qbTqUztDEzJmYRfCIWaQ.png', 2, 1, NULL, '2025-07-03 06:48:06', '2025-07-10 09:56:00'),
(6, 'Liya An', 'liya.an@gmail.com', '$2y$12$01NYcr7CRg.d0lyjWqBj2eP4OjwSu10SKZKXTZd.oKVjNQEZ5/Nb6', 'users/soGfJAKROnynRPuRKPyRAX5k1cKOf1LsYtYNqwBQ.jpg', 4, 5, NULL, '2025-07-04 03:06:22', '2025-07-09 05:10:17'),
(7, 'Sophea Dev', 'sophean.dev@gmail.com', '$2y$12$wznqvH6fYp8hOM2RSUU/fea.5tBu0eZrd40FtppnSPV58yWuPGuOi', 'users/RJzMuWojGlyteIo2T7UV3rQWId2Mii0ndWkbeWgq.jpg', 3, 9, NULL, '2025-07-04 04:03:05', '2025-07-10 09:04:21'),
(18, 'Chhea Chhouy', 'chhea.chhouy@student.passerellesnumeriques.org', '$2y$12$LMNOGQdsv4oj1kteGCxx1eqj2rfgxXsw3akYcMoxXJ4tDzvl7aAu.', 'users/f2tp4GMrkyLgFGPhnIuA5cHtnBMOJzg3v6i4e0Kd.jpg', 1, 1, NULL, '2025-07-08 21:12:24', '2025-07-09 23:09:29'),
(22, 'Darin Hoy', 'darin.hoy@gmail.com', '$2y$12$hprLhC.q4HXx00GChJaEA.i5HcAGsFpr7ZVBaXwfUAr9ssf/QoU9G', 'users/fn71EUsL1oEvWuVbloAR5nkUtVIBIIOrpvUozM39.jpg', 4, 2, NULL, '2025-07-10 09:08:49', '2025-07-10 09:08:49'),
(23, 'Charyna Chab', 'charyna.chab@gmail.com', '$2y$12$ytBN5m1Z7sw2zOQEnv/fJOTdeTr341.r3Qa.FelBOw1.osDHe0rC2', 'users/XQksEWqhofTjCq2Nmc0ujag74CA95rS7lvAxLm3h.png', 4, 2, NULL, '2025-07-10 15:36:56', '2025-07-10 15:36:56');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `departments_head_user_id_foreign` (`head_user_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Indexes for table `permission_access`
--
ALTER TABLE `permission_access`
  ADD PRIMARY KEY (`id`),
  ADD KEY `permission_access_role_id_foreign` (`role_id`),
  ADD KEY `permission_access_permission_type_id_foreign` (`permission_type_id`);

--
-- Indexes for table `permission_approvals`
--
ALTER TABLE `permission_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `permission_approvals_permission_request_id_foreign` (`permission_request_id`),
  ADD KEY `permission_approvals_approved_by_foreign` (`approved_by`);

--
-- Indexes for table `permission_requests`
--
ALTER TABLE `permission_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `permission_requests_user_id_foreign` (`user_id`),
  ADD KEY `permission_requests_permission_type_id_foreign` (`permission_type_id`);

--
-- Indexes for table `permission_types`
--
ALTER TABLE `permission_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_department_id_foreign` (`department_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `permission_access`
--
ALTER TABLE `permission_access`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `permission_approvals`
--
ALTER TABLE `permission_approvals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `permission_requests`
--
ALTER TABLE `permission_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `permission_types`
--
ALTER TABLE `permission_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_head_user_id_foreign` FOREIGN KEY (`head_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `permission_access`
--
ALTER TABLE `permission_access`
  ADD CONSTRAINT `permission_access_permission_type_id_foreign` FOREIGN KEY (`permission_type_id`) REFERENCES `permission_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_access_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `permission_approvals`
--
ALTER TABLE `permission_approvals`
  ADD CONSTRAINT `permission_approvals_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_approvals_permission_request_id_foreign` FOREIGN KEY (`permission_request_id`) REFERENCES `permission_requests` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `permission_requests`
--
ALTER TABLE `permission_requests`
  ADD CONSTRAINT `permission_requests_permission_type_id_foreign` FOREIGN KEY (`permission_type_id`) REFERENCES `permission_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `permission_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
