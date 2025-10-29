export const validateClientCreate = (req, res, next) => {
  const {
    nombre,
    razon_social,
    nombre_comercial,
    direccion_fiscal,
    pais,
    id_region,
    unidad_negocio,
    email,
    telefono,
    direccion,
  } = req.body;  
  if (
    !nombre ||
    !razon_social ||
    !direccion_fiscal ||
    !pais ||
    !unidad_negocio
  ) {
    return res.status(400).json({ message: "Todos los campos obligatorios deben ser proporcionados", status: 400 });
  }
  if(parseInt(id_region) >= 1 || parseInt(id_region) <= 3) {
    return res.status(400).json({ message: "El ID de la región invalido", status: 400 });
  }

  next();
}