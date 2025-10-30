import express from "express";
import morgan from "morgan";
import cors from "cors"; // Importa el paquete cors
import proyectsRoutes from "./routes/proyects.routes.js";
import avanceFisicoRoutes from "./routes/avance_fisico.routes.js";
import avanceFinancieroRoutes from "./routes/avance_financiero.routes.js";
import indexRoutes from "./routes/index.routes.js";
import regionesRoutes from './routes/regiones.routes.js'
import dashboardRoutes from './routes/dashboard.routes.js'
import { costsRoutes } from "./modules/costs-module/index.js";
import proveedoresRoutes from './routes/proveedores.routes.js'
import requisitionRoutes from './routes/requisition.routes.js'
import estatusComercialRoutes from './routes/estatus_comercial.routes.js'
import procedimientoComercialRoutes from './routes/procedimiento_comercial.routes.js'
import userRoutes from "./routes/user.routes.js"
import roleRoutes from "./routes/role.routes.js"
import archivosRoutes from "./routes/archivos.routes.js";
import { clientRoutes } from "./modules/client-module/index.js";
import youtubeRoutes from "./routes/youtube.routes.js";
import path from 'path';
import { fileURLToPath } from 'url';
import statusRoutes from "./modules/status-madule/status.routes.js";
import { authRoutes } from "./modules/auth/index.js";
import { physicalRoutes } from "./modules/physical-module/index.js";
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middlewares
const uploadsPath = path.join(__dirname, '../uploads');
console.log("Serviendo desde:", uploadsPath);

app.use('/uploads', express.static(uploadsPath));

app.use(cors()); // Habilita CORS para todas las rutas
app.use(morgan("dev"));
app.use(express.json());

// Routes
app.use("/", indexRoutes);
app.use("/api", proyectsRoutes);
app.use("/api", avanceFisicoRoutes);
app.use("/api", avanceFinancieroRoutes);
app.use("/api", regionesRoutes);
app.use("/api", dashboardRoutes);
app.use("/api", proveedoresRoutes);
app.use("/api", requisitionRoutes);
app.use("/api", estatusComercialRoutes);
app.use("/api", procedimientoComercialRoutes);
app.use("/api/users", userRoutes)
app.use("/api/roles", roleRoutes)
app.use("/api/archivos", archivosRoutes);
app.use("/api/youtube", youtubeRoutes);

app.use("/api/v2/status", statusRoutes);
app.use("/api/v2/auth", authRoutes)
app.use("/api/v2/costos", costsRoutes)
app.use("/api/v2/clients", clientRoutes)
app.use("/api/v2/physical", physicalRoutes)
// Middleware para manejar rutas no encontradas
app.use((req, res, next) => {
  res.status(404).json({ message: "Not found" });
});

export default app;