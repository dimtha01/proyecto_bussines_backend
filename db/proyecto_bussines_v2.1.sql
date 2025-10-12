/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `archivos`;
CREATE TABLE `archivos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_proyecto` int(11) DEFAULT NULL,
  `nombre_archivo` varchar(255) NOT NULL,
  `ruta_archivo` varchar(500) NOT NULL,
  `tipo_archivo` varchar(100) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_archivo_proyecto` (`id_proyecto`),
  CONSTRAINT `fk_archivo_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `avance_financiero`;
CREATE TABLE `avance_financiero` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_proyecto` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `numero_valuacion` varchar(50) DEFAULT NULL,
  `monto_usd` decimal(15,2) DEFAULT NULL,
  `numero_factura` varchar(50) DEFAULT NULL,
  `ofertado` decimal(15,2) DEFAULT NULL,
  `costo_planificado` decimal(15,2) DEFAULT NULL,
  `id_estatus_proceso` int(11) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_proyecto` (`id_proyecto`),
  KEY `id_estatus_proceso` (`id_estatus_proceso`),
  CONSTRAINT `avance_financiero_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `avance_financiero_ibfk_2` FOREIGN KEY (`id_estatus_proceso`) REFERENCES `estatus_proceso` (`id_estatus`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `avance_fisico`;
CREATE TABLE `avance_fisico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_proyecto` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `avance_real` varchar(255) DEFAULT NULL,
  `avance_planificado` varchar(255) DEFAULT NULL,
  `puntos_atencion` text DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_proyecto` (`id_proyecto`),
  CONSTRAINT `avance_fisico_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `unidad_negocio` varchar(255) DEFAULT NULL,
  `razon_social` varchar(255) NOT NULL,
  `nombre_comercial` varchar(255) DEFAULT NULL,
  `direccion_fiscal` text DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `id_region` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_clientes_region` (`id_region`),
  CONSTRAINT `fk_clientes_region` FOREIGN KEY (`id_region`) REFERENCES `regiones` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `costos_proyectos`;
