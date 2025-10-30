import { RegionModel } from "./regions.model.js"

export const getRegiones = async (req, res) => {
    const result = await RegionModel.getRegions();
    return res.status(result.status).json(result);
}