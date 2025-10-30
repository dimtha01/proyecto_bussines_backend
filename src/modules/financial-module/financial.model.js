export const financialModel = {
    createAdvaced: async () => {
        const result = await financialService.createAdvacedPhysical();
        return result;
    }
}