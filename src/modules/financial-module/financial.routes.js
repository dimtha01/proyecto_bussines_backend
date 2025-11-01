import Router from "express";
import { financialValidator } from "./financial.validator.js";
import { createAvanceFinanciero } from "./financial.controller.js";
const router = Router();

router.post("", financialValidator, createAvanceFinanciero);

export default router;