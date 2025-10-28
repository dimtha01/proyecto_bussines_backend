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
      return createSuccessResponse("Login exitoso", { token, user: {
        id: user.id,
        email: user.email,
        role: user.roleName,
        permissionEdit: user.permissionEdit === 1,
      } }, 200)
    } catch (error) {
      return createErrorResponse("Error al iniciar sesión", error, 500)
    } 
  }
}

export default authModel;