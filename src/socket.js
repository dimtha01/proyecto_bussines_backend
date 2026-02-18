import { Server } from "socket.io";

let io;

// Inicializa el servidor de Socket.io
export const initSocket = (httpServer) => {
  io = new Server(httpServer, {
    cors: {
      origin: "*", // En producción, especificar los orígenes permitidos
      methods: ["GET", "POST"],
    },
  });

  io.on("connection", (socket) => {
    console.log(`Cliente conectado: ${socket.id}`);

    // Unirse a una sala específica de proyecto
    socket.on("unir_proyecto", (projectId) => {
      socket.join(`proyecto_${projectId}`);
      console.log(`Cliente ${socket.id} se unió al proyecto ${projectId}`);
    });

    // Salir de una sala de proyecto
    socket.on("salir_proyecto", (projectId) => {
      socket.leave(`proyecto_${projectId}`);
      console.log(`Cliente ${socket.id} salió del proyecto ${projectId}`);
    });

    socket.on("disconnect", () => {
      console.log(`Cliente desconectado: ${socket.id}`);
    });
  });

  return io;
};

// Obtener la instancia de io (para usar desde otros archivos)
export const getIO = () => {
  if (!io) {
    throw new Error("Socket.io no ha sido inicializado");
  }
  return io;
};

// Emitir notificación a todos los clientes conectados
export const emitNotification = (notification) => {
  const ioInstance = getIO();

  // Emitir a todos los clientes conectados
  ioInstance.emit("nueva_notificacion", notification);

  // También emitir a la sala específica del proyecto si hay un projectId
  if (notification.id_proyecto) {
    ioInstance.to(`proyecto_${notification.id_proyecto}`).emit("notificacion_proyecto", notification);
  }
};
