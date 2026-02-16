# Dockerfile para aplicación Django vulnerable
FROM python:2.7-slim

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE mysite.settings

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instalar herramientas de análisis
RUN pip install safety bandit
RUN npm install -g retire

# Crear directorio de trabajo
WORKDIR /app

# Copiar requirements primero (para mejor cacheo)
COPY requirements.txt /app/
COPY requirements-safe.txt /app/

# Instalar dependencias vulnerables
RUN pip install -r requirements.txt

# Copiar el resto del código
COPY . /app/

# Exponer puerto
EXPOSE 8000

# Comando por defecto
CMD ["python", "app/manage.py", "runserver", "0.0.0.0:8000"]