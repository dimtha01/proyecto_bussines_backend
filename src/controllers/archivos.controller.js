// controllers/archivos.controller.js
import { pool } from "../db.js";
import { detectFileType } from "../middleware/multer.middleware.js";
import fs from "fs/promises";
import path from "path";
import { emitNotification } from "../socket.js";

// =====================================================
// CONFIG: Root absoluto de uploads (portable local/prod)
// =====================================================
const UPLOADS_ROOT = process.env.UPLOADS_ROOT
  ? path.resolve(process.env.UPLOADS_ROOT)
  : path.resolve(process.cwd(), "uploads"); // uploads/ en la raíz del proyecto [web:136]

// Convierte "uploads/pdf/x.pdf" o "/uploads/pdf/x.pdf" -> "pdf/x.pdf"
const toUploadsRelative = (rutaArchivo) => {
  const p = String(rutaArchivo || "").replace(/\\/g, "/").replace(/^\//, "");
  return p.startsWith("uploads/") ? p.slice("uploads/".length) : p;
};

// Formatear tamaño de archivo en bytes a formato legible
const formatearTamano = (bytes) => {
  if (bytes === 0) return "0 Bytes";
  const k = 1024;
  const tamaños = ["Bytes", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + " " + tamaños[i];
};

// Construye el path absoluto real dentro de UPLOADS_ROOT y valida que no se salga
const resolveSafeUploadPath = (rutaArchivo) => {
  const rel = toUploadsRelative(rutaArchivo);
  const abs = path.resolve(UPLOADS_ROOT, rel);
  // Evita traversal: abs debe quedar dentro de UPLOADS_ROOT [web:144]
  if (!abs.startsWith(UPLOADS_ROOT + path.sep) && abs !== UPLOADS_ROOT) {
    throw new Error("Ruta inválida (path traversal)");
  }
  return abs;
};

// =====================================================
// SUBIR ARCHIVOS
// =====================================================
export const uploadProjectFiles = async (req, res) => {
  try {
    const { projectId } = req.params;
    const files = req.files ?? [];

    if (!files.length) {
      return res.status(400).json({ message: "Debes subir al menos un archivo" });
    }

    const [projectExists] = await pool.query("SELECT id FROM proyectos WHERE id = ?", [projectId]);
    if (projectExists.length === 0) {
      return res.status(404).json({ message: "Proyecto no encontrado" });
    }

    // Guardar SIEMPRE ruta relativa (recomendado: "uploads/...")
    // Asumo que file.relativePath viene como "uploads/xxx/yyy.ext".
    const values = files.map((file) => {
      const relativePath = String(file.relativePath || "").replace(/\\/g, "/").replace(/^\//, "");
      if (!relativePath) {
        throw new Error("El middleware de multer no está asignando file.relativePath");
      }

      return [
        projectId,                     // id_proyecto
        file.originalname,             // nombre_archivo
        relativePath,                  // ruta_archivo (RELATIVA)
        detectFileType(file.mimetype), // tipo_archivo
      ];
    });

    const [result] = await pool.query(
      `INSERT INTO archivos (id_proyecto, nombre_archivo, ruta_archivo, tipo_archivo) VALUES ?`,
      [values]
    );

    // Obtener información del proyecto para la notificación
    const [projectInfo] = await pool.query(
      "SELECT id, nombre, nombre_cortos FROM proyectos WHERE id = ?",
      [projectId]
    );

    // Usar nombre_cortos si existe, sino el nombre completo
    const nombreProyecto = projectInfo[0]?.nombre_cortos || projectInfo[0]?.nombre || `Proyecto #${projectId}`;

    // Crear lista detallada de archivos para la notificación
    const archivosDetallados = files.map((file) => {
      const tipo = detectFileType(file.mimetype);
      const tamanoBytes = file.size;
      const tamanoFormateado = formatearTamano(tamanoBytes);

      return {
        nombre: file.originalname,
        tipo: tipo,
        tamano: tamanoFormateado,
        tamanoBytes: tamanoBytes,
        mimetype: file.mimetype,
      };
    });

    // Agrupar archivos por tipo
    const archivosPorTipo = archivosDetallados.reduce((acc, arch) => {
      acc[arch.tipo] = (acc[arch.tipo] || 0) + 1;
      return acc;
    }, {});

    // Calcular tamaño total
    const tamanoTotalBytes = archivosDetallados.reduce((sum, arch) => sum + arch.tamanoBytes, 0);
    const tamanoTotal = formatearTamano(tamanoTotalBytes);

    // Crear mensaje detallado
    const tipoTexto = Object.entries(archivosPorTipo)
      .map(([tipo, cantidad]) => `${cantidad} ${tipo}${cantidad > 1 ? 's' : ''}`)
      .join(', ');

    const titulo = "Nuevos archivos subidos";
    const mensaje = `Se han subido ${result.affectedRows} archivo${result.affectedRows > 1 ? 's' : ''} a "${nombreProyecto}" (${tamanoTotal})`;

    const datosNotificacion = {
      proyecto: {
        id: parseInt(projectId),
        nombre: nombreProyecto,
      },
      resumen: {
        cantidadArchivos: result.affectedRows,
        tamanoTotal: tamanoTotal,
        tamanoTotalBytes: tamanoTotalBytes,
        tipos: archivosPorTipo,
      },
      archivos: archivosDetallados,
      fecha: new Date().toISOString(),
    };

    const [notifResult] = await pool.query(
      `INSERT INTO notificaciones (id_proyecto, titulo, mensaje, tipo, datos)
       VALUES (?, ?, ?, 'archivo_subido', ?)`,
      [projectId, titulo, mensaje, JSON.stringify(datosNotificacion)]
    );

    // Emitir notificación por WebSocket
    emitNotification({
      id: notifResult.insertId,
      id_proyecto: parseInt(projectId),
      titulo,
      mensaje,
      tipo: "archivo_subido",
      leida: false,
      datos: datosNotificacion,
      fecha_creacion: datosNotificacion.fecha,
    });

    return res.status(201).json({
      message: `${result.affectedRows} archivo(s) guardados correctamente.`,
      files: values.map((v) => ({ nombre: v[1], tipo: v[3] })),
    });
  } catch (error) {
    console.error("Error al subir archivos:", error);
    return res.status(500).json({ message: "Error interno al subir archivos" });
  }
};

// =====================================================
// LISTAR ARCHIVOS DE UN PROYECTO
// =====================================================
export const getProjectFiles = async (req, res) => {
  try {
    const { projectId } = req.params;
    const baseUrl = `${req.protocol}://${req.get("host")}`

    const [projectExists] = await pool.query("SELECT id FROM proyectos WHERE id = ?", [projectId]);
    if (projectExists.length === 0) {
      return res.status(404).json({ message: "Proyecto no encontrado" });
    }

    const [files] = await pool.query(
      `SELECT id, nombre_archivo, ruta_archivo, tipo_archivo, fecha_creacion
       FROM archivos
       WHERE id_proyecto = ?
       ORDER BY fecha_creacion DESC`,
      [projectId]
    );

    const isExternalUrl = (url) =>
      !!url && (String(url).startsWith("http://") || String(url).startsWith("https://"));

    const mappedFiles = files.map((file) => {
      const ruta = String(file.ruta_archivo || "");
      const external = isExternalUrl(ruta);

      // Si ruta_archivo es interna (relativa), expón una URL pública (si también sirves /uploads como estático)
      // Ej: baseUrl + "/uploads/pdf/archivo.pdf"
      const publicUrl = external ? ruta : `${baseUrl}/${ruta.replace(/^\//, "")}`;

      return {
        id: file.id,
        nombre: file.nombre_archivo,
        tipo: file.tipo_archivo,
        fechaCreacion: file.fecha_creacion,
        urlDescarga: `/api/archivos/descargar/${file.id}`,
        ruta_archivo: publicUrl,
      };
    });

    return res.status(200).json({ total: mappedFiles.length, archivos: mappedFiles });
  } catch (error) {
    console.error("Error al obtener archivos:", error);
    return res.status(500).json({ message: "Error interno al obtener archivos" });
  }
};

// =====================================================
// DESCARGAR ARCHIVO
// =====================================================
export const downloadFile = async (req, res) => {
  try {
    const { fileId } = req.params;

    const [files] = await pool.query(
      `SELECT nombre_archivo, ruta_archivo FROM archivos WHERE id = ?`,
      [fileId]
    );

    if (files.length === 0) {
      return res.status(404).json({ message: "Archivo no encontrado" });
    }

    const file = files[0];
    const currentFilePath = String(file.ruta_archivo || "");

    // No descargues URLs externas desde tu FS
    if (currentFilePath.startsWith("http://") || currentFilePath.startsWith("https://")) {
      return res.status(400).json({ message: "Este archivo es externo y no se descarga desde el servidor." });
    }

    // Resuelve path real dentro de UPLOADS_ROOT (portable + seguro)
    let fullPath;
    try {
      fullPath = resolveSafeUploadPath(currentFilePath);
    } catch (e) {
      return res.status(400).json({ message: "Ruta inválida" });
    }

    try {
      await fs.access(fullPath);
    } catch (_) {
      return res.status(404).json({ message: "Archivo físico no encontrado" });
    }

    // Soporte UTF-8 para nombres (acentos/ñ) con filename* [web:140]
    const encoded = encodeURIComponent(file.nombre_archivo);
    res.setHeader("Content-Disposition", `attachment; filename*=UTF-8''${encoded}`);

    return res.download(fullPath);
  } catch (error) {
    console.error("Error al descargar archivo:", error);
    return res.status(500).json({ message: "Error interno al descargar archivo" });
  }
};

// =====================================================
// ELIMINAR ARCHIVO
// =====================================================
export const deleteFile = async (req, res) => {
  try {
    const { fileId } = req.params;

    const [files] = await pool.query(
      `SELECT id, nombre_archivo, ruta_archivo FROM archivos WHERE id = ?`,
      [fileId]
    );

    if (files.length === 0) {
      return res.status(404).json({ message: "Archivo no encontrado" });
    }

    const file = files[0];
    const ruta = String(file.ruta_archivo || "");

    // Si es archivo local, intenta borrarlo físicamente
    if (!(ruta.startsWith("http://") || ruta.startsWith("https://"))) {
      try {
        const fullPath = resolveSafeUploadPath(ruta);
        await fs.unlink(fullPath);
      } catch (error) {
        console.warn("Archivo físico no encontrado o no se pudo borrar, continuando:", error.message);
      }
    }

    await pool.query("DELETE FROM archivos WHERE id = ?", [fileId]);

    return res.status(200).json({
      message: "Archivo eliminado correctamente",
      archivoEliminado: file.nombre_archivo,
    });
  } catch (error) {
    console.error("Error al eliminar archivo:", error);
    return res.status(500).json({ message: "Error interno al eliminar archivo" });
  }
};