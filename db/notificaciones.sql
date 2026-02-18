-- Tabla de notificaciones
DROP TABLE IF EXISTS `notificaciones`;
CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_proyecto` int(11) DEFAULT NULL,
  `titulo` varchar(255) NOT NULL,
  `mensaje` text NOT NULL,
  `tipo` varchar(50) NOT NULL DEFAULT 'archivo_subido',
  `leida` tinyint(1) NOT NULL DEFAULT 0,
  `datos` json DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_notificacion_proyecto` (`id_proyecto`),
  CONSTRAINT `fk_notificacion_proyecto` FOREIGN KEY (`id_proyecto`) REFERENCES `proyectos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
