import { proyectsModel } from "./proyect.model.js";

export const getProyects = async (req, res) => {

  const result = await proyectsModel.getProyects();
  res.status(result.status).json(result);

}