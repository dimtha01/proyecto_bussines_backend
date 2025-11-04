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
    createAdvanceFinancial: async (id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin,) => {
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
            console.error(error);
            return createErrorResponse("Error al crear el avance financiero", error.message, 500);
        }
    },
    // Update financial advance
    updateAvanceFinanciero: async (id, data) => {
        try {
            const { id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin } = data;
            console.log("Data to update:", id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin);
            const fields = [];
            const values = [];

            if (id_proyecto !== undefined && id_proyecto !== null) {
                fields.push("id_proyecto = ?");
                values.push(id_proyecto);
            }
            if (fecha !== undefined && fecha !== null) {
                fields.push("fecha = ?");
                values.push(fecha);
            }
            if (numero_valuacion !== undefined && numero_valuacion !== null) {
                fields.push("numero_valuacion = ?");
                values.push(numero_valuacion);
            }
            if (monto_usd !== undefined && monto_usd !== null) {
                fields.push("monto_usd = ?");
                values.push(monto_usd);
            }
            if (numero_factura !== undefined) {
                fields.push("numero_factura = ?");
                values.push(numero_factura);
            }
            if (id_estatus_proceso !== undefined && id_estatus_proceso !== null) {
                fields.push("id_estatus_proceso = ?");
                values.push(id_estatus_proceso);
            }
            if (fecha_inicio !== undefined && fecha_inicio !== null) {
                fields.push("fecha_inicio = ?");
                values.push(fecha_inicio);
            }
            if (fecha_fin !== undefined && fecha_fin !== null) {
                fields.push("fecha_fin = ?");
                values.push(fecha_fin);
            }

            if (fields.length === 0) {
                throw new Error("No hay campos para actualizar");
            }

            values.push(id);

            const query = `UPDATE avance_financiero SET ${fields.join(", ")} WHERE id = ?`;

            console.log("Query:", query);
            console.log("Values:", values);

            const [result] = await pool.query(query, values);
            return result;
        } catch (error) {
            throw error;
        }
    },

    // Update status
    updateEstatus: async (id, data) => {
        try {
            const { id_estatus_proceso, numero_factura, fecha_inicio, fecha_fin } = data;
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
    // Update monto
    updateMonto: async (id, monto_usd) => {
        try {
            const [result] = await pool.query(
                `
      UPDATE avance_financiero
      SET monto_usd = ?
      WHERE id = ?
    `,
                [monto_usd, id]
            );
            return result;
        } catch (error) {
            throw error;
        }
    },
}