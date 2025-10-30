import { Router } from "express";
import { getRegiones } from "./regions.controller.js";

const router = Router();

router.get("/regiones", getRegiones);

export default router;