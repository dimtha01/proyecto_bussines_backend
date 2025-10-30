import { Router } from "express";
import { getRegiones } from "./regions.controller.js";

const router = Router();

router.get("/", getRegiones);

export default router;