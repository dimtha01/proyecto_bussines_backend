import { Router } from "express";
import { createPhysical } from "./physical.controller.js";
import { ValidatePhysicalCreate } from "./physical.validators.js";

const router = Router();
router.post("/", ValidatePhysicalCreate, createPhysical);
export default router;