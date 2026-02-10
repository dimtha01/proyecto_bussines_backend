import { Router } from "express";
import { uploadApkMiddleware } from "../middleware/multer.middleware.js";
import {
  uploadApk,
  getLatestApk,
  getAllApks,
  downloadApk,
  deleteApk
} from "../controllers/app.controller.js";

const router = Router();

// Subir una nueva APK
router.post("/upload", uploadApkMiddleware, uploadApk);

// Obtener la última versión de la APK
router.get("/latest", getLatestApk);

// Obtener todas las APKs
router.get("/list", getAllApks);

// Descargar una APK por ID
router.get("/download/:apkId", downloadApk);

// Eliminar una APK por ID
router.delete("/:apkId", deleteApk);

// Test endpoint
router.get("/test", (req, res) => {
  res.json({ message: "API is working!" });
});

export default router;
