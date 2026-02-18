import app from "./app.js";
import { PORT } from "./config.js";
import { createServer } from "http";
import { initSocket } from "./socket.js";

// Crear servidor HTTP
const httpServer = createServer(app);

// Inicializar Socket.io
initSocket(httpServer);

// Iniciar servidor
httpServer.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor en http://0.0.0.0:${PORT} o http://TU_IP:${PORT}`);
});
console.log(`Server on port http://localhost:${PORT}`);
