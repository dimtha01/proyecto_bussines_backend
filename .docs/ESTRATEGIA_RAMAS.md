# 🏗️ Estrategia de Ramas por Arquitectura - Backend Express.js

## 📁 Estructura de Ramas Creadas

### 🔥 Ramas Principales
- **main** - Producción estable (versiones desplegadas)
- **develop** - Integración continua (próximo release)

### 🔧 Ramas por Módulos Funcionales
- **feature/auth-module** - Autenticación, usuarios, roles, JWT
- **feature/clients-module** - Gestión de clientes (CRUD, validaciones)
- **feature/projects-module** - Gestión de proyectos, estatus comercial
- **feature/financial-module** - Avances financieros, costos
- **feature/physical-module** - Avances físicos, procedimientos
- **feature/dashboard-module** - Dashboard principal, métricas
- **feature/files-module** - Gestión de archivos, multer, uploads
- **feature/youtube-module** - Integración YouTube API, videos
- **feature/costs-module** - Control de costos, presupuestos
- **feature/providers-module** - Gestión de proveedores
- **feature/regions-module** - Gestión de regiones, geografía
- **feature/status-module** - Estatus de proyectos y comerciales

### 🏛️ Ramas por Capa Arquitectónica
- **feature/database-layer** - db.js, migraciones, esquemas SQL
- **feature/api-routes** - Definición de rutas, endpoints
- **feature/middleware** - Middlewares (auth, multer, CORS)
- **feature/config** - Configuración, variables de entorno, Docker

## 🔄 Flujo de Trabajo (Git Flow)

### 1. Desarrollo de Nuevas Funcionalidades
```bash
# Desde develop, crear rama de funcionalidad
git checkout develop
git checkout -b feature/nueva-funcionalidad

# Trabajar en la funcionalidad
# Hacer commits y push

# Integrar a develop
git checkout develop
git merge feature/nueva-funcionalidad
git push origin develop
```

### 2. Despliegue a Producción
```bash
# Desde develop, crear rama de release
git checkout develop
git checkout -b release/v1.2.0

# Preparar release (testing, fixes)
# Hacer merge a main
git checkout main
git merge release/v1.2.0
git tag v1.2.0
git push origin main --tags

# Integrar cambios de regreso a develop
git checkout develop
git merge main
```

### 3. Fixes Críticos en Producción
```bash
# Desde main, crear hotfix
git checkout main
git checkout -b hotfix/critical-fix

# Aplicar fix, testear
# Hacer merge a main y develop
git checkout main
git merge hotfix/critical-fix
git checkout develop
git merge hotfix/critical-fix
```

## 📝 Convenciones de Nomenclatura

### Feature Branches
- `feature/nombre-funcionalidad` - Nuevas funcionalidades
- `feature/modulo-componente` - Componentes específicos

### Fixes
- `fix/descripcion-problema` - Bugs no críticos
- `hotfix/descripcion-critica` - Bugs críticos en producción

### Otras
- `refactor/mejora-codigo` - Refactorización
- `docs/actualizar-documentacion` - Documentación
- `test/agregar-pruebas` - Tests unitarios/integración

## 🎯 Mapeo Módulos → Archivos

### Auth Module
- src/controllers/auth.controller.js
- src/controllers/user.controller.js
- src/controllers/role.controller.js
- src/middleware/auth.middleware.js
- src/routes/auth.routes.js
- src/routes/user.routes.js
- src/routes/role.routes.js

### Database Layer
- src/db.js
- db/*.sql
- src/config.js

### Files Module
- src/controllers/archivos.controller.js
- src/middleware/multer.middleware.js
- src/middleware/multerConfig.js
- src/routes/archivos.routes.js
- uploads/

## 🔥 Buenas Prácticas

1. **Commits Atómicos**: Un cambio lógico por commit
2. **Pull Requests**: Siempre usar PRs para integrar
3. **Code Review**: Revisión obligatoria antes de merge
4. **Tests**: Mantener tests actualizados con cada cambio
5. **Documentación**: Actualizar README y comentarios
6. **Limpiar**: Eliminar ramas ya integradas

## 🚀 Comandos Útiles

```bash
# Ver todas las ramas
git branch -a

# Cambiar entre ramas
git checkout nombre-rama

# Ver diferencias entre ramas
git diff develop..feature/nombre-funcionalidad

# Sincronizar con remoto
git fetch --all
git pull origin develop
```