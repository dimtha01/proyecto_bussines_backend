import { financialService } from "./financial.service.js";

export const financialModel = {
    
    getAllAvanceFinanciero: async () => {
        const result = await financialService.getAllAvanceFinanciero();

        if (result.length === 0) {
            throw new Error("No se encontraron registros de avance financiero");
        }

        return result;
    },

    // Get financial advances by project ID
    getByProyectoId: async (id_proyecto) => {
        const result = await financialService.getByProyectoId(id_proyecto);
        return result;
    },

    createAdvaced: async () => {
        const result = await financialService.createAdvanceFinancial();
        return result;
    },
    // Update financial advance
    updateAvanceFinanciero: async (id, id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin) => {
        const existingRecord = await financialService.updateAvanceFinanciero(id);

        if (existingRecord.length === 0) {
            throw new Error("El registro de avance financiero no existe");
        }

        const result = await financialService.updateAvanceFinanciero(
            id,
            id_proyecto,
            fecha,
            numero_valuacion,
            monto_usd,
            numero_factura,
            id_estatus_proceso,
            fecha_inicio,
            fecha_fin
        );

        if (result.affectedRows === 0) {
            throw new Error("No se pudo actualizar el registro");
        }

        return result;
    },

    // Update status
    updateEstatus: async (id, id_estatus_proceso, numero_factura, fecha_inicio, fecha_fin) => {
        const result = await financialService.updateEstatus(
            id,
            id_estatus_proceso,
            numero_factura,
            fecha_inicio,
            fecha_fin
        );

        if (result.affectedRows === 0) {
            throw new Error("No se encontró el avance financiero con el ID proporcionado");
        }

        return result;
    },

    // Update monto
    updateMonto: async (id, monto_usd) => {
        const existingRecord = await financialService.findById(id);

        if (existingRecord.length === 0) {
            throw new Error("El registro de avance financiero no existe");
        }

        const result = await financialService.updateMonto(id, monto_usd);

        if (result.affectedRows === 0) {
            throw new Error("No se pudo actualizar el registro");
        }

        return result;
    },
};