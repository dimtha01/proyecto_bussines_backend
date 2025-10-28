import authModel from "./auth.model.js";


export const login = async (req, res) => {
  try {
    const { email, password } = req.body
    const { success, message, data, status } = await authModel.userLogin(email, password);

    res.status(status).json({
      success: success,
      message: message,
      data: data,
    });
  } catch (error) {
    console.error("Login error:", error)
    return res.status(500).json({
      success: false,
      message: "Error al iniciar sesión",
      error: error.message,
    });
  }
}

export const register = async (req, res) => {
  try {
    const { email, password, roleName } = req.body
    console.log(email, password, roleName);

    const { success, message, data, status } = await authModel.userRegister(email, password, roleName);    
    res.status(201).json({
      success: success,
      message: message,
      data: data,
    });
  } catch (error) {
    console.error("Register error:", error)
    res.status(500).json({
      success: false,
      message: "Error al registrar usuario",
      error: error.message,
    });
  }
}