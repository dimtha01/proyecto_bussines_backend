import { pool } from "../db.js";



export const updateCostos = async (req, res) => {
  try {
    // Extraer el ID del costo de los parámetros de la URL
    const { id } = req.params;

    // Extraer los datos del cuerpo de la solicitud
    const { id_proyecto, fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin } = req.body;

    // Validar que se proporcione al menos un campo para actualizar
    if (
      !id_proyecto &&
      !fecha &&
      !costo &&
      !monto_sobrepasado &&
      !fecha_inicio &&
      !fecha_fin
    ) {
      return res.status(400).json({
        message: "Debes proporcionar al menos un campo para actualizar.",
      });
    }

    // Verificar si el registro existe en la base de datos
    const [existingRecord] = await pool.query("SELECT * FROM costos_proyectos WHERE id = ?", [id]);
    if (existingRecord.length === 0) {
      return res.status(404).json({
        message: "El registro de costo no existe.",
      });
    }

    // Validar que el proyecto exista si se proporciona un nuevo id_proyecto
    if (id_proyecto !== undefined) {
      const [proyecto] = await pool.query("SELECT id FROM proyectos WHERE id = ?", [id_proyecto]);
      if (proyecto.length === 0) {
        return res.status(400).json({
          message: "El proyecto con el ID proporcionado no existe.",
        });
      }
    }

    // Validar que el costo sea un número mayor que 0 si se proporciona
    let costoNumerico;
    if (costo !== undefined) {
      costoNumerico = parseFloat(costo);
      if (isNaN(costoNumerico) || costoNumerico <= 0) {
        return res.status(400).json({
          message: "El costo debe ser un número mayor que 0.",
        });
      }
    }

    // Validar que el sobrecosto sea un número mayor o igual a 0 si se proporciona
    let sobrecostoNumerico;
    if (monto_sobrepasado !== undefined) {
      sobrecostoNumerico = parseFloat(monto_sobrepasado);
      if (isNaN(sobrecostoNumerico) || sobrecostoNumerico < 0) {
        return res.status(400).json({
          message: "El monto sobrepasado debe ser un número mayor o igual a 0.",
        });
      }
    }

    // Construir dinámicamente la consulta SQL para actualizar solo los campos proporcionados
    const updates = [];
    const values = [];

    if (id_proyecto !== undefined) {
      updates.push("id_proyecto = ?");
      values.push(id_proyecto);
    }
    if (fecha !== undefined) {
      updates.push("fecha = ?");
      values.push(fecha);
    }
    if (costo !== undefined) {
      updates.push("costo = ?");
      values.push(costoNumerico);
    }
    if (monto_sobrepasado !== undefined) {
      updates.push("monto_sobrepasado = ?");
      values.push(sobrecostoNumerico);
    }
    if (fecha_inicio !== undefined) {
      updates.push("fecha_inicio = ?");
      values.push(fecha_inicio);
    }
    if (fecha_fin !== undefined) {
      updates.push("fecha_fin = ?");
      values.push(fecha_fin);
    }

    // Si no hay campos para actualizar, devolver un error
    if (updates.length === 0) {
      return res.status(400).json({
        message: "No se proporcionaron campos válidos para actualizar.",
      });
    }

    // Agregar el ID del registro al final de los valores
    values.push(id);

    // Construir la consulta SQL final
    const query = `
      UPDATE costos_proyectos
      SET ${updates.join(", ")}
      WHERE id = ?
    `;

    // Ejecutar la consulta SQL
    const [result] = await pool.query(query, values);

    // Verificar si la actualización fue exitosa
    if (result.affectedRows === 0) {
      return res.status(500).json({
        message: "No se pudo actualizar el registro.",
      });
    }

    // Devolver una respuesta exitosa
    res.status(200).json({
      message: `El registro de costo con ID ${id} ha sido actualizado correctamente.`,
      data: {
        id,
        id_proyecto,
        fecha,
        costo: costoNumerico,
        monto_sobrepasado: sobrecostoNumerico,
        fecha_inicio,
        fecha_fin,
      },
    });
  } catch (error) {
    console.error("Error al actualizar el costo:", error);
    return res.status(500).json({
      message: "Ocurrió un error al intentar actualizar el registro.",
    });
  }
};

