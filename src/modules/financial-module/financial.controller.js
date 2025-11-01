import { financialModel } from "./financial.model.js";

export const createAvanceFinanciero = async (req, res) => {
  try {
    const {
      id_proyecto,
      fecha,
      numero_valuacion,
      monto_usd,
      numero_factura,
      id_estatus_proceso,
      fecha_inicio,
      fecha_fin,
    } = req.body;

    const result = await financialModel.createAvanceFinanciero(id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin);
    return res.status(201).json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Algo salió mal al crear el registro" });
  }
};