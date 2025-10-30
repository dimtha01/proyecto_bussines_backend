import { Router } from "express";
import { createCostos, getAllCostosByProyecto, updateCosto, updateCostoEstatus } from "./costs.controller.js";
import { validateCostsIsById, validateCostsIsCreate, validateCostsIsEstatus, validateCostsIsUpdate } from "./costs.validators.js";


export const costsRoutes = Router();

costsRoutes.get("/:id", validateCostsIsById, getAllCostosByProyecto);
costsRoutes.put("/:id/estatus", validateCostsIsById, validateCostsIsEstatus, updateCostoEstatus);
costsRoutes.post("/", validateCostsIsCreate, createCostos);
costsRoutes.patch("/:id", validateCostsIsUpdate, updateCosto);

export default costsRoutes;