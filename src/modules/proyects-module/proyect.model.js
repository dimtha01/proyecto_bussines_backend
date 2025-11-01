import { createErrorResponse, createSuccessResponse } from "../../util/response.js";
import { proyectsService } from "./proyect.service.js";

export const proyectsModel = {
  getProyects: async () => {
    try {
      const [
        proyectsData,
        plannedCostsData,
        offeredData,
        commercialStatusData,
        amortizationData,
        anticipationData
      ] = await Promise.all([
        proyectsService.getProyects(),
        proyectsService.getTotalPlannedCost(),
        proyectsService.getTotalOffered(),
        proyectsService.getCommercialStatus(),
        proyectsService.getTotalAmortization(),
        proyectsService.getTotalAnticipation()
      ]);

      
      const errorMap = [
        { data: proyectsData, message: "Error al obtener los proyectos" },
        { data: plannedCostsData, message: "Error al obtener los costos planificados" }, 
        { data: offeredData, message: "Error al obtener el total ofertado" },
        { data: commercialStatusData, message: "Error al obtener el estatus comercial" },
        { data: amortizationData, message: "Error al obtener el total de amortización" },
        { data: anticipationData, message: "Error al obtener el total de anticipación" }
      ];

      for (const item of errorMap) {
        if (item.data.error) {
          return createErrorResponse(item.message, item.data.error, 500);
        }
      }

      const { resultProyects } = proyectsData;
      const { resultTotalPlannedCosts } = plannedCostsData;
      const { resultTotalOffered } = offeredData;
      const { resultCommercialStatus } = commercialStatusData;
      const { resultTotalAmortization } = amortizationData;
      const { resultTotalAnticipation } = anticipationData;

      const commercialData = resultCommercialStatus?.[0] || {};
      const result = {
        proyectos: resultProyects,
        totales: {

          total_ofertado: resultTotalOffered[0].total_ofertado,

          total_costo_planificado: resultTotalPlannedCosts[0].total_costo_planificado,
          ...commercialData,
          total_amortizacion: resultTotalAmortization[0].total_amortizacion,
          total_monto_anticipo: resultTotalAnticipation[0].total_monto_anticipo,
        }
      };

      return createSuccessResponse("Proyectos obtenidos correctamente", result, 200);

    } catch (error) {
      console.error("Error inesperado en proyectsModel.getProyects:", error);
      return createErrorResponse("Error inesperado en el servidor", error.message || error, 500);
    }
  }
};