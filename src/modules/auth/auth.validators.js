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
    return /^[a-zA-Z0-9]+$/.test(value);
  },
  isPasswordMatch: (password, userPassword) => {
    return bcrypt.compare(password, userPassword);
  }
  
}

export default loginValidator;