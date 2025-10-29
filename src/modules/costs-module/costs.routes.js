import { Router } from "express";
import { createCostos, getAllCostosByProyecto, updateCostoEstatus } from "./costs.controller.js";
import { validateCostsIsById, validateCostsIsCreate, validateCostsIsEstatus } from "./costs.validators.js";


export const costsRoutes = Router();

costsRoutes.get("/:id", validateCostsIsById, getAllCostosByProyecto);
costsRoutes.put("/:id/estatus", validateCostsIsById, validateCostsIsEstatus, updateCostoEstatus);
costsRoutes.post("/", validateCostsIsCreate, createCostos);

export default costsRoutes;