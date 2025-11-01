import { pool } from "../../db.js";

export const proyectsService = {
  getProyects: async (id) => {
    try {
      let query = `
      SELECT 
        p.id,
        p.numero,
        p.nombre AS nombre_proyecto,
        p.nombre_cortos,
        p.id_estatus_comercial,
        p.id_region,
        p.id_cliente,
        p.codigo_contrato_cliente, -- Campo agregado: Código del contrato del cliente
        p.oferta_del_proveedor,
        c.nombre AS nombre_cliente,
        r.nombre AS nombre_responsable,
        reg.nombre AS nombre_region,
        c.unidad_negocio AS unidad_negocio,
        p.costo_estimado,
        p.monto_ofertado,
        p.fecha_inicio,
        p.fecha_final,
        p.duracion,
        p.observaciones, -- Campo agregado
        p.monto_estimado_oferta_cliente, -- Campo agregado
        p.monto_estimado_oferta_cerrado_sdo, -- Campo agregado
        ec.nombre AS estatus_comercial, -- Nombre del estatus comercial
        -- Subconsulta para calcular el costo real
        (SELECT SUM(co.costo) 
         FROM costos_proyectos co 
         WHERE co.id_proyecto = p.id) AS costo_real,
        -- Subconsulta para calcular el monto facturado (estatus 6)
        (SELECT SUM(af_financiero.monto_usd)
         FROM avance_financiero af_financiero
         INNER JOIN estatus_proceso ep ON af_financiero.id_estatus_proceso = ep.id_estatus
         WHERE af_financiero.id_proyecto = p.id
           AND ep.id_estatus = 6) AS facturado,
        -- Subconsulta para calcular el monto por valor (estatus diferente de 6)
        (SELECT SUM(af_financiero.monto_usd)
         FROM avance_financiero af_financiero
         INNER JOIN estatus_proceso ep ON af_financiero.id_estatus_proceso = ep.id_estatus
         WHERE af_financiero.id_proyecto = p.id
           AND ep.id_estatus = 4) AS por_valuar,
        -- Subconsulta para calcular el monto por factura (estatus relacionado con facturas)
        (SELECT SUM(af_financiero.monto_usd)
         FROM avance_financiero af_financiero
         INNER JOIN estatus_proceso ep ON af_financiero.id_estatus_proceso = ep.id_estatus
         WHERE af_financiero.id_proyecto = p.id
           AND ep.id_estatus = 5) AS por_factura,
        -- Subconsulta para calcular el total de amortización por proyecto
        COALESCE((SELECT SUM(cp.amortizacion)
                  FROM costos_proyectos cp
                  WHERE cp.id_proyecto = p.id), 0) AS total_amortizacion,
        -- Subconsulta para calcular el total de monto anticipado por proyecto
        COALESCE((SELECT SUM(req.monto_anticipo)
                  FROM requisition req
                  WHERE req.id_proyecto = p.id), 0) AS monto_anticipo_total,
        -- Máximo avance real y planificado
        MAX(af_fisico.avance_real) AS avance_real_maximo,
        MAX(af_fisico.avance_planificado) AS avance_planificado_maximo
      FROM
        proyectos p
        LEFT JOIN clientes c ON p.id_cliente = c.id
        LEFT JOIN responsables r ON p.id_responsable = r.id
        LEFT JOIN regiones reg ON p.id_region = reg.id
        LEFT JOIN avance_fisico af_fisico ON p.id = af_fisico.id_proyecto
        LEFT JOIN estatus_comercial ec ON p.id_estatus_comercial = ec.id -- Unión con la tabla estatus_comercial
      WHERE
        ec.id = 8 -- Filtrar por estatus comercial con ID 8
    `;
      query += `
      GROUP BY 
        p.id,
        p.numero,
        p.nombre,
        p.nombre_cortos,
        p.codigo_contrato_cliente, -- Campo agregado al GROUP BY
        c.nombre,
        r.nombre,
        reg.nombre,
        c.unidad_negocio,
        p.costo_estimado,
        p.monto_ofertado,
        p.fecha_inicio,
        p.fecha_final,
        p.duracion,
        p.observaciones, -- Campo agregado al GROUP BY
        p.monto_estimado_oferta_cliente, -- Campo agregado al GROUP BY
        p.monto_estimado_oferta_cerrado_sdo, -- Campo agregado al GROUP BY
        ec.nombre; -- Nombre del estatus comercial agregado al GROUP BY
    `;
      const [resultProyects] = await pool.query(query);
      return { resultProyects, error: null };
    } catch (error) {
      console.error(error);
      return { resultProyects: null, error: error.message };
    }
  },
  getTotalOffered: async () => {
    try {
      const [resultTotalOffered] = await pool.query(
        `
      SELECT
        SUM(P.monto_ofertado) AS total_ofertado
      FROM 
        proyectos P
        LEFT JOIN estatus_comercial ec ON P.id_estatus_comercial = ec.id
      WHERE 
        ec.id = 8;
    `
      );
      return { resultTotalOffered, error: null };
    } catch (error) {
      console.error(error);
      return { resultTotalOffered: null, error: error.message };
    }
  },
  getTotalPlannedCost: async () => {
    try {
      const [resultTotalPlannedCosts] = await pool.query(
        `
      SELECT
        SUM(P.costo_estimado) AS total_costo_planificado
      FROM 
        proyectos P
        LEFT JOIN estatus_comercial ec ON P.id_estatus_comercial = ec.id
      WHERE 
        ec.id = 8;
    `
      );
      return { resultTotalPlannedCosts, error: null };
    } catch (error) {
      console.error(error);
      return { resultTotalPlannedCost: null, error: error.message };
    }
  },
  getCommercialStatus: async () => {
    try {
      const [resultCommercialStatus] = await pool.query(
        `
        SELECT
          (
            SELECT COALESCE(SUM(costo), 0)
            FROM costos_proyectos cp2
            JOIN proyectos P ON cp2.id_proyecto = P.id
            LEFT JOIN estatus_comercial ec ON P.id_estatus_comercial = ec.id
            WHERE ec.id = 8
          ) AS total_costo_real,
          SUM(CASE WHEN AV.id_estatus_proceso = 4 THEN AV.monto_usd ELSE 0 END) AS total_por_valuar,
          SUM(CASE WHEN AV.id_estatus_proceso = 5 THEN AV.monto_usd ELSE 0 END) AS total_por_facturar,
          SUM(CASE WHEN AV.id_estatus_proceso = 6 THEN AV.monto_usd ELSE 0 END) AS total_facturado
        FROM 
          proyectos P
          LEFT JOIN estatus_comercial ec ON P.id_estatus_comercial = ec.id
          LEFT JOIN avance_financiero AV ON AV.id_proyecto = P.id
        WHERE 
          ec.id = 8;
      `
      );

      return { resultCommercialStatus, error: null };
    } catch (error) {
      console.error(error);
      return { resultCommercialStatus: null, error: error.message };
    }
  },
  getTotalAmortization: async () => {
    try {
      const [resultTotalAmortization] = await pool.query(
        `
      SELECT
        COALESCE(SUM(cp.amortizacion), 0) AS total_amortizacion
      FROM 
        costos_proyectos cp
        JOIN proyectos P ON cp.id_proyecto = P.id
        LEFT JOIN estatus_comercial ec ON P.id_estatus_comercial = ec.id
      WHERE 
        ec.id = 8;
    `
      );

      return { resultTotalAmortization, error: null };
    } catch (error) {
      console.error(error);
      return { resultTotalAmortization: null, error: error.message };
    }
  },
  getTotalAnticipation: async () => {
    try {
      const [resultTotalAnticipation] = await pool.query(
        `
      SELECT
        COALESCE(SUM(req.monto_anticipo), 0) AS total_monto_anticipo
      FROM 
        requisition req
        JOIN proyectos P ON req.id_proyecto = P.id
        LEFT JOIN estatus_comercial ec ON P.id_estatus_comercial = ec.id
      WHERE 
        ec.id = 8;
    `
      );
      return { resultTotalAnticipation, error: null };
    } catch (error) {
      console.error(error);
      return { resultTotalAnticipation: null, error: error.message };
    }
  }
}