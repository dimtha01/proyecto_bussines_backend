export const financialValidator = (req, res, next) => {
    const {
        id_proyecto,
        fecha,
        numero_valuacion,
        monto_usd,
        numero_factura,
        id_estatus_proceso,
        fecha_inicio,
        fecha_fin,
    } = req.body;

    // Validar que todos los campos requeridos estén presentes
    if (
        !id_proyecto ||
        !fecha ||
        !numero_valuacion ||
        !monto_usd ||
        !id_estatus_proceso ||
        !fecha_inicio ||
        !fecha_fin
    ) {
        return res.status(400).json({ message: "Todos los campos son obligatorios" });
    }
    next();
}