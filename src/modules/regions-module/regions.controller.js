import { RegionModel } from "./regions.model.js"

export const getRegiones = async (req, res) => {
    const { result, error } = await RegionModel.getRegions();
    if (error) {
        return res.status(500).json({ error: error.message });
    }
    return res.json(result);
}