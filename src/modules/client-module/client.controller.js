import { clientModel } from "./client.model.js";

export const getClientes = async (req, res) => {
  const { region } = req.query;
  const result = await clientModel.getClientes(region);
  return res.status(result.status).json(result);
}

export const createCliente = async (req, res) => {
  
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

    const result = await clientModel.createCliente({ nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion });

    return res.status(result.status).json(result);
};

export const updateCliente = async (req, res) => {
  try {
    // Extraer el ID del cliente de los parámetros de la URL
    const { id } = req.params;

    // Extraer los datos del cuerpo de la solicitud
    const {
      nombre,
      razon_social,
      nombre_comercial,
      direccion_fiscal,
      pais,
      id_region,
      unidad_negocio,
      email,
      telefono, // Opcional
      direccion, // Opcional
    } = req.body;

   const result = await clientModel.updateCliente(id, { nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion });
   return res.status(result.status).json(result);
  } catch (error) {
    console.error("Error al actualizar el cliente:", error); // Registrar el error en la consola
    return res.status(500).json({ message: "Ocurrió un error al intentar actualizar el cliente." });
  }
};
