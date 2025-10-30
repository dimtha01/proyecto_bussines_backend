import { pool } from "../../db.js";
import statusModel from "./status.model.js";

export const getStatus = async (req, res) => {
  const result = await statusModel.getStatus();
  return res.status(result.status).json(result);
};
