import { createErrorResponse } from "../../util/response.js";
export const validateCostsIsById = (req, res, next) => {
  const { id } = req.params;
  if (!id || isNaN(parseInt(id))) {
    const result = createErrorResponse({
      message: "El ID del proyecto es invalido.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }
  next();
}

export const validateCostsIsEstatus = (req, res, next) => {
  const { id_estatus } = req.body;
  if (!id_estatus || isNaN(parseInt(id_estatus))) {
    const result = createErrorResponse({
      message: "El ID del estatus es invalido.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }
  if(parseInt(id_estatus) < 4 || parseInt(id_estatus) > 6) {
    const result = createErrorResponse({
      message: "El ID del estatus es invalido.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }
  next();
}