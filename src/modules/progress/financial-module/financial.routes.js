import Router from "express";
import { financialValidator, financialValidatorById, updateAvanceFinancieroValidator, updateEstatusValidator, updateMontoValidator } from "./financial.validator.js";
import { createAvanceFinanciero, updateAvanceFinanciero, getAvanceFinanciero, getAvanceFinancieroByProyectoId, updateEstatusAvanceFinanciero, updateMontoAvanceFinanciero } from "./financial.controller.js";
const router = Router();

router.get("/", getAvanceFinanciero);
router.get("/:id_proyecto", financialValidatorById, getAvanceFinancieroByProyectoId);
router.post("/", financialValidator, createAvanceFinanciero);
router.put("/:id", updateAvanceFinancieroValidator, updateAvanceFinanciero);
router.put("/:id", updateEstatusValidator, updateEstatusAvanceFinanciero);
router.put("/:id", updateMontoValidator, updateMontoAvanceFinanciero);

export default router;