import { proyectsModel } from "./proyect.model.js";

export const getProyects = async (req, res) => {
  try {
    const result = await proyectsModel.getProyects();
    res.status(result.status).json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Algo salió mal" });
  }



}