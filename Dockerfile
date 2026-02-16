# Etapa 1: Aplicación vulnerable (Python 2.7)
FROM python:2.7-slim-buster as app-vulnerable

# Desactivar comprobación de fecha
RUN echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Configurar repositorios archive
RUN echo "deb http://archive.debian.org/debian/ buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security/ buster/updates main contrib non-free" >> /etc/apt/sources.list

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE mysite.settings

# Instalar dependencias mínimas
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Instalar Retire.js (para JS)
RUN npm install -g retire

WORKDIR /app

COPY requirements.txt /app/
COPY requirements-safe.txt /app/

RUN pip install -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["python", "app/manage.py", "runserver", "0.0.0.0:8000"]

# Etapa 2: Herramientas de análisis (Python 3.9)
FROM python:3.9-slim as scanner

RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    npm \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instalar herramientas de análisis en Python 3.9
RUN pip install safety bandit
RUN npm install -g retire

WORKDIR /workspace

COPY requirements.txt /workspace/
COPY requirements-safe.txt /workspace/
COPY scripts/scan.sh /workspace/scripts/

CMD ["bash", "/workspace/scripts/scan.sh"]
