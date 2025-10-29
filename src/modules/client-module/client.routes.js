import { Router } from "express";
import { createCliente, getClientes, updateCliente } from "./client.controller.js";
import { validateClientCreate, validateClientUpdate } from "./client.validators.js";

const router = Router();

router.get("/", getClientes);
router.post("/", validateClientCreate, createCliente);
router.put("/:id", validateClientUpdate, updateCliente);
export default router;
