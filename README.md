# **API REST de Gestión Empresarial**

![Node.js](https://img.shields.io/badge/Node.js-v18.x-green?style=flat-square&logo=node.js)
![Express.js](https://img.shields.io/badge/Express.js-4.x-blue?style=flat-square&logo=express)
![MySQL](https://img.shields.io/badge/MySQL-8.x-orange?style=flat-square&logo=mysql)
![NPM](https://img.shields.io/badge/npm-8.x-red?style=flat-square&logo=npm)
![Licencia](https://img.shields.io/badge/Licencia-MIT-yellow?style=flat-square)

API REST robusta y escalable construida con Node.js, Express y MySQL para la gestión integral de proyectos y recursos empresariales.

---

## **Tabla de Contenidos**

- [Resumen del Proyecto](#resumen-del-proyecto)
- [Características](#características)
- [Pila Tecnológica](#pila-tecnológica)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Uso de la API](#uso-de-la-api)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Documentación de la API](#documentación-de-la-api)
- [Pruebas (Testing)](#pruebas-testing)
- [Despliegue](#despliegue)
- [Mejoras Potenciales](#mejoras-potenciales)
- [¿Cómo Contribuir?](#cómo-contribuir)
- [Licencia](#licencia)

---

## **Resumen del Proyecto**

Este proyecto es el backend para una aplicación de gestión empresarial. Sigue una arquitectura **MVC (Modelo-Vista-Controlador) modular**, lo que facilita la escalabilidad y el mantenimiento. El diseño se centra en la separación de responsabilidades, con una capa de ruteo, una de controladores (lógica de negocio) y una de acceso a datos, aunque no sigue un patrón de Repositorio formalmente.

## **Características**

-   :key: **Autenticación y Autorización**: Sistema basado en JWT con roles y permisos.
-   :briefcase: **Gestión de Proyectos**: Seguimiento completo de proyectos, incluyendo avance físico y financiero.
-   :office: **Administración de Clientes y Proveedores**: CRUD completo para entidades comerciales.
-   :money_with_wings: **Control de Costos y Requisiciones**: Manejo de recursos y solicitudes internas.
-   :bar_chart: **Dashboard**: Endpoints optimizados para la visualización de datos y métricas clave.
-   :electric_plug: **API RESTful**: Endpoints consistentes y bien estructurados.

## **Pila Tecnológica**

| Categoría | Dependencia | Propósito |
| :--- | :--- | :--- |
| **Runtime** | Node.js | Entorno de ejecución de JavaScript. |
| **Framework** | Express.js | Framework para la construcción de la API. |
| **Base de Datos** | MySQL | Sistema de gestión de bases de datos relacional. |
| **Driver DB** | `mysql2` | Cliente de MySQL para Node.js, con soporte para Promises. |
| **Autenticación**| `jsonwebtoken`, `bcryptjs` | Creación/verificación de tokens y hashing de contraseñas. |
| **Middleware** | `cors`, `morgan` | Habilitar CORS y logging de peticiones HTTP. |
| **Variables de Entorno**| `dotenv` | Carga de variables de entorno desde un archivo `.env`. |
| **Pruebas** | `jest`, `supertest` | Framework de pruebas y cliente HTTP para testing de API. |
| **Desarrollo** | `nodemon`, `cross-env` | Reinicio automático del servidor y scripts cross-platform. |

*Nota: Se recomienda revisar `package.json` para remover dependencias no utilizadas y mantener el proyecto limpio.*

## **Requisitos Previos**

-   Node.js (v18 o superior)
-   NPM o PNPM
-   Servidor de MySQL (local o en Docker)

## **Instalación**

1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/proyecto_bussines_backend.git
    cd proyecto_bussines_backend
    ```

2.  **Instala las dependencias:**
    ```bash
    npm install
    ```

3.  **Configura la base de datos:**
    -   Asegúrate de que tu servidor de MySQL esté corriendo.
    -   Crea una base de datos (ej. `business_db`).
    -   Importa el esquema y los datos iniciales desde los archivos `.sql` en el directorio `/db`:
        ```bash
        mysql -u tu_usuario -p tu_base_de_datos < db/proyecto_valesco.sql
        ```

## **Configuración**

1.  Crea un archivo `.env` en la raíz del proyecto, puedes basarte en el archivo `.env.example` si existe.
2.  Añade las siguientes variables de entorno:

    ```env
    # Server
    PORT=3000

    # Database
    DB_HOST=localhost
    DB_USER=root
    DB_PASSWORD=tu_contraseña
    DB_DATABASE=business_db
    DB_PORT=3306

    # JWT
    JWT_SECRET=tu_secreto_para_jwt
    ```

3.  **Ejecuta el servidor:**
    -   **Modo Desarrollo (con reinicio automático):**
        ```bash
        npm run dev
        ```
    -   **Modo Producción:**
        ```bash
        npm start
        ```

## **Uso de la API**

### **Autenticación**

| Método | Endpoint | Descripción | Autenticación |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/register` | Registra un nuevo usuario. | No requerida |
| `POST` | `/api/auth/login` | Inicia sesión y obtiene un token JWT. | No requerida |

### **Clientes**

| Método | Endpoint | Descripción | Autenticación |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/clients` | Obtiene la lista de todos los clientes. | Requerida |
| `POST` | `/api/clients` | Crea un nuevo cliente. | Requerida |
| `GET` | `/api/clients/:id` | Obtiene un cliente por su ID. | Requerida |
| `PUT` | `/api/clients/:id` | Actualiza un cliente por su ID. | Requerida |
| `DELETE`| `/api/clients/:id` | Elimina un cliente por su ID. | Requerida |

*(Secciones similares existirían para `proyects`, `proveedores`, `requisition`, etc.)*

## **Estructura del Proyecto**

```
C:/.../proyecto_bussines_backend/
├───.gitignore
├───docker-compose.yml
├───jest.config.js
├───package.json
├───README.md
├───db/
│   └───proyecto_valesco.sql
├───src/
│   ├───app.js
│   ├───config.js
│   ├───db.js
│   ├───index.js
│   ├───controllers/
│   ├───middleware/
│   │   └───auth.middleware.js
│   └───routes/
└───tests/
```

## **Documentación de la API**

Actualmente, la documentación de la API se encuentra en este mismo archivo (`README.md`). No se utiliza Swagger u otra herramienta de generación automática.

## **Pruebas (Testing)**

El proyecto utiliza **Jest** y **Supertest** para pruebas unitarias y de integración.

-   **Para ejecutar todas las pruebas:**
    ```bash
    npm test
    ```
-   **Para agregar una nueva prueba:**
    1.  Crea un archivo con el sufijo `.test.js` en el directorio `/tests`.
    2.  Sigue la estructura de los tests existentes para escribir nuevos casos de prueba.

## **Despliegue**

-   **Local:** Se puede ejecutar directamente con Node.js o usando `nodemon` para desarrollo.
-   **Producción:**
    -   **PM2:** Se recomienda usar un gestor de procesos como PM2 para mantener la aplicación viva.
        ```bash
        pm2 start src/index.js --name "business-api"
        ```
    -   **Docker:** El proyecto incluye un archivo `docker-compose.yml` que puede ser extendido para un entorno de producción.

## **Mejoras Potenciales**

-   :lock: **Seguridad**: Implementar `helmet` para añadir cabeceras de seguridad y `express-rate-limit` para prevenir ataques de fuerza bruta.
-   :heavy_check_mark: **Validación**: Añadir validación de datos de entrada en todas las rutas usando una librería como `joi` o `express-validator`.
-   :books: **Documentación**: Integrar Swagger o OpenAPI para generar documentación interactiva de la API.
-   :rocket: **Escalabilidad**: Refactorizar la lógica de base de datos a un patrón de Repositorio para mayor abstracción.
-   :recycle: **Consistencia**: Mejorar el manejo de errores para que todas las respuestas de error sigan un formato estándar.

## **¿Cómo Contribuir?**

Las contribuciones son bienvenidas. Por favor, sigue estos pasos:

1.  **Haz un Fork** de este repositorio.
2.  **Crea una nueva rama**: `git checkout -b feature/nueva-caracteristica`.
3.  **Realiza tus cambios** y haz commit: `git commit -m 'feat: Agrega nueva característica'`.
4.  **Haz Push** a tu rama: `git push origin feature/nueva-caracteristica`.
5.  **Abre un Pull Request**.

Asegúrate de seguir los estándares de código existentes.

## **Licencia**

Este proyecto está bajo la [Licencia MIT](https://opensource.org/licenses/MIT).

---
*Última Actualización: 2025-10-12*
<br>
*Para reportar un problema o sugerir una mejora, por favor [abre un issue](https://github.com/tu-usuario/proyecto_bussines_backend/issues).*