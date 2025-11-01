export const financialService = {
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
}