export const financialValidator = (req, res, next) => {
    const { id_proyecto, fecha, avance_real, avance_planificado, puntos_atencion, fecha_inicio, fecha_fin } = req.body;
    if (!id_proyecto || !fecha || !avance_real || !avance_planificado || !puntos_atencion || !fecha_inicio || !fecha_fin) {
        return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }
    next();
}