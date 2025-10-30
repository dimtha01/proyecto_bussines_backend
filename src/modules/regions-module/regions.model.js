import { ServiceRegionGetGlobal } from "./regions.service.js"
import { ServiceRegionGetDetails } from "./regions.service.js"

export const RegionModel = {
    getRegions: async () => {
        const { result: { costo_planificado_total = 0, costo_real_total = 0 }, error } = await ServiceRegionGetGlobal.getConsolidatedProjects();
        if (error) {
            return createErr{ result: null, error }
        }

        const { regions, error: errorRegions } = await ServiceRegionGetDetails.getAllRegions();

        if (errorRegions) {
            return { result: null, error: errorRegions }
        }
        return {
            costo_planificado_total: Number.parseFloat(costo_planificado_total || 0),
            costo_real_total: Number.parseFloat(costo_real_total || 0),
            regiones: regions, // Detalles por región
        }
    }
}