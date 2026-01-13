-- -------------------------------------------------------------
-- TablePlus 6.8.0(654)
--
-- https://tableplus.com/
--
-- Database: proyecto_bussines
-- Generation Time: 2026-01-13 00:40:31.4150
-- -------------------------------------------------------------


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
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proyecto` int DEFAULT NULL,
  `nombre_archivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `ruta_archivo` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_archivo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_archivo_proyecto` (`id_proyecto`),
  CONSTRAINT `fk_archivo_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `avance_financiero`;
CREATE TABLE `avance_financiero` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proyecto` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `numero_valuacion` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `monto_usd` decimal(15,2) DEFAULT NULL,
  `numero_factura` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ofertado` decimal(15,2) DEFAULT NULL,
  `costo_planificado` decimal(15,2) DEFAULT NULL,
  `id_estatus_proceso` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_proyecto` (`id_proyecto`),
  KEY `id_estatus_proceso` (`id_estatus_proceso`),
  CONSTRAINT `avance_financiero_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `avance_financiero_ibfk_2` FOREIGN KEY (`id_estatus_proceso`) REFERENCES `estatus_proceso` (`id_estatus`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `avance_fisico`;
CREATE TABLE `avance_fisico` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proyecto` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `avance_real` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avance_planificado` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `puntos_atencion` text COLLATE utf8mb4_general_ci,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_proyecto` (`id_proyecto`),
  CONSTRAINT `avance_fisico_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `direccion` text COLLATE utf8mb4_general_ci,
  `unidad_negocio` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `razon_social` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre_comercial` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `direccion_fiscal` text COLLATE utf8mb4_general_ci,
  `pais` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_region` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_clientes_region` (`id_region`),
  CONSTRAINT `fk_clientes_region` FOREIGN KEY (`id_region`) REFERENCES `regiones` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `costos_proyectos`;
CREATE TABLE `costos_proyectos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_proyecto` int NOT NULL,
  `fecha` date NOT NULL,
  `costo` decimal(10,2) NOT NULL,
  `monto_sobrepasado` decimal(10,2) DEFAULT '0.00',
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `id_estatus` int DEFAULT '4',
  `numero_valuacion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amortizacion` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `id_proyecto` (`id_proyecto`),
  KEY `fk_id` (`id_estatus`),
  CONSTRAINT `costos_proyectos_ibfk_1` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_id` FOREIGN KEY (`id_estatus`) REFERENCES `estatus_proceso` (`id_estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estatus_comercial`;
CREATE TABLE `estatus_comercial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estatus_proceso`;
CREATE TABLE `estatus_proceso` (
  `id_estatus` int NOT NULL AUTO_INCREMENT,
  `nombre_estatus` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_estatus`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estatus_proveedor`;
CREATE TABLE `estatus_proveedor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre_abreviado` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `color` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '#CCCCCC',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE `proveedores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_comercial` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `direccion_fiscal` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `pais` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `RIF` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `estatus_id` int NOT NULL DEFAULT '1' COMMENT '1=Apto por defecto',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_proveedor_estatus` (`estatus_id`),
  CONSTRAINT `fk_proveedor_estatu` FOREIGN KEY (`estatus_id`) REFERENCES `estatus_proveedor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `proyectos`;
CREATE TABLE `proyectos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `id_cliente` int DEFAULT NULL,
  `id_responsable` int DEFAULT NULL,
  `id_region` int DEFAULT NULL,
  `id_contrato` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `costo_estimado` decimal(15,2) DEFAULT NULL,
  `monto_ofertado` decimal(15,2) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_final` date DEFAULT NULL,
  `duracion` int DEFAULT NULL,
  `id_estatus` int NOT NULL DEFAULT '1',
  `nombre_cortos` varchar(155) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `codigo_contrato_cliente` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_estatus_comercial` int DEFAULT '1',
  `monto_estimado_oferta_cerrado_sdo` decimal(10,0) DEFAULT '0',
  `monto_estimado_oferta_cliente` decimal(10,0) DEFAULT '0',
  `oferta_del_proveedor` int DEFAULT '0',
  `observaciones` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `regiones`;
CREATE TABLE `regiones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `requisition`;
CREATE TABLE `requisition` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_tipo` int NOT NULL,
  `id_proyecto` int DEFAULT NULL,
  `nro_requisicion` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `id_proveedores` int NOT NULL,
  `fecha_elaboracion` date NOT NULL,
  `monto_total` decimal(10,2) DEFAULT NULL,
  `nro_renglones` int NOT NULL,
  `monto_anticipo` decimal(10,2) NOT NULL DEFAULT '0.00',
  `nro_odc` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
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
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `cargo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `permissionEdit` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `tipo_requisition`;
CREATE TABLE `tipo_requisition` (
  `id` int NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `roleId` int NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_region` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `roleId` (`roleId`),
  KEY `fk_region_user` (`id_region`),
  CONSTRAINT `fk_region_user` FOREIGN KEY (`id_region`) REFERENCES `regiones` (`id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `estatus_comercial` (`id`, `nombre`) VALUES
(1, 'Alcance Recibido.'),
(2, 'Proceso de Planificación y Costos.'),
(3, 'Negociación.'),
(4, 'Oferta entregada.'),
(5, 'Adjudicación.'),
(6, 'Firma del contrato.'),
(7, 'Negociación Anticipo.'),
(8, 'Acta Inicio.');

INSERT INTO `estatus_proceso` (`id_estatus`, `nombre_estatus`, `descripcion`, `fecha_creacion`, `activo`) VALUES
(1, 'En Elaboración de Valuación', 'El proceso está en la fase inicial de elaboración.', '2025-02-10 16:55:47', 1),
(2, 'En Revisión por el Cliente', 'El cliente está revisando la valuación.', '2025-02-10 16:55:47', 1),
(3, 'Valuación Aprobada', 'La valuación ha sido aprobada por el cliente.', '2025-02-10 16:55:47', 1),
(4, 'Por Valuar', 'aluar implica evaluar el valor de un bien o activo de manera objetiva y precisa, utilizando métodos y técnicas específicas según el contexto', '2025-02-11 18:11:48', 1),
(5, 'Por Facturar', 'El proceso está listo para ser facturado.', '2025-02-10 16:55:47', 1),
(6, 'Facturado', 'El proceso ha sido facturado completamente.', '2025-02-10 16:55:47', 1);

INSERT INTO `estatus_proveedor` (`id`, `nombre_completo`, `nombre_abreviado`, `descripcion`, `color`, `created_at`, `updated_at`) VALUES
(1, 'Apto', 'APT', 'Proveedor cumple con todos los requisitos', '#28a745', '2025-05-06 19:04:07', '2025-05-06 19:04:07'),
(2, 'No Apto', 'N-APT', 'Proveedor no cumple con los requisitos mínimos', '#dc3545', '2025-05-06 19:04:07', '2025-05-06 19:04:07'),
(3, 'Con Observaciones', 'OBS', 'Proveedor cumple parcialmente con los requisitos', '#ffc107', '2025-05-06 19:04:07', '2025-05-06 19:04:07');

INSERT INTO `proyectos` (`id`, `numero`, `nombre`, `id_cliente`, `id_responsable`, `id_region`, `id_contrato`, `costo_estimado`, `monto_ofertado`, `fecha_inicio`, `fecha_final`, `duracion`, `id_estatus`, `nombre_cortos`, `codigo_contrato_cliente`, `id_estatus_comercial`, `monto_estimado_oferta_cerrado_sdo`, `monto_estimado_oferta_cliente`, `oferta_del_proveedor`, `observaciones`) VALUES
(1, 'PDC-PRDL-2025-S-0108', 'EQUIPOS MARINOS PARA TENDIDO DE CABLE 35 KV ENTRE PPP Y \nEUD-1', NULL, NULL, 2, NULL, NULL, 1000.00, NULL, NULL, NULL, 1, 'EQUIPOS MARINOS PARA TENDIDO DE CABLE 35 KV', NULL, 1, 0, 0, 0, NULL);

INSERT INTO `regiones` (`id`, `nombre`) VALUES
(1, 'all'),
(2, 'Occidente'),
(3, 'Oriente');

INSERT INTO `roles` (`id`, `name`, `permissionEdit`, `createdAt`, `updatedAt`) VALUES
(1, 'planificador', 0, '2025-04-28 15:51:17', '2025-04-28 15:51:17'),
(2, 'direccion', 0, '2025-04-28 16:11:44', '2025-04-28 16:11:44'),
(3, 'gestion', 0, '2025-04-28 16:11:59', '2025-04-28 16:11:59'),
(4, 'administrador', 1, '2025-04-28 16:12:09', '2025-04-28 16:12:09'),
(5, 'procura', 0, '2025-04-28 16:15:15', '2025-04-28 16:15:15'),
(6, 'procedimiento comercial', 1, '2025-05-27 06:02:15', '2025-05-27 06:02:15'),
(7, 'Administracion de Contratos', 1, '2025-05-28 05:09:26', '2025-05-28 05:09:26');

INSERT INTO `tipo_requisition` (`id`, `nombre`) VALUES
(1, 'producto'),
(2, 'servicio');



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;