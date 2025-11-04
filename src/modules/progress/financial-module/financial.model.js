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
    updateAvanceFinanciero: async (id, data) => {
        const result = await financialService.updateAvanceFinanciero(id, data);

        if (result.affectedRows === 0) {
            throw new Error("No se pudo actualizar el registro");
        }

        return result;
    },

    // Update status
    updateEstatus: async (id, data) => {
        const result = await financialService.updateEstatus(id, data);

        if (result.affectedRows === 0) {
            throw new Error("No se encontró el avance financiero con el ID proporcionado");
        }

        return result;
    },
    // Update monto
    updateMonto: async (id, monto_usd) => {

        const result = await financialService.updateMonto(id, monto_usd);

        if (result.affectedRows === 0) {
            throw new Error("No se pudo actualizar el registro");
        }

        return result;
    },
};