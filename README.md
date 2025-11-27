# Tarea Com Feliz

Aplicación de seguros con asistente de IA.

## Estructura del Proyecto

- **Backend**: Carpeta `backend` (Rails)
- **Frontend**: Carpeta `frontend` (React)

## Iniciar el Servidor

### Backend

Antes de iniciar el servidor, es necesario configurar la base de datos y ejecutar los seeds:

```bash
cd backend
rails db:create
rails db:migrate
rails db:seed
rails s
```

El servidor se ejecutará en `http://localhost:3000`

### Frontend

```bash
cd frontend
npm run start
```

La aplicación se abrirá en `http://localhost:3001` (o el puerto disponible)

## Configuración de Variables de Entorno

Para el uso de variables de entorno, es necesario crear un archivo `.env` en la carpeta `backend` donde se configuren las siguientes variables:

```bash
cd backend
touch .env
```

Ejemplo de variables de entorno necesarias:

```env
GEMINI_API_KEY=tu_api_key_de_gemini
POLICE_API_URL=https://comunidad-feliz.free.mockoapp.net/
```

## Requisitos

- Ruby y Rails instalados
- Node.js y npm instalados
- PostgreSQL configurado para el backend

## Casos de Uso de Prueba

El sistema incluye datos de prueba (seeds) con las siguientes solicitudes de seguro:

### Solicitudes Aprobadas

| ID | Email | Nombre | Estado |
|---|---|---|---|
| 24236 | carlos.rodriguez@example.com | Carlos Rodríguez | ✅ Aprobada |
| 24237 | ana.martinez@example.com | Ana Martínez | ✅ Aprobada |
| 24239 | luis.sanchez@example.com | Luis Sánchez | ✅ Aprobada |

### Solicitudes Rechazadas

| ID | Email | Nombre | Motivo de Rechazo |
|---|---|---|---|
| 24234 | juan.perez@example.com | Juan Pérez | ❌ Menor de edad y vehículo muy barato |
| 24235 | maria.gonzalez@example.com | María González | ❌ No es propietario del vehículo |
| 24238 | luis.sanchez@example.com | Luis Sánchez | ❌ Más de 10 infracciones |

### Ejemplos de Uso

Puedes probar el asistente de IA con cualquiera de estas solicitudes:

- **Por ID**: "Por favor calcula la prima de la solicitud con id 24234"
- **Por email**: "Por favor calcula la prima de la solicitud con email   carlos.rodriguez@example.com"
- **Consulta general**: "¿Por favor calcula la prima de la solicitud con id  24239?"

El sistema procesará automáticamente la solicitud, calculará el premium (si aplica) y enviará una notificación por correo electrónico al usuario con el resultado.

