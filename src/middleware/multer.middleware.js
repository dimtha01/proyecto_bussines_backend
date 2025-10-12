import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import slugify from 'slugify';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Ruta base de almacenamiento
const rootDir = path.resolve(process.cwd(), 'uploads');

// Mapas MIME por tipo de archivo permitido
const MIME_GROUPS = {
  image: new Set(['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
  pdf: new Set(['application/pdf']),
  document: new Set([
    'application/msword', 
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
    'application/vnd.ms-excel', 
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  ])
};

// Detectar tipo de archivo
export function detectFileType(mimetype) {
  if (MIME_GROUPS.image.has(mimetype)) return 'image';
  if (MIME_GROUPS.pdf.has(mimetype)) return 'pdf';
  if (MIME_GROUPS.document.has(mimetype)) return 'document';
  return 'unknown';
}

// Función para crear directorios dinámicos
function createDynamicDirectory(fileType) {
  const typeDir = path.join(rootDir, fileType);
  
  // Crear directorio si no existe
  if (!fs.existsSync(typeDir)) {
    fs.mkdirSync(typeDir, { recursive: true });
  }
  
  return typeDir;
}

// Multer storage configurado con slugify
const storage = multer.diskStorage({
  destination(req, file, cb) {
    // Detectar tipo de archivo y crear directorio correspondiente
    const fileType = detectFileType(file.mimetype);
    const uploadDir = createDynamicDirectory(fileType);
    
    cb(null, uploadDir);
  },
  filename(req, file, cb) {
    // Usar slugify para normalizar el nombre del archivo
    const slugifiedName = slugify(path.parse(file.originalname).name, {
      replacement: '-',  // reemplazar espacios y caracteres especiales con guión
      lower: true,       // convertir a minúsculas
      strict: true,      // eliminar caracteres no permitidos
      trim: true         // eliminar espacios al inicio y final
    });

    // Obtener la extensión original
    const ext = path.extname(file.originalname).toLowerCase();
    
    // Crear nombre único combinando nombre slugificado, timestamp y extensión
    const uniqueName = `${slugifiedName}-${Date.now()}${ext}`;
    
    cb(null, uniqueName);
  },
});

// Filtro de archivos según tipo permitido
function fileFilter(req, file, cb) {
  const type = detectFileType(file.mimetype);
  if (type === 'unknown') {
    return cb(new multer.MulterError('LIMIT_UNEXPECTED_FILE', `Tipo de archivo no permitido: ${file.mimetype}`));
  }
  cb(null, true);
}

// Configuración completa de multer
const upload = multer({
  storage,
  fileFilter,
  limits: { 
    fileSize: 50 * 1024 * 1024, // 50 MB máximo por archivo
    files: 10 // Máximo 10 archivos a la vez
  }, 
});

// Middleware exportado para subir múltiples archivos
export const autoUpload = upload.array('files', 10);

export const uploadMiddleware = (req, res, next) => {
  autoUpload(req, res, (err) => {
    if (err instanceof multer.MulterError) {
      // Error de Multer (por ejemplo, archivo demasiado grande)
      return res.status(400).json({
        message: err.message || 'Error al subir archivos'
      });
    } else if (err) {
      // Otros errores
      return res.status(500).json({
        message: err.message || 'Error interno del servidor'
      });
    }

    // Si no hay archivos, enviar error
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({ 
        message: 'Debes subir al menos un archivo' 
      });
    }

    // Mapear archivos subidos con sus rutas relativas
    req.files = req.files.map(file => ({
      ...file,
      relativePath: path.relative(process.cwd(), file.path)
    }));

    // Continuar con la solicitud
    next();
  });
};

// Función de utilidad para obtener la ruta relativa de un archivo
export function getRelativeFilePath(fullPath) {
  return path.relative(process.cwd(), fullPath);
}
