import { createErrorResponse, createSuccessResponse } from "../../util/response.js";
import { regionsService } from "./regions.service.js";

export const RegionModel = {
    getRegions: async () => {
        const { costo_planificado_total = 0, costo_real_total = 0 , error } = await regionsService.getConsolidatedProjects();
        if (error) {
            return createErrorResponse("Error al obtener los proyectos consolidados", error.message,500)
        }

        const { regions, error: errorRegions } = await regionsService.getAllRegions();

        if (errorRegions) {
            return createErrorResponse("Error al obtener los proyectos consolidados", errorRegions.message,500)
        }
        return createSuccessResponse("Regiones y sus consolidados obtenidos exitosamente", {
            costo_planificado_total: Number.parseFloat(costo_planificado_total || 0),
            costo_real_total: Number.parseFloat(costo_real_total || 0),
            regiones: regions, // Detalles por región
        },200)
    }
}