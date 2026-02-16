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

# Instalar una versión de safety compatible con Python 2.7
RUN pip install safety==1.10.3

# Instalar Retire.js
RUN npm install -g retire

# Crear directorio de trabajo
WORKDIR /app

# Copiar requirements.txt
COPY requirements.txt /app/
COPY requirements-safe.txt /app/

# Instalar dependencias del proyecto
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código
COPY . /app/

# Verificar instalación
RUN python -c "import django; print('Django installed: {}'.format(django.get_version()))"

# Exponer puerto
EXPOSE 8000

# Comando por defecto
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
