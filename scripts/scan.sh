#!/bin/bash

echo "=============================================="
echo " ANÁLISIS DE VULNERABILIDADES SCA"
echo "=============================================="
echo

# Crear directorio para reportes
mkdir -p /reports
REPORT_DIR="/reports/$(date +%Y%m%d_%H%M%S)"
mkdir -p $REPORT_DIR

echo "📋 1. ANALIZANDO DEPENDENCIAS PYTHON CON SAFETY"
echo "------------------------------------------------"
cd /workspace
safety check --full-report -r requirements.txt > $REPORT_DIR/safety_report.txt
safety check --full-report -r requirements.txt

echo
echo "📋 2. ANALIZANDO CÓDIGO CON BANDIT"
echo "------------------------------------------------"
bandit -r /workspace/app -f html -o $REPORT_DIR/bandit_report.html
bandit -r /workspace/app

echo
echo "📋 3. ANALIZANDO LIBRERÍAS JAVASCRIPT CON RETIRE.JS"
echo "------------------------------------------------"
cd /workspace/app/static
retire --path . --outputformat json --outputpath $REPORT_DIR/retire_report.json
retire --path .

echo
echo "📋 4. COMPARANDO CON VERSIONES SEGURAS"
echo "------------------------------------------------"
echo "Comparando requirements.txt vs requirements-safe.txt:"
echo
echo "Versiones vulnerables actuales:"
echo "------------------------------"
cat /workspace/requirements.txt
echo
echo "Versiones seguras recomendadas:"
echo "-------------------------------"
cat /workspace/requirements-safe.txt

echo
echo "📋 5. RESUMEN DE VULNERABILIDADES"
echo "------------------------------------------------"
echo "Reportes guardados en: $REPORT_DIR"
echo
echo "Resumen rápido:"
safety check -r /workspace/requirements.txt --bare | wc -l | xargs -I {} echo "- {} vulnerabilidades en Python"
cd /workspace/app/static && retire --path . | grep -i "vulnerability\|vulnerable" | wc -l | xargs -I {} echo "- {} librerías JavaScript vulnerables"

echo
echo "=============================================="
echo " ANÁLISIS COMPLETADO"
echo "=============================================="