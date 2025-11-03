import { pool } from "../../db.js";

export const financialService = {
    getAllAvanceFinanciero: async () => {
        try {
            const [result] = await pool.query(`
        SELECT 
          af.id,
          af.id_proyecto,
          af.fecha,
          af.numero_valuacion,
          af.monto_usd,
          af.numero_factura,
          af.fecha_inicio,
          af.fecha_fin,
          ep.nombre_estatus AS estatus_proceso_nombre,
          ep.descripcion AS estatus_proceso_descripcion
        FROM 
          avance_financiero af
        LEFT JOIN 
          estatus_proceso ep
        ON 
          af.id_estatus_proceso = ep.id_estatus
      `);
            return result;
        } catch (error) {
            throw error;
        }
    },

    // Get financial advances by project ID
    getByProyectoId: async (id_proyecto) => {
        try {
            const [result] = await pool.query(
                `
        SELECT 
          af.id,
          af.id_proyecto,
          af.fecha,
          af.numero_valuacion,
          af.monto_usd,
          af.numero_factura,
          af.fecha_inicio,
          af.fecha_fin,
          ep.nombre_estatus AS estatus_proceso_nombre,
          ep.descripcion AS estatus_proceso_descripcion
        FROM 
          avance_financiero af
        LEFT JOIN 
          estatus_proceso ep
        ON 
          af.id_estatus_proceso = ep.id_estatus
        WHERE 
          af.id_proyecto = ?
        `,
                [id_proyecto]
            );
            return result;
        } catch (error) {
            throw error;
        }
    },
    createAdvanceFinancial: async () => {
        try {
            const [result] = await pool.query(
                `
      INSERT INTO avance_financiero (
        id_proyecto,
        fecha,
        numero_valuacion,
        monto_usd,
        numero_factura,
        id_estatus_proceso,
        fecha_inicio,
        fecha_fin
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
    `,
                [
                    id_proyecto,
                    fecha,
                    numero_valuacion,
                    monto_usd,
                    numero_factura || null,
                    id_estatus_proceso,
                    fecha_inicio,
                    fecha_fin,
                ]
            );
            return result;
        } catch (error) {
            throw error;
        }
    },
    // Update financial advance
    updateAvanceFinanciero: async (id, id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin) => {
        try {
            const updates = [];
            const values = [];

            if (id_proyecto !== undefined) {
                updates.push("id_proyecto = ?");
                values.push(id_proyecto);
            }
            if (fecha !== undefined) {
                updates.push("fecha = ?");
                values.push(fecha);
            }
            if (numero_valuacion !== undefined) {
                updates.push("numero_valuacion = ?");
                values.push(numero_valuacion);
            }
            if (monto_usd !== undefined) {
                updates.push("monto_usd = ?");
                values.push(monto_usd);
            }
            if (numero_factura !== undefined) {
                updates.push("numero_factura = ?");
                values.push(numero_factura || null);
            }
            if (id_estatus_proceso !== undefined) {
                updates.push("id_estatus_proceso = ?");
                values.push(id_estatus_proceso);
            }
            if (fecha_inicio !== undefined) {
                updates.push("fecha_inicio = ?");
                values.push(fecha_inicio);
            }
            if (fecha_fin !== undefined) {
                updates.push("fecha_fin = ?");
                values.push(fecha_fin);
            }

            values.push(id);

            const query = `
        UPDATE avance_financiero
        SET ${updates.join(", ")}
        WHERE id = ?
      `;

            const [result] = await pool.query(query, values);
            return result;
        } catch (error) {
            throw error;
        }
    },

    // Update status
    updateEstatus: async (id, id_estatus_proceso, numero_factura, fecha_inicio, fecha_fin) => {
        try {
            let query = "UPDATE avance_financiero SET id_estatus_proceso = ?";
            const queryParams = [id_estatus_proceso];

            if (numero_factura !== undefined && numero_factura !== null && numero_factura.trim() !== "") {
                query += ", numero_factura = ?";
                queryParams.push(numero_factura);
            }

            if (fecha_inicio) {
                query += ", fecha_inicio = ?";
                queryParams.push(fecha_inicio);
            }

            if (fecha_fin) {
                query += ", fecha_fin = ?";
                queryParams.push(fecha_fin);
            }

            query += " WHERE id = ?";
            queryParams.push(id);

            const [result] = await pool.query(query, queryParams);
            return result;
        } catch (error) {
            throw error;
        }
    },
}