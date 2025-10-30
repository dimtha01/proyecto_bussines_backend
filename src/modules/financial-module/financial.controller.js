export const createAvanceFisico = async (req, res) => {
  try {
    const { id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin } = req.body;

    // Validar que todos los campos obligatorios estén presentes
    if (!id_proyecto || !fecha || !avance_real || !avance_planificado || !puntos_atencion || !fecha_inicio || !fecha_fin) {
      return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }

    // Insertar el nuevo registro en la base de datos
    const [result] = await pool.query(
      `
      INSERT INTO avance_fisico (id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin]
    );

    // Devolver el ID del nuevo registro creado
    res.status(201).json({
      id: result.insertId,
      id_proyecto,
      fecha,
      avance_real,
      avance_planificado,
      puntos_atencion,
      fecha_inicio,
      fecha_fin,
      message: "Registro de avance físico creado exitosamente",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Algo salió mal al crear el registro" });
  }
};