export const updateCosto = async (req, res) => {
  try {
    // Extraer los datos del cuerpo de la solicitud
    const { id } = req.params; // ID del costo a actualizar
    const { fecha, costo, monto_sobrepasado, fecha_inicio, fecha_fin, numero_valuacion, amortizacion } = req.body;

    // Validar que al menos un campo esté presente para actualizar
    if (
      !fecha &&
      costo === undefined &&
      monto_sobrepasado === undefined &&
      !fecha_inicio &&
      !fecha_fin &&
      numero_valuacion === undefined &&
      amortizacion === undefined
    ) {
      return res.status(400).json({
        message: "Debes proporcionar al menos un campo para actualizar.",
      });
    }

    // Validar que el costo sea un número mayor que 0 (si se proporciona)
    if (costo !== undefined) {
      const costoNumerico = parseFloat(costo);
      if (isNaN(costoNumerico) || costoNumerico <= 0) {
        return res.status(400).json({
          message: "El costo debe ser un número mayor que 0.",
        });
      }
    }

    // Validar que el sobrecosto sea un número mayor o igual a 0 (si se proporciona)
    if (monto_sobrepasado !== undefined) {
      const sobrecostoNumerico = parseFloat(monto_sobrepasado);
      if (isNaN(sobrecostoNumerico) || sobrecostoNumerico < 0) {
        return res.status(400).json({
          message: "El monto sobrepasado debe ser un número mayor o igual a 0.",
        });
      }
    }

    // Validar que la amortización sea un número mayor o igual a 0 (si se proporciona)
    if (amortizacion !== undefined) {
      const amortizacionNumerica = parseFloat(amortizacion);
      if (isNaN(amortizacionNumerica) || amortizacionNumerica < 0) {
        return res.status(400).json({
          message: "La amortización debe ser un número mayor o igual a 0.",
        });
      }
    }

    // Validar que numero_valuacion tenga un formato adecuado (si se proporciona)
    if (numero_valuacion !== undefined && numero_valuacion !== null) {
      if (typeof numero_valuacion !== "string" || numero_valuacion.trim() === "") {
        return res.status(400).json({
          message: "El número de valuación debe ser una cadena de texto válida.",
        });
      }
    }

    // Verificar que el costo exista en la base de datos
    const [costoExistente] = await pool.query("SELECT * FROM costos_proyectos WHERE id = ?", [id]);
    if (costoExistente.length === 0) {
      return res.status(404).json({
        message: "El costo con el ID proporcionado no existe.",
      });
    }

    // Construir la consulta dinámica para actualizar solo los campos proporcionados
    let query = "UPDATE costos_proyectos SET ";
    const updates = [];
    const values = [];

    if (fecha) {
      updates.push("fecha = ?");
      values.push(fecha);
    }
    if (costo !== undefined) {
      updates.push("costo = ?");
      values.push(parseFloat(costo));
    }
    if (monto_sobrepasado !== undefined) {
      updates.push("monto_sobrepasado = ?");
      values.push(parseFloat(monto_sobrepasado));
    }
    if (fecha_inicio) {
      updates.push("fecha_inicio = ?");
      values.push(fecha_inicio);
    }
    if (fecha_fin) {
      updates.push("fecha_fin = ?");
      values.push(fecha_fin);
    }
    if (numero_valuacion !== undefined) {
      updates.push("numero_valuacion = ?");
      values.push(numero_valuacion);
    }
    if (amortizacion !== undefined) {
      updates.push("amortizacion = ?");
      values.push(parseFloat(amortizacion)); // Añadir la amortización a la consulta
    }

    // Agregar el ID al final de los valores
    values.push(id);

    // Completar la consulta
    query += updates.join(", ") + " WHERE id = ?";

    // Ejecutar la consulta
    await pool.query(query, values);

    // Devolver una respuesta exitosa
    res.status(200).json({
      message: "Costo actualizado exitosamente.",
    });
  } catch (error) {
    console.error("Error al actualizar el costo:", error);
    res.status(500).json({
      message: "Ocurrió un error al procesar la solicitud.",
    });
  }
};