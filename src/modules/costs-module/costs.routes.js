import { Router } from "express";
import { getAllCostosByProyecto } from "./costs.controller.js";
import { validateCostsIsById } from "./costs.validators.js";

const router = Router();

router.get("/:id", validateCostsIsById, getAllCostosByProyecto);

export default router;