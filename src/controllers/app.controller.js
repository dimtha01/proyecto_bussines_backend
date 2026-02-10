import { pool } from "../db.js";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const UPLOADS_ROOT = process.env.UPLOADS_ROOT
  ? path.resolve(process.env.UPLOADS_ROOT)
  : path.resolve(process.cwd(), "uploads");

const APK_DIR = path.join(UPLOADS_ROOT, "apk");

const ensureApkDir = async () => {
  try {
    await fs.access(APK_DIR);
  } catch {
    await fs.mkdir(APK_DIR, { recursive: true });
  }
};

export const uploadApk = async (req, res) => {
  try {
    await ensureApkDir();

    if (!req.file) {
      return res.status(400).json({ message: "Debes subir un archivo APK" });
    }

    const { version, description, forceUpdate = false } = req.body;

    const fileName = req.file.filename;
    const relativePath = path.join("apk", fileName);
    const fileSize = req.file.size;

    const [result] = await pool.query(
      `INSERT INTO apks (nombre_archivo, ruta_archivo, version, descripcion, fuerza_actualizacion, tamano)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [req.file.originalname, relativePath, version, description, forceUpdate, fileSize]
    );

    return res.status(201).json({
      message: "APK subida correctamente",
      apk: {
        id: result.insertId,
        nombre: req.file.originalname,
        version,
        descripcion: description,
        fuerza_actualizacion: !!forceUpdate,
        tamano: fileSize
      }
    });
  } catch (error) {
    console.error("Error al subir APK:", error);
    return res.status(500).json({ message: "Error interno al subir APK" });
  }
};

export const getLatestApk = async (req, res) => {
  try {
    const { currentVersion } = req.query;

    let query = `SELECT id, nombre_archivo, ruta_archivo, version, descripcion, fuerza_actualizacion, tamano, fecha_creacion
                 FROM apks
                 ORDER BY fecha_creacion DESC
                 LIMIT 1`;

    const [apks] = await pool.query(query);

    if (apks.length === 0) {
      return res.status(404).json({ message: "No hay APKs disponibles" });
    }

    const apk = apks[0];
    const needsUpdate = currentVersion && currentVersion !== apk.version;

    return res.status(200).json({
      id: apk.id,
      nombre: apk.nombre_archivo,
      version: apk.version,
      descripcion: apk.descripcion,
      tamano: apk.tamano,
      urlDescarga: `/api/app/download/${apk.id}`,
      necesitaActualizacion: apk.fuerza_actualizacion ? true : needsUpdate,
      actualizacionForzada: !!apk.fuerza_actualizacion,
      fechaCreacion: apk.fecha_creacion
    });
  } catch (error) {
    console.error("Error al obtener APK:", error);
    return res.status(500).json({ message: "Error interno al obtener APK" });
  }
};

export const getAllApks = async (req, res) => {
  try {
    const [apks] = await pool.query(
      `SELECT id, nombre_archivo, version, descripcion, fuerza_actualizacion, tamano, fecha_creacion
       FROM apks
       ORDER BY fecha_creacion DESC`
    );

    const baseUrl = `https://${req.get("host")}`;

    const mappedApks = apks.map((apk) => ({
      id: apk.id,
      nombre: apk.nombre_archivo,
      version: apk.version,
      descripcion: apk.descripcion,
      tamano: apk.tamano,
      actualizacionForzada: !!apk.fuerza_actualizacion,
      fechaCreacion: apk.fecha_creacion,
      urlDescarga: `/api/app/download/${apk.id}`
    }));

    return res.status(200).json({ total: mappedApks.length, apks: mappedApks });
  } catch (error) {
    console.error("Error al obtener APKs:", error);
    return res.status(500).json({ message: "Error interno al obtener APKs" });
  }
};

export const downloadApk = async (req, res) => {
  try {
    const { apkId } = req.params;

    const [apks] = await pool.query(
      `SELECT nombre_archivo, ruta_archivo FROM apks WHERE id = ?`,
      [apkId]
    );

    if (apks.length === 0) {
      return res.status(404).json({ message: "APK no encontrada" });
    }

    const apk = apks[0];
    const fullPath = path.resolve(UPLOADS_ROOT, apk.ruta_archivo);

    try {
      await fs.access(fullPath);
    } catch {
      return res.status(404).json({ message: "Archivo APK no encontrado" });
    }

    const encoded = encodeURIComponent(apk.nombre_archivo);
    res.setHeader("Content-Disposition", `attachment; filename*=UTF-8''${encoded}`);
    res.setHeader("Content-Type", "application/vnd.android.package-archive");

    return res.download(fullPath);
  } catch (error) {
    console.error("Error al descargar APK:", error);
    return res.status(500).json({ message: "Error interno al descargar APK" });
  }
};

export const deleteApk = async (req, res) => {
  try {
    const { apkId } = req.params;

    const [apks] = await pool.query(
      `SELECT id, nombre_archivo, ruta_archivo FROM apks WHERE id = ?`,
      [apkId]
    );

    if (apks.length === 0) {
      return res.status(404).json({ message: "APK no encontrada" });
    }

    const apk = apks[0];
    const fullPath = path.resolve(UPLOADS_ROOT, apk.ruta_archivo);

    try {
      await fs.unlink(fullPath);
    } catch (error) {
      console.warn("Archivo físico no encontrado o no se pudo borrar:", error.message);
    }

    await pool.query("DELETE FROM apks WHERE id = ?", [apkId]);

    return res.status(200).json({
      message: "APK eliminada correctamente",
      apkEliminada: apk.nombre_archivo
    });
  } catch (error) {
    console.error("Error al eliminar APK:", error);
    return res.status(500).json({ message: "Error interno al eliminar APK" });
  }
};
