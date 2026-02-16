FROM python:2.7-slim-buster

# Desactivar comprobación de fecha de los repositorios
RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Configurar repositorios archive
RUN echo "deb http://archive.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list

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

# Instalar herramientas de análisis compatibles
RUN pip install safety==2.3.5

# Instalar Retire.js
RUN npm install -g retire

# Crear directorio de trabajo
WORKDIR /app

# Copiar requirements.txt primero (para mejor caché)
COPY requirements.txt /app/
COPY requirements-safe.txt /app/

# Instalar dependencias - con verificación
RUN pip install --no-cache-dir -r requirements.txt && \
    python -c "import django; print(f'Django {django.get_version()} installed successfully')"

# Copiar el resto del código
COPY . /app/

# Verificar que Django está instalado
RUN python -c "import django; print('Django OK')"

# Exponer puerto
EXPOSE 8000

# Comando por defecto
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
