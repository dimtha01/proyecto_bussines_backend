import { pool } from "../../../db.js";
import { createErrorResponse } from "../../../util/response.js";

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
  createCliente: async (cliente) => {
    try {
      const { nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion } = cliente;
      const [rows] = await pool.query(
        `INSERT INTO clientes (nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [nombre, razon_social, nombre_comercial, direccion_fiscal, pais, id_region, unidad_negocio, email, telefono, direccion]
      );
      const [result] = await pool.query(
        `SELECT * FROM clientes WHERE id = ?`,
        [rows.insertId]
      );
      return result[0];
    } catch (error) {
      console.error(error);
      return createErrorResponse("Error al crear el cliente", error.message, 500);
    }
  }
}