import { Router } from "express";
import { getAllCostosByProyecto, updateCostoEstatus } from "./costs.controller.js";
import { validateCostsIsById, validateCostsIsEstatus } from "./costs.validators.js";


export const costsRoutes = Router();

costsRoutes.get("/:id", validateCostsIsById, getAllCostosByProyecto);
costsRoutes.put("/:id/estatus", validateCostsIsById, validateCostsIsEstatus, updateCostoEstatus);

export default costsRoutes;