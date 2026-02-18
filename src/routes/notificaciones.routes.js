// routes/notificaciones.routes.js
import express from "express";
import {
  getNotificaciones,
  getNotificacionesByProyecto,
  marcarComoLeida,
  marcarTodasComoLeidas,
  contarNoLeidas,
  deleteNotificacion,
} from "../controllers/notificaciones.controller.js";

const router = express.Router();

// Obtener todas las notificaciones (con filtros opcionales)
router.get("/", getNotificaciones);

// Contar notificaciones no leídas
router.get("/contar-no-leidas", contarNoLeidas);

// Obtener notificaciones de un proyecto específico
router.get("/proyectos/:projectId", getNotificacionesByProyecto);

// Marcar una notificación como leída
router.patch("/:notificationId/leer", marcarComoLeida);

// Marcar todas las notificaciones como leídas
router.patch("/marcar-todas-leidas", marcarTodasComoLeidas);

// Eliminar una notificación
router.delete("/:notificationId", deleteNotificacion);

export default router;
