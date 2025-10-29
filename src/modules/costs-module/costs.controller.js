import costsModel from "./costs.model.js";

export const getAllCostosByProyecto = async (req, res) => {
  const { id } = req.params;
  const result = await costsModel.getAllCostosByProyecto(id);
  return res.status(result.status).json(result);
};
