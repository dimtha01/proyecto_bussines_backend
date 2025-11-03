// export const financialValidatorById = (req, res, next) => {
//     const { id_proyecto } = req.params;

//     if (!id_proyecto) {
//         return res.status(400).json({ message: "No se encontro el avance financiero" });
//     }

//     next();
// }

export const financialValidator = (req, res, next) => {
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

    // Validar que todos los campos requeridos estén presentes
    if (
        !id_proyecto ||
        !fecha ||
        !numero_valuacion ||
        !monto_usd ||
        !id_estatus_proceso ||
        !fecha_inicio ||
        !fecha_fin
    ) {
        return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }
    next();
}

// Validator for UPDATE operation
export const updateAvanceFinancieroValidator = (req, res, next) => {
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

  if (
    id_proyecto === undefined &&
    fecha === undefined &&
    numero_valuacion === undefined &&
    monto_usd === undefined &&
    numero_factura === undefined &&
    id_estatus_proceso === undefined &&
    fecha_inicio === undefined &&
    fecha_fin === undefined
  ) {
    return res.status(400).json({ 
      message: "Debes proporcionar al menos un campo para actualizar" 
    });
  }

  next();
};

// Validator for UPDATE STATUS operation
export const updateEstatusValidator = (req, res, next) => {
  const { id_estatus_proceso } = req.body;
  const { id } = req.params;

  if (!id_estatus_proceso || !id) {
    return res.status(400).json({ 
      message: "El campo 'id_estatus_proceso' es obligatorio" 
    });
  }

  next();
};

// Validator for UPDATE MONTO operation
export const updateMontoValidator = (req, res, next) => {
  const { id } = req.params;
  const { monto_usd } = req.body;

  if (!id || monto_usd === undefined || monto_usd === null) {
    return res.status(400).json({ 
      message: "El ID y el monto son obligatorios" 
    });
  }

  next();
};