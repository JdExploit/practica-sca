# 🔒 Práctica 1: Análisis de Vulnerabilidades SCA (Software Composition Analysis)

<div align="center">

![Django](https://img.shields.io/badge/Django-1.11.29-092E20?style=for-the-badge&logo=django)
![Python](https://img.shields.io/badge/Python-2.7|3.6-3776AB?style=for-the-badge&logo=python)
![Docker](https://img.shields.io/badge/Docker-✓-2496ED?style=for-the-badge&logo=docker)
![Safety](https://img.shields.io/badge/Security-SCA-FF0000?style=for-the-badge)

**Repositorio de práctica académica para análisis de vulnerabilidades en dependencias de terceros**

[📋 Informe](INFORME_PRACTICA1.md) | [🚀 Instalación](#instalación) | [📊 Resultados](#resultados) | [🛠️ Corrección](#plan-de-remediación)

</div>

---

## 📝 Descripción

Este repositorio contiene una **aplicación Django intencionalmente vulnerable** diseñada con fines educativos para la asignatura de Seguridad en Aplicaciones. El objetivo es aprender a identificar, analizar y corregir vulnerabilidades en dependencias de terceros mediante herramientas SCA (Software Composition Analysis).

### 🎯 Objetivos de la Práctica

- ✅ Crear un Dockerfile para una aplicación Django con versiones antiguas
- ✅ Analizar vulnerabilidades Python con **Safety**
- ✅ Detectar librerías JavaScript obsoletas con **Retire.js**
- ✅ Identificar problemas de código con **Bandit**
- ✅ Documentar hallazgos y proponer correcciones

---

## 🏗️ Estructura del Proyecto

```
practica-sca/
├── 📁 app/
│   ├── 📁 app/                    # Aplicación principal
│   │   ├── 📁 mysite/             # Configuración Django
│   │   │   ├── settings.py        # Settings vulnerables
│   │   │   ├── urls.py            # URLs (versión Django 1.11)
│   │   │   └── wsgi.py
│   │   ├── manage.py               # Manage.py
│   │   └── 📁 static/
│   │       └── 📁 js/
│   │           └── jquery-1.7.2.js # jQuery vulnerable
│   └── 📁 reports/                  # Reportes generados
├── 📁 scripts/
│   └── scan.sh                      # Script de análisis automático
├── Dockerfile                        # Imagen Docker
├── docker-compose.yml                # Orquestación de contenedores
├── requirements.txt                  # Dependencias vulnerables
├── requirements-safe.txt             # Dependencias seguras
└── INFORME_PRACTICA1.md              # Informe completo
```

---

## 🚀 Instalación

### Prerrequisitos

- Docker y Docker Compose
- Git
- Kali Linux / Debian / Ubuntu (recomendado)

### Pasos Rápidos

```bash
# 1. Clonar repositorio
git clone https://github.com/JdExploit/practica-sca.git
cd practica-sca

# 2. Construir imagen
docker-compose build

# 3. Iniciar aplicación vulnerable
docker-compose up -d web-vulnerable

# 4. Ejecutar análisis de vulnerabilidades
docker-compose up scanner

# 5. Ver resultados
cd reports/$(ls -t reports/ | head -1)
ls -la  # safety_report.txt, retire_report.json, bandit_report.html
```

### 📋 Comandos Útiles

```bash
# Ver logs de la aplicación
docker-compose logs -f web-vulnerable

# Acceder al contenedor
docker exec -it django-vulnerable bash

# Detener todo
docker-compose down

# Limpiar caché de Docker
docker system prune -f
```

---

## 🔬 Vulnerabilidades Incluidas

### 🐍 Python (Django 1.11.29)

| Paquete | Versión | Vulnerabilidades | CVEs Críticos |
|---------|---------|------------------|---------------|
| Django | 1.11.29 | 39 | CVE-2025-64459, CVE-2022-34265 |
| Pillow | 6.2.2 | 31 | CVE-2022-22817, CVE-2021-34552 |
| urllib3 | 1.24.3 | 10 | CVE-2026-21441, CVE-2025-66418 |
| jinja2 | 2.10.1 | 5 | CVE-2025-27516, CVE-2024-56326 |
| requests | 2.20.0 | 3 | CVE-2024-47081 |
| pyyaml | 4.2b1 | 2 | CVE-2020-1747 (RCE) |

### 📜 JavaScript (jQuery 1.7.2)

| CVE | Descripción | Severidad |
|-----|-------------|-----------|
| CVE-2012-6708 | Selector interpretado como HTML | MEDIA |
| CVE-2020-7656 | XSS en método load() | MEDIA |
| CVE-2015-9251 | Ejecución de peticiones CORS | MEDIA |
| CVE-2019-11358 | Prototype Pollution | MEDIA |
| CVE-2020-11023 | XSS en manipulación DOM | MEDIA |
| CVE-2020-11022 | XSS en htmlPrefilter | MEDIA |

### ⚙️ Configuración

- 🔑 Clave secreta hardcodeada en `settings.py`
- 🐞 DEBUG activado en producción
- 🌐 ALLOWED_HOSTS = ['*'] (permite todos los hosts)
- 🍪 Cookies inseguras (SESSION_COOKIE_SECURE = False)

---

## 📊 Resultados del Análisis

### Safety Report
```
📦 Paquetes analizados: 11
🔓 Vulnerabilidades encontradas: 106
⚠️  Paquetes afectados: 9
🔥 Críticas: 5
📈 Altas: 15
📉 Medias: 86
```

### Retire.js Report
```
🔍 Librerías analizadas: 1 (jQuery 1.7.2)
🔓 Vulnerabilidades: 7
📌 Versión EOL: Sí (sin soporte desde 2016)
```

### Bandit Report
```
📁 Archivos analizados: 1
🔓 Problemas detectados: 1 (Hardcoded Secret)
📊 Severidad: BAJA (en este contexto educativo)
```

---

## 🛠️ Plan de Corrección

### 1. Actualizar Dependencias Python

```bash
# requirements-safe.txt
Django==4.2.7
Pillow==10.1.0
requests==2.31.0
urllib3==2.1.0
pyyaml==6.0.1
jinja2==3.1.2
```

### 2. Actualizar jQuery

```bash
curl -o app/static/js/jquery-3.7.1.min.js https://code.jquery.com/jquery-3.7.1.min.js
```

### 3. Corregir Configuración

```python
# settings.py seguro
import os
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')
DEBUG = False
ALLOWED_HOSTS = ['localhost', '127.0.0.1']
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
```

---

## 📈 Resultados Post-Corrección

```bash
# Safety
✔ No known security vulnerabilities detected

# Retire.js
✔ No vulnerabilities found

# Bandit
✔ No issues detected
```

---

## 🎓 Uso Educativo

Este repositorio está diseñado para:

- 🏫 **Clases de Seguridad en Aplicaciones**
- 📚 **Talleres de DevSecOps**
- 🔬 **Laboratorios de Ethical Hacking**
- 📖 **Prácticas de SCA (Software Composition Analysis)**

### ⚠️ Advertencia

> **NO UTILIZAR EN PRODUCCIÓN**  
> Este código contiene vulnerabilidades intencionales. Solo para fines educativos en entornos controlados.

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas para:
- ➕ Añadir más vulnerabilidades educativas
- 🐛 Mejorar scripts de análisis
- 📝 Ampliar documentación
- 🌐 Traducir informes

---

## 📄 Licencia

Este proyecto es **educativo** y de código abierto. Puedes usarlo, modificarlo y compartirlo libremente para fines académicos.

---

## 📞 Contacto

**Autor:** JdExploit  
**Repositorio:** [github.com/JdExploit/practica-sca](https://github.com/JdExploit/practica-sca)  
**Informe completo:** [INFORME_PRACTICA1.md](INFORME_PRACTICA1.md)

---

<div align="center">

**[⬆ Volver arriba](#-práctica-1-análisis-de-vulnerabilidades-sca-software-composition-analysis)**

⭐ Si este repositorio te fue útil, ¡no olvides darle una estrella! ⭐

</div>

---

## 📚 Referencias

- [OWASP Top 10](https://owasp.org/Top10/)
- [Safety Documentation](https://pyup.io/safety/)
- [Retire.js](https://retirejs.github.io/retire.js/)
- [Bandit Documentation](https://bandit.readthedocs.io/)
- [Django Security](https://docs.djangoproject.com/en/4.2/topics/security/)
