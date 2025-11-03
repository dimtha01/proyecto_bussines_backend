import Router from "express";
import { financialValidator, updateAvanceFinancieroValidator } from "./financial.validator.js";
import { createAvanceFinanciero, updateAvanceFinanciero, getAvanceFinanciero, getAvanceFinancieroByProyectoId } from "./financial.controller.js";
const router = Router();

router.get("/", getAvanceFinanciero);
router.get("/:id" ,getAvanceFinancieroByProyectoId);
router.post("/", financialValidator, createAvanceFinanciero);
router.put("/:id", updateAvanceFinancieroValidator, updateAvanceFinanciero);
// router.put("", financialValidator, updateEstatusAvanceFinanciero);
// router.put("", financialValidator, updateMontoAvanceFinanciero);

export default router;