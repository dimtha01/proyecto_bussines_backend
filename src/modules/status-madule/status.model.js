import { statusService } from "./status.service.js";

const statusModel = {
  getStatus: async () => {
    const result = await statusService.getStatus();
    return createSuccessResponse("Estatus obtenido correctamente", result, 200);
  }
}

export default statusModel;