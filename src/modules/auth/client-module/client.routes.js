import { Router } from "express";
import { createCliente, getClientes } from "./client.controller.js";
import { validateClientCreate } from "./client.validators.js";

const router = Router();

router.get("/", getClientes);
router.post("/", validateClientCreate, createCliente);
export default router;
