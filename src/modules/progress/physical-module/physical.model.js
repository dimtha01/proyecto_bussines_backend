import { createSuccessResponse } from "../../util/response.js"
import { physicalService } from "./physical.service.js"

export const physicalModel ={
    createPhysical: async (physical) => { 
        try {
            const result = await physicalService.createPhysical(physical)
            return createSuccessResponse("avance fisico creado exitosamente",result,201)
        } catch (error) {
            createSuccessResponse("error no se pudo crear el avance fisico",error.message,500)
        }
     }

}