CREATE TABLE `costos_proyectos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_proyecto` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `costo` decimal(10,2) NOT NULL,
  `monto_sobrepasado` decimal(10,2) DEFAULT 0.00,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `id_estatus` int(11) DEFAULT 4,
  `numero_valuacion` varchar(255) DEFAULT NULL,
  `amortizacion` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `id_proyecto` (`id_proyecto`),
  KEY `fk_id` (`id_estatus`),
  CONSTRAINT `costos_proyectos_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id` FOREIGN KEY (`id_estatus`) REFERENCES `estatus_proceso` (`id_estatus`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estatus_comercial`;
CREATE TABLE `estatus_comercial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estatus_proceso`;
CREATE TABLE `estatus_proceso` (
  `id_estatus` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estatus` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id_estatus`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estatus_proveedor`;
CREATE TABLE `estatus_proveedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(50) NOT NULL,
  `nombre_abreviado` varchar(10) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `color` varchar(20) DEFAULT '#CCCCCC',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_comercial` varchar(255) NOT NULL,
  `direccion_fiscal` varchar(255) NOT NULL,
  `pais` varchar(255) NOT NULL,
  `telefono` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `RIF` varchar(255) NOT NULL,
  `estatus_id` int(11) NOT NULL DEFAULT 1 COMMENT '1=Apto por defecto',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_proveedor_estatus` (`estatus_id`),
  CONSTRAINT `fk_proveedor_estatu` FOREIGN KEY (`estatus_id`) REFERENCES `estatus_proveedor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `proyectos`;
CREATE TABLE `proyectos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_responsable` int(11) DEFAULT NULL,
  `id_region` int(11) DEFAULT NULL,
  `id_contrato` varchar(100) DEFAULT NULL,
  `costo_estimado` decimal(15,2) DEFAULT NULL,
  `monto_ofertado` decimal(15,2) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_final` date DEFAULT NULL,
  `duracion` int(11) DEFAULT NULL,
  `id_estatus` int(11) NOT NULL DEFAULT 1,
  `nombre_cortos` varchar(155) DEFAULT NULL,
  `codigo_contrato_cliente` varchar(255) DEFAULT NULL,
  `id_estatus_comercial` int(11) DEFAULT 1,
  `monto_estimado_oferta_cerrado_sdo` decimal(10,0) DEFAULT 0,
  `monto_estimado_oferta_cliente` decimal(10,0) DEFAULT 0,
  `oferta_del_proveedor` int(11) DEFAULT 0,
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero` (`numero`),
  UNIQUE KEY `id_contrato` (`id_contrato`),
  UNIQUE KEY `codigo_contrato_cliente` (`codigo_contrato_cliente`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_responsable` (`id_responsable`),
  KEY `id_region` (`id_region`),
  KEY `fk_estatus_comercial_Proyecto` (`id_estatus_comercial`),
  CONSTRAINT `fk_estatus_comercial_Proyecto` FOREIGN KEY (`id_estatus_comercial`) REFERENCES `estatus_comercial` (`id`),
  CONSTRAINT `proyectos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`),
  CONSTRAINT `proyectos_ibfk_2` FOREIGN KEY (`id_responsable`) REFERENCES `responsables` (`id`),
  CONSTRAINT `proyectos_ibfk_3` FOREIGN KEY (`id_region`) REFERENCES `regiones` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `regiones`;
CREATE TABLE `regiones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `requisition`;
CREATE TABLE `requisition` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo` int(11) NOT NULL,
  `id_proyecto` int(11) DEFAULT NULL,
  `nro_requisicion` varchar(255) NOT NULL,
  `id_proveedores` int(11) NOT NULL,
  `fecha_elaboracion` date NOT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL,
  `nro_renglones` int(11) NOT NULL,
  `monto_anticipo` decimal(10,2) NOT NULL DEFAULT 0.00,
  `nro_odc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tipo_requisition` (`id_tipo`),
  KEY `fk_proyecto` (`id_proyecto`),
  KEY `fk_proveedores` (`id_proveedores`),
  CONSTRAINT `fk_proveedores` FOREIGN KEY (`id_proveedores`) REFERENCES `proveedores` (`id`),
  CONSTRAINT `fk_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`),
  CONSTRAINT `fk_tipo_requisition` FOREIGN KEY (`id_tipo`) REFERENCES `tipo_requisition` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `responsables`;
CREATE TABLE `responsables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `cargo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `permissionEdit` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `tipo_requisition`;
CREATE TABLE `tipo_requisition` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `roleId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_region` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `roleId` (`roleId`),
  KEY `fk_region_user` (`id_region`),
  CONSTRAINT `fk_region_user` FOREIGN KEY (`id_region`) REFERENCES `regiones` (`id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `archivos` (`id`, `id_proyecto`, `nombre_archivo`, `ruta_archivo`, `tipo_archivo`, `fecha_creacion`) VALUES
(2, 51, 'plagio de base de dato xd.docx', 'C:\\Users\\deibe\\Downloads\\VSCODE\\Proyecto_business\\proyecto_bussines_backend\\uploads\\document\\plagio-de-base-de-dato-xd-1760285197709.docx', 'document', '2025-10-12 12:06:37');
INSERT INTO `archivos` (`id`, `id_proyecto`, `nombre_archivo`, `ruta_archivo`, `tipo_archivo`, `fecha_creacion`) VALUES
(3, 51, 'WhatsApp Image 2025-09-27 at 04.55.27_b9ce4c69.jpg', 'C:\\Users\\deibe\\Downloads\\VSCODE\\Proyecto_business\\proyecto_bussines_backend\\uploads\\image\\whatsapp-image-2025-09-27-at-045527b9ce4c69-1760285244941.jpg', 'image', '2025-10-12 12:07:25');
INSERT INTO `archivos` (`id`, `id_proyecto`, `nombre_archivo`, `ruta_archivo`, `tipo_archivo`, `fecha_creacion`) VALUES
(4, 51, 'WhatsApp Image 2025-10-09 at 15.09.19_5b5284d7.jpg', 'C:\\Users\\deibe\\Downloads\\VSCODE\\Proyecto_business\\proyecto_bussines_backend\\uploads\\image\\whatsapp-image-2025-10-09-at-1509195b5284d7-1760285244947.jpg', 'image', '2025-10-12 12:07:25');
INSERT INTO `archivos` (`id`, `id_proyecto`, `nombre_archivo`, `ruta_archivo`, `tipo_archivo`, `fecha_creacion`) VALUES
(7, 51, 'Manual_Ydam-Daniela_Arevalo.pdf', 'uploads\\pdf\\manualydam-danielaarevalo-1760285824009.pdf', 'pdf', '2025-10-12 12:17:04');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 41, '2025-03-08', 'VALUACION 1', '98675.33', NULL, NULL, NULL, 5, '2025-01-05', '2025-01-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(2, 41, '2025-03-08', 'VALUACION 2', '126144.06', NULL, NULL, NULL, 5, '2025-01-15', '2025-01-31');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(3, 41, '2025-03-08', 'VALUACION 3', '130802.04', NULL, NULL, NULL, 5, '2025-02-01', '2025-02-16');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(4, 41, '2025-03-08', 'VALUACION 4', '62266.71', NULL, NULL, NULL, 5, '2025-02-17', '2025-02-28');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(5, 42, '2025-03-08', 'VALUACION 1', '914606.07', '2025-011', NULL, NULL, 6, '2024-12-03', '2024-12-18');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(6, 42, '2025-03-08', 'VALUACION 2', '729677.38', NULL, NULL, NULL, 5, '2024-12-19', '2025-01-17');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(7, 43, '2025-03-08', 'VALUACION 01', '527286.46', NULL, NULL, NULL, 5, '2025-01-30', '2025-03-06');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(8, 44, '2025-03-08', 'VALUACION 1', '168525.64', '2025-010', NULL, NULL, 6, '2024-12-03', '2024-12-16');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(9, 44, '2025-03-08', 'VALUACION 2', '230013.75', NULL, NULL, NULL, 5, '2024-12-16', '2024-12-31');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(10, 44, '2025-03-08', 'VALUACION 3', '195049.54', NULL, NULL, NULL, 5, '2025-01-01', '2025-01-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(11, 44, '2025-03-08', 'VALUACION 4', '228934.85', NULL, NULL, NULL, 5, '2025-01-15', '2025-01-31');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(12, 45, '2025-03-08', 'VALUACION 1 A', '124283.04', NULL, NULL, NULL, 5, '2025-01-28', '2025-02-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(13, 45, '2025-03-08', 'VALUACION 1 B', '89500.56', NULL, NULL, NULL, 5, '2025-01-22', '2025-02-20');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(14, 46, '2025-03-17', '1', '79960.74', '0001', NULL, NULL, 6, '2025-02-17', '2025-03-02');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(15, 42, '2025-03-25', 'VALUACION 3', '455789.15', NULL, NULL, NULL, 5, '2025-01-08', '2025-02-16');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(16, 44, '2025-03-25', 'VALUACION 5', '236430.52', NULL, NULL, NULL, 5, '2025-01-31', '2025-02-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(17, 45, '2025-03-25', 'VALUACION 2 A', '51352.22', NULL, NULL, NULL, 5, '2025-02-16', '2025-02-28');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(18, 46, '2025-04-09', '2', '79960.74', '0002', NULL, NULL, 6, '2025-03-03', '2025-03-17');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(19, 46, '2025-04-09', '3', '60497.07', NULL, NULL, NULL, 4, '2025-03-18', '2025-04-05');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(20, 41, '2025-04-09', 'VALUACION 5', '108872.49', NULL, NULL, NULL, 5, '2025-03-16', '2025-03-31');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(21, 41, '2025-04-09', 'VALUACION 6', '101056.11', NULL, NULL, NULL, 5, '2025-03-16', '2025-03-31');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(22, 44, '2025-04-09', 'VALUACION 6', '192729.08', NULL, NULL, NULL, 5, '2025-02-15', '2025-02-28');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(23, 44, '2025-04-09', 'VALUACION 7', '172298.30', NULL, NULL, NULL, 5, '2025-03-01', '2025-03-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(24, 44, '2025-04-09', 'VALUACION 8', '222834.90', NULL, NULL, NULL, 5, '2025-03-16', '2025-03-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(25, 48, '2025-04-09', 'VALUACION 1', '0.01', NULL, NULL, NULL, 5, '2025-03-01', '2025-03-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(26, 43, '2025-04-09', 'VALUACION 2', '351326.05', NULL, NULL, NULL, 5, '2025-01-30', '2025-03-06');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(27, 42, '2025-04-09', 'VALUACION 4', '2367421.07', NULL, NULL, NULL, 5, '2025-02-17', '2025-03-03');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(28, 45, '2025-04-10', 'VALUACION 3 A', '74040.10', NULL, NULL, NULL, 5, '2025-03-01', '2025-03-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(29, 45, '2025-04-10', 'VALUACION 4 A', '89889.06', NULL, NULL, NULL, 5, '2025-03-16', '2025-03-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(30, 45, '2025-04-10', 'VALUACION 2 B', '81783.75', NULL, NULL, NULL, 5, '2025-02-21', '2025-03-20');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(31, 48, '2025-04-12', 'VALUACION 2', '142473.69', NULL, NULL, NULL, 5, '2025-03-15', '2025-03-31');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(32, 49, '2025-04-12', 'VALUACION 1', '52375.98', NULL, NULL, NULL, 5, '2025-01-22', '2025-03-20');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(33, 49, '2025-04-12', 'VALUACION 2', '257567.22', NULL, NULL, NULL, 5, '2025-02-22', '2025-03-20');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(34, 52, '2025-04-22', 'VALUACION 1', '33516.49', NULL, NULL, NULL, 5, '2025-04-03', '2025-04-17');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(35, 50, '2025-04-22', 'VALUACION 1', '139654.72', NULL, NULL, NULL, 5, '2025-04-03', '2025-04-17');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(36, 44, '2025-04-25', 'VALUACION 9', '170487.80', NULL, NULL, NULL, 5, '2025-03-31', '2025-04-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(37, 45, '2025-04-25', 'VALUACION 5', '64104.39', NULL, NULL, NULL, 5, '2025-04-01', '2025-04-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(38, 45, '2025-04-25', 'VALUACION 3 B', '119254.74', NULL, NULL, NULL, 5, '2025-03-24', '2025-04-21');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(39, 44, '2025-05-03', 'VALUACION 10 CORRESP CABILLERO 350 (II)', '294141.12', NULL, NULL, NULL, 4, '2025-03-01', '2025-03-17');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(40, 45, '2025-05-03', 'VALUACION 6 A', '62001.80', NULL, NULL, NULL, 5, '2025-04-16', '2025-04-28');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(41, 51, '2025-05-03', 'VALUACION 1', '55419.93', NULL, NULL, NULL, 5, '2025-04-03', '2025-04-17');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(42, 50, '2025-05-03', 'VALUACION 2', '162125.21', NULL, NULL, NULL, 5, '0005-04-18', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(43, 41, '2025-05-14', 'VALUACION 7', '78474.06', NULL, NULL, NULL, 5, '2025-04-01', '2025-04-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(44, 44, '2025-05-14', 'VALUACION 10', '0.01', NULL, NULL, NULL, 5, '2025-04-16', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(45, 43, '2025-05-14', 'VALUACION 3', '195272.70', NULL, NULL, NULL, 5, '2025-03-30', '2025-04-10');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(46, 43, '2025-05-14', 'VALUACION 4', '238420.11', NULL, NULL, NULL, 5, '2025-04-10', '2025-04-26');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(47, 49, '2025-05-14', 'VALUACION 3', '231350.14', NULL, NULL, NULL, 4, '2025-03-21', '2025-05-12');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(48, 51, '2025-05-14', 'VALUACION 2', '134430.17', NULL, NULL, NULL, 5, '2025-05-01', '2025-05-13');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(49, 41, '2025-05-18', 'VALUACION 8', '54814.75', NULL, NULL, NULL, 5, '2025-04-15', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(50, 48, '2025-05-18', 'VALUACION 2 B', '202855.00', NULL, NULL, NULL, 5, '2025-04-01', '2025-04-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(51, 52, '2025-05-18', 'VALUACION 2', '23791.85', NULL, NULL, NULL, 5, '2025-04-17', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(52, 50, '2025-05-18', 'VALUACION 3', '116345.66', NULL, NULL, NULL, 5, '2025-05-01', '2025-05-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(53, 41, '2025-05-25', 'VALUACION 9', '71929.58', NULL, NULL, NULL, 4, '2025-05-01', '2025-05-15');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(54, 48, '2025-05-25', 'VALUACION 3', '180489.82', NULL, NULL, NULL, 5, '2025-04-15', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(55, 48, '2025-05-25', 'VALUACION 4', '200857.13', NULL, NULL, NULL, 4, '2025-04-15', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(56, 41, '2025-06-02', 'VALUACION 10', '68037.37', NULL, NULL, NULL, 4, '2025-05-16', '2025-05-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(57, 44, '2025-06-02', 'VALUACION 10 CORRESP CABILLERO 350 (I)', '141197.93', NULL, NULL, NULL, 4, '2025-04-14', '2025-04-25');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(58, 48, '2025-06-02', 'VALUACION 5', '178658.70', NULL, NULL, NULL, 4, '2025-05-16', '2025-05-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(59, 43, '2025-06-02', 'VALUACION 5', '135595.27', NULL, NULL, NULL, 5, '2025-04-26', '2025-05-06');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(60, 43, '2025-06-02', 'VALUACION 6', '179853.96', NULL, NULL, NULL, 4, '2025-05-06', '2025-05-13');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(61, 43, '2025-06-02', 'VALUACION 7', '133978.28', NULL, NULL, NULL, 4, '2025-05-14', '2025-05-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(62, 51, '2025-06-02', 'VALUACION 3', '355226.97', NULL, NULL, NULL, 4, '2025-05-14', '2025-05-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(63, 52, '2025-06-08', 'VALUACION 3', '22999.60', NULL, NULL, NULL, 4, '2025-04-17', '2025-04-30');
INSERT INTO `avance_financiero` (`id`, `id_proyecto`, `fecha`, `numero_valuacion`, `monto_usd`, `numero_factura`, `ofertado`, `costo_planificado`, `id_estatus_proceso`, `fecha_inicio`, `fecha_fin`) VALUES
(64, 54, '2025-06-08', 'VALUACION 1 TECNOLE', '102334.15', NULL, NULL, NULL, 4, '2025-05-23', '2025-05-31');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 45, '2025-03-08', '25', '25', 'No hay plan establecido ', '2025-01-28 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(2, 41, '2025-03-08', '27', '27', 'No hay plan establecido', '2025-01-05 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(3, 42, '2025-03-08', '22', '22', 'No hay plan establecido', '2024-12-03 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(4, 43, '2025-03-08', '7', '7', 'No hay plan establecido', '2025-01-05 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(5, 44, '2025-03-08', '38', '38', 'No hay plan establecido', '2024-12-03 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(6, 46, '2025-03-12', '80', '69', 'Se culmino con la fabricación de los 50 atracaderos, se han inspeccionado 25 atracaderos, para iniciar con el sandblasting y pintura de los mismos', '2025-02-16 00:00:00', '2025-03-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(7, 41, '2025-03-25', '28.88', '28.88', 'No hay plan establecido', '2025-01-05 00:00:00', '2025-03-22 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(8, 42, '2025-03-25', '36.71', '36.71', 'No hay plan establecido', '2024-12-03 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(9, 43, '2025-03-25', '13.21', '13.21', 'No hay plan establecido', '2025-01-05 00:00:00', '2025-03-08 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(10, 45, '2025-03-25', '34', '34', 'No hay plan establecido', '2025-01-28 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(11, 41, '2025-04-09', '36.11', '50.67', 'EN ESPERA DE ASIGNACION DE POZOS', '2025-03-23 00:00:00', '2025-04-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(12, 41, '2025-04-09', '36.11', '50.67', 'No hay plan establecido', '2025-03-31 00:00:00', '2025-04-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(13, 44, '2025-04-09', '84.62', '69.23', 'No hay plan establecido', '2025-03-30 00:00:00', '2025-04-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(14, 48, '2025-04-09', '7.69', '8.55', 'No hay plan establecido y no tiene acta de inicio', '2025-03-02 00:00:00', '2025-03-29 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(15, 48, '2025-04-09', '10.26', '10.26', 'No hay plan establecido y no tiene acta de inicio', '2025-03-30 00:00:00', '2025-04-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(16, 43, '2025-04-09', '16.67', '38.24', 'No hay plan establecido', '2025-03-30 00:00:00', '2025-04-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(17, 42, '2025-04-09', '52.08', '60', 'No hay plan establecido', '2025-03-09 00:00:00', '2025-03-29 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(18, 42, '2025-04-09', '86.81', '100', 'No hay plan establecido', '2025-03-30 00:00:00', '2025-04-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(19, 45, '2025-04-10', '53.21', '87.5', 'No hay plan establecido', '2025-03-28 00:00:00', '2025-04-28 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(20, 44, '2025-04-25', '92.31', '80.77', 'No hay plan establecido', '2025-04-14 00:00:00', '2025-04-20 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(21, 48, '2025-04-25', '13.68', '13.68', 'No hay plan establecido', '2025-04-14 00:00:00', '2025-04-20 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(22, 45, '2025-04-25', '57.19', '91.67', 'No hay plan establecido', '2025-04-14 00:00:00', '2025-04-20 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(23, 52, '2025-04-25', '4.6', '22.61', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-25 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(24, 50, '2025-04-25', '15.06', '17.06', 'No hay plan establecido', '2025-04-14 00:00:00', '2025-04-20 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(25, 45, '2025-05-03', '69.71', '100', 'No hay plan establecido', '2025-04-21 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(26, 50, '2025-05-03', '19.18', '22.75', 'No hay plan establecido', '2025-04-21 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(27, 51, '2025-05-03', '4.5', '4', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(28, 52, '2025-05-03', '4.6', '31.75', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(29, 41, '2025-05-03', '36.11', '62.22', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(30, 44, '2025-05-03', '96.15', '84.62', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(31, 43, '2025-05-03', '22.22', '47.06', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(32, 48, '2025-05-03', '15.38', '15.38', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-04-27 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(33, 51, '2025-05-08', '8', '12', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(34, 45, '2025-05-08', '71.87', '100', 'No hay plan establecido', '2025-04-22 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(35, 52, '2025-05-08', '5', '42.21', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(36, 50, '2025-05-08', '26.73', '30.01', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(37, 43, '2025-05-08', '27.78', '58.82', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(38, 48, '2025-05-08', '16.24', '17.09', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(39, 44, '2025-05-08', '96.15', '84.62', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(40, 41, '2025-05-08', '36.67', '66.11', 'No hay plan establecido', '2025-04-28 00:00:00', '2025-05-06 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(41, 52, '2025-05-14', '9', '49.55', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(42, 45, '2025-05-14', '78.87', '100', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(43, 50, '2025-05-14', '32.93', '35.51', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(44, 51, '2025-05-14', '14.9', '19', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(45, 43, '2025-05-14', '27.78', '64.71', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(46, 48, '2025-05-14', '17.95', '18.8', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(47, 44, '2025-05-14', '96.15', '92.31', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(48, 44, '2025-05-14', '96.15', '92.31', 'No hay plan establecido', '2025-05-07 00:00:00', '2025-05-13 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(49, 45, '2025-05-25', '84.47', '100', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(50, 50, '2025-05-25', '35.55', '41.2', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(51, 51, '2025-05-25', '22.3', '27', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(52, 52, '2025-05-25', '16', '55.73', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(53, 41, '2025-05-25', '42.78', '73.89', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(54, 44, '2025-05-25', '96.15', '98.08', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(55, 48, '2025-05-25', '21.37', '20.51', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(56, 43, '2025-05-25', '33.33', '67.65', 'No hay plan establecido', '2025-05-14 00:00:00', '2025-05-21 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(57, 46, '2025-05-29', '80', '100', 'Se culmino con la fabricación , sandblasting y pintura de los 50 atracaderos que fueron entregados para fabricación, distribuidos en ( 30 atracaderos Monopilote y 20 atracaderos tipo FDB); los cuales fueron inspeccionados y liberados por el Cliente.', '2025-02-17 00:00:00', '2025-03-17 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(58, 41, '2025-06-02', '46.11', '81.67', 'No hay plan establecido', '2025-05-26 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(59, 43, '2025-06-02', '44.44', '76.47', 'No hay plan establecido', '2025-05-26 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(60, 48, '2025-06-02', '24.79', '23.93', 'No hay plan establecido', '2025-05-26 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(61, 50, '2025-06-02', '44.95', '51.01', 'No hay plan establecido', '2025-05-26 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(62, 51, '2025-06-02', '33.5', '40', 'No hay plan establecido', '2025-05-26 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(63, 52, '2025-06-02', '18.5', '66.3', 'No hay plan establecido', '2025-05-26 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `avance_fisico` (`id`, `id_proyecto`, `fecha`, `avance_real`, `avance_planificado`, `puntos_atencion`, `fecha_inicio`, `fecha_fin`) VALUES
(64, 54, '2025-06-02', '2.8', '1', 'No hay plan establecido', '2025-05-27 00:00:00', '2025-06-01 00:00:00');
INSERT INTO `clientes` (`id`, `nombre`, `email`, `telefono`, `direccion`, `unidad_negocio`, `razon_social`, `nombre_comercial`, `direccion_fiscal`, `pais`, `id_region`) VALUES
(15, 'SDO', NULL, NULL, NULL, 'Perforación ', 'J-401574297', 'Suministro y Sergio sol de oriente', 'Av. Principal de lechería centro empresarial la cascada nivel 3 local G-N3-01,02,03 zona la cascada lecheria estado Anzoátegui ', 'Venezuela', 3);
INSERT INTO `clientes` (`id`, `nombre`, `email`, `telefono`, `direccion`, `unidad_negocio`, `razon_social`, `nombre_comercial`, `direccion_fiscal`, `pais`, `id_region`) VALUES
(16, 'TIA JUANA INVESTMENTS, C.A', 'Luisvasquez-occidente@business.com', NULL, 'AV ARAURE CON CALLES LAS LOMAS Y RORARIMA QTA MARURA URB CHUAO  CARACAS MIRANDA ZONA POSTAL 1080', 'PETROLEO', 'PETROLEO ', 'TIA JUANA INVESTMENTS, C.A', 'AV ARAURE CON CALLES LAS LOMAS Y RORARIMA QTA MARURA URB CHUAO  CARACAS MIRANDA ZONA POSTAL 1080', 'Venezuela', 2);
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(17, 53, '2025-04-10', '436400.00', '0.00', '2025-02-10 00:00:00', '2025-02-10 00:00:00', 4, NULL, '436400.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(18, 53, '2025-04-10', '90432.10', '0.00', '2025-02-27 00:00:00', '2025-02-27 00:00:00', 4, NULL, '90432.10');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(19, 53, '2025-04-10', '336168.27', '0.00', '2025-03-12 00:00:00', '2025-03-12 00:00:00', 4, NULL, '336168.27');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(20, 46, '2025-04-10', '74203.75', '0.00', '2025-02-17 00:00:00', '2025-03-02 00:00:00', 6, NULL, '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(21, 46, '2025-04-10', '74203.75', '0.00', '2025-03-03 00:00:00', '2025-03-17 00:00:00', 6, NULL, '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(22, 41, '2025-04-20', '45945.00', '0.00', '2025-01-05 00:00:00', '2025-01-15 00:00:00', 5, 'VALUACION 1', '13784.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(23, 41, '2025-04-20', '61248.07', '0.00', '2025-01-16 00:00:00', '2025-01-31 00:00:00', 5, 'VALUACION 2', '18374.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(24, 41, '2025-04-20', '62239.00', '0.00', '2025-02-01 00:00:00', '2025-02-16 00:00:00', 5, 'VALUACION 3', '18672.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(25, 44, '2025-04-20', '106215.47', '0.00', '2024-12-03 00:00:00', '2024-12-16 00:00:00', 5, 'VALUACION 1', '31865.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(26, 44, '2025-04-20', '133206.43', '0.00', '2024-12-17 00:00:00', '2025-01-01 00:00:00', 5, 'VALUACION 2', '39962.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(27, 44, '2025-04-20', '120676.86', '0.00', '2025-01-02 00:00:00', '2025-01-15 00:00:00', 5, 'VALUACION 3', '36203.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(28, 44, '2025-04-20', '145398.39', '0.00', '2025-01-16 00:00:00', '2025-01-31 00:00:00', 5, 'VALUACION 4', '43620.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(29, 44, '2025-04-20', '141521.42', '0.00', '2025-02-01 00:00:00', '2025-02-15 00:00:00', 5, 'VALUACION 5', '42456.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(30, 44, '2025-04-20', '13655.60', '0.00', '2025-03-03 00:00:00', '2025-03-30 00:00:00', 4, 'VALUACION REEMBOLSABLE', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(31, 44, '2025-04-20', '121013.00', '0.00', '2025-02-16 00:00:00', '2025-03-02 00:00:00', 5, 'VALUACION 6', '36304.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(32, 44, '2025-04-20', '110371.92', '0.00', '2025-03-02 00:00:00', '2025-03-15 00:00:00', 5, 'VALUACION 7', '33112.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(33, 44, '2025-04-20', '142783.96', '0.00', '2025-03-15 00:00:00', '2025-03-30 00:00:00', 5, 'VALUACION 8', '42835.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(34, 43, '2025-04-20', '210160.80', '0.00', '2025-02-05 00:00:00', '2025-03-07 00:00:00', 5, 'VALUACION 1', '52540.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(35, 43, '2025-04-20', '212222.20', '0.00', '2025-02-21 00:00:00', '2025-03-07 00:00:00', 5, 'VALUACION 2', '53056.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(36, 43, '2025-04-20', '161701.55', '0.00', '2025-03-07 00:00:00', '2025-03-29 00:00:00', 5, 'VALUACION 3', '40425.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(37, 45, '2025-04-21', '33840.00', '0.00', '2025-01-22 00:00:00', '2025-02-20 00:00:00', 5, 'VALUACION 1', '12859.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(38, 45, '2025-04-21', '102249.00', '0.00', '2025-01-28 00:00:00', '2025-02-15 00:00:00', 5, 'VALUACION 1 PRUEBA POZO', '38855.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(39, 45, '2025-04-21', '27990.00', '0.00', '2025-02-21 00:00:00', '2025-03-20 00:00:00', 5, 'VALUACION 2 PRUEBA DE NIVEL', '10636.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(40, 45, '2025-04-21', '35769.75', '0.00', '2025-02-16 00:00:00', '2025-02-28 00:00:00', 5, 'VALUACION 2 PRUEBA DE POZO', '13593.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(41, 45, '2025-04-21', '50436.55', '0.00', '2025-03-01 00:00:00', '2025-03-14 00:00:00', 5, 'VALUACION 3 PRUEBA POZO', '19166.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(42, 45, '2025-04-21', '63640.00', '0.00', '2025-03-15 00:00:00', '2025-03-30 00:00:00', 5, 'VALUACION 4 PRUEBA POZO', '24183.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(43, 48, '2025-04-21', '153712.00', '0.00', '2025-03-01 00:00:00', '2025-03-15 00:00:00', 5, 'VALUACION 1', '46113.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(44, 48, '2025-04-21', '75624.00', '0.00', '2025-03-15 00:00:00', '2025-03-31 00:00:00', 5, 'VALUACION 2', '22687.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(45, 42, '2025-04-21', '242970.03', '0.00', '2025-03-21 00:00:00', '2025-03-21 00:00:00', 4, 'VALUACION 1', '121485.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(46, 42, '2025-04-21', '191222.90', '0.00', '2025-03-19 00:00:00', '2025-03-19 00:00:00', 4, 'VALUACION 1 MGGV', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(47, 42, '2025-04-21', '218320.08', '0.00', '2025-03-26 00:00:00', '2025-03-26 00:00:00', 4, 'VALUACION 2 MGGV', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(48, 42, '2025-04-21', '101878.00', '0.00', '2024-12-03 00:00:00', '2024-12-18 00:00:00', 4, 'VALUACION 1 NITOR', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(49, 42, '2025-04-21', '690000.00', '0.00', '2025-03-13 00:00:00', '2025-03-17 00:00:00', 4, 'VALUACION 2 NITOR', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(50, 42, '2025-04-21', '126995.00', '0.00', '2025-01-18 00:00:00', '2025-02-16 00:00:00', 4, 'VALUACION 3 NITOR', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(51, 42, '2025-04-21', '44491.00', '0.00', '2025-03-16 00:00:00', '2025-03-31 00:00:00', 4, 'VALUACION 4 NITOR', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(52, 42, '2025-04-21', '10000.00', '0.00', '2025-03-04 00:00:00', '2025-03-04 00:00:00', 4, 'VALUACION 1 TECNOLE', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(53, 42, '2025-04-21', '337142.67', '0.00', '2025-03-13 00:00:00', '2025-03-13 00:00:00', 4, 'VALUACION 2 TECNOLE', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(54, 41, '2025-04-26', '52231.54', '0.00', '2025-03-01 00:00:00', '2025-03-15 00:00:00', 5, 'VALUACION 5', '15669.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(55, 44, '2025-04-26', '112159.00', '0.00', '2025-03-31 00:00:00', '2025-04-14 00:00:00', 5, 'VALUACION 9', '33648.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(56, 44, '2025-04-26', '4840.80', '0.00', '2025-03-01 00:00:00', '2025-03-31 00:00:00', 4, 'VALUACION REEMBOLSABLE II', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(57, 44, '2025-04-26', '9217.30', '0.00', '2025-03-31 00:00:00', '2025-04-14 00:00:00', 4, 'VALUACION REEMBOLSABLE III', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(58, 44, '2025-04-26', '2258.20', '0.00', '2025-02-11 00:00:00', '2025-03-02 00:00:00', 4, 'VALUACION REEMBOLSABLE VI', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(59, 44, '2025-04-26', '6764.00', '0.00', '2025-02-28 00:00:00', '2025-02-28 00:00:00', 5, 'VALUACION 1 TECNOLE', '2029.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(60, 44, '2025-04-26', '7486.00', '0.00', '2025-01-16 00:00:00', '2025-03-07 00:00:00', 5, 'VALUACION 2 TECNOLE', '2246.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(61, 44, '2025-04-26', '7600.00', '0.00', '2025-03-08 00:00:00', '2025-03-12 00:00:00', 5, 'VALUACION 3 TECNOLE', '2280.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(62, 44, '2025-04-26', '15920.00', '0.00', '2025-03-10 00:00:00', '2025-03-14 00:00:00', 5, 'VALUACION 4 TECNOLE', '4776.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(63, 44, '2025-04-26', '2870.00', '0.00', '2025-03-13 00:00:00', '2025-03-14 00:00:00', 5, 'VALUACION 5 TECNOLE', '861.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(64, 44, '2025-04-26', '6270.00', '0.00', '2025-03-29 00:00:00', '2025-04-05 00:00:00', 5, 'VALUACION 6 TECNOLE', '1881.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(65, 44, '2025-04-26', '16252.00', '0.00', '2025-04-06 00:00:00', '2025-04-09 00:00:00', 5, 'VALUACION 7 TECNOLE', '4876.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(66, 44, '2025-04-26', '3724.00', '0.00', '2025-04-14 00:00:00', '2025-04-17 00:00:00', 5, 'VALUACION 8 TECNOLE', '1117.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(67, 44, '2025-04-26', '9282.00', '0.00', '2025-04-20 00:00:00', '2025-04-21 00:00:00', 5, 'VALUACION 9 TECNOLE', '2785.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(68, 49, '2025-04-26', '39903.06', '0.00', '2025-03-05 00:00:00', '2025-03-05 00:00:00', 4, 'VALUACION 1 ALPRO', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(69, 49, '2025-04-26', '58281.96', '0.00', '2025-03-05 00:00:00', '2025-03-05 00:00:00', 4, 'VALUACION 2 ALPRO', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(70, 49, '2025-04-26', '116563.92', '0.00', '2025-03-05 00:00:00', '2025-03-05 00:00:00', 4, 'VALUACION 3 ALPRO', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(71, 41, '2025-05-14', '29939.66', '0.00', '2025-02-16 00:00:00', '2025-02-28 00:00:00', 5, 'VALUACION 4', '8982.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(72, 41, '2025-05-14', '48056.00', '0.00', '2025-03-16 00:00:00', '2025-03-30 00:00:00', 5, 'VALUACION 6', '14417.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(73, 41, '2025-05-16', '37676.00', '0.00', '2025-05-21 00:00:00', '2025-05-22 00:00:00', 5, '0001', '11303.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(74, 41, '2025-05-27', '0.01', '0.00', '2025-01-05 00:00:00', '2025-01-15 00:00:00', 4, 'VALUACION 1', '0.01');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(75, 41, '2025-05-27', '0.01', '0.00', '2025-01-15 00:00:00', '2025-01-31 00:00:00', 5, 'VALUACION 2', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(76, 41, '2025-05-27', '0.10', '0.00', '2025-02-01 00:00:00', '2025-02-15 00:00:00', 5, 'VALUACION 3', '0.10');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(77, 41, '2025-05-27', '25881.00', '0.00', '2025-04-16 00:00:00', '2025-05-01 00:00:00', 5, 'VALUACION 8', '7764.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(78, 44, '2025-05-28', '90422.00', '0.00', '2025-04-15 00:00:00', '2025-04-30 00:00:00', 5, 'VALUACION 10', '27126.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(79, 44, '2025-05-28', '5595.00', '0.00', '2025-05-01 00:00:00', '2025-05-02 00:00:00', 5, 'VALUACION 11', '1679.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(80, 44, '2025-05-28', '4104.00', '0.00', '2025-04-22 00:00:00', '2025-04-23 00:00:00', 5, 'VALUACION 10 TECNOLE', '1231.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(81, 44, '2025-05-28', '5928.00', '0.00', '2025-04-24 00:00:00', '2025-04-25 00:00:00', 5, 'VALUACION 11 TECNOLE', '1778.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(82, 44, '2025-05-28', '3159.00', '0.00', '2025-04-15 00:00:00', '2025-04-30 00:00:00', 4, 'VALUACION REEMBOLSABLE V', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(83, 48, '2025-05-28', '107793.66', '0.00', '2025-03-31 00:00:00', '2025-04-16 00:00:00', 5, 'VALUACION 3', '32338.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(84, 48, '2025-05-28', '95817.36', '0.00', '2025-04-16 00:00:00', '2025-04-29 00:00:00', 5, 'VALUACION 4', '28745.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(85, 43, '2025-05-28', '189494.00', '0.00', '2025-04-10 00:00:00', '2025-04-26 00:00:00', 5, 'VALUACION 4', '47373.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(86, 43, '2025-05-28', '282438.02', '0.00', '2025-03-07 00:00:00', '2025-03-29 00:00:00', 5, 'VALUACION 2 A', '70610.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(87, 51, '2025-05-28', '26049.00', '0.00', '2025-04-22 00:00:00', '2025-04-30 00:00:00', 5, 'VALUACION 1', '4949.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(88, 51, '2025-05-28', '63769.20', '0.00', '2025-05-01 00:00:00', '2025-05-18 00:00:00', 5, 'VALUACION 2', '12116.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(89, 52, '2025-05-28', '23627.75', '0.00', '2025-04-03 00:00:00', '2025-04-17 00:00:00', 5, 'VALUACION 1', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(90, 52, '2025-05-28', '20508.00', '0.00', '2025-04-17 00:00:00', '2025-05-17 00:00:00', 5, 'VALUACION 2', '0.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(91, 45, '2025-05-28', '51430.00', '0.00', '2025-04-01 00:00:00', '2025-04-15 00:00:00', 5, 'VALUACION 5', '19543.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(92, 50, '2025-05-28', '71086.28', '0.00', '2025-04-03 00:00:00', '2025-04-15 00:00:00', 5, 'VALUACION 1', '17061.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(93, 50, '2025-05-28', '83316.48', '0.00', '2025-04-15 00:00:00', '2025-04-30 00:00:00', 5, 'VALUACION 2', '19996.00');
INSERT INTO `costos_proyectos` (`id`, `id_proyecto`, `fecha`, `costo`, `monto_sobrepasado`, `fecha_inicio`, `fecha_fin`, `id_estatus`, `numero_valuacion`, `amortizacion`) VALUES
(94, 50, '2025-05-28', '79229.90', '0.00', '2025-05-01 00:00:00', '2025-05-15 00:00:00', 5, 'VALUACION 3', '19015.00');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(1, 'Alcance Recibido.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(2, 'Proceso de Planificación y Costos.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(3, 'Negociación.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(4, 'Oferta entregada.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(5, 'Adjudicación.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(6, 'Firma del contrato.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(7, 'Negociación Anticipo.');
INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(8, 'Acta Inicio.');
INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(1, 'En Elaboración de Valuación', 'El proceso está en la fase inicial de elaboración.', '2025-02-10 16:55:47', 1);
INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(2, 'En Revisión por el Cliente', 'El cliente está revisando la valuación.', '2025-02-10 16:55:47', 1);
INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(3, 'Valuación Aprobada', 'La valuación ha sido aprobada por el cliente.', '2025-02-10 16:55:47', 1);
INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(4, 'Por Valuar', 'aluar implica evaluar el valor de un bien o activo de manera objetiva y precisa, utilizando métodos y técnicas específicas según el contexto', '2025-02-11 18:11:48', 1);
INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(5, 'Por Facturar', 'El proceso está listo para ser facturado.', '2025-02-10 16:55:47', 1);
INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(6, 'Facturado', 'El proceso ha sido facturado completamente.', '2025-02-10 16:55:47', 1);
INSERT INTO `estatus_proveedor` (`id`, `nombre_completo`, `nombre_abreviado`, `descripcion`, `color`, `created_at`, `updated_at`) VALUES
(1, 'Apto', 'APT', 'Proveedor cumple con todos los requisitos', '#28a745', '2025-05-06 19:04:07', '2025-05-06 19:04:07');
INSERT INTO `estatus_proveedor` (`id`, `nombre_completo`, `nombre_abreviado`, `descripcion`, `color`, `created_at`, `updated_at`) VALUES
(2, 'No Apto', 'N-APT', 'Proveedor no cumple con los requisitos mínimos', '#dc3545', '2025-05-06 19:04:07', '2025-05-06 19:04:07');
INSERT INTO `estatus_proveedor` (`id`, `nombre_completo`, `nombre_abreviado`, `descripcion`, `color`, `created_at`, `updated_at`) VALUES
(3, 'Con Observaciones', 'OBS', 'Proveedor cumple parcialmente con los requisitos', '#ffc107', '2025-05-06 19:04:07', '2025-05-06 19:04:07');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(1, 'ARTIFICIAL LIFT PRODUCTION DE VENEZUELA (ALPRO), C.A.', 'AV. JORGE RODRIGUEZ, EDIF. DECO HOTEL & SPA. PISO PB LOCAL 3, SECTOR LAS GARSAS, LECHERIAS, ESTADO ANZOATEGUI', 'Venezuela', '04148101049', 'marcos.dias@alpro1.com', 'J-40871654-2', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(2, 'RIHERCA', 'POR INDICAR', 'Venezuela', 'POR INDICAR', 'POR INDICAR', 'POR INDICAR', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(3, 'B&D CONSULTING 11.11, C.A.', 'CALLE 137 LOS PARDILLOS Y AV. TERCERA, MANZANA NRO. 02 LOCAL NRO 90-201 URB EL TRIGAL SUR VALENCIA CARABOBO', 'Venezuela', 'POR INDICAR', 'POR INDICAR', 'J-50457559-3', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(4, 'EOS', 'POR INDICAR', 'Venezuela', 'POR INDICAR', 'POR INDICAR', 'POR INDICAR', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(5, 'INGENIERIA MECACIV CA', 'CALLE MANZANA E7-1 CC LOMAS DE LA ESMERALDA ETAPA 1 MODULO 3 NIVEL NIVEL - LOCAL COMERCIAL 2-21 URB PARQUE RESIDENCIAL LA ESMERALDA, SAN DIEGO VALENCIA CARABOBO ZONA POSTAL 2005', 'Venezuela', 'POR INDICAR', 'POR INDICAR', 'J-31034404-3', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(6, 'TRIDENT SERVICE, C.A', 'Av. José Antonio Anzoátegui, Local S/N. Urb. Campo Duarte, Anaco Estado Anzoátegui, Zopa Postal 6003 ', 'Venezuela', '0424-6459320', 'POR INDICAR', 'J-50119818-7', 1, '2025-05-13 14:32:14', '2025-05-28 12:35:05');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(7, 'GLOBAL', 'POR INDICAR', 'Venezuela', 'POR INDICAR', 'POR INDICAR', 'POR INDICAR', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(8, 'TECNOLE', 'POR INDICAR', 'Venezuela', 'POR INDICAR', 'POR INDICAR', 'POR INDICAR', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(9, 'FOSHAN BUSINESS AND DEVELOPMENT ALLY CO., LTD', 'STORE 105, BUILDING 13, GUANGDONG ZHONGSHI COMMODITY CITY, NO.43, PINGDI ROAD SOUTH, DALI TOWN, NANHAI DISTRICT, FOSHAN CITY', 'CHINA', '+86 15915883084', 'supportasia@businessdally.com', '91440605MADOM HBV54', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(10, 'RUBLOCA CONSTRUCTORA, C.A', 'CALLE AYACUCHO NRO 98 MARACAY ESTADO ARAGUA ZONA POSTAL 2104', 'VENEZUELA', '024312345', 'constructora@rubloca.com', 'J-30144175-3', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(11, 'EVANCEN PETROCHEMICAL SUPPLIES, C.A', 'AV. EL PAUJI, C.C.GALERIAS LOS NARANJOS NIVEL 3 OFIC 83 URB. LOS NARANJOS, CARACAS', 'VENEZUELA', '0212-9352158', 'legal@evacen.com', 'J-40856946-9', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(12, 'EVANCEN PETROCHEMICAL SUPPLIES, C.A', 'AV. EL PAUJI, C.C.GALERIAS LOS NARANJOS NIVEL 3 OFIC 83 URB. LOS NARANJOS, CARACAS', 'VENEZUELA', '0212-9352158', 'legal@evacen.com', 'J-40856946-9', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(13, 'LANDERCOPY DIGITAL, C.A', 'CALLE AGUSTIN CODAZZI ENTRE AV. TERESA DE LA PARRA Y ARTURO MICHELENA QUINTA NEOLISA PB LOCAL 1 URB. SANTA MONICA CARACAS', 'VENEZUELA', '0212-4171288', 'info@landercopy.com', 'J-40805545-7', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(14, 'MGGV INGENIERIA, C.A', 'AV.CIRCUNVALACION DEL SOL C.C CENTRO PROFESIONAL SANTA PAULA, NIVEL 8, OF 84, URB. SANTA PAULA CARACAS (EL CAFETAL) MIRANDA ZONA POSTAL 1061', 'VENEZUELA', '0414-8101049', 'mggving@gmail.com', 'J-31457111-7', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(15, 'CONSTRUCCIONES Y SERVICIOS RR 413, C.A', 'AV. FUERZAS ARMADAS, CON CALLE RICAURTE C.C VEGA DEL NEVERI, NIVEL PB. LOCAL L3 URB. LOS JARDINES DE BARCELONA ANZOATEGUI ZONA POSTAL 6001', 'VENEZUELA', '0414-8101049', 'yasmin.rodriguez@construccionesrrca.com', 'J-40668648-4', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(16, 'NITOR METAL, S.A', 'AVENIDA LOS PILONES, SECTOR LA FLORIDA, PATIO NITOR, ANACO ESTADO ANZOATEGUI', 'VENEZUELA', '0414-8380503', 'tulio.weber@gmail.com', 'J-30284471-1', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(17, 'MUDVEN, C.A', 'EDIF.CENTRO PROFESIONAL DAVIS, PISO 3 OFICINA 19, AV. ALIRIO UGARTE PELAYO, FRENTE E/S MONAGAS MATURIN ESTADO MONAGAS ZONA POSTAL 6201', 'VENEZUELA', '0424-9165708', 'rcargnel@mudven.com', 'J-40362525-5', 1, '2025-05-13 14:32:14', '2025-05-13 14:32:14');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(18, 'INVERSIONES HELP COMPUTER, C.A', 'Av. Francisco de Miranda, Multicentro Empresarial del Este, Edif. Miranda, Nucleo A, PB, Local 12. Chacao', 'Venezuela', '0414-2319559', 'mifuturopc@hotmail.com', 'J-31330456-5', 1, '2025-05-27 18:23:21', '2025-05-27 18:23:21');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(19, 'INVERSIONES HELP COMPUTER, C.A', 'Av. Francisco de Miranda, Multicentro Empresarial del Este, Edif. Miranda, Nucleo A, PB, Local 12. Chacao', 'Venezuela', '0414-2319559', 'mifuturopc@hotmail.com', 'J-31330456-5', 1, '2025-05-27 18:24:28', '2025-05-27 18:24:28');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(20, 'BIENES RAICES BUSINESS, C.A', 'Calle 137 Los Pardillos, Local Nro 90-201, Urb. El Trigal Sur, Manzana 2, Valencia Estado Carabobo', 'Venezuela', '0424-6180221', 'bpropertiesinmobiliaria@gmail.com', 'J-50577199-0', 1, '2025-05-27 18:33:49', '2025-05-27 18:33:49');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(21, 'PROYECCION Y DESARROLLO, C.A', 'Av. Fernando Peñalver, C.C Las Palmeras, Local Nro 11, Diagonal al terminal de pasajeros de Piritu, Piritu Estado Anzoategui', 'Venezuela', '0281-4412384', 'proyeccionydesarrollo@gmail.com', 'J-40002755-1', 1, '2025-05-27 18:38:53', '2025-05-27 18:38:53');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(22, 'TRANSPORTE Y SERVICIO CORPORIENTE, C.A', 'Calle San Miguel, Local Nro 23, Sector el Tanque, Parroquia la Sabanita, Ciudad Bolivar Estado Bolivar', 'Venezuela', '0424-8446386', 'Pendiente', 'J-41288111-6', 1, '2025-05-27 19:10:31', '2025-05-27 19:10:31');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(23, 'YORVIS RAFALE ACOSTA PALENCIA', 'Calle Principal Casa Nro 28, Conjunto Residencial Puinare las Isletas, Puerto Piritu Estado Anzoategui ', 'Venezuela', 'Pendiente', 'Pendiente', 'V-12373374-2', 1, '2025-05-27 19:15:59', '2025-05-27 19:15:59');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(24, 'SERVINTSA COMERCIAL, C.A', 'Av. Final Jose Antonio Anzoategui, Edif Andinas, piso 01, local PB1 Sector Crucero de los Muertos, Anaco Estado Anzoatequi', 'Venezuela', '0282-4246741', 'Pendiente', 'J-31356785-0', 1, '2025-05-27 19:34:44', '2025-05-27 19:34:44');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(25, 'SCRAP GLOBAL METAL, C.A', 'Av. Final, Av. Bolivar Sexta, Calle Quinta San Judas Tadeo, Urb. Colinas de Valle Seco, Puerto Cabello Estado Carabobo', 'Venezuela', '0412-1999890', 'Pendiente', 'J-50082210-3', 1, '2025-05-27 19:46:52', '2025-05-27 19:46:52');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(26, 'PRISMI ELECTRIC DE VZLA, C.A', 'Av. Francisco de Miranda, Local 156, El Tigre Estado Anzoategui', 'Venezuela', '0412-9469655', 'prismielectricdevzla@gmail.com', 'J-50044271-8', 1, '2025-05-27 19:51:27', '2025-05-27 19:51:27');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(27, 'MIBRA GROUP 2022, C.A', 'Caracas ', 'Venezuela', '0414-4711773', 'Pendiente', 'J-50315996-0', 1, '2025-05-27 19:56:20', '2025-05-27 19:56:20');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(28, 'ELECTRONICA LA GLORIA, C.A', 'Av. Francisco de Miranda con Calle 13 Sur, Edif H.H.W Piso PB, Oficina2 06 Sector Pueblo Nuevo Sur, El Tigre Estado Anzoategui', 'Venezuela', '0424-8646240', 'Pendiente', 'J-29722702-4', 1, '2025-05-27 19:59:50', '2025-05-27 19:59:50');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(29, 'JULIO CESAR SANABRIA', 'Calle no tiene, Edif 10, Piso PB, Apto D. Urb. Ciudad Casarapa, Caracas', 'Venezuela', '0424-1826125', 'Pendiente', 'V-23184977-3', 1, '2025-05-27 20:02:59', '2025-05-27 20:02:59');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(30, 'ARENERA JD, C.A', 'Av. Fernando Padilla Local Galpon S/N Sector Cruz de Belen, Ciudad Clarines Estado Anzoategui', 'Venezuela', '0414-0840729', 'areneramatiyure@gmail.com', 'J-41116480-8', 1, '2025-05-27 20:11:43', '2025-05-27 20:11:43');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(31, 'COMERCIALIZADORA IMPORT 21, C.A', 'Av. Intercomunal Don Julio Centeno entre calle L y calle K, Local L2. Urb. Bosqueserino San Diego Estado Carabobo', 'Venezuela', '0424-4968931', 'comercializadoraimportml@gmail.com', 'J-40657664-4', 1, '2025-05-27 20:15:51', '2025-05-27 20:15:51');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(32, 'OAMED, C.A', 'Calle Ppal Poblado de San Diego, Campo Resid Edif 45 Piso 6, Apto 4562, Sector 7 Etapa 6, Municipio San Diego Estado Carabobo', 'Venezuela', '0414-5972341', 'Pendiente', 'J-50081904-8', 1, '2025-05-27 20:19:53', '2025-05-27 20:19:53');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(33, 'SUPPLIES CX3, C.A', 'Calle Cambural, Casa Nro 6, Sector Los Pilones, Central Tacarigua Estado Carabobo', 'Venezuela', '0416-6402777', 'inversioneslos3@hotmail.com', 'J-50380097-6', 1, '2025-05-27 20:26:10', '2025-05-27 20:26:10');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(34, 'SERVICIOS Y SOLUCIONES API, C.A', 'Calle Neveri Local Nro 3-60. Urb. El Morro II, Lecherias Estado Anzoategui', 'Venezuela', 'Pendiente', 'Pendiente', 'J-50359956-1', 1, '2025-05-27 20:33:10', '2025-05-27 20:33:10');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(35, 'CORP UNIVERSAL TECNOLOGHY XXI, C.A', 'Av. Abraham Lincolm con calle Union y Villaflor, C.C City Market nivel feria local 341-345 Urb. Sabana Grande Caracas ', 'Venezuela', '0412-2059412', 'Pendiente', 'J-40501969-7', 1, '2025-05-28 12:45:20', '2025-05-28 12:45:20');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(36, 'INVERSIONES TELESHOES, C.A', 'Caracas', 'Venezuela', '0414-3044321', 'Pendiente', 'J-31650590-1', 1, '2025-05-28 12:47:48', '2025-05-28 12:47:48');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(37, 'PROSEIN, PROVEEDURIA Y SERVICIOS INDUSTRIAL, C.A', 'Av. Sanatorio Avila, C.C Ciudad Center Nivel A-1, Nivel PB, Local 1-A1. Urb. Boleita Norte Caracas', 'Venezuela', '0412-3773822', 'Pendiente', 'J-00141771-0', 1, '2025-05-28 12:54:11', '2025-05-28 12:54:11');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(38, 'DIEGO EDUARDO ESTE RODRIGUEZ (SERVICIO AMBULANCIA)', 'Calle la Esperanza, Sector los Jobillotes Pariaguan Estado Anzoátegui', 'Venezuela', '0424-8483982', 'Pendiente', 'V-13751887-9', 1, '2025-05-28 13:46:45', '2025-05-28 13:46:45');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(39, 'ALOISE MARCANO (SERVICIO AMBULANCIA)', 'Vereda 17, Casa Nro 12. Urb. Antonio Pinto Salinas, Pariaguan Estado Anzoategui', 'Venezuela', '0412-0861832', 'Pendiente', 'V-15845322-0', 1, '2025-05-28 13:50:02', '2025-05-28 13:50:02');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(40, 'NORELYS DEL CARMEN PINO DELGADO (SERVICIO DE COMIDAS)', 'Carretera Nacional San Diego- Mapire, Casa N° 6, Sector la Torre,  San Diego de Cabrutica Estado Anzoategui', 'Venezuela', '0414-7964973', 'Pendiente', 'V-12438330-3', 1, '2025-05-28 13:55:38', '2025-05-28 13:55:38');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(41, 'SENIOR DE ORIENTE, C.A', 'Av. Jose Antonio Anzoategui, Calle Manaure, Casa Nro 3, Sector Santa Rosa II, Puerto Piritu Estado Anzoategui', 'Venezuela', '04128774742', 'seniordeoriente@gmail.com', 'J-40181357-7', 1, '2025-05-28 14:03:39', '2025-05-28 14:03:39');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(42, 'DAGMAR AIMED RIVERA APONTE (STARLINK POWER)', 'Calle Eloy Brito, Casa Antonella Sector la Union Caracas (El Hatillo Miranda)', 'Venezuela', '0412-9341029', 'Pendiente', 'V-15175178-0', 1, '2025-05-28 14:10:08', '2025-05-28 14:10:08');
INSERT INTO `proveedores` (`id`, `nombre_comercial`, `direccion_fiscal`, `pais`, `telefono`, `email`, `RIF`, `estatus_id`, `created_at`, `updated_at`) VALUES
(43, 'JONY GEORGES ZIADE EL JAWICHE', 'Av. Urdaneta Edif Doral Centro, Torre A, Piso 9, Apto 92 Urb. la Candelaria Caracas', 'Venezuela', '0414-2334352', 'jonyziade5@gmail.com', 'V-20802678-9', 1, '2025-05-28 14:14:07', '2025-05-28 14:14:07');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(41, 'OR01', 'SERVICIOS MENORES PARA RECUPERACIÓN DE PRODUCCIÓN CON TALADROS DE 150 HP EN CAMPO ZUATA, PETROLERA RORAIMA, S.A.', 15, 2, 3, NULL, '755250.00', '1559066.58', '2025-01-05', '2025-07-03', 179, 1, 'Taladro 150 Hp (SDO-01)', '(ODS 09) 5C-197-002-D-24-N-0011', 8, '1559067', NULL, 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(42, 'OR04', 'SERVICIO INTEGRAL PARA LA INSTALACIÓN DE SISTEMAS DE LEVANTAMIENTO ARTIFICIAL PARA LA RECUPERACIÓN DE PRODUCCIÓN DIFERIDA EN POZOS DEL CAMPO ZUATA DE LA EM PETROLERA RORAIMA, S. A', 15, 2, 3, NULL, '4559700.74', '7584608.51', '2024-12-03', '2025-03-03', 90, 1, 'LEVANTAMIENTO ARTIFICIAL', '(ODS 16)', 8, '7584609', NULL, 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(43, 'OR03', 'SERVICIOS MAYORES PARA RECUPERACION DE PRODUCCION CON TALADROS DE 550 HP EN LOS POZOS EM PETROLERA RORAIMA.', 15, 2, 3, NULL, '2700204.59', '3950007.45', '2025-01-05', '2025-07-03', 179, 1, 'Taladro 550 Hp (SDO-03)', '(ODS 19) 5C-197-002-D-24-N-0021', 8, NULL, '3950007', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(44, 'OR02', 'SERVICIO INTEGRAL DE UN TALADRO TIPO CABILLERO DE 350 HP PARA SERVICIOS A  POZOS A SER TRABAJADOS EN LAS AREAS OPERACIONALES DE PETROLERA RORAIMA, S.A.', 15, 2, 3, NULL, '1939595.20', '2977378.65', '2024-12-03', '2025-05-31', 179, 1, 'Taladro 350 Hp (SDO-02)', '(ODS 10) 5C-197-002-D-24-N-0012', 8, NULL, '2977379', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(45, 'OR05', 'SERVICIO DE PRUEBAS DE PRODUCCIÓN A POZOS Y TOMA DE NIVEL DE FLUIDOS A POZOS DE LA EM PETROLERA RORAIMA, S.A.', 15, 2, 3, NULL, '521636.00', '818928.31', '2025-01-28', '2025-04-27', 89, 1, 'Prueba de pozos', NULL, 8, NULL, '1014939', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(46, 'OC03', 'ATRACADEROS (SERVICIO INTEGRAL DE FABRICACION, SANDBLASTING Y PINTURA DE ATRACADEROS)', 16, 2, 2, NULL, '204548.60', '220418.75', '2025-02-16', '2025-03-21', 33, 1, 'ATRACADEROS', NULL, 8, '0', '0', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(48, 'OR06', 'SERVICIO DE TALADRO CABILLERO DE 350 HP PARA LA INCORPORACION DE POZOS CATEGORIA DOS, EN LAS AREAS OPERACIONALES DE PETROLERA RORAIMA, S.A.\"', 15, 2, 3, NULL, '3462609.95', '6256940.69', '2025-03-18', '2026-03-18', 365, 1, 'Taladro 350 Hp (SDO-04)', '5C-197-002-D-25-N-0040', 8, NULL, '6256941', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(49, 'OR07', 'ADQUISICIÓN DE BOMBAS DE CAVIDAD PROGRESIVA PARA LA COMPLETACIÓN DE POZOS EN LA FASE I DEL CAMPO OPERACIONAL DE LA EM PETROLERA RORAIMA S.A.', 15, 2, 3, NULL, '1103600.27', '1567255.96', '2025-03-01', '2025-05-30', 90, 1, 'ODC BCP', NULL, 8, '0', '0', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(50, 'OR08', 'SERVICIO DE DESPLAZAMIENTO DE FLUIDOS CALIENTES CON CAMIONES BOMBA (HOT OIL) EN EL SISTEMA DE RECOLECCIÓN DE PRODUCCION EN EL AREA OPERACIONAL DE PETROLERA RORAIMA', 15, 2, 3, NULL, '542468.00', '892043.12', '2025-04-03', '2025-08-01', 120, 1, 'CAMIONES BOMBA (HOT OIL)', NULL, 8, '0', '0', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(51, 'OR09', 'Servicio de inspección de ensayos no destructivo (END) en PetroRoraima S.A., area de Producción, San Diego de Cabrutica', 15, 2, 3, NULL, '1395636.40', '3171475.65', '2025-04-03', '2025-09-30', 180, 1, 'Inspección de ensayos no destructivo (END)', '(ODS 55)', 8, NULL, '3171476', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(52, 'OR10', 'SERVICIO DE MANTENIMIENTO NIVEL IV AL SISTEMA CONTRA INCENDIO AREA BOMBAS DE ESTACION PRINCIPAL DE PETROLERA RORAIMA, S.A', 15, 2, 3, NULL, '388501.38', '419179.57', '2025-03-31', '2025-07-20', 111, 1, 'SISTEMA CONTRA INCENDIO', '(ODS 29)', 8, NULL, '419180', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(53, 'OC02', 'PROCURA MAYOR DE TUBERÍA DE DIÁMETRO DE 2\", 3\", 4\" y 6\"', 16, 2, 2, NULL, '2946630.15', '4209472.94', '2025-03-01', '2025-03-04', 3, 1, 'PROCURA MAYOR TUBERÍA', NULL, 8, '0', '0', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(54, 'OR11', '\"SERVICIO DE TALADRO CABILLERO DE 350 HP PARA LA RECUPERACION DE POZOS CAIDOS DE LA BASE CATEGORIA TRES, EN LAS AREAS OPERACIONALES DE PETROLERA RORAIMA, S.A.\"', 15, 2, 3, NULL, '3462609.95', '6018449.69', '2025-04-01', '2025-09-28', 180, 1, 'Taladro 350 Hp (SDO-05)', NULL, 8, NULL, '6018450', 0, NULL);
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(55, 'OC04', 'SERVICIOS ESPECIALIZADOS A POZOS CON TUBERÍA CONTINUA UP ROSA MEDIANO, DE LA DIVISIÓN LAGO, CUENCA OCCIDENTE. (Coiled Tubing)', 16, NULL, 2, NULL, NULL, NULL, '2025-01-01', '2025-01-02', 1, 1, 'POZOS CON TUBERÍA CONTINUA (Coiled Tubing)', 'NO APLICA', 1, NULL, NULL, 0, 'PDVSA y Tía Juana evaluando estrategias para determinar que contratos se van a considerar.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(64, 'OC05', 'PROCURA MATERIAL FERROSO', 16, NULL, 2, NULL, NULL, NULL, '2025-01-01', '2025-01-02', 1, 1, 'PROCURA MATERIAL FERROSO', 'NO APLIC', 1, '1', '1', 1, 'PDVSA y Tía Juana evaluando estrategias para determinar que contratos se van a considerar.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(65, 'OC06', 'MANTENIMIENTO NIVEL 5 A TURBINA GE FRAME 5002 EN PLANTA COMPRESORA TÍA JUANA 4 UP ROSA MEDIANO DIVISIÓN LAGO CUENCA OCCIDENTE ', 16, NULL, 2, NULL, NULL, NULL, '2025-05-01', '2025-05-02', 1, 1, 'TURBINA GE FRAME 5002 ', NULL, 1, NULL, '9839814', 7539414, 'PDVSA y Tía Juana evaluando estrategias para determinar que contratos se van a considerar.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(66, 'OC07', 'TENDIDO DE OLEODUCTO DE 16\" MB-LL-01 A MB-TJ-06  DE LA UNIDAD DE PRODUCCIÓN TÍA JUANA LAGO, DIVISIÓN LAGO, CUENCA OCCIDENTE', 16, NULL, 2, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'TENDIDO DE OLEODUCTO DE 16\"', NULL, 3, NULL, '5477767', NULL, 'Por concretar aprobación de oferta, firma del contrato e inicio de operaciones.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(67, 'OR12', 'ODC Cabillas (ADQUISICIÓN DE CABILLAS DE SUCCIÓN Y ACCESORIOS DE COMPLETACIÓN DE POZOS PARA LA FASE I DEL CAMPO OPERACIONAL ZUATA PRINCIPAL DE LA EM PETROLERA RORAIMA S,A. )', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'ODC Cabillas', NULL, 3, NULL, '4264879', 3339832, 'SDO está negociando los costos con el cliente EMPR (PetroRoraima).  Proveedor Foshan.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(68, 'OR13', 'ADQUISICIÓN DE MATERIALES Y EQUIPOS PARA REPOSICIÓN A LA DIRECCIÓN ADJUNTA DE LOGÍSTICA FPO', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Procura LADAL', NULL, 1, NULL, NULL, 0, 'SDO está negociando los costos con el cliente EMPR (PetroRoraima). ');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(69, 'OR14', 'ODC Tubería (ADQUISICIÓN DE TUBERIAS DE PRODUCCION 4-1/2\" EUE, 5-1/2\" LTC Y 1.315\" SIN COSTURA RORAIMA S,A.)', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'ODC Tubería', NULL, 4, '5037150', '6362226', 3938767, 'Se presento oferta al cliente y se presentó la documentación solicitada. Esperando la adjudicación del contrato (Fecha estimada: entre el 19/05/25 y el 23/05/25)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(70, 'OR15', 'ADECUACIÓN DEL SISTEMA DE AGUA PRODUCIDA DE LOS POZOS INYECTORES Y LAS LÍNEAS DE INYECCIÓN EN ÁREA OPERACIONALES DE PETROLERA RORAIMA. S.A', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Aguas Producidas Pozos Inyectores_014116', NULL, 2, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(71, 'OR16', 'SERVICIO TÉCNICO ESPECIALIZADO DE INSTALACIÓN Y REINSTALACIÓN DE SISTEMAS DE CABLE CALENTADOR (CEF) PARA LA EM PETROLERA RORAIMA, S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Cable Calentador PR 2025', NULL, 2, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(72, 'OR17', 'SERVICIO INTEGRAL DE CEMENTACION PARA LOS POZOS DE LA EMPRESA MIXTA PETROLERA RORAIMA S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'CEMENTACIÓN 07 11 2024_020636', NULL, 2, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(73, 'OR18', 'ADQUISICIÓN DE EQUIPOS PARA MANTENIMIENTO Y PRUEBAS EN SISTEMAS ELÉCTRICOS', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'E.T adq equipo de pruebas y mtto', NULL, 2, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(74, 'OR19', 'SERVICIO INTEGRAL DE GUAYA ELECTRICA PARA LA REHABILITACIÓN DE POZOS A SER TRABAJADOS CON CABRIA DE LA EM PETROLERA RORAIMA S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'GUAYA ELECTRICA_020457', NULL, 2, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(75, 'OR20', 'SERVICIO DE LIMPIEZA CON ROTO JET PARA LAS ACTIVIDADES DE REHABILITACIÓN DE POZOS A SER TRABAJADOS EN LAS AREAS OPERACIONALES DE PETROLERA RORAIMA, S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'ROTO JET HERRAMIENTA DE VACIO', NULL, 2, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(76, 'OR21', 'SERVICIO DE MANTENIMIENTO Y FABRICACIÓN DE COLGADORES, EMPACADURAS TÉRMICAS, CROSS OVER Y TAPONES DE AISLAMIENTOS, PARA LOS POZOS MULTILATERALES Y RA-RC A SER TRABAJADOS POR CABRIA EN LAS ÁREAS OPERACIONALES DE LA EM PETROLERA RORAIMA S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'MANTENIMIENTO Y FABRICACIÓN DE PIEZAS PARA POZOS', NULL, 1, NULL, NULL, 0, 'Enviada lista de Materiales y Servicios a Gerencia de Procura.\n- Por informar sobre la estimación de costos planificados y la oferta estimada sobre cerrada.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(77, 'OR22', 'ADQUISICIÓN DE MATERIALES DE COMPLETACIÓN PARA EL PROYECTO DE CALENTAMIENTO ELÉCTRICO EN FONDO (CEF) FASE I DE LA EM PETROLERA RORAIMA, S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Material CEF PR  2025 FASE I', NULL, 1, NULL, NULL, 0, 'Enviada lista de Materiales y Servicios a Gerencia de Procura.\n- Por informar sobre la estimación de costos planificados y la oferta estimada sobre cerrada.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(78, 'OR23', 'ADQUISICIÓN DE MATERIALES DE COMPLETACIÓN PARA EL PROYECTO DE CALENTAMIENTO ELÉCTRICO EN FONDO (CEF) FASE II DE LA EM PETROLERA RORAIMA, S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Material CEF PR  2025 FASE II', NULL, 1, NULL, NULL, 0, 'Enviada lista de Materiales y Servicios a Gerencia de Procura.\n- Por informar sobre la estimación de costos planificados y la oferta estimada sobre cerrada.');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(79, 'OR24', 'SERVICIOS PROFESIONALES PARA EL DESARROLLO DE PROYECTOS DE INGENIERÍA CONCEPTUAL, BÁSICA Y DETALLE DE PETROLERA RORAIMA, S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'Servicios Profesionales Ing de Prod', NULL, 1, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(80, 'OR25', 'TRATAMIENTO, MOVILIZACION Y CONFORMACION DE RIPIOS Y FLUIDOS PETROLIZADOS, PROVENIENTES DE LAS ACTIVIDADES DE RA/RC EN POZOS DE PETROLERA RORAIMA S.A.', 15, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'RIPIOS Y FLUIDOS PETROLIZADOS', NULL, 1, NULL, NULL, 0, 'En proceso de Procura (evaluación de ofertas)');
INSERT INTO `regiones` (`id`, `nombre`) VALUES
(1, 'all');
INSERT INTO `regiones` (`id`, `nombre`) VALUES
(2, 'Occidente');
INSERT INTO `regiones` (`id`, `nombre`) VALUES
(3, 'Oriente');

INSERT INTO `responsables` (`id`, `nombre`, `cargo`) VALUES
(1, 'Juan Pérez', 'Administrador');
INSERT INTO `responsables` (`id`, `nombre`, `cargo`) VALUES
(2, 'María González', 'Planificador');
INSERT INTO `responsables` (`id`, `nombre`, `cargo`) VALUES
(3, 'Carlos López', 'Planificador');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(1, 'planificador', 0, '2025-04-28 15:51:17', '2025-04-28 15:51:17');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(2, 'direccion', 0, '2025-04-28 16:11:44', '2025-04-28 16:11:44');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(3, 'gestion', 0, '2025-04-28 16:11:59', '2025-04-28 16:11:59');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(4, 'administrador', 1, '2025-04-28 16:12:09', '2025-04-28 16:12:09');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(5, 'procura', 0, '2025-04-28 16:15:15', '2025-04-28 16:15:15');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(6, 'procedimiento comercial', 1, '2025-05-27 06:02:15', '2025-05-27 06:02:15');
INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(7, 'Administracion de Contratos', 1, '2025-05-28 05:09:26', '2025-05-28 05:09:26');
INSERT INTO `tipo_requisition` (`id`, `nombre`) VALUES
(1, 'producto');
INSERT INTO `tipo_requisition` (`id`, `nombre`) VALUES
(2, 'servicio');
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(1, 'manuelviera-oriente@business.com', '$2b$10$T2.HeTHM7OWjnMq/ckKDv.nO4MXoLa7/Ne1b74bpFCihVBabGGJGO', 1, '2025-04-28 16:10:26', '2025-05-13 14:54:37', 3);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(2, 'Luisvasquez-occidente@business.com', '$2b$10$omIP1q3ur4IG1bSjwP.lYegxzDH6VOZeCRflwzWA3.aIYjiWFUm4O', 1, '2025-04-28 16:12:34', '2025-05-13 14:54:38', 2);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(3, 'direccion@business.com', '$2b$10$qzVk6599Mqu4IF2/Wwo9kODaNqQJaTMO/LWH0EIh2/lfo6r10Iuym', 2, '2025-04-28 16:12:50', '2025-04-28 16:12:50', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(4, 'luis.lamas@business.com', '$2b$10$RcSuDDIjhZwMyFF0ZFz2KuiYUUOjizYc0Dw/pdqv9I5zP8HSAbx2q', 2, '2025-04-28 16:13:20', '2025-04-28 16:13:20', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(5, 'orencio.marante@business.com', '$2b$10$TRdxK4pbWU6hwsTXKXJ79eBImtTHuPjQKOBzrJr8Qg7ECpFDRIuU.', 2, '2025-04-28 16:13:30', '2025-04-28 16:13:30', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(6, 'mauricioesteves-gestion@business.com', '$2b$10$gifz1RsGrQtHAgxZz5vnpOOdjgfsYwMfeIVbH8HHAPk1b2r6zj5QS', 3, '2025-04-28 16:13:39', '2025-04-28 16:13:39', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(7, 'israelnunez-gestion@business.com', '$2b$10$wTDZ2IwIR4pwzNIprXUCHu3KeKDqut9zSA8Ejxx03xuU0McIjDFYy', 3, '2025-04-28 16:13:54', '2025-04-28 16:13:54', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(8, 'jesusgarcia-administrador@business.com', '$2b$10$7i9qKNY8Kbb4TPo3meKC5.Ki0QsyjYHt/4CQyrgd9y1bRIrcLKWxu', 4, '2025-04-28 16:14:04', '2025-04-28 16:14:04', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(9, 'procura@business.com', '$2b$10$jJcr1ANw5rXGjpDO0Kf6NuB4JJ7rwypJgyjUsj9HXUI6eRDszuFYO', 5, '2025-04-28 16:15:28', '2025-04-28 16:15:28', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(10, 'procedimiento-comercial@business.com', '$2b$10$WectZRbk9n6kp.t2KA/x9eyEpNZYtKqp2GJFn9UtA6xN5AaQTRdNa', 6, '2025-05-27 06:03:31', '2025-05-27 06:03:31', 1);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(11, 'administracion.contratos.oriente@business.com', '$2b$10$zMuiG0nMcojuO5AHDgmr7Oh3HIBcdo6o3ummoMPLOqlCrPMQbCVRu', 7, '2025-05-28 05:12:02', '2025-05-28 05:13:38', 3);
INSERT INTO `users` (`id`, `email`, `password`, `roleId`, `createdAt`, `updatedAt`, `id_region`) VALUES
(12, 'administracion.contratos.occidente@business.com', '$2b$10$K/9O9JW25BKzg.OV.8e2xepuvaGSF65Wk8THuLpjh9.ZuN1z90OnW', 7, '2025-05-28 05:12:42', '2025-05-28 05:13:38', 2);


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;