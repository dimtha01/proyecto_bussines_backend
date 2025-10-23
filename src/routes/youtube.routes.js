import express from 'express';

import { videoUpload } from '../middleware/multerConfig.js';
import { uploadVideoController } from '../controllers/videoYoutube.controller.js';

const router = express.Router();

// // Ruta para obtener URL de autorización
// router.get('/auth-url', getAuthUrlController);

// // Ruta para guardar token después de autorizar
// router.post('/save-token', saveTokenController);

// Ruta para subir video a YouTube
router.post('/upload/:id_proyecto', videoUpload.single('video'), uploadVideoController);

export default router;
