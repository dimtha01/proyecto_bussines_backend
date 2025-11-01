import { financialService } from "./financial.service.js";

export const financialModel = {
    createAdvaced: async () => {
        const result = await financialService.createAdvanceFinancial();
        return result;
    }
}