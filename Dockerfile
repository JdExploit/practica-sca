FROM python:2.7-slim-buster

# Configurar repositorios archive (versión corregida)
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i '/httpredir.debian.org/d' /etc/apt/sources.list

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE mysite.settings

# Actualizar e instalar dependencias (comandos separados)
RUN apt-get update -o Acquire::Check-Valid-Until=false && \
    apt-get install -y \
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

# Copiar requirements
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
