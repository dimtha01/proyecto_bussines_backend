import { createSuccessResponse } from "../../../util/response.js";
import { clientService } from "./client.service.js";

export const clientModel = {
  getClientes: async (region) => {
    const result = await clientService.getClientes(region);
    if (result.length === 0) {
      return createSuccessResponse("No se encontraron clientes", result, 500);
    }
    return createSuccessResponse("Clientes obtenidos correctamente", result, 200);

  },
  createCliente: async (cliente) => {
    const result = await clientService.createCliente(cliente);
    if (result.length === 0) {
      return createSuccessResponse("No se pudo crear el cliente", result, 500);
    }
    return createSuccessResponse("Cliente creado correctamente", result, 200);
  },
  updateCliente: async (id, cliente) => {
    const result = await clientService.updateCliente(id, cliente);
    if (result.length === 0) {
      return createSuccessResponse("No se pudo actualizar el cliente", result, 500);
    }
    return createSuccessResponse("Cliente actualizado correctamente", result, 200);
  },
}