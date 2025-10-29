import { pool } from "../../db.js";
import { hashPassword } from "../../util/auth.js";
import { generateToken } from "../../util/auth.js";

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
  },
  getRoleByName: async (name) => {
    try {
      const [roles] = await pool.query("SELECT * FROM roles WHERE name = ?", [name]);
      console.log(roles)
      return roles.length > 0 ? roles[0] : null;
    } catch (error) {
      console.error("Error al obtener el rol por nombre:", error);
      throw error;
    }
  },
  getUserById: async (id) => {
    try {
      const [user] = await pool.query(`
        SELECT u.*, r.name as roleName, r.permissionEdit, reg.nombre as regionName
        FROM users u
        JOIN roles r ON u.roleId = r.id
        JOIN regiones reg ON reg.id = u.id_region
        WHERE u.id = ?
      `, [id]);
      return user.length > 0 ? user[0] : null;
    }
    catch (error) {
      console.error("Error al obtener el usuario por ID:", error);
      throw error;
    }
  },
  createUser: async (email, password, role) => {
    try {
      const hashedPassword = await hashPassword(password);
        const [result] = await pool.query("INSERT INTO users (email, password, roleId) VALUES (?, ?, ?)", [email, hashedPassword, role.id]);
      return { token: generateToken(result.insertId), user: { id: result.insertId, email, role: role.name , permissionEdit: role.permissionEdit === 1} };
    }
    catch (error) {
      console.error("Error al crear el usuario:", error);
      throw error;
    }
  }
}