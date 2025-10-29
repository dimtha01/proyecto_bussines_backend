import { pool } from "../../db.js";

export const costsService = {
  getCostoByProyecto: async (id) => {
    const [proyectoResult] = await pool.query(
      `
      SELECT 
        id,
        fecha,
        costo,
        monto_sobrepasado,
        fecha_inicio,
        fecha_fin,
        e.nombre_estatus,
        numero_valuacion,
        amortizacion -- Agregamos el campo amortización aquí
      FROM 
        costos_proyectos c
      JOIN estatus_proceso e ON c.id_estatus = e.id_estatus
      WHERE 
        id_proyecto = ?
      ORDER BY 
        id DESC
      `,
      [id]
    );

    return proyectoResult;
  },
  getMontoAnticipoByProyecto: async (id) => {
    const [montoAnticipoResult] = await pool.query(
      `
      SELECT 
        COALESCE(SUM(req.monto_anticipo), 0) AS total_monto_anticipo
      FROM 
        requisition req
      WHERE 
        req.id_proyecto = ?
      `,
      [id]
    );
    return montoAnticipoResult[0]?.total_monto_anticipo || 0;
  },
  getAmortizacionByProyecto: async (id) => {
    const [amortizacionResult] = await pool.query(
      `
      SELECT 
        COALESCE(SUM(c.amortizacion), 0) AS total_amortizacion
      FROM 
        costos_proyectos c
      WHERE 
        c.id_proyecto = ?
      `,
      [id]
    );
    return amortizacionResult[0]?.total_amortizacion || 0;
  },
  getOrdenesCompraByProyecto: async (id) => {
    const [CostoOrdenesCompra] = await pool.query(
      `
      SELECT 
        COALESCE(SUM(r.monto_total), 0) AS Costo_ordenes_Compra
      FROM 
        requisition r
      INNER JOIN proyectos p ON r.id_proyecto = p.id
      WHERE 
        p.id = ?
      `,
      [id] // Usamos el ID dinámico en lugar de un valor fijo
    );
    return CostoOrdenesCompra[0]?.Costo_ordenes_Compra || 0;
  },
}