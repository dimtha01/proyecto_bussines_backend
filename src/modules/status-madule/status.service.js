import { pool } from "../../db.js";

export const statusService = {
  getStatus: async () => {
    const [result] = await pool.query(`
      SELECT
        e.nombre_estatus,
        COUNT(DISTINCT a.id_proyecto) AS cantidad_proyectos_distintos,
        COALESCE(SUM(a.monto_usd), 0) AS suma_montos
      FROM
        estatus_proceso e
        LEFT JOIN avance_financiero a ON e.id_estatus = a.id_estatus_proceso
      WHERE
        e.id_estatus IN (4, 5, 6)
      GROUP BY
        e.id_estatus,
        e.nombre_estatus
      ORDER BY
        cantidad_proyectos_distintos DESC;
    `);
    return result;
  }
}