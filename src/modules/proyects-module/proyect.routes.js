import { Router } from "express";
import { getProyects } from "./proyect.controller.js";
const router = Router();

router.get("/", getProyects);
export default router;