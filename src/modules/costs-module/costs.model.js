import { createErrorResponse, createSuccessResponse } from "../../util/response.js";
import { costsService } from "./costs.service.js";

const costsModel = {
  getAllCostosByProyecto: async (id) => {

    try {

    const costosResult = await costsService.getCostoByProyecto(id);

    if (costosResult.length === 0) {
      return createErrorResponse({
        message: "No se encontró ningún proyecto con el ID proporcionado.",
        status: 404,
      });
    }

    const costoOfertado = costosResult[0].costo_estimado;

    const totalMontoAnticipo = await costsService.getMontoAnticipoByProyecto(id);

    const totalAmortizacion = await costsService.getAmortizacionByProyecto(id);

    const costoOrdenesCompra = await costsService.getOrdenesCompraByProyecto(id);

    return createSuccessResponse("Costos obtenidos correctamente.",
      {
        costosOfertado: costoOfertado,
        totalMontoAnticipo: totalMontoAnticipo,
        totalAmortizacion: totalAmortizacion,
        CostoOrdenesCompra: costoOrdenesCompra,
        costos: costosResult,
      }, 200);
  } catch (error) {
    return createErrorResponse({
      message: "Error al obtener los costos.",
      status: 500,
    });
  }
  }
}

export default costsModel;