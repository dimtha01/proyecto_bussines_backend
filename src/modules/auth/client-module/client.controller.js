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

    // Validar que se proporcionen al menos algunos campos para actualizar
    if (
      !nombre &&
      !razon_social &&
      !nombre_comercial &&
      !direccion_fiscal &&
      !pais &&
      !id_region &&
      !unidad_negocio &&
      !email &&
      !telefono &&
      !direccion
    ) {
      return res.status(400).json({ message: "Debes proporcionar al menos un campo para actualizar" });
    }

    // Verificar si el cliente existe en la base de datos
    const [existingClient] = await pool.query("SELECT * FROM clientes WHERE id = ?", [id]);
    if (existingClient.length === 0) {
      return res.status(404).json({ message: "El cliente no existe" });
    }

    // Construir dinámicamente la consulta SQL para actualizar solo los campos proporcionados
    const updates = [];
    const values = [];

    if (nombre !== undefined) {
      updates.push("nombre = ?");
      values.push(nombre);
    }
    if (razon_social !== undefined) {
      updates.push("razon_social = ?");
      values.push(razon_social);
    }
    if (nombre_comercial !== undefined) {
      updates.push("nombre_comercial = ?");
      values.push(nombre_comercial || null);
    }
    if (direccion_fiscal !== undefined) {
      updates.push("direccion_fiscal = ?");
      values.push(direccion_fiscal);
    }
    if (pais !== undefined) {
      updates.push("pais = ?");
      values.push(pais);
    }
    if (id_region !== undefined) {
      updates.push("id_region = ?");
      values.push(id_region);
    }
    if (unidad_negocio !== undefined) {
      updates.push("unidad_negocio = ?");
      values.push(unidad_negocio);
    }
    if (email !== undefined) {
      updates.push("email = ?");
      values.push(email || null);
    }
    if (telefono !== undefined) {
      updates.push("telefono = ?");
      values.push(telefono || null);
    }
    if (direccion !== undefined) {
      updates.push("direccion = ?");
      values.push(direccion || null);
    }

    // Si no hay campos para actualizar, devolver un error
    if (updates.length === 0) {
      return res.status(400).json({ message: "No se proporcionaron campos válidos para actualizar" });
    }

    // Agregar el ID del cliente al final de los valores
    values.push(id);

    // Construir la consulta SQL final
    const query = `
      UPDATE clientes
      SET ${updates.join(", ")}
      WHERE id = ?
    `;

    // Ejecutar la consulta SQL
    const [result] = await pool.query(query, values);

    // Verificar si la actualización fue exitosa
    if (result.affectedRows === 0) {
      return res.status(500).json({ message: "No se pudo actualizar el cliente" });
    }

    // Devolver una respuesta exitosa
    res.status(200).json({
      message: `El cliente con ID ${id} ha sido actualizado correctamente`,
      data: {
        id,
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
      },
    });
  } catch (error) {
    console.error("Error al actualizar el cliente:", error); // Registrar el error en la consola
    return res.status(500).json({ message: "Ocurrió un error al intentar actualizar el cliente." });
  }
};
