import { pool } from "../../db.js";

export const authService = {
  getUserByEmail: async (email) => {
    try {
      const [users] = await pool.query(`
        SELECT u.*, r.name as roleName, r.permissionEdit, reg.nombre as regionName
        FROM users u
        JOIN roles r ON u.roleId = r.id
        JOIN regiones reg ON reg.id = u.id_region
        WHERE u.email = ?
      `, [email]);
      return users.length > 0 ? users[0] : null;
    } catch (error) {
      console.error("Error al obtener el usuario por email:", error);
      throw error;
    }
  }
}