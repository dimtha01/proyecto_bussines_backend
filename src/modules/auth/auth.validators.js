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

export default loginValidator;