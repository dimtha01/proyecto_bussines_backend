import bcrypt from "bcryptjs";

const loginValidator = {
  isEmail: (value) => {
    if (!value) {
      return false;
    }
    if (typeof value !== "string") {
      return false;
    }
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
  },
  isPassword: (value) => {
    if (!value) {
      return false;
    }
    if (typeof value !== "string") {
      return false;
    }
    
    // // Mínimo 8 caracteres
    // if (value.length < 8) {
    //   return false;
    // }
    
    // // Al menos una letra mayúscula
    // if (!/[A-Z]/.test(value)) {
    //   return false;
    // }
    
    // // Al menos una letra minúscula
    // if (!/[a-z]/.test(value)) {
    //   return false;
    // }
    
    // // Al menos un número
    // if (!/[0-9]/.test(value)) {
    //   return false;
    // }
    
    // // Al menos un carácter especial
    // if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(value)) {
    //   return false;
    // }
    
    // // Sin espacios en blanco
    // if (/\s/.test(value)) {
    //   return false;
    // }
    
    return true;
  },
  isPasswordMatch: (password, userPassword) => {
    return bcrypt.compare(password, userPassword);
  }
  
}

export const validateLogin = (req, res, next) => {
  const { email, password } = req.body

  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: "Email y password son requeridos"
    });
  }

  if (!loginValidator.isEmail(email)) {
    return res.status(400).json({
      success: false,
      message: "Formato de email inválido"
    });
  }

  if (!loginValidator.isPassword(password)) {
    return res.status(400).json({
      success: false,
      message: "Password inválido"
    });
  }

  next();
}

export const validateRegister = (req, res, next) => {
  const { email, password, roleName } = req.body

  if (!email || !password || !roleName) {
    return res.status(400).json({
      success: false,
      message: "Email, password y roleName son requeridos"
    });
  }

  if (!loginValidator.isEmail(email)) {
    return res.status(400).json({
      success: false,
      message: "Formato de email inválido"
    });
  }

  if (!loginValidator.isPassword(password)) {
    return res.status(400).json({
      success: false,
      message: "Password inválido"
    });
  }

  next();
}

export default loginValidator;