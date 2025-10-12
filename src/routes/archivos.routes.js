// routes/archivos.routes.js
import { Router } from 'express';
import { uploadMiddleware } from '../middleware/multer.middleware.js';
import {
    uploadProjectFiles,
    getProjectFiles,
    downloadFile,
    deleteFile
} from '../controllers/archivos.controller.js';

const router = Router();

// Subir archivos a un proyecto
router.post('/proyectos/:projectId/upload',
    uploadMiddleware,
    uploadProjectFiles
);

// Obtener archivos de un proyecto
router.get('/proyectos/:projectId/files', getProjectFiles);

// Descargar un archivo
router.get('/descargar/:fileId', downloadFile);

// Eliminar un archivo
router.delete('/eliminar/:fileId', deleteFile);

export default router;
