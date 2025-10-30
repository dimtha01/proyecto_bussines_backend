export const financialService = {
    createAdvancePhysical: async () => {
        try {
            const [result] = await pool.query(
                `
              INSERT INTO avance_fisico (id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin)
              VALUES (?, ?, ?, ?, ?, ?, ?)
              `,
                [id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin]
            );
            return result;
        } catch (error) {
            throw error;
        }
    },
}