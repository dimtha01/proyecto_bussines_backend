import { pool } from "../../db.js";

const regionsService = {
  getConsolidatedProjects: async () => {
    try {
    const [result] = await pool.query(
      `
       SELECT 
          SUM(p.costo_estimado) AS costo_planificado_total,
          COALESCE(SUM(cp_totals.total_costo_real), 0) AS costo_real_total
        FROM 
          proyectos p
        LEFT JOIN 
          (
            SELECT 
              id_proyecto, 
              SUM(costo) AS total_costo_real
            FROM 
              costos_proyectos
            GROUP BY 
              id_proyecto
          ) cp_totals ON p.id = cp_totals.id_proyecto
      `
    )
    return {result , error:null}
    } catch (error) {
      return {result:null , error}
    }
  },
  getAllRegions: async () => {
    try {
      const [regions] = await pool.query(`
        SELECT 
          r.nombre AS nombre_region,
          COUNT(DISTINCT p.id) AS total_proyectos,
          COALESCE(SUM(p.monto_ofertado), 0) AS total_monto_ofertado,
          COALESCE(SUM(p.costo_estimado), 0) AS total_costo_planificado,
          COALESCE(SUM(cp.total_costo_real), 0) AS total_costo_real
        FROM 
          regiones r
        LEFT JOIN 
          proyectos p ON r.id = p.id_region
        LEFT JOIN 
          (
            SELECT 
              id_proyecto, 
              SUM(costo) AS total_costo_real
            FROM 
              costos_proyectos
            GROUP BY 
              id_proyecto
          ) cp ON p.id = cp.id_proyecto
        GROUP BY 
          r.id, r.nombre
        ORDER BY 
          total_monto_ofertado DESC;
      `)
      return {regions , error:null}
    } catch (error) {
      return {regions:null , error}
    }
  },  
}