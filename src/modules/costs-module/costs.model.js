import { createErrorResponse, createSuccessResponse } from "../../util/response.js";
import { costsService } from "./costs.service.js";

export const costsModel = {
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
  },
  updateCostoEstatus: async (id, id_estatus) => {
    try {
      const result = await costsService.updateCostoEstatus(id, id_estatus);
      if (result.affectedRows === 0) {
        return createErrorResponse({
          message: "No se pudo actualizar el estatus del costo.",
          status: 404,
        });
      }
      return createSuccessResponse("Estatus del costo actualizado correctamente.", result.affectedRows, 201);
    } catch (error) {
      console.log(error);
      return createErrorResponse({
        message: "Error al actualizar el estatus del costo.",
        status: 500,
      });
    }
  },
  createCostos: async (id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion) => {
    try {
      const result = await costsService.createCostos(id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion);
      return createSuccessResponse("Costo agregado correctamente.", result.insertId, 201);
    } catch (error) {
      console.log(error);
      return createErrorResponse({
        message: "Error al agregar el costo.",
        status: 500,
      });
    }
  },
  updateCosto: async (id, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion) => {
    try {
      const result = await costsService.updateCosto(id, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion);
      if (result.affectedRows === 0) {
        return createErrorResponse({
          message: "No se pudo actualizar el costo.",
          status: 500,
        });
      }
      return createSuccessResponse("Costo actualizado correctamente.", result.affectedRows, 200);
    } catch (error) {
      console.log(error);
      return createErrorResponse({
        message: "Error al actualizar el costo.",
        status: 500,
      });
    }
  }
}