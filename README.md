# Tarea Com Feliz

Aplicación de seguros con asistente de IA.

## Estructura del Proyecto

- **Backend**: Carpeta `backend` (Rails)
- **Frontend**: Carpeta `frontend` (React)

## Iniciar el Servidor

### Backend

```bash
cd backend
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
