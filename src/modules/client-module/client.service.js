import { pool } from "../../db.js";
import { createErrorResponse } from "../../util/response.js";

export const clientService = {
  getClientes: async (region) => {
    try {
      let query = `
      SELECT 
        c.id, 
        c.nombre, 
        c.email, 
        c.telefono, 
        c.direccion, 
        c.unidad_negocio, 
        c.razon_social, 
        c.nombre_comercial,
        c.id_region,
        r.nombre AS region
      FROM clientes c
      LEFT JOIN regiones r ON c.id_region = r.id
    `;

      if (region) {
        query += ` WHERE r.nombre = ?`;
      }
      const [result] = await pool.query(query, region ? [region] : [])
      return result;
    } catch (error) {
      console.error(error);
      return createErrorResponse("Error al obtener los clientes", error.message, 500);
    }
  },
  getClienteById: async (id) => {
    try {
      const [result] = await pool.query(
        `SELECT * FROM clientes WHERE id = ?`,
        [id]
      );
      return result[0];
    }
    catch (error) {
      console.error(error);
      return createErrorResponse("Error al obtener el cliente", error.message, 500);
    }
  },
  createCliente: async (cliente) => {
    try {
      const { nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion } = cliente;
      const [rows] = await pool.query(
        `INSERT INTO clientes (nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion]
      );
      const [result] = await clientService.getClienteById(rows.insertId);
      return result[0];
    } catch (error) {
      console.error(error);
      return createErrorResponse("Error al crear el cliente", error.message, 500);
    }
  },
  updateCliente: async (id, cliente) => {
    try {
      const { nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion } = cliente;
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

      await pool.query(query, values);
      return await clientService.getClienteById(id);
    }
    catch (error) {
      console.error(error);
      return createErrorResponse("Error al actualizar el cliente", error.message, 500);
    }
  }

}