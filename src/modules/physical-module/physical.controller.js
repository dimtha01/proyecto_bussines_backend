import { physicalModel } from "./physical.model.js";

export const createPhysical = async (req, res) => {
  try {
    const { id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin } = req.body;

   const result = await physicalModel.createPhysical({ id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin });

   if (result.affectedRows === 0) {
      return res.status(result.status).json({ message: "No se pudo crear el registro" });
    }

    res.status(result.status).json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Algo salió mal al crear el registro" });
  }
};