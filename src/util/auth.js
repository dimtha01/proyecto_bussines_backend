import jwt from "jsonwebtoken"
import bcrypt from "bcryptjs"

export const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET)
}

export const hashPassword = (password) => {
  return bcrypt.hash(password, 10);
}