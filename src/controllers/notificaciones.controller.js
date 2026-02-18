// controllers/notificaciones.controller.js
import { pool } from "../db.js";

// =====================================================
// OBTENER TODAS LAS NOTIFICACIONES
// =====================================================
export const getNotificaciones = async (req, res) => {
  try {
    const { proyectoId, noLeidas } = req.query;

    let query = `
      SELECT n.*, p.nombre as nombre_proyecto
      FROM notificaciones n
      LEFT JOIN proyectos p ON n.id_proyecto = p.id
    `;
    const params = [];

    if (proyectoId) {
      query += ` WHERE n.id_proyecto = ?`;
      params.push(proyectoId);
    }

    if (noLeidas === "true") {
      query += params.length ? ` AND n.leida = 0` : ` WHERE n.leida = 0`;
    }

    query += ` ORDER BY n.fecha_creacion DESC`;

    const [notificaciones] = await pool.query(query, params);

    // mysql2 ya parsea los campos JSON automáticamente
    const parsed = notificaciones.map((n) => ({
      ...n,
      datos: n.datos || null,
    }));

    return res.status(200).json({ total: parsed.length, notificaciones: parsed });
  } catch (error) {
    console.error("Error al obtener notificaciones:", error);
    return res.status(500).json({ message: "Error interno al obtener notificaciones" });
  }
};

// =====================================================
// OBTENER NOTIFICACIONES DE UN PROYECTO
// =====================================================
export const getNotificacionesByProyecto = async (req, res) => {
  try {
    const { projectId } = req.params;

    const [notificaciones] = await pool.query(
      `SELECT * FROM notificaciones
       WHERE id_proyecto = ?
       ORDER BY fecha_creacion DESC`,
      [projectId]
    );

    // mysql2 ya parsea los campos JSON automáticamente
    const parsed = notificaciones.map((n) => ({
      ...n,
      datos: n.datos || null,
    }));

    return res.status(200).json({ total: parsed.length, notificaciones: parsed });
  } catch (error) {
    console.error("Error al obtener notificaciones del proyecto:", error);
    return res.status(500).json({ message: "Error interno al obtener notificaciones" });
  }
};

// =====================================================
// MARCAR NOTIFICACIÓN COMO LEÍDA
// =====================================================
export const marcarComoLeida = async (req, res) => {
  try {
    const { notificationId } = req.params;

    await pool.query(
      `UPDATE notificaciones SET leida = 1 WHERE id = ?`,
      [notificationId]
    );

    return res.status(200).json({ message: "Notificación marcada como leída" });
  } catch (error) {
    console.error("Error al marcar notificación como leída:", error);
    return res.status(500).json({ message: "Error interno al actualizar notificación" });
  }
};

// =====================================================
// MARCAR TODAS LAS NOTIFICACIONES COMO LEÍDAS
// =====================================================
export const marcarTodasComoLeidas = async (req, res) => {
  try {
    const { proyectoId } = req.body;

    let query = `UPDATE notificaciones SET leida = 1`;
    const params = [];

    if (proyectoId) {
      query += ` WHERE id_proyecto = ?`;
      params.push(proyectoId);
    }

    await pool.query(query, params);

    return res.status(200).json({ message: "Todas las notificaciones marcadas como leídas" });
  } catch (error) {
    console.error("Error al marcar notificaciones como leídas:", error);
    return res.status(500).json({ message: "Error interno al actualizar notificaciones" });
  }
};

// =====================================================
// CONTAR NOTIFICACIONES NO LEÍDAS
// =====================================================
export const contarNoLeidas = async (req, res) => {
  try {
    const { proyectoId } = req.query;

    let query = `SELECT COUNT(*) as total FROM notificaciones WHERE leida = 0`;
    const params = [];

    if (proyectoId) {
      query += ` AND id_proyecto = ?`;
      params.push(proyectoId);
    }

    const [result] = await pool.query(query, params);

    return res.status(200).json({ noLeidas: result[0].total });
  } catch (error) {
    console.error("Error al contar notificaciones no leídas:", error);
    return res.status(500).json({ message: "Error interno al contar notificaciones" });
  }
};

// =====================================================
// ELIMINAR NOTIFICACIÓN
// =====================================================
export const deleteNotificacion = async (req, res) => {
  try {
    const { notificationId } = req.params;

    await pool.query(`DELETE FROM notificaciones WHERE id = ?`, [notificationId]);

    return res.status(200).json({ message: "Notificación eliminada correctamente" });
  } catch (error) {
    console.error("Error al eliminar notificación:", error);
    return res.status(500).json({ message: "Error interno al eliminar notificación" });
  }
};
