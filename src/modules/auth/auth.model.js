import loginValidator from "./auth.validators.js";
import { authService } from "./auth.service.js";
import { generateToken } from "../../util/auth.js";
import { createSuccessResponse, createErrorResponse } from "../../util/response.js";

const authModel = {
  userLogin: async (email, password) => {
    try {
      if (!loginValidator.isEmail(email) || !loginValidator.isPassword(password)) {
        return createErrorResponse("Email o contraseña inválidos", null, 400)
      }

      const user = await authService.getUserByEmail(email)

      if (!user) {
        return createErrorResponse("Usuario no encontrado", null, 401)
      }
      if (!(await loginValidator.isPasswordMatch(password, user.password))) {
        return createErrorResponse("Contraseña incorrecta", null, 401)
      }
      const token = generateToken(user.id)
      return createSuccessResponse("Login exitoso", {
        token, user: {
          id: user.id,
          email: user.email,
          role: user.roleName,
          permissionEdit: user.permissionEdit === 1,
        }
      }, 200)
    } catch (error) {
      return createErrorResponse("Error al iniciar sesión", error, 500)
    }
  },
  userRegister: async (email, password, roleName) => {
    try {
      const existingUsers = await authService.getUserByEmail(email);

      if (existingUsers !== null) {
        return createErrorResponse("El usuario ya existe", null, 400)
      }

      const role = await authService.getRoleByName(roleName)
      console.log(role)
      const user = await authService.createUser(email, password, role)

      return createSuccessResponse("Usuario registrado exitosamente", { token: user.token, user: user.user }, 201)
    }
    catch (error) {
      console.log(error)
      return createErrorResponse("Error al registrar usuario", error, 500)
    }
  },
  getUserProfile: async (id) => {
    try {
      const user = await authService.getUserById(id); 
      if (user === null) {
        return createErrorResponse("Usuario no encontrado", null, 404)
      }
      return createSuccessResponse("Usuario encontrado", {
        id: user.id,
        email: user.email,
        role: user.roleName,
        permissionEdit: user.permissionEdit === 1,
      }, 200)
    }
    catch (error) {
      console.log(error)
      return createErrorResponse("Error al obtener el perfil del usuario", error, 500)
    }
  }
}

export default authModel;