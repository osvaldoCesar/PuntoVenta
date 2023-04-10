-- --------------------------------------------------------
-- Host:                         localhost
-- Versión del servidor:         5.7.24 - MySQL Community Server (GPL)
-- SO del servidor:              Win64
-- HeidiSQL Versión:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para punto_venta
DROP DATABASE IF EXISTS `punto_venta`;
CREATE DATABASE IF NOT EXISTS `punto_venta` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `punto_venta`;

-- Volcando estructura para tabla punto_venta.categories
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_created_by_index` (`created_by`),
  KEY `categories_updated_by_index` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.categories: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` (`id`, `name`, `description`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
	(1, 'Servicio', 'Prueba', 1, 1, '2023-02-11 15:29:49', '2023-02-12 23:29:15');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.doctors
DROP TABLE IF EXISTS `doctors`;
CREATE TABLE IF NOT EXISTS `doctors` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dni` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rfc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `doctors_lastname_index` (`lastname`),
  KEY `doctors_rfc_index` (`rfc`),
  KEY `doctors_email_index` (`email`),
  KEY `doctors_created_by_index` (`created_by`),
  KEY `doctors_updated_by_index` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.doctors: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` (`id`, `dni`, `name`, `lastname`, `rfc`, `phone`, `email`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
	(1, 'D00001', 'Doctor cliente prueba', 'prue', '09090909', '1111111111', '', 1, 1, '2023-02-10 21:55:06', '2023-02-12 23:26:02'),
	(2, 'D00002', 'Doctor cliente OSVALDO', 'CESAR', 'CEGO9405', '2227246843', 'os@gmail.com', 1, 1, '2023-02-13 20:56:33', '2023-02-16 22:28:21');
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.patients que hace referencia a los pacientes del cliente al cual se le hace el trabajo
DROP TABLE IF EXISTS `patients`;
CREATE TABLE IF NOT EXISTS `patients` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dni` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `doctor_id` bigint(20) unsigned NOT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `patients_lastname_index` (`lastname`),
  KEY `patients_document_index` (`document`),
  KEY `patients_email_index` (`email`),
  KEY `patients_created_by_index` (`created_by`),
  KEY `patients_updated_by_index` (`updated_by`),
  KEY `orders_doctor_id_foreign` (`doctor_id`),
  CONSTRAINT `orders_doctor_id_foreign` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.patients: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` (`id`, `dni`,`name`, `lastname`, `document`, `phone`, `email`, `doctor_id`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
	(1, 'P00001','Paciente prueba', 'prue', '09090909', '1111111111', '', 1, 1, 1, '2023-02-10 21:55:06', '2023-02-12 23:26:02'),
	(2, 'P00002','Paciente OSVALDO', 'CESAR', 'CEGO9405', '2227246843', 'os@gmail.com', 1, 1, 1, '2023-02-13 20:56:33', '2023-02-16 22:28:21');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.details_orders
DROP TABLE IF EXISTS `details_orders`;
CREATE TABLE IF NOT EXISTS `details_orders` (
  `order_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `quantity` smallint(6) DEFAULT '12',
  `price` double DEFAULT '12',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  KEY `details_orders_order_id_foreign` (`order_id`),
  KEY `details_orders_product_id_foreign` (`product_id`),
  CONSTRAINT `details_orders_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `details_orders_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.details_orders: ~5 rows (aproximadamente)
/*!40000 ALTER TABLE `details_orders` DISABLE KEYS */;
INSERT INTO `details_orders` (`order_id`, `product_id`, `quantity`, `price`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, 15, NULL, NULL),
	(2, 1, 1, 15, NULL, NULL),
	(3, 1, 1, 15, NULL, NULL),
	(4, 1, 1, 15, NULL, NULL),
	(5, 1, 1, 15, NULL, NULL),
	(6, 1, 1, 15, NULL, NULL);
/*!40000 ALTER TABLE `details_orders` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.technicals
DROP TABLE IF EXISTS `technicals`;
CREATE TABLE IF NOT EXISTS `technicals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dni` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rfc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `technicals_lastname_index` (`lastname`),
  KEY `technicals_rfc_index` (`rfc`),
  KEY `technicals_email_index` (`email`),
  KEY `technicals_created_by_index` (`created_by`),
  KEY `technicals_updated_by_index` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.technicals: ~3 rows (aproximadamente)
/*!40000 ALTER TABLE `technicals` DISABLE KEYS */;
INSERT INTO `technicals` (`id`, `dni`, `name`, `lastname`, `rfc`, `phone`, `email`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
	(1, 'T00001', 'Técnico Yahir', 'Piña', 'PIRY1212', '1111111111', 'yahir@gmail.com', 21, 21, '2020-05-28 01:00:01', '2020-05-28 01:00:01'),
	(2, 'T00002', 'Técnico Gaby', 'López', 'GABY1212', '2222222222', 'gaby@gmail.com', 29, 1, '2022-11-19 02:28:14', '2023-02-11 01:24:41'),
	(3, 'T00003', 'Técnico osvaldo', 'cesar', 'CEGO9405', '1212121212', '', 1, 1, '2023-02-11 01:42:35', '2023-02-12 23:27:26');
/*!40000 ALTER TABLE `technicals` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.files
DROP TABLE IF EXISTS `files`;
CREATE TABLE IF NOT EXISTS `files` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `files_created_by_index` (`created_by`),
  KEY `files_updated_by_index` (`updated_by`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.files: ~25 rows (aproximadamente)
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
INSERT INTO `files` (`id`, `path`, `filename`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
	(1, 'http://punto_venta.test/storage/users/uiSlFySZVu_logo.png', 'logo.png', 1, 1, '2020-05-04 17:03:35', '2020-05-04 17:03:35'),
	(2, 'http://punto_venta.test/storage/users/R7lCrnCd6B_logo.png', 'logo.png', 1, 1, '2020-05-04 17:04:02', '2020-05-04 17:04:02'),
	(3, 'http://punto_venta.test/storage/users/Cro5vbebyn_logo.png', 'logo.png', 1, 1, '2020-05-04 18:37:57', '2020-05-04 18:37:57'),
	(4, 'http://punto_venta.test/storage/users/k6xGflzQaB_logo.png', 'logo.png', 1, 1, '2020-05-04 18:38:32', '2020-05-04 18:38:32'),
	(5, 'http://punto_venta.test/storage/users/P8ihl6r0DU_logo.png', 'logo.png', 1, 1, '2020-05-04 18:40:53', '2020-05-04 18:40:53'),
	(6, 'http://punto_venta.test/storage/users/FLAUCpx1fB_logo.png', 'logo.png', 1, 1, '2020-05-04 18:41:51', '2020-05-04 18:41:51'),
	(7, 'http://punto_venta.test/storage/users/Vd2wugMQoO_logo.png', 'logo.png', 1, 1, '2020-05-04 18:52:52', '2020-05-04 18:52:52'),
	(8, 'http://punto_venta.test/storage/users/aI8koIP8n8_image.png', 'image.png', 1, 1, '2020-05-07 19:53:08', '2020-05-07 19:53:08'),
	(9, 'http://punto_venta.test/storage/users/24ECyAiOfz_image.png', 'image.png', 1, 1, '2020-05-14 21:24:17', '2020-05-14 21:24:17'),
	(10, 'http://punto_venta.test/storage/users/fAeFPRZUBT_image.png', 'image.png', 1, 1, '2020-05-15 19:39:40', '2020-05-15 19:39:40'),
	(11, 'http://punto_venta.test/storage/users/jgOwoT21SL_image.png', 'image.png', 1, 1, '2020-05-15 20:27:26', '2020-05-15 20:27:26'),
	(12, 'http://punto_venta.test/storage/users/9fTJddBfRm_image.png', 'image.png', 1, 1, '2020-05-15 20:32:40', '2020-05-15 20:32:40'),
	(13, 'http://punto_venta.test/storage/users/VIyFwcZRZx_image.png', 'image.png', 1, 1, '2020-05-16 11:52:30', '2020-05-16 11:52:30'),
	(14, 'http://punto_venta.test/storage/users/tHhC1DAnYw_image.png', 'image.png', 1, 1, '2020-05-16 11:56:42', '2020-05-16 11:56:42'),
	(15, 'http://punto_venta.test/storage/users/KuI2Q3qEZA_image.png', 'image.png', 1, 1, '2020-05-16 12:05:32', '2020-05-16 12:05:32'),
	(16, 'http://punto_venta.test/storage/users/Z14rchytUJ_image.png', 'image.png', 1, 1, '2020-05-16 12:11:21', '2020-05-16 12:11:21'),
	(17, 'http://punto_venta.test/storage/users/ZOrHmkDEMC_image.png', 'image.png', 1, 1, '2020-05-20 21:14:36', '2020-05-20 21:14:36'),
	(18, 'http://punto_venta.test/storage/users/ifZHSqvea3_image.png', 'image.png', 1, 1, '2020-05-20 21:26:46', '2020-05-20 21:26:46'),
	(19, 'http://punto_venta.test/storage/users/kPrsdPeHq8_image.png', 'image.png', 1, 1, '2020-05-20 21:29:01', '2020-05-20 21:29:01'),
	(20, 'http://punto_venta.test/storage/users/qBT0ZLwidj_image.png', 'image.png', 1, 1, '2020-05-20 21:30:04', '2020-05-20 21:30:04'),
	(21, 'http://punto_venta.com/storage/users/ZPzFxhD2TW_heroe final.jpg', 'heroe final.jpg', 21, 21, '2020-07-09 13:21:01', '2020-07-09 13:21:01'),
	(22, 'http://punto_venta.com/storage/users/24wKZY5Z77_heroe final.jpg', 'heroe final.jpg', 21, 21, '2020-07-09 13:34:01', '2020-07-09 13:34:01'),
	(23, 'http://punto_venta.com/storage/users/lqRd3PC4HY_image.png', 'image.png', 21, 21, '2020-07-20 17:21:47', '2020-07-20 17:21:47'),
	(24, 'http://punto_venta.com/storage/users/zjTea7w5Fr_image.png', 'image.png', 21, 21, '2020-07-20 17:25:16', '2020-07-20 17:25:16'),
	(25, 'http://punto_venta.com/storage/users/wcDuRxbymz_image.png', 'image.png', 21, 21, '2020-07-20 17:39:18', '2020-07-20 17:39:18');
/*!40000 ALTER TABLE `files` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.messages
DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from` int(10) unsigned NOT NULL,
  `to` int(10) unsigned NOT NULL,
  `read` tinyint(1) NOT NULL DEFAULT '0',
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.messages: ~40 rows (aproximadamente)
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` (`id`, `from`, `to`, `read`, `text`, `created_at`, `updated_at`) VALUES
	(1, 21, 24, 1, 'Hola', '2020-06-04 15:29:07', '2020-06-05 16:31:27'),
	(2, 21, 24, 1, 'Como estas?', '2020-06-04 15:29:11', '2020-06-05 16:31:27'),
	(3, 24, 21, 1, 'Bien y tu?', '2020-06-04 15:29:12', '2020-06-08 20:12:17'),
	(4, 21, 24, 1, 'Hola', '2020-06-04 17:29:05', '2020-06-05 16:31:27'),
	(5, 21, 24, 1, 'Como estas?', '2020-06-04 17:37:13', '2020-06-05 16:31:27'),
	(6, 21, 24, 1, 'Todo bien?', '2020-06-04 17:37:18', '2020-06-05 16:31:27'),
	(64, 21, 24, 1, 'Hola', '2020-06-04 23:11:33', '2020-06-05 16:31:27'),
	(65, 21, 24, 1, 'Mensaje de Prueba', '2020-06-04 23:13:11', '2020-06-05 16:31:27'),
	(66, 24, 21, 1, 'Respuesta de Prueba', '2020-06-04 23:13:29', '2020-06-08 20:12:17'),
	(67, 21, 24, 1, 'Hola', '2020-06-05 00:11:11', '2020-06-05 16:31:27'),
	(68, 24, 21, 1, 'Como estas?', '2020-06-05 00:11:16', '2020-06-08 20:12:17'),
	(69, 24, 20, 0, 'Hola?', '2020-06-05 00:15:19', '2020-06-05 00:15:19'),
	(70, 24, 22, 0, 'Hola', '2020-06-05 00:15:42', '2020-06-05 00:15:42'),
	(71, 24, 21, 1, 'Hola', '2020-06-05 00:18:27', '2020-06-08 20:12:17'),
	(72, 24, 21, 1, 'Hola mundo', '2020-06-05 00:34:27', '2020-06-08 20:12:17'),
	(73, 24, 21, 1, 'Hola de prueba', '2020-06-05 00:34:57', '2020-06-08 20:12:17'),
	(74, 24, 21, 1, 'Hola de prueba 2', '2020-06-05 00:35:10', '2020-06-08 20:12:17'),
	(75, 24, 21, 1, 'Hola Juan', '2020-06-05 11:26:17', '2020-06-08 20:12:17'),
	(76, 24, 21, 1, 'Hola Anton', '2020-06-05 11:27:14', '2020-06-08 20:12:17'),
	(77, 24, 21, 1, 'Otro mensaje de Prueba', '2020-06-05 11:55:50', '2020-06-08 20:12:17'),
	(78, 24, 21, 1, 'Hola', '2020-06-05 13:48:05', '2020-06-08 20:12:17'),
	(79, 24, 21, 1, 'EScribiendo', '2020-06-05 13:54:16', '2020-06-08 20:12:17'),
	(80, 24, 21, 1, 'Hola', '2020-06-05 15:26:31', '2020-06-08 20:12:17'),
	(81, 24, 21, 1, 'Prueba', '2020-06-05 15:26:45', '2020-06-08 20:12:17'),
	(82, 24, 21, 1, 'Hola', '2020-06-05 16:08:02', '2020-06-08 20:12:17'),
	(97, 21, 1, 0, 'Hola', '2020-06-05 22:30:24', '2020-06-05 22:30:24'),
	(98, 25, 21, 1, 'Hola', '2020-06-05 22:56:07', '2020-08-14 16:48:34'),
	(99, 25, 21, 1, 'Hola como estas', '2020-06-05 22:56:29', '2020-08-14 16:48:34'),
	(100, 25, 21, 1, 'Prueba', '2020-06-05 22:56:45', '2020-08-14 16:48:34'),
	(101, 25, 21, 1, 'Prueba 3', '2020-06-05 22:56:54', '2020-08-14 16:48:34'),
	(102, 25, 21, 1, 'Prueba 4', '2020-06-05 22:56:58', '2020-08-14 16:48:34'),
	(103, 21, 25, 1, 'Respuesta', '2020-06-05 22:57:13', '2020-07-18 20:09:45'),
	(104, 25, 21, 1, 'Prueba', '2020-06-05 22:57:46', '2020-08-14 16:48:34'),
	(105, 25, 21, 1, 'Bueno podemos agregar otra validaciòn, que pasa si escribimos un mensaje con varios caracteres, como estamos escribiendo ahora', '2020-06-05 23:06:12', '2020-08-14 16:48:34'),
	(106, 25, 21, 1, 'Mensaje de Prueba', '2020-06-06 22:51:03', '2020-08-14 16:48:34'),
	(107, 25, 21, 1, 'Mensaje de Prueba', '2020-06-06 22:51:21', '2020-08-14 16:48:34'),
	(108, 25, 21, 1, 'HOla pieritos', '2020-06-08 03:10:12', '2020-08-14 16:48:34'),
	(109, 21, 25, 1, 'que paso', '2020-06-08 03:10:29', '2020-07-18 20:09:45'),
	(110, 21, 1, 0, 'adasd', '2020-07-18 19:31:48', '2020-07-18 19:31:48'),
	(120, 21, 25, 0, 'Mensaje de Prueba con Emoji 😀', '2020-08-14 16:39:18', '2020-08-14 16:39:18');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.migrations: ~14 rows (aproximadamente)
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '2014_04_25_204732_create_files_table', 1),
	(2, '2014_10_12_000000_create_users_table', 1),
	(3, '2014_10_12_100000_create_password_resets_table', 1),
	(4, '2020_04_25_205358_create_permissions_table', 1),
	(5, '2020_04_25_205514_create_roles_table', 1),
	(6, '2020_04_25_205543_create_users_permissions_table', 1),
	(7, '2020_04_25_205727_create_users_roles_table', 1),
	(8, '2020_04_25_205815_create_roles_permissions_table', 1),
	(9, '2020_04_25_205935_create_messages_table', 1),
	(10, '2020_04_25_210043_create_categories_table', 1),
	(11, '2020_04_25_210147_create_products_table', 1),
	(12, '2020_04_25_210503_create_customers_table', 1),
	(13, '2020_04_25_210710_create_orders_table', 1),
	(14, '2020_04_25_211021_create_details_orders_table', 1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.orders
DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `patient_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `technical_id` bigint(20) unsigned NOT NULL,
  `total` double(8,2) NOT NULL DEFAULT '0.00',
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `state` enum('A','I','L') COLLATE utf8mb4_unicode_ci DEFAULT 'A',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fecha_cita` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orders_patient_id_foreign` (`patient_id`),
  KEY `orders_user_id_foreign` (`user_id`),
  KEY `orders_created_by_index` (`created_by`),
  KEY `orders_updated_by_index` (`updated_by`),
  KEY `orders_technical_id_foreign` (`technical_id`),
  CONSTRAINT `orders_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`),
  CONSTRAINT `orders_technical_id_foreign` FOREIGN KEY (`technical_id`) REFERENCES `technicals` (`id`),
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.orders: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` (`id`, `order_number`, `comments`, `patient_id`, `user_id`, `technical_id`, `total`, `created_by`, `updated_by`, `state`, `created_at`, `updated_at`, `fecha_cita`) VALUES
	(1, '20232111', 'Prueba', 1, 1, 1, 15.00, 1, 1, 'A', '2023-02-11 15:30:33', '2023-02-11 15:30:33', NULL),
	(2, '20232132', '', 1, 1, 3, 15.00, 1, 1, 'A', '2023-02-13 01:16:02', '2023-02-13 01:16:02', NULL),
	(3, '20232133', '', 1, 1, 3, 15.00, 1, 1, 'A', '2023-02-13 01:44:31', '2023-02-13 01:44:31', NULL),
	(4, '20232134', '', 2, 1, 1, 15.00, 1, 1, 'L', '2023-02-13 20:56:34', '2023-02-13 22:25:58', NULL),
	(5, '20232135', '', 2, 1, 3, 15.00, 1, 1, 'L', '2023-02-13 23:50:07', '2023-02-15 22:23:20', '2023-02-13 23:50:02'),
	(6, '20232146', '', 2, 1, 2, 15.00, 1, 1, 'L', '2023-02-14 00:25:49', '2023-02-14 00:25:49', '2023-02-14 00:25:46');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.payments
DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comments` text,
  `credit` double(8,2) DEFAULT '0.00',
  `order_id` bigint(20) unsigned NOT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_order_id_foreign` (`order_id`),
  KEY `payments_user_id_foreign` (`created_by`),
  CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;

-- Volcando datos para la tabla punto_venta.payments: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` (`id`, `comments`, `credit`, `order_id`, `created_by`, `created_at`) VALUES
	(14, '', 15.00, 6, 1, '2023-02-18 00:26:17'),
	(15, '', 15.00, 5, 1, '2023-02-18 00:27:01'),
	(16, '', 1.00, 4, 1, '2023-02-18 11:40:36'),
	(17, '', 14.00, 4, 1, '2023-02-18 11:40:45');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.permissions
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.permissions: ~31 rows (aproximadamente)
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` (`id`, `slug`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'usuario.index', 'Navegar Usuarios', '2020-05-11 16:57:10', '2020-05-11 16:57:10'),
	(2, 'usuario.crear', 'Crear Usuario', '2020-05-11 16:57:10', '2020-05-16 20:17:10'),
	(3, 'usuario.editar', 'Editar Usuario', '2020-05-11 16:57:10', '2020-05-16 20:17:19'),
	(4, 'usuario.ver', 'Ver Usuario', '2020-05-11 16:57:10', '2020-05-16 20:17:31'),
	(5, 'usuario.activar', 'Activar Usuario', '2020-05-11 16:57:10', '2023-02-13 00:29:00'),
	(6, 'usuario.desactivar', 'Desactivar Usuario', '2020-05-11 16:57:10', '2020-05-16 20:18:08'),
	(7, 'rol.index', 'Navegar Roles', '2020-05-11 16:57:10', '2020-05-11 16:57:10'),
	(8, 'permiso.crear', 'Crear Permiso', '2020-05-14 13:08:05', '2020-05-16 20:17:50'),
	(9, 'usuario.permiso', 'Permiso Usuario', '2020-05-15 12:22:59', '2020-05-15 12:22:59'),
	(10, 'rol.crear', 'Crear Rol', '2020-05-15 12:24:39', '2020-05-15 12:24:39'),
	(11, 'rol.editar', 'Editar Rol', '2020-05-15 12:25:00', '2020-05-15 12:25:00'),
	(12, 'rol.ver', 'Ver Rol', '2020-05-16 20:11:48', '2020-05-16 20:12:05'),
	(13, 'permiso.index', 'Navegar Permiso', '2020-05-16 20:13:19', '2020-05-16 20:13:19'),
	(14, 'permiso.editar', 'Editar Permiso', '2020-05-16 20:13:34', '2020-05-16 20:13:34'),
	(15, 'dashboard.index', 'Navegar Dashboard', '2020-05-16 20:15:04', '2020-05-16 20:15:04'),
	(16, 'pedido.index', 'Navegar Pedidos', '2020-05-16 20:15:31', '2020-05-16 20:19:29'),
	(17, 'categoria.index', 'Navegar Categorias', '2020-05-16 20:16:16', '2020-05-16 20:19:07'),
	(18, 'producto.index', 'Navegar Productos', '2020-05-16 20:16:26', '2020-05-16 20:18:59'),
	(19, 'reporte.pedido.index', 'Navegar Reporte Pedido', '2020-05-16 20:20:19', '2020-05-16 20:20:19'),
	(20, 'categoria.crear', 'Crear Categoria', '2020-05-22 17:31:16', '2020-05-22 17:31:16'),
	(21, 'categoria.editar', 'Editar Categoria', '2020-05-22 17:57:29', '2020-05-22 17:57:29'),
	(22, 'producto.crear', 'Crear Producto', '2020-05-23 22:39:54', '2020-05-23 22:39:54'),
	(23, 'producto.editar', 'Editar Producto', '2020-05-23 22:40:02', '2020-05-23 22:40:02'),
	(24, 'pedido.crear', 'Crear Pedido', '2020-05-25 20:32:47', '2020-05-25 20:32:47'),
	(25, 'pedido.ver', 'Ver Pedido', '2020-05-25 20:33:51', '2020-05-25 20:33:51'),
	(26, 'pedido.rechazar', 'Rechazar Pedido', '2020-05-25 20:34:09', '2020-05-25 20:34:09'),
	(27, 'productos.mas.vendidos', 'Productos mas vendidos', '2020-06-02 01:12:42', '2020-06-02 01:30:19'),
	(28, 'ventas.por.dia', 'Ventas por dia', '2020-06-02 01:13:16', '2020-06-02 01:30:11'),
	(29, 'tecnico.index', 'Navegar Técnicos', '2023-02-09 23:10:37', '2023-02-09 23:10:37'),
	(30, 'tecnico.editar', 'Editar Técnico', '2023-02-10 21:44:13', '2023-02-10 21:44:13'),
	(31, 'tecnico.crear', 'Crear Técnico', '2023-02-10 21:44:21', '2023-02-10 21:44:21'),
	(32, 'doctor.index', 'Navegar Doctores', '2023-02-09 23:10:37', '2023-02-09 23:10:37'),
	(33, 'doctor.editar', 'Editar Doctor', '2023-02-10 21:44:13', '2023-02-10 21:44:13'),
	(34, 'doctor.crear', 'Crear Doctor', '2023-02-10 21:44:21', '2023-02-10 21:44:21'),
	(35, 'pedido.abonar', 'Abonar Pedido', '2023-02-15 23:08:31', '2023-02-15 23:09:45'),
	(36, 'paciente.ver', 'Ver Pacientes', '2023-02-15 23:08:31', '2023-02-15 23:09:45'),
	(37, 'paciente.crear', 'Crear Pacientes', '2023-02-15 23:08:31', '2023-02-15 23:09:45');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.products
DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `stock` smallint(6) NOT NULL DEFAULT '1',
  `state` enum('Y','N') COLLATE utf8mb4_unicode_ci DEFAULT 'Y',
  `price` double(4,2) NOT NULL DEFAULT '10.50',
  `categorie_id` bigint(20) unsigned DEFAULT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `products_categorie_id_foreign` (`categorie_id`),
  KEY `products_created_by_index` (`created_by`),
  KEY `products_updated_by_index` (`updated_by`),
  CONSTRAINT `products_categorie_id_foreign` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.products: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` (`id`, `name`, `description`, `stock`, `price`, `categorie_id`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
	(1, 'Servicio 2', '', 4, 15.00, 1, 1, 1, '2023-02-11 15:30:15', '2023-02-13 00:25:57');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.roles
DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.roles: ~2 rows (aproximadamente)
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` (`id`, `slug`, `name`, `created_at`, `updated_at`) VALUES
	(2, 'rol.administrador', 'Administrador', '2020-05-11 15:45:15', '2023-02-15 23:10:45'),
	(3, 'vendedor', 'Vendedor', '2020-06-01 19:23:31', '2023-02-13 00:29:45');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.roles_permissions
DROP TABLE IF EXISTS `roles_permissions`;
CREATE TABLE IF NOT EXISTS `roles_permissions` (
  `role_id` bigint(20) unsigned NOT NULL,
  `permission_id` bigint(20) unsigned NOT NULL,
  KEY `roles_permissions_role_id_foreign` (`role_id`),
  KEY `roles_permissions_permission_id_foreign` (`permission_id`),
  CONSTRAINT `roles_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `roles_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.roles_permissions: ~43 rows (aproximadamente)
/*!40000 ALTER TABLE `roles_permissions` DISABLE KEYS */;
INSERT INTO `roles_permissions` (`role_id`, `permission_id`) VALUES
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4),
	(2, 5),
	(2, 6),
	(2, 7),
	(2, 8),
	(2, 9),
	(2, 10),
	(2, 11),
	(2, 12),
	(2, 13),
	(2, 14),
	(2, 15),
	(2, 16),
	(2, 17),
	(2, 18),
	(2, 19),
	(2, 20),
	(2, 21),
	(2, 22),
	(2, 23),
	(2, 24),
	(2, 25),
	(2, 26),
	(2, 27),
	(2, 28),
	(2, 29),
	(2, 30),
	(2, 31),
	(2, 32),
	(2, 33),
	(2, 34),
	(2, 35),
	(2, 36),
	(2, 37);
/*!40000 ALTER TABLE `roles_permissions` ENABLE KEYS */;

-- Volcando estructura para procedimiento punto_venta.sp_Archivo_setRegistrarArchivo
DROP PROCEDURE IF EXISTS `sp_Archivo_setRegistrarArchivo`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Archivo_setRegistrarArchivo`(IN `cpath` VARCHAR(255), IN `cfilename` VARCHAR(50), IN `nidauthuser` INT)
BEGIN
	INSERT INTO files (path, filename, created_by, updated_by, created_at, updated_at)
				VALUES	(cpath, cfilename, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdFile := (SELECT	((IFNULL(MAX(image.id), 1)))
	FROM		files image);

	/*RETORNAMOS*/
	SELECT	@nIdFile	AS	nIdFile;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Categoria_getListarCategorias
DROP PROCEDURE IF EXISTS `sp_Categoria_getListarCategorias`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Categoria_getListarCategorias`(IN `nidcategoria` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT)
BEGIN
	SELECT	categoria.id,
				categoria.name,
				categoria.description
	FROM		categories categoria
	WHERE		CONCAT_WS(' ', categoria.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', categoria.description)	LIKE	CONCAT('%', cdescripcion, '%')
				AND	(categoria.id	=	nidcategoria	OR	nidcategoria	=	0)
	ORDER BY categoria.id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Categoria_setEditarCategoria
DROP PROCEDURE IF EXISTS `sp_Categoria_setEditarCategoria`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Categoria_setEditarCategoria`(IN `nidcategoria` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nidauthuser` INT)
BEGIN
	UPDATE	categories
	SET		name			=	cnombre,
				description	=	cdescripcion,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidcategoria;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Categoria_setRegistrarCategoria
DROP PROCEDURE IF EXISTS `sp_Categoria_setRegistrarCategoria`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Categoria_setRegistrarCategoria`(IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nidauthuser` INT)
BEGIN
	INSERT	INTO	categories	(name, description, created_by, updated_by, created_at, updated_at)
							VALUES	(cnombre, cdescripcion, nidauthuser, nidauthuser, NOW(), NOW());
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Chat_getListarContactos
DROP PROCEDURE IF EXISTS `sp_Chat_getListarContactos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Chat_getListarContactos`(IN `nidauthuser` INT)
BEGIN
	SELECT	usuario.id,
				CONCAT_WS(' ', usuario.firstname, usuario.lastname)	AS	fullname,
				IFNULL(imagen.path, '')	AS	profile_imagen,
				(
					SELECT	COUNT(mensaje.id)
					FROM		messages	mensaje
					WHERE		mensaje.`to`	=	nidauthuser
								AND	mensaje.`from`	=	usuario.id
								AND	mensaje.`read`	=	0
				)	AS	nNumeroMensajeNoLeidos,
				(
					SELECT	mensaje.text

					FROM		messages	mensaje
					WHERE		mensaje.`to`	=	nidauthuser
								AND	mensaje.`from`	=	usuario.id
								AND	mensaje.`read`	=	0
					ORDER	BY	mensaje.id	DESC
					LIMIT	1
				)	AS	cUltimoMensajeNoLeido
	FROM		users	usuario
				LEFT OUTER JOIN	files	imagen	ON	usuario.file_id	=	imagen.id
	WHERE		usuario.id	NOT	IN	(nidauthuser);
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Chat_getListarConversaciones
DROP PROCEDURE IF EXISTS `sp_Chat_getListarConversaciones`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Chat_getListarConversaciones`(IN `nidcontacto` INT, IN `nidauthuser` INT)
BEGIN
	UPDATE	messages
	SET		`read`			=	1,
				`updated_at`	=	NOW()
	WHERE		`from`			=	nidcontacto
				AND	`to`		=	nidauthuser;

	SELECT	mensaje.`*`,
				CONCAT_WS(' ', usu_from.firstname, usu_from.lastname)	AS	usu_from_fullname,
				IFNULL(usu_from_image.path, '')	AS	usu_from_profile_image,
				CONCAT_WS(' ', usu_to.firstname, usu_to.lastname)	AS	usu_to_fullname,
				IFNULL(usu_to_image.path, '')	AS	usu_to_profile_image

	FROM		messages	mensaje
				INNER	JOIN	users	usu_to					ON	mensaje.`to`		=	usu_to.id
				INNER	JOIN	users	usu_from					ON	mensaje.`from`		=	usu_from.id
				LEFT OUTER JOIN	files	usu_to_image	ON	usu_to.file_id		=	usu_to_image.id
				LEFT OUTER JOIN	files	usu_from_image	ON	usu_from.file_id	=	usu_from_image.id
	WHERE		(mensaje.`from`	=	nidauthuser		AND	mensaje.`to`	=	nidcontacto)
				OR	(mensaje.`from`	=	nidcontacto	AND	mensaje.`to`	=	nidauthuser);
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Chat_setRegistrarMensaje
DROP PROCEDURE IF EXISTS `sp_Chat_setRegistrarMensaje`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Chat_setRegistrarMensaje`(IN `from` INT, IN `to` INT, IN `text` VARCHAR(191))
BEGIN
	set names utf8mb4;

	INSERT	INTO	messages	(`from`, `to`, `text`, created_at, updated_at)
						VALUES	(`from`, `to`, text, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdMensaje := (SELECT	((IFNULL(MAX(mensaje.id), 1)))
	FROM		messages mensaje);

	SELECT	mensaje.`*`,
				CONCAT_WS(' ', usu_from.firstname, usu_from.lastname)	AS	usu_from_fullname,
				IFNULL(usu_from_image.path, '')	AS	usu_from_profile_image,
				CONCAT_WS(' ', usu_to.firstname, usu_to.lastname)	AS	usu_to_fullname,
				IFNULL(usu_to_image.path, '')	AS	usu_to_profile_image

	FROM		messages	mensaje
				INNER	JOIN	users	usu_to					ON	mensaje.`to`		=	usu_to.id
				INNER	JOIN	users	usu_from					ON	mensaje.`from`		=	usu_from.id
				LEFT OUTER JOIN	files	usu_to_image	ON	usu_to.file_id		=	usu_to_image.id
				LEFT OUTER JOIN	files	usu_from_image	ON	usu_from.file_id	=	usu_from_image.id
	WHERE		mensaje.id	=	@nIdMensaje;

	set names utf8mb4;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Doctor_getNuevoDniDoctor
DROP PROCEDURE IF EXISTS `sp_Doctor_getNuevoDniDoctor`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_getNuevoDniDoctor`(
)
BEGIN
	SET @nDniDoctor := (SELECT IF(ISNULL(id), 'D00001', CONCAT('D', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM doctors);

	/*RETORNAMOS*/
	SELECT	@nDniDoctor	AS	nDniDoctor;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Doctor_getListarDoctores
DROP PROCEDURE IF EXISTS `sp_Doctor_getListarDoctores`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_getListarDoctores`(
	IN `niddoctor` INT,
	IN `ddni` VARCHAR(50),
	IN `dnombre` VARCHAR(50),
	IN `drfc` VARCHAR(50)

)
BEGIN
	SELECT	doctor.id,
				doctor.dni,
				CONCAT_WS(' ', doctor.name, doctor.lastname)	AS	fullname,
				doctor.name,
				doctor.lastname,
				doctor.rfc,
				doctor.email,
				doctor.phone
	FROM		doctors	doctor
	WHERE		CONCAT_WS(' ', doctor.name, doctor.lastname)	LIKE	CONCAT('%', dnombre, '%')
				AND	doctor.dni	LIKE	CONCAT('%', ddni, '%')
				AND	doctor.rfc	LIKE	CONCAT('%', drfc, '%')
				AND	(doctor.id	=	niddoctor	OR	niddoctor = 0)
	ORDER	BY	doctor.id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Doctor_setEditarDoctor
DROP PROCEDURE IF EXISTS `sp_Doctor_setEditarDoctor`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_setEditarDoctor`(
	IN `niddoctor` INT,
	IN `drfc` VARCHAR(50),
	IN `dnombre` VARCHAR(50),
	IN `dapellido` VARCHAR(50),
	IN `demail` VARCHAR(50),
	IN `dtelefono` VARCHAR(50),
	IN `nidauthuser` INT

)
BEGIN
	UPDATE	doctors
	SET		rfc			=	drfc,
				name			=	dnombre,
				lastname		=	dapellido,
				email			=	demail,
				phone			=	dtelefono,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	niddoctor;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Doctor_setRegistrarDoctor
DROP PROCEDURE IF EXISTS `sp_Doctor_setRegistrarDoctor`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Doctor_setRegistrarDoctor`(
	IN `drfc` VARCHAR(50),
	IN `dnombre` VARCHAR(50),
	IN `dapellido` VARCHAR(50),
	IN `demail` VARCHAR(50),
	IN `dtelefono` VARCHAR(50),
	IN `nidauthuser` INT
)
BEGIN
	SET @nDniDoctor := (SELECT IF(ISNULL(id), 'D00001', CONCAT('D', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM doctors);
	INSERT	INTO	doctors	(dni, rfc, name, lastname, email, phone, created_by, updated_by, created_at, updated_at)
							VALUES	(@nDniDoctor, drfc, dnombre, dapellido, demail, dtelefono, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdDoctor := (SELECT	((IFNULL(MAX(doctor.id), 1)))
	FROM		doctors doctor);

	/*RETORNAMOS*/
	SELECT	@nIdDoctor	AS	nIdDoctor;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Paciente_getNuevoDniPaciente
DROP PROCEDURE IF EXISTS `sp_Paciente_getNuevoDniPaciente`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_getNuevoDniPaciente`(
)
BEGIN
	SET @nDniPaciente := (SELECT IF(ISNULL(id), 'P00001', CONCAT('P', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM patients);

	/*RETORNAMOS*/
	SELECT	@nDniPaciente	AS	nDniPaciente;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Paciente_getListarPacientes
DROP PROCEDURE IF EXISTS `sp_Paciente_getListarPacientes`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_getListarPacientes`(IN `nidpaciente` INT, IN `niddoctor` INT, IN `pnombre` VARCHAR(50), IN `pdni` VARCHAR(50))
BEGIN
	SELECT	paciente.id,
				paciente.dni,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	fullname,
				paciente.name,
				paciente.lastname,
				paciente.document,
				paciente.email,
				paciente.phone
	FROM		patients	paciente, doctors doctor
	WHERE		paciente.doctor_id  =   niddoctor
                AND paciente.doctor_id  =   doctor.id
                AND CONCAT_WS(' ', paciente.name, paciente.lastname)	LIKE	CONCAT('%', pnombre, '%')
				AND	paciente.dni	LIKE	CONCAT('%', pdni, '%')
				AND	(paciente.id	=	nidpaciente	OR	nidpaciente = 0)
	ORDER	BY	paciente.id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Paciente_setEditarPaciente
DROP PROCEDURE IF EXISTS `sp_Paciente_setEditarPaciente`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_setEditarPaciente`(IN `nidpaciente` INT, IN `cdocumento` VARCHAR(50), IN `cnombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cemail` VARCHAR(50), IN `ctelefono` VARCHAR(50), IN `nidauthuser` INT)
BEGIN
	UPDATE	patients
	SET		document		=	cdocumento,
				name			=	cnombre,
				lastname		=	capellido,
				email			=	cemail,
				phone			=	ctelefono,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidpaciente;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Paciente_setRegistrarPaciente
DROP PROCEDURE IF EXISTS `sp_Paciente_setRegistrarPaciente`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Paciente_setRegistrarPaciente`(IN `cdocumento` VARCHAR(50), IN `cnombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cemail` VARCHAR(50), IN `ctelefono` VARCHAR(50), IN `nidauthuser` INT)
BEGIN
	SET @nDniPaciente := (SELECT IF(ISNULL(id), 'P00001', CONCAT('P', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM patients);

	INSERT	INTO	patients	(document, name, lastname, email, phone, created_by, updated_by, created_at, updated_at)
							VALUES	(cdocumento, cnombre, capellido, cemail, ctelefono, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdPaciente := (SELECT	((IFNULL(MAX(paciente.id), 1)))
	FROM		patients paciente);

	/*RETORNAMOS*/
	SELECT	@nIdPaciente	AS	nIdPaciente;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Dashboard_getProductosMasVendidos
DROP PROCEDURE IF EXISTS `sp_Dashboard_getProductosMasVendidos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Dashboard_getProductosMasVendidos`()
BEGIN
	SELECT	producto.id,
				producto.name,
				(
					SELECT	SUM(detalle.quantity)
					FROM		details_orders	detalle
					WHERE		detalle.product_id	=	producto.id
				)	AS	cantidad
	FROM		products	producto
	ORDER	BY	cantidad DESC
	LIMIT	5;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Dashboard_getVentasPorDia
DROP PROCEDURE IF EXISTS `sp_Dashboard_getVentasPorDia`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Dashboard_getVentasPorDia`()
BEGIN
	SELECT	SUM(pedido.total)	AS	total,
				DAY(pedido.created_at)	AS	dia
	FROM		orders	pedido
	WHERE		MONTH(pedido.created_at)	=	MONTH(NOW())
	GROUP	BY	dia;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Tecnico_getNuevoDniTecnico
DROP PROCEDURE IF EXISTS `sp_Tecnico_getNuevoDniTecnico`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_getNuevoDniTecnico`(
)
BEGIN
	SET @nDniTecnico := (SELECT IF(ISNULL(id), 'T00001', CONCAT('T', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM technicals);

	/*RETORNAMOS*/
	SELECT	@nDniTecnico	AS	nDniTecnico;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Tecnico_getListarTecnicos
DROP PROCEDURE IF EXISTS `sp_Tecnico_getListarTecnicos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_getListarTecnicos`(
	IN `nidtechnical` INT,
    IN `tdni` VARCHAR(50),
	IN `tnombre` VARCHAR(50),
	IN `trfc` VARCHAR(50)
)
BEGIN
	SELECT	tecnico.id,
                tecnico.dni,
				CONCAT_WS(' ', tecnico.name, tecnico.lastname)	AS	fullname,
				tecnico.name,
				tecnico.lastname,
				tecnico.rfc,
				tecnico.email,
				tecnico.phone
	FROM		technicals	tecnico
	WHERE		CONCAT_WS(' ', tecnico.name, tecnico.lastname)	LIKE	CONCAT('%', tnombre, '%')
				AND	tecnico.dni	LIKE	CONCAT('%', tdni, '%')
				AND	tecnico.rfc	LIKE	CONCAT('%', trfc, '%')
				AND	(tecnico.id	=	nidtechnical	OR	nidtechnical = 0)
	ORDER	BY	tecnico.id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Tecnico_setEditarTecnico
DROP PROCEDURE IF EXISTS `sp_Tecnico_setEditarTecnico`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_setEditarTecnico`(
	IN `nidtechnical` INT,
	IN `trfc` VARCHAR(50),
	IN `tnombre` VARCHAR(50),
	IN `tapellido` VARCHAR(50),
	IN `temail` VARCHAR(50),
	IN `ttelefono` VARCHAR(50),
	IN `nidauthuser` INT

)
BEGIN
	UPDATE	technicals
	SET		rfc			=	trfc,
				name			=	tnombre,
				lastname		=	tapellido,
				email			=	temail,
				phone			=	ttelefono,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidtechnical;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Tecnico_setRegistrarTecnico
DROP PROCEDURE IF EXISTS `sp_Tecnico_setRegistrarTecnico`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Tecnico_setRegistrarTecnico`(
	IN `trfc` VARCHAR(50),
	IN `tnombre` VARCHAR(50),
	IN `tapellido` VARCHAR(50),
	IN `temail` VARCHAR(50),
	IN `ttelefono` VARCHAR(50),
	IN `nidauthuser` INT
)
BEGIN
    SET @nDniTecnico := (SELECT IF(ISNULL(id), 'T00001', CONCAT('T', LPAD(cast(substring(max(dni), 5, 5) AS UNSIGNED INTEGER) + 1,5,'0'))) FROM technicals);
	INSERT	INTO	technicals	(dni, rfc, name, lastname, email, phone, created_by, updated_by, created_at, updated_at)
							VALUES	(@nDniTecnico, trfc, tnombre, tapellido, temail, ttelefono, nidauthuser, nidauthuser, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdTechnical := (SELECT	((IFNULL(MAX(technical.id), 1)))
	FROM		technicals technical);

	/*RETORNAMOS*/
	SELECT	@nIdTechnical	AS	nIdTechnical;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_getDetallePedido
DROP PROCEDURE IF EXISTS `sp_Pedido_getDetallePedido`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getDetallePedido`(IN `nidpedido` INT)
BEGIN
	SELECT	producto.id,
				producto.name				AS	cProducto,
				detalle_pedido.quantity	AS	nCantidad,
				detalle_pedido.price		AS	fPrecio,
				(detalle_pedido.quantity * detalle_pedido.price)	AS	fSubTotal
	FROM		orders	pedido
				INNER	JOIN	details_orders	detalle_pedido	ON	pedido.id	=	detalle_pedido.order_id
				INNER	JOIN	products			producto			ON	detalle_pedido.product_id	=	producto.id
	WHERE		pedido.id	=	nidpedido;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_getListarAbonoPedidos
DROP PROCEDURE IF EXISTS `sp_Pedido_getListarAbonoPedidos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getListarAbonoPedidos`(
	IN `nidpedido` INT
)
BEGIN
	SELECT	pedido.id,
				pedido.order_number	AS	pedido,
				(
					SELECT	SUM(detalle_venta.price)
					FROM		details_orders	detalle_venta
					WHERE		detalle_venta.order_id		=	pedido.id
				)	AS	total,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'ACTIVO'
															WHEN	'I'	THEN	'RECHAZADO'
																			ELSE	'LIQUIDADO'
																			END	estado,
				IFNULL(pedido.state, '')	AS	state,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	vendedor,
				abono.credit	AS	abonos,
				DATE_FORMAT(abono.created_at,'%d-%m-%Y %r')	AS	fecha,
				abono.comments	AS	comentario
	FROM		payments		abono
				INNER	JOIN	users		vendedor		ON	abono.created_by		=	vendedor.id
				INNER	JOIN	orders	pedido		ON	abono.order_id			=	pedido.id
	WHERE		pedido.id	=	nidpedido
	ORDER	BY	pedido.order_number	DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_getListarPedidos
DROP PROCEDURE IF EXISTS `sp_Pedido_getListarPedidos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getListarPedidos`(
	IN `cNombre` VARCHAR(50),
	IN `cDocumento` VARCHAR(50),
	IN `cPedido` VARCHAR(50),
	IN `cEstado` CHAR(1)
,
	IN `dFechaCita` VARCHAR(50)



)
BEGIN
	SELECT	pedido.id,
				pedido.order_number	AS	pedido,
				paciente.document		AS	documento,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	paciente,
				tecnico.rfc				AS	rfcTechnical,
				CONCAT_WS(' ', tecnico.name, tecnico.lastname)	AS	tecnico,
				(
					SELECT	SUM(detalle_venta.price)
					FROM		details_orders	detalle_venta
					WHERE		detalle_venta.order_id		=	pedido.id
				)	AS	total,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'ACTIVO'
															WHEN	'I'	THEN	'RECHAZADO'
																			ELSE	'LIQUIDADO'
																			END	estado,
				IFNULL(pedido.state, '')	AS	state,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	vendedor
	FROM		orders	pedido
				INNER	JOIN	patients	paciente	ON	pedido.patient_id	=	paciente.id
				INNER	JOIN	technicals	tecnico	ON	pedido.technical_id	=	tecnico.id
				INNER	JOIN	users			vendedor	ON	pedido.user_id			=	vendedor.id
	WHERE		CONCAT_WS(' ', paciente.name, paciente.lastname)	LIKE	CONCAT('%', cNombre, '%')
				AND	paciente.document	LIKE	CONCAT('%', cDocumento, '%')
				AND	pedido.order_number	LIKE	CONCAT('%', cPedido, '%')
				AND	(pedido.state	=	cEstado	OR	cEstado	=	'')
				AND	(DATE(pedido.fecha_cita)	Like CONCAT('%', dFechaCita, '%')	OR	(dFechaCita	=	''))
	ORDER	BY	pedido.order_number	DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_getListarTotales
DROP PROCEDURE IF EXISTS `sp_Pedido_getListarTotales`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getListarTotales`(
	IN `nidpedido` INT
)
BEGIN
	SELECT
			(SELECT total FROM orders pedido WHERE pedido.id=nidpedido) AS totalPedido,
			IFNULL(SUM(abonos.credit), 0) AS totalAbonos,
			(SELECT total FROM orders pedido WHERE pedido.id=nidpedido) - IFNULL(SUM(abonos.credit), 0) AS restante
	FROM orders pedidos, payments abonos
	WHERE abonos.order_id = pedidos.id AND abonos.order_id=nidpedido;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_getPedido
DROP PROCEDURE IF EXISTS `sp_Pedido_getPedido`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_getPedido`(
	IN `nidpedido` INT



)
BEGIN
	SELECT	pedido.id,
				pedido.order_number		AS	nNumeroPedido,
				DATE_FORMAT(pedido.created_at,'%d-%m-%Y %r')			AS	dFechaPedido,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'GENERADO'
															WHEN	'I'	THEN	'RECHAZADO'
																			ELSE	'LIQUIDADO'
																			END	cEstadoPedido,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	cVendedor,
				vendedor.email	AS	cVendedorCorreo,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	pPaciente,
				CONCAT_WS(' ', tecnico.name, tecnico.lastname)	AS	tTechnical,
				paciente.document					AS	cDocumento,
				IFNULL(paciente.phone, '')		AS	cTelefono,
				IFNULL(paciente.email, '')		AS	cCorreo,
				pedido.total						AS	fTotalPedido,
				IFNULL(pedido.comments, '')	AS	cComentario,
				DATE_FORMAT(pedido.fecha_cita,'%d-%m-%Y %r') AS dFechaCita
	FROM		orders	pedido
				INNER	JOIN	patients	paciente	ON	pedido.patient_id	=	paciente.id
				INNER	JOIN	technicals	tecnico	ON	pedido.technical_id	=	tecnico.id
				INNER	JOIN	users			vendedor	ON	pedido.user_id			=	vendedor.id
	WHERE		pedido.id	=	nidpedido;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_setCambiarEstadoPedido
DROP PROCEDURE IF EXISTS `sp_Pedido_setCambiarEstadoPedido`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setCambiarEstadoPedido`(IN `nidpedido` INT, IN `cestado` CHAR(1), IN `nidauthuser` INT)
BEGIN
	UPDATE	orders
	SET		state			=	cestado,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidpedido;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_setRegistrarAbono
DROP PROCEDURE IF EXISTS `sp_Pedido_setRegistrarAbono`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setRegistrarAbono`(
	IN `nidpedido` INT,
	IN `fabono` DOUBLE,
	IN `ccomentario` TEXT,
	IN `nidauthuser` INT





)
BEGIN
	INSERT	INTO	payments	(comments, credit, order_id, created_by, created_at)
							VALUES	(ccomentario, fabono, nidpedido, nidauthuser, NOW());

	SET @resultado	:=	(SELECT ((SELECT total FROM orders pedido WHERE pedido.id=nidpedido) - IFNULL(SUM(abonos.credit), 0))
							FROM orders pedidos, payments abonos
							WHERE abonos.order_id = pedidos.id AND abonos.order_id=nidpedido);

	if @resultado<=0 then
    	UPDATE orders pedidos SET pedidos.state='L' WHERE pedidos.id = nidpedido;
	end if;

	SELECT	@resultado	AS	resultado;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_setRegistrarDetallePedido
DROP PROCEDURE IF EXISTS `sp_Pedido_setRegistrarDetallePedido`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setRegistrarDetallePedido`(IN `nidpedido` INT, IN `nidproducto` INT, IN `nstock` INT, IN `fsubtotal` DOUBLE)
BEGIN
	INSERT	INTO	details_orders	(order_id, product_id, quantity, price)
								VALUES	(nidpedido, nidproducto, nstock, fsubtotal);
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Pedido_setRegistrarPedido
DROP PROCEDURE IF EXISTS `sp_Pedido_setRegistrarPedido`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Pedido_setRegistrarPedido`(
	IN `nidpaciente` INT,
	IN `nidtechnical` INT,
	IN `ccomentario` TEXT,
	IN `ftotalpedido` DOUBLE,
	IN `dfechacita` VARCHAR(50),
	IN `nidauthuser` INT


)
BEGIN
	/*Generar el número del pedido*/
	SET @nOrderName := (SELECT	CONCAT_WS('', YEAR(NOW()), MONTH(NOW()), DAY(NOW())));

	INSERT	INTO	orders	(comments, patient_id, user_id, technical_id, total, created_by, updated_by, created_at, updated_at, fecha_cita)
						VALUES	(ccomentario, nidpaciente, nidauthuser, nidtechnical, ftotalpedido, nidauthuser, nidauthuser, NOW(), NOW(), dfechacita);

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdPedido := (SELECT	((IFNULL(MAX(pedido.id), 1)))
	FROM		orders pedido);

	/*ACTUALIZAR EL NUMERO DEL PEDIDO*/
	UPDATE	orders
	SET		order_number	=	CONCAT_WS('', @nOrderName, @nIdPedido)
	WHERE		id					=	@nIdPedido;

	/*RETORNAMOS*/
	SELECT	@nIdPedido	AS	nIdPedido;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Permiso_getListarPermisos
DROP PROCEDURE IF EXISTS `sp_Permiso_getListarPermisos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Permiso_getListarPermisos`(
	IN `nidpermiso` INT,
	IN `cnombre` VARCHAR(50),
	IN `cslug` VARCHAR(50)
)
BEGIN
	SELECT	permiso.id,
				permiso.slug,
				permiso.name
	FROM		permissions permiso
	WHERE		CONCAT_WS(' ', permiso.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', permiso.slug)	LIKE	CONCAT('%', cslug, '%')
				AND	(permiso.id	=	nidpermiso	OR	nidpermiso = 0)
	ORDER BY permiso.name ASC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Permiso_setEditarPermiso
DROP PROCEDURE IF EXISTS `sp_Permiso_setEditarPermiso`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Permiso_setEditarPermiso`(IN `nidpermiso` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))
BEGIN
	UPDATE	permissions
	SET		name			=	cnombre,
				slug			=	cslug,
				updated_at	=	NOW()
	WHERE		id				=	nidpermiso;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Permiso_setRegistrarPermiso
DROP PROCEDURE IF EXISTS `sp_Permiso_setRegistrarPermiso`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Permiso_setRegistrarPermiso`(IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))
BEGIN
	INSERT	INTO	permissions	(name, slug, created_at, updated_at)
							VALUES	(cnombre, cslug, NOW(), NOW());
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Producto_getListarProductos
DROP PROCEDURE IF EXISTS `sp_Producto_getListarProductos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Producto_getListarProductos`(IN `nidproducto` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nidcategoria` INT)
BEGIN
	SELECT	producto.id,
				producto.name,
				producto.description,
				producto.stock,
				producto.price,
				categoria.id	AS	nidcategoria,
				categoria.name	AS	categoria
	FROM		products producto
				INNER JOIN categories categoria	ON	producto.categorie_id = categoria.id
	WHERE		CONCAT_WS(' ', producto.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', producto.description)	LIKE	CONCAT('%', cdescripcion, '%')
				AND	(producto.id	=	nidproducto	OR	nidproducto	=	0)
				AND	(categoria.id	=	nidcategoria	OR	nidcategoria	=	0)
	ORDER BY producto.id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Producto_setEditarProducto
DROP PROCEDURE IF EXISTS `sp_Producto_setEditarProducto`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Producto_setEditarProducto`(IN `nidproducto` INT, IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nstock` INT, IN `fprecio` DOUBLE, IN `nidcategoria` INT, IN `nidauthuser` INT)
BEGIN
	UPDATE	products
	SET		name				=	cnombre,
				description		=	cdescripcion,
				stock				=	nstock,
				price				=	fprecio,
				categorie_id	=	nidcategoria,
				updated_by		=	nidauthuser,
				updated_at		=	NOW()
	WHERE		id					=	nidproducto;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Producto_setRegistrarProducto
DROP PROCEDURE IF EXISTS `sp_Producto_setRegistrarProducto`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Producto_setRegistrarProducto`(IN `cnombre` VARCHAR(50), IN `cdescripcion` TEXT, IN `nstock` INT, IN `fprecio` DOUBLE, IN `nidcategoria` INT, IN `nidauthuser` INT)
BEGIN
	INSERT	INTO	products	(name, description, stock, price, categorie_id, created_by, updated_by, created_at, updated_at)
						VALUES	(cnombre, cdescripcion, nstock, fprecio, nidcategoria, nidauthuser, nidauthuser, NOW(), NOW());
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Reporte_getListarPedidos
DROP PROCEDURE IF EXISTS `sp_Reporte_getListarPedidos`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Reporte_getListarPedidos`(
	IN `cNombre` VARCHAR(50),
	IN `cDocumento` VARCHAR(50),
	IN `cPedido` VARCHAR(50),
	IN `cEstado` CHAR(1),
	IN `dFechaInicio` VARCHAR(50),
	IN `dFechaFin` VARCHAR(50)
)
BEGIN
	SELECT	pedido.id,
				pedido.order_number	AS	pedido,
				paciente.document		AS	documento,
				CONCAT_WS(' ', paciente.name, paciente.lastname)	AS	paciente,
				(
					SELECT	SUM(detalle_venta.price)
					FROM		details_orders	detalle_venta
					WHERE		detalle_venta.order_id		=	pedido.id
				)	AS	total,
				CASE	IFNULL(pedido.state, '')	WHEN	'A'	THEN	'ACTIVO'
																			ELSE	'RECHAZADO'
																			END	estado,
				IFNULL(pedido.state, '')	AS	state,
				CONCAT_WS(' ', vendedor.firstname, vendedor.lastname)	AS	vendedor
	FROM		orders	pedido
				INNER	JOIN	patients	paciente	ON	pedido.patient_id	=	paciente.id
				INNER	JOIN	users			vendedor	ON	pedido.user_id			=	vendedor.id
	WHERE		CONCAT_WS(' ', paciente.name, paciente.lastname)	LIKE	CONCAT('%', cNombre, '%')
				AND	paciente.document	LIKE	CONCAT('%', cDocumento, '%')
				AND	pedido.order_number	LIKE	CONCAT('%', cPedido, '%')
				AND	(pedido.state	=	cEstado	OR	cEstado	=	'')
				AND	((DATE(pedido.created_at)	BETWEEN	dFechaInicio	AND	dFechaFin)	OR	(dFechaInicio	=	''	AND	dFechaFin = ''))
	ORDER	BY	pedido.order_number	DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Rol_getListarPermisosByRol
DROP PROCEDURE IF EXISTS `sp_Rol_getListarPermisosByRol`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_getListarPermisosByRol`(IN `nidrol` INT)
BEGIN
	SELECT	permiso.id,
				permiso.slug,
				permiso.name,
				CASE	IFNULL(rol_permiso.role_id, '')	WHEN	''	THEN	0
																				ELSE	1
																				END	checked
	FROM		permissions	permiso
				LEFT OUTER JOIN	roles_permissions	rol_permiso	ON	permiso.id	=	rol_permiso.permission_id
																					AND	rol_permiso.role_id	=	nidrol;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Rol_getListarRoles
DROP PROCEDURE IF EXISTS `sp_Rol_getListarRoles`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_getListarRoles`(IN `nidrol` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))
BEGIN
	SELECT	rol.id,
				rol.slug,
				rol.name
	FROM		roles rol
	WHERE		CONCAT_WS(' ', rol.name)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', rol.slug)	LIKE	CONCAT('%', cslug, '%')
				AND	(rol.id	=	nidrol	OR	nidrol = 0)
	ORDER BY rol.id DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Rol_setEditarRol
DROP PROCEDURE IF EXISTS `sp_Rol_setEditarRol`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_setEditarRol`(IN `nidrol` INT, IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))
BEGIN
	UPDATE	roles
	SET		name			=	cnombre,
				slug			=	cslug,
				updated_at	=	NOW()
	WHERE		id				=	nidrol;


	DELETE
	FROM		roles_permissions
	WHERE		role_id	=	nidrol;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Rol_setRegistrarRol
DROP PROCEDURE IF EXISTS `sp_Rol_setRegistrarRol`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_setRegistrarRol`(IN `cnombre` VARCHAR(50), IN `cslug` VARCHAR(50))
BEGIN
	INSERT	INTO	roles	(name, slug, created_at, updated_at)
					VALUES	(cnombre, cslug, NOW(), NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdRol := (SELECT	((IFNULL(MAX(rol.id), 1)))
	FROM		roles rol);

	/*RETORNAMOS*/
	SELECT	@nIdRol	AS	nIdRol;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Rol_setRegistrarRolPermiso
DROP PROCEDURE IF EXISTS `sp_Rol_setRegistrarRolPermiso`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Rol_setRegistrarRolPermiso`(IN `nidrol` INT, IN `nidpermiso` INT)
BEGIN
	INSERT INTO roles_permissions	(role_id, permission_id)
								VALUES	(nidrol, nidpermiso);
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_getListarPermisosByRolAsignado
DROP PROCEDURE IF EXISTS `sp_Usuario_getListarPermisosByRolAsignado`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarPermisosByRolAsignado`(IN `nidusario` INT)
BEGIN
	SELECT	p.id,
				p.name,
				p.slug
	FROM		users_roles	ur
				INNER	JOIN	roles_permissions	rp	ON	ur.role_id			=	rp.role_id
				INNER	JOIN	permissions		p		ON	rp.permission_id	=	p.id
	WHERE		ur.user_id	=	nidusario;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_getListarPermisosByUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_getListarPermisosByUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarPermisosByUsuario`(IN `nidusuario` INT)
BEGIN
	SELECT	permiso.id,
				permiso.slug,
				permiso.name,
				CASE	IFNULL(user_permiso.user_id, '')	WHEN	''	THEN	0
																				ELSE	1
																				END	checked
	FROM		permissions	permiso
				LEFT OUTER JOIN	users_permissions	user_permiso	ON	permiso.id	=	user_permiso.permission_id
																					AND	user_permiso.user_id	=	nidusuario;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_getListarRolPermisosByUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_getListarRolPermisosByUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarRolPermisosByUsuario`(IN `nidusuario` INT)
BEGIN
	SELECT	permiso.id,
				permiso.name,
				permiso.slug
	FROM		permissions	permiso
				INNER JOIN	users_permissions	user_permiso	ON	permiso.id	=	user_permiso.permission_id
																					AND	user_permiso.user_id	=	nidusuario

	UNION

	SELECT	p.id,
				p.name,
				p.slug
	FROM		users_roles	ur
				INNER	JOIN	roles_permissions	rp	ON	ur.role_id			=	rp.role_id
				INNER	JOIN	permissions		p		ON	rp.permission_id	=	p.id
	WHERE		ur.user_id	=	nidusuario;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_getListarUsuarios
DROP PROCEDURE IF EXISTS `sp_Usuario_getListarUsuarios`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getListarUsuarios`(IN `nidusuario` INT, IN `cnombre` VARCHAR(50), IN `cusuario` VARCHAR(50), IN `ccorreo` VARCHAR(50), IN `cestado` CHAR(1))
BEGIN
	SELECT	usuario.id,
				CONCAT_WS(' ', usuario.firstname, usuario.secondname, usuario.lastname)	AS	fullname,
				usuario.firstname,
				usuario.secondname,
				usuario.lastname,
				usuario.username,
				IFNULL(usuario.email, '')	AS	email,
				CASE	IFNULL(usuario.state, '')	WHEN	'A'	THEN	'ACTIVO'
																			ELSE	'INACTIVO'
																			END	state_alias,
				IFNULL(usuario.state, '')	AS	state,
				IFNULL(image.path, '')		AS	profile_image
	FROM		users	usuario
				LEFT OUTER JOIN files image ON usuario.file_id	=	image.id
	WHERE		CONCAT_WS(' ', usuario.firstname, usuario.secondname, usuario.lastname)	LIKE	CONCAT('%', cnombre, '%')
				AND	CONCAT_WS(' ', usuario.username)	LIKE	CONCAT('%', cusuario, '%')
				AND	CONCAT_WS(' ', usuario.email)		LIKE	CONCAT('%', ccorreo, '%')
				AND	(usuario.state	=	cestado	OR	cestado	=	'')
				AND	(usuario.id		=	nidusuario	OR	nidusuario	=	0)
	ORDER	BY	usuario.id	DESC;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_getRolByUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_getRolByUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_getRolByUsuario`(IN `nidusuario` INT)
BEGIN
	SELECT	ur.role_id	AS	nIdRol,
				rol.name
	FROM		users_roles	ur
				INNER	JOIN	roles	rol	ON	ur.role_id	=	rol.id
	WHERE		user_id		=	nidusuario;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_setCambiarEstadoUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_setCambiarEstadoUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setCambiarEstadoUsuario`(IN `nidusuario` INT, IN `cestado` CHAR(1), IN `nidauthuser` INT)
BEGIN
	UPDATE	users
	SET		state			=	cestado,
				updated_by	=	nidauthuser,
				updated_at	=	NOW()
	WHERE		id				=	nidusuario;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_setEditarRolByUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_setEditarRolByUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setEditarRolByUsuario`(IN `nidusuario` INT, IN `nidrol` INT)
BEGIN
	SELECT	@nCantidadRoles :=	COUNT(role_id)
	FROM		users_roles
	WHERE		user_id		=	nidusuario;

	IF(@nCantidadRoles > 0)
		THEN
			/* ACTUALIZAR EL ROL POR USUARIO*/
			UPDATE	users_roles
			SET		role_id		=	nidrol
			WHERE		user_id		=	nidusuario;
	ELSE
		INSERT	INTO	users_roles	(user_id, role_id)
								VALUES	(nidusuario, nidrol);
	END IF;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_setEditarUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_setEditarUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setEditarUsuario`(IN `nidusuario` INT, IN `cprimernombre` VARCHAR(50), IN `csegundonombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cusuario` VARCHAR(50), IN `ccorreo` VARCHAR(50), IN `ccontrasena` VARCHAR(150), IN `ofotografia` INT, IN `nidauthuser` INT)
BEGIN
	IF(csegundonombre = '' AND ccontrasena = '' AND ofotografia = 0)
		THEN
			UPDATE	users
			SET		firstname	=	cprimernombre,
						lastname		=	capellido,
						username		=	cusuario,
						email			=	ccorreo,
						updated_by	=	nidauthuser,
						updated_at	=	NOW()
			WHERE		id				=	nidusuario;
	ELSE
		IF(csegundonombre	= ''	AND	ccontrasena = '')
			THEN
				UPDATE	users
				SET		firstname	=	cprimernombre,
							lastname		=	capellido,
							username		=	cusuario,
							email			=	ccorreo,
							file_id		=	ofotografia,
							updated_by	=	nidauthuser,
							updated_at	=	NOW()
				WHERE		id				=	nidusuario;
		ELSE
			IF(csegundonombre	=	''	AND	ofotografia = 0)
				THEN
					UPDATE	users
					SET		firstname	=	cprimernombre,
								lastname		=	capellido,
								password		=	ccontrasena,
								username		=	cusuario,
								email			=	ccorreo,
								updated_by	=	nidauthuser,
								updated_at	=	NOW()
					WHERE		id				=	nidusuario;
			ELSE
				IF(ccontrasena	=	''	AND	ofotografia = 0)
					THEN
						UPDATE	users
						SET		firstname	=	cprimernombre,
									secondname	=	csegundonombre,
									lastname		=	capellido,
									username		=	cusuario,
									email			=	ccorreo,
									updated_by	=	nidauthuser,
									updated_at	=	NOW()
						WHERE		id				=	nidusuario;
				ELSE
					IF	(csegundonombre = '')
						THEN
							UPDATE	users
							SET		firstname	=	cprimernombre,
										lastname		=	capellido,
										password		=	ccontrasena,
										file_id		=	ofotografia,
										username		=	cusuario,
										email			=	ccorreo,
										updated_by	=	nidauthuser,
										updated_at	=	NOW()
							WHERE		id				=	nidusuario;
					ELSE
						IF(ccontrasena	=	'')
							THEN
								UPDATE	users
								SET		firstname	=	cprimernombre,
											secondname	=	csegundonombre,
											lastname		=	capellido,
											file_id		=	ofotografia,
											username		=	cusuario,
											email			=	ccorreo,
											updated_by	=	nidauthuser,
											updated_at	=	NOW()
								WHERE		id				=	nidusuario;
						ELSE
							IF(ofotografia = 0)
								THEN
									UPDATE	users
									SET		firstname	=	cprimernombre,
												secondname	=	csegundonombre,
												lastname		=	capellido,
												password		=	ccontrasena,
												username		=	cusuario,
												email			=	ccorreo,
												updated_by	=	nidauthuser,
												updated_at	=	NOW()
									WHERE		id				=	nidusuario;
							ELSE
								UPDATE	users
								SET		firstname	=	cprimernombre,
											secondname	=	csegundonombre,
											lastname		=	capellido,
											password		=	ccontrasena,
											username		=	cusuario,
											email			=	ccorreo,
											file_id		=	ofotografia,
											updated_by	=	nidauthuser,
											updated_at	=	NOW()
								WHERE		id				=	nidusuario;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_setEliminarPermisosByUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_setEliminarPermisosByUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setEliminarPermisosByUsuario`(IN `nidusuario` INT)
BEGIN
	DELETE
	FROM		users_permissions
	WHERE		user_id	=	nidusuario;
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_setRegistrarPermisosByUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_setRegistrarPermisosByUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setRegistrarPermisosByUsuario`(IN `nidusuario` INT, IN `nidpermiso` INT)
BEGIN
	INSERT	INTO	users_permissions	(user_id, permission_id)
									VALUES	(nidusuario, nidpermiso);
END//
DELIMITER ;

-- Volcando estructura para procedimiento punto_venta.sp_Usuario_setRegistrarUsuario
DROP PROCEDURE IF EXISTS `sp_Usuario_setRegistrarUsuario`;
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_Usuario_setRegistrarUsuario`(IN `cprimernombre` VARCHAR(50), IN `csegundonombre` VARCHAR(50), IN `capellido` VARCHAR(50), IN `cusuario` VARCHAR(50), IN `ccorreo` VARCHAR(50), IN `ccontrasena` VARCHAR(150), IN `ofotografia` VARCHAR(50), IN `nidauthuser` INT)
BEGIN
	insert into	users	(firstname, secondname, lastname, username, email, password, file_id, state, created_by, updated_by, created_at)
				VALUES	(cprimernombre, csegundonombre, capellido, cusuario, ccorreo, ccontrasena, ofotografia, 'A', nidauthuser, nidauthuser, NOW());

	/*OBTENER EL ULTIMO ID REGISTRADO*/
	SET @nIdUsuario := (SELECT	((IFNULL(MAX(usuario.id), 1)))
	FROM		users usuario);

	/*RETORNAMOS*/
	SELECT	@nIdUsuario	AS	nIdUsuario;
END//
DELIMITER ;

-- Volcando estructura para tabla punto_venta.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secondname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_id` bigint(20) unsigned DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `updated_by` bigint(20) unsigned NOT NULL,
  `state` enum('A','I') COLLATE utf8mb4_unicode_ci DEFAULT 'A',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_file_id_foreign` (`file_id`),
  KEY `users_username_index` (`username`),
  KEY `users_created_by_index` (`created_by`),
  KEY `users_updated_by_index` (`updated_by`),
  CONSTRAINT `users_file_id_foreign` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.users: ~1 rows (aproximadamente)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `firstname`, `secondname`, `lastname`, `username`, `email`, `email_verified_at`, `password`, `file_id`, `remember_token`, `created_by`, `updated_by`, `state`, `created_at`, `updated_at`) VALUES
	(1, 'César', 'Yahir', 'Piña', 'yayo', 'prueba@gmail.com', NULL, '$2y$10$o228YoDlY9ykI0kvZWhcLODrMfHkrz7b.IOFLJoU.18b.pBX.GAs.', NULL, NULL, 21, 1, 'A', '2022-11-19 00:58:31', '2023-02-16 21:01:56');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.users_permissions
DROP TABLE IF EXISTS `users_permissions`;
CREATE TABLE IF NOT EXISTS `users_permissions` (
  `user_id` bigint(20) unsigned NOT NULL,
  `permission_id` bigint(20) unsigned NOT NULL,
  KEY `users_permissions_user_id_foreign` (`user_id`),
  KEY `users_permissions_permission_id_foreign` (`permission_id`),
  CONSTRAINT `users_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`),
  CONSTRAINT `users_permissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.users_permissions: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `users_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_permissions` ENABLE KEYS */;

-- Volcando estructura para tabla punto_venta.users_roles
DROP TABLE IF EXISTS `users_roles`;
CREATE TABLE IF NOT EXISTS `users_roles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `role_id` bigint(20) unsigned NOT NULL,
  KEY `users_roles_user_id_foreign` (`user_id`),
  KEY `users_roles_role_id_foreign` (`role_id`),
  CONSTRAINT `users_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `users_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volcando datos para la tabla punto_venta.users_roles: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
INSERT INTO `users_roles` (`user_id`, `role_id`) VALUES
	(1, 2);
/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;

-- Volcando estructura para disparador punto_venta.tr_Pedido_setActualizarStock
DROP TRIGGER IF EXISTS `tr_Pedido_setActualizarStock`;
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
DELIMITER //
CREATE TRIGGER `tr_Pedido_setActualizarStock` AFTER INSERT ON `details_orders` FOR EACH ROW BEGIN
	UPDATE	products
	SET		stock		=	stock - NEW.quantity
	WHERE		id			=	NEW.product_id;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
