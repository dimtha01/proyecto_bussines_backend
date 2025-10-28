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