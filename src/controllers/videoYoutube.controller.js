import fs from 'fs';
import path from 'path';
import { google } from 'googleapis';
import { fileURLToPath } from 'url';
import { pool } from '../db.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Rutas
const TOKEN_PATH = path.join(__dirname, '..', '../config/token.json');
console.log(TOKEN_PATH);

const CREDENTIALS_PATH = path.join(__dirname, '..', '../config/credentials.json');
console.log(CREDENTIALS_PATH);

// ✅ Scope para YouTube
const SCOPES = ['https://www.googleapis.com/auth/youtube.upload'];

/**
 * Carga las credenciales de OAuth2
 */
function loadCredentials() {
  const credentials = JSON.parse(fs.readFileSync(CREDENTIALS_PATH, 'utf8'));
  const { web } = credentials;
  
  if (!web.redirect_uris || web.redirect_uris.length === 0) {
    throw new Error('Falta "redirect_uris" en credentials.json');
  }
  
  return {
    client_id: web.client_id,
    client_secret: web.client_secret,
    redirect_uris: web.redirect_uris,
  };
}

/**
 * Obtiene el cliente OAuth2 autenticado
 */
function getAuthClient() {
  const { client_id, client_secret, redirect_uris } = loadCredentials();
  const oAuth2Client = new google.auth.OAuth2(
    client_id,
    client_secret,
    redirect_uris[0]
  );

  // Cargar token existente
  if (fs.existsSync(TOKEN_PATH)) {
    const token = fs.readFileSync(TOKEN_PATH, 'utf8');
    oAuth2Client.setCredentials(JSON.parse(token));
    return oAuth2Client;
  }

  throw new Error('Token no encontrado. Ejecuta primero el proceso de autorización.');
}

/**
 * Controller: Subir video a YouTube
 */
export const uploadVideoController = async (req, res) => {
  try {
    // Verificar que se haya subido un archivo
    const { id_proyecto } = req.params;
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'No se recibió ningún video'
      });
    }

    // Obtener metadatos del body
    const {
    
      title = 'Video sin título',
      description = 'Subido automáticamente',
      tags = 'video,upload',
      categoryId = '22', // People & Blogs
      privacyStatus = 'unlisted' // private | unlisted | public
    } = req.body;

    // Validar id_proyecto
    if (!id_proyecto) {
      return res.status(400).json({
        success: false,
        message: 'id_proyecto es requerido'
      });
    }

    const videoPath = req.file.path;

    // Verificar que el archivo exista
    if (!fs.existsSync(videoPath)) {
      return res.status(400).json({
        success: false,
        message: 'Archivo de video no encontrado'
      });
    }

    // Autenticar con OAuth2
    const auth = getAuthClient();
    const youtube = google.youtube({ version: 'v3', auth });

    console.log('📤 Subiendo video a YouTube...');

    // Subir video a YouTube
    const response = await youtube.videos.insert({
      part: 'snippet,status',
      requestBody: {
        snippet: {
          title,
          description,
          tags: tags.split(',').map(tag => tag.trim()),
          categoryId,
        },
        status: {
          privacyStatus,
        },
      },
      media: {
        mimeType: req.file.mimetype,
        body: fs.createReadStream(videoPath),
      },
    });

    const videoId = response.data.id;
    const youtubeUrl = `https://youtu.be/${videoId}`;

    console.log('✅ Video subido con éxito:', videoId);

    // Guardar información en la base de datos
    const values = [[
      id_proyecto,
      req.file.originalname,
      youtubeUrl, // Guardamos la URL de YouTube en lugar de la ruta local
      'video'
    ]];

    const [result] = await pool.query(
      `INSERT INTO archivos 
      (id_proyecto, nombre_archivo, ruta_archivo, tipo_archivo) 
      VALUES ?`,
      [values]
    );

    console.log('✅ Información guardada en BD:', result.insertId);

    // Eliminar archivo temporal después de subir
    fs.unlinkSync(videoPath);

    // Responder con éxito
    return res.status(200).json({
      success: true,
      message: 'Video subido exitosamente',
      data: {
        videoId: videoId,
        url: youtubeUrl,
        title: response.data.snippet.title,
        privacyStatus: response.data.status.privacyStatus,
        dbInsertId: result.insertId
      }
    });

  } catch (error) {
    console.error('❌ Error al subir video:', error.message);

    // Eliminar archivo temporal en caso de error
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }

    return res.status(500).json({
      success: false,
      message: 'Error al subir el video',
      error: error.message
    });
  }
};

/**
 * Controller: Obtener URL de autorización OAuth2
 */
export const getAuthUrlController = (req, res) => {
  try {
    const { client_id, client_secret, redirect_uris } = loadCredentials();
    const oAuth2Client = new google.auth.OAuth2(
      client_id,
      client_secret,
      redirect_uris[0]
    );

    const authUrl = oAuth2Client.generateAuthUrl({
      access_type: 'offline',
      scope: SCOPES,
      include_granted_scopes: true,
    });

    res.status(200).json({
      success: true,
      authUrl,
      message: 'Abre esta URL para autorizar la aplicación'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

/**
 * Controller: Guardar token OAuth2 después de autorización
 */
export const saveTokenController = async (req, res) => {
  try {
    const { code } = req.body;

    if (!code) {
      return res.status(400).json({
        success: false,
        message: 'Código de autorización requerido'
      });
    }

    const { client_id, client_secret, redirect_uris } = loadCredentials();
    const oAuth2Client = new google.auth.OAuth2(
      client_id,
      client_secret,
      redirect_uris[0]
    );

    const { tokens } = await oAuth2Client.getToken(code);
    oAuth2Client.setCredentials(tokens);

    // Guardar token en archivo
    fs.writeFileSync(TOKEN_PATH, JSON.stringify(tokens, null, 2));

    res.status(200).json({
      success: true,
      message: 'Token guardado exitosamente'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};
