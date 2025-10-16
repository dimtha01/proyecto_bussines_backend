import { pool } from "../db.js";
import { detectFileType } from "../middleware/multer.middleware.js";
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Controlador para subir archivos a un proyecto específico
export const uploadProjectFiles = async (req, res) => {
    try {
        // Obtener el ID del proyecto desde el request
        const { projectId } = req.params;

        // Obtener los archivos subidos
        const files = req.files ?? [];


        // Validar que al menos un archivo se haya subido
        if (!files.length) {
            return res.status(400).json({ message: 'Debes subir al menos un archivo' });
        }

        // Validar que el proyecto exista
        const [projectExists] = await pool.query(
            'SELECT id FROM proyectos WHERE id = ?',
            [projectId]
        );

        if (projectExists.length === 0) {
            return res.status(404).json({ message: 'Proyecto no encontrado' });
        }

        // Construir los valores para la base de datos
        const values = files.map(file => [
            projectId,                         // id_proyecto
            file.originalname,                 // nombre_archivo
            file.relativePath,                         // ruta_archivo 
            detectFileType(file.mimetype),     // tipo_archivo
        ]);

        // Insertar múltiples archivos en la tabla archivos
        const [result] = await pool.query(
            `INSERT INTO archivos 
            (id_proyecto, nombre_archivo, ruta_archivo, tipo_archivo) 
            VALUES ?`,
            [values]
        );

        // Respuesta exitosa
        res.status(201).json({
            message: `${result.affectedRows} archivo(s) guardados correctamente.`,
            files: values.map(v => ({
                nombre: v[1],
                tipo: v[3]
            }))
        });

    } catch (error) {
        console.error('Error al subir archivos:', error);
        res.status(500).json({ message: 'Error interno al subir archivos' });
    }
};

// Controlador para listar archivos de un proyecto
export const getProjectFiles = async (req, res) => {
    try {
        const { projectId } = req.params;
        const baseUrl = `${req.protocol}://${req.get('host')}`;


        // Validar que el proyecto exista
        const [projectExists] = await pool.query(
            'SELECT id FROM proyectos WHERE id = ?',
            [projectId]
        );

        if (projectExists.length === 0) {
            return res.status(404).json({ message: 'Proyecto no encontrado' });
        }

        // Obtener todos los archivos del proyecto
        const [files] = await pool.query(
            `SELECT 
                id, 
                nombre_archivo, 
                ruta_archivo, 
                tipo_archivo, 
                fecha_creacion 
            FROM archivos 
            WHERE id_proyecto = ?
            ORDER BY fecha_creacion DESC`,
            [projectId]
        );

        // Mapear archivos para incluir URL de descarga
        const mappedFiles = files.map(file => ({
            id: file.id,
            nombre: file.nombre_archivo,
            tipo: file.tipo_archivo,
            fechaCreacion: file.fecha_creacion,
            urlDescarga: `/api/archivos/descargar/${file.id}`,
            ruta_archivo: `${baseUrl}/${file.ruta_archivo}`
        }));

        res.status(200).json({
            total: mappedFiles.length,
            archivos: mappedFiles
        });

    } catch (error) {
        console.error('Error al obtener archivos:', error);
        res.status(500).json({ message: 'Error interno al obtener archivos' });
    }
};

// Controlador para descargar un archivo
export const downloadFile = async (req, res) => {
    try {
        const { fileId } = req.params;

        // Buscar información del archivo
        const [files] = await pool.query(
            `
        SELECT
            nombre_archivo,
            ruta_archivo
        FROM
            archivos
        WHERE
            id = ?
            `,
            [fileId]
        );

        if (files.length === 0) {
            return res.status(404).json({ message: 'Archivo no encontrado' });
        }

        const file = files[0];
        const currentFilePath = file.ruta_archivo;

        const fullPath = path.join(__dirname, '..', currentFilePath);
        console.log(fullPath);

        // Verificar si el archivo existe
        try {
            await fs.access(fullPath);
        } catch (error) {
            return res.status(404).json({ message: 'Archivo físico no encontrado' });
        }

        // Configurar headers para descarga
        res.setHeader('Content-Disposition', `attachment; filename=${file.nombre_archivo}`);

        // Enviar archivo
        res.download(fullPath, file.nombre_archivo, (err) => {
            if (err) {
                console.error('Error al descargar archivo:', err);
                res.status(500).json({ message: 'Error al descargar archivo' });
            }
        });

    } catch (error) {
        console.error('Error al descargar archivo:', error);
        res.status(500).json({ message: 'Error interno al descargar archivo' });
    }
};

// Controlador para eliminar un archivo
export const deleteFile = async (req, res) => {
    try {
        const { fileId } = req.params;

        // Buscar información del archivo
        const [files] = await pool.query(
            `SELECT 
                id, 
                nombre_archivo, 
                ruta_archivo 
            FROM archivos 
            WHERE id = ?`,
            [fileId]
        );

        if (files.length === 0) {
            return res.status(404).json({ message: 'Archivo no encontrado' });
        }

        const file = files[0];

        // Eliminar archivo físico
        try {
            await fs.unlink(file.ruta_archivo);
        } catch (error) {
            console.warn('Archivo físico no encontrado, continuando con eliminación de registro');
        }

        // Eliminar registro de la base de datos
        const [result] = await pool.query(
            'DELETE FROM archivos WHERE id = ?',
            [fileId]
        );

        res.status(200).json({
            message: 'Archivo eliminado correctamente',
            archivoEliminado: file.nombre_archivo
        });

    } catch (error) {
        console.error('Error al eliminar archivo:', error);
        res.status(500).json({ message: 'Error interno al eliminar archivo' });
    }
};
