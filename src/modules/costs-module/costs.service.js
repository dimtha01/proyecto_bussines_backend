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
  updateCostoEstatus: async (id, id_estatus) => {
    const [result] = await pool.query(
      "UPDATE costos_proyectos SET id_estatus = ? WHERE id = ?",
      [id_estatus, id]
    );
    return result;
  },
  getProjectById: async (id) => {
    const [projectResult] = await pool.query("SELECT * FROM proyectos WHERE id = ?", [id]);
    return projectResult;
  },
  createCostos: async (id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion) => {
    const [result] = await pool.query(
      "INSERT INTO costos_proyectos (id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
      [id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion]
    );
    return result;
  },
  getCostoById: async (id) => {
    const [result] = await pool.query("SELECT * FROM costos_proyectos WHERE id = ?", [id]);
    return result.length > 0 ? result[0] : null;
  },
  updateCosto: async (id, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion) => {

    let query = "UPDATE costos_proyectos SET ";
    const updates = [];
    const values = [];

    if (fecha) {
      updates.push("fecha = ?");
      values.push(fecha);
    }
    if (costo !== undefined) {
      updates.push("costo = ?");
      values.push(parseFloat(costo));
    }
    if (monto_sobrepasado !== undefined) {
      updates.push("monto_sobrepasado = ?");
      values.push(parseFloat(monto_sobrepasado));
    }
    if (fecha_inicio) {
      updates.push("fecha_inicio = ?");
      values.push(fecha_inicio);
    }
    if (fecha_fin) {
      updates.push("fecha_fin = ?");
      values.push(fecha_fin);
    }
    if (numero_valuacion !== undefined) {
      updates.push("numero_valuacion = ?");
      values.push(numero_valuacion);
    }
    if (amortizacion !== undefined) {
      updates.push("amortizacion = ?");
      values.push(parseFloat(amortizacion));
    }
    values.push(id);

    query += updates.join(", ") + " WHERE id = ?";

    await pool.query(query, values);

    const [result] = await pool.query(query, values);
    return result;
  }
};