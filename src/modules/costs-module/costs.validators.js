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