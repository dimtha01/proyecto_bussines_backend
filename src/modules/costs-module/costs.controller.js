import { costsModel } from "./costs.model.js";

export const getAllCostosByProyecto = async (req, res) => {
  const { id } = req.params;
  const result = await costsModel.getAllCostosByProyecto(id);
  return res.status(result.status).json(result);
};

export const updateCostoEstatus = async (req, res) => {
  const { id } = req.params;
  const { id_estatus } = req.body;
  const result = await costsModel.updateCostoEstatus(id, id_estatus);
  return res.status(result.status).json(result);
};

export const createCostos = async (req, res) => {
  const {
    id_proyecto,
    fecha,
    costo,
    monto_sobrepasado,
    fecha_inicio,
    fecha_fin,
    numero_valuacion,
    amortizacion,
  } = req.body;

  const result = await costsModel.createCostos(id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion);
  return res.status(result.status).json(result);
}
