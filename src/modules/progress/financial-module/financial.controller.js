import { createSuccessResponse } from "../../../util/response.js";
import { financialModel } from "./financial.model.js";

export const getAvanceFinanciero = async (req, res) => {
  try {
    const result = await financialModel.getAllAvanceFinanciero();
    res.json(result);
  } catch (error) {
    console.error("Error al obtener el avance financiero:", error);

    if (error.message === "No se encontraron registros de avance financiero") {
      return res.status(404).json({ createSuccessResponse });
    }

    return res.status(500).json({
      message: "Algo salió mal",
      error: error.message
    });
  }
};

// Get financial advances by project ID
export const getAvanceFinancieroByProyectoId = async (req, res) => {
  try {
    const { id_proyecto } = req.params;
    const result = await financialModel.getByProyectoId(id_proyecto);
    return res.json(result);
  } catch (error) {
    console.error("Error al obtener el avance financiero:", error);
    return res.status(500).json({
      message: "Algo salió mal",
      error: error.message
    });
  }
};

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

    const result = await financialModel.createAdvaced(id_proyecto, fecha, numero_valuacion, monto_usd, numero_factura, id_estatus_proceso, fecha_inicio, fecha_fin);

    return res.status(201).json(result);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Algo salió mal al crear el registro" });
  }
};

// Update financial advance
export const updateAvanceFinanciero = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await financialModel.updateAvanceFinanciero(id,req.body);

    res.status(200).json({
      message: `El registro de avance financiero con ID ${id} ha sido actualizado correctamente`,
      data: result,
    });
  } catch (error) {
    console.error("Error al actualizar el avance financiero:", error);
    res.status(500).json({ message: error.message });
  }
};


// Update status
export const updateEstatusAvanceFinanciero = async (req, res) => {
  try {
    const { id } = req.params;
    
    await financialModel.updateEstatus(
      id,
      req.body
    );

    res.status(200).json({
      message: "Estado del avance financiero actualizado exitosamente",
      updatedId: id,
      newStatusId: id_estatus_proceso,
      numeroFactura: numero_factura || "No proporcionado",
      fechaInicio: fecha_inicio || "No actualizada",
      fechaFin: fecha_fin || "No actualizada",
    });
  } catch (error) {
    console.error("Error al actualizar el estado del avance financiero:", error);

    if (error.message === "No se encontró el avance financiero con el ID proporcionado") {
      return res.status(404).json({ message: error.message });
    }

    return res.status(500).json({
      message: "Algo salió mal",
      error: error.message
    });
  }
};

// Update monto
export const updateMontoAvanceFinanciero = async (req, res) => {
  try {
    const { id } = req.params;
    const { monto_usd } = req.body;

    await financialModel.updateMonto(id, monto_usd);

    res.status(200).json({
      message: "Monto del avance financiero actualizado correctamente",
      data: {
        id,
        monto_usd,
      },
    });
  } catch (error) {
    console.error("Error al actualizar el monto del avance financiero:", error);

    if (error.message === "El registro de avance financiero no existe") {
      return res.status(404).json({ message: error.message });
    }

    if (error.message === "No se pudo actualizar el registro") {
      return res.status(500).json({ message: error.message });
    }

    return res.status(500).json({
      message: "Algo salió mal",
      error: error.message
    });
  }
};