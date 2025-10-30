import { createErrorResponse } from "../../util/response.js";
import { costsService } from "./costs.service.js";

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
  if (parseInt(id_estatus) < 4 || parseInt(id_estatus) > 6) {
    const result = createErrorResponse({
      message: "El ID del estatus es invalido.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }
  next();
}


export const validateCostsIsCreate = async (req, res, next) => {
  const {
    id_proyecto,
    fecha,
    costo,
    fecha_inicio,
    fecha_fin,
    monto_sobrepasado,
    amortizacion,
    numero_valuacion,
  } = req.body;

  if (!id_proyecto || !fecha || !costo || !fecha_inicio || !fecha_fin) {
    const result = createErrorResponse({
      message: "Campos obligatorios: id_proyecto, fecha, costo, fecha_inicio y fecha_fin.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  const costoNumerico = parseFloat(costo);
  if (isNaN(costoNumerico) || costoNumerico <= 0) {
    const result = createErrorResponse({
      message: "El costo debe ser un número mayor que 0.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  const idProyectoNumerico = parseInt(id_proyecto, 10);
  if (isNaN(idProyectoNumerico) || idProyectoNumerico <= 0) {
    const result = createErrorResponse({
      message: "El id_proyecto debe ser un número entero mayor que 0.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  const fechaValida = isValidDate(fecha);
  const fechaInicioValida = isValidDate(fecha_inicio);
  const fechaFinValida = isValidDate(fecha_fin);

  if (!fechaValida || !fechaInicioValida || !fechaFinValida) {
    const result = createErrorResponse({
      message: "Una o más fechas (fecha, fecha_inicio, fecha_fin) tienen un formato inválido.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  if (fechaInicioValida.getTime() >= fechaFinValida.getTime()) {
    const result = createErrorResponse({
      message: "La fecha de inicio debe ser anterior a la fecha de fin.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  if (monto_sobrepasado !== undefined && monto_sobrepasado !== null) {
    const sobrecostoNumerico = parseFloat(monto_sobrepasado);
    if (isNaN(sobrecostoNumerico) || sobrecostoNumerico < 0) {
      const result = createErrorResponse({
        message: "El monto sobrepasado debe ser un número mayor o igual a 0.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }

  if (amortizacion !== undefined && amortizacion !== null) {
    const amortizacionNumerica = parseFloat(amortizacion);
    if (isNaN(amortizacionNumerica) || amortizacionNumerica < 0) {
      const result = createErrorResponse({
        message: "La amortización debe ser un número mayor o igual a 0.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }

  if (numero_valuacion !== undefined && numero_valuacion !== null) {
    if (typeof numero_valuacion !== "string" || numero_valuacion.trim() === "") {
      const result = createErrorResponse({
        message: "El número de valuación debe ser una cadena de texto no vacía.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }

  if (!(await projectExists(idProyectoNumerico))) {
    const result = createErrorResponse({
      message: "El proyecto no existe.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  next();
};
export const validateCostsIsUpdate = async (req, res, next) => {
  const { id } = req.params;
  const { fecha, costo, fecha_inicio, fecha_fin, monto_sobrepasado, amortizacion, numero_valuacion } = req.body;

  if (!id || isNaN(parseInt(id)) || (await costsService.getCostoById(id)) === null) {
    const result = createErrorResponse({
      message: "El costo con el ID proporcionado no existe.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }

  if (
    !fecha &&
    costo === undefined &&
    monto_sobrepasado === undefined &&
    !fecha_inicio &&
    !fecha_fin &&
    numero_valuacion === undefined &&
    amortizacion === undefined
  ) {
    const result = createErrorResponse({
      message: "Debes proporcionar al menos un campo para actualizar.",
      status: 400,
    });
    return res.status(result.status).json(result);
  }
  if (costo !== undefined) {
    const costoNumerico = parseFloat(costo);
    if (isNaN(costoNumerico) || costoNumerico <= 0) {
      const result = createErrorResponse({
        message: "El costo debe ser un número mayor que 0.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }

  // Validar que el sobrecosto sea un número mayor o igual a 0 (si se proporciona)
  if (monto_sobrepasado !== undefined) {
    const sobrecostoNumerico = parseFloat(monto_sobrepasado);
    if (isNaN(sobrecostoNumerico) || sobrecostoNumerico < 0) {
      const result = createErrorResponse({
        message: "El monto sobrepasado debe ser un número mayor o igual a 0.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }

  // Validar que la amortización sea un número mayor o igual a 0 (si se proporciona)
  if (amortizacion !== undefined) {
    const amortizacionNumerica = parseFloat(amortizacion);
    if (isNaN(amortizacionNumerica) || amortizacionNumerica < 0) {
      const result = createErrorResponse({
        message: "La amortización debe ser un número mayor o igual a 0.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }

  // Validar que numero_valuacion tenga un formato adecuado (si se proporciona)
  if (numero_valuacion !== undefined && numero_valuacion !== null) {
    if (typeof numero_valuacion !== "string" || numero_valuacion.trim() === "") {
      const result = createErrorResponse({
        message: "El número de valuación debe ser una cadena de texto válida.",
        status: 400,
      });
      return res.status(result.status).json(result);
    }
  }
  next();
}
export const projectExists = async (id) => {
  const result = await costsService.getProjectById(id);
  return result[0]?.id ? true : false;
}
const isValidDate = (dateString) => {
  if (!dateString) return null; // No validar si no existe
  const date = new Date(dateString);
  return !isNaN(date.getTime()) ? date : null;
};