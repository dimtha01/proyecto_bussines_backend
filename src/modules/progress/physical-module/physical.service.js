import { pool } from "../../db.js";

export const physicalService = {
    createPhysical: async (physical) => {
       const { id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin } = physical;

       const [result] = await pool.query(
      `
      INSERT INTO avance_fisico (id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin]
    );
    return result;
}
}