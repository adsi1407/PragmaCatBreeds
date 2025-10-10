# SonarCloud Integration Guide

## Overview
Esta guía te ayuda a configurar SonarCloud para monitoreo automático de deuda técnica en el proyecto Pragma Cat Breeds.

## Configuración Inicial

### 1. Configurar SonarCloud
1. Ve a [SonarCloud](https://sonarcloud.io)
2. Inicia sesión con tu cuenta de GitHub
3. Importa el repositorio `adsi1407/PragmaCatBreeds`
4. Configura la organización como `adsi1407`

### 2. Configurar Secrets en GitHub
En tu repositorio GitHub:
1. Ve a Settings → Secrets and variables → Actions
2. Agrega los siguientes secrets:
   ```
   SONAR_TOKEN: [Tu token de SonarCloud]
   ```

### 3. Quality Gates
SonarCloud configurará automáticamente Quality Gates que fallarán el pipeline cuando:
- **Maintainability Rating** sea peor que A
- **Reliability Rating** sea peor que A
- **Security Rating** sea peor que A
- **Coverage** sea menor al porcentaje configurado
- **Duplicated Lines** excedan el límite

## Métricas Monitoreadas

### Technical Debt Ratio
- **Qué mide**: Tiempo estimado para arreglar issues vs tiempo de desarrollo
- **Umbral recomendado**: ≤ 5%

### Maintainability Rating
- **A**: ≤ 5% technical debt ratio
- **B**: 6-10% technical debt ratio
- **C**: 11-20% technical debt ratio
- **D**: 21-50% technical debt ratio
- **E**: > 50% technical debt ratio

### Code Smells
- Issues que afectan la mantenibilidad
- Categorizados por severidad: Blocker, Critical, Major, Minor, Info

### Duplicación
- **Umbral recomendado**: ≤ 3% líneas duplicadas

## Integración CI/CD

### Pull Request Decoration
SonarCloud automáticamente:
- Analiza el código en cada PR
- Agrega comentarios con issues encontrados
- Bloquea merge si Quality Gate falla
- Muestra métricas de cobertura

### Branch Analysis
- **Main branch**: Análisis completo con trending histórico
- **Feature branches**: Análisis diferencial vs main

## Configuración Avanzada

### Custom Quality Gates
Puedes crear Quality Gates personalizados para:
```yaml
Conditions:
- Maintainability Rating is worse than A
- Reliability Rating is worse than A  
- Security Rating is worse than A
- Coverage on New Code is less than 80%
- Duplicated Lines (%) on New Code is greater than 3%
- Technical Debt Ratio on New Code is greater than 5%
```

### Exclusiones
Ya configuradas en `sonar-project.properties`:
- Archivos generados (*.g.dart, *.freezed.dart)
- Archivos de configuración
- Código de plataforma (android/, ios/, etc.)
- Tests (para métricas de cobertura)

## Dashboards y Reportes

### Project Dashboard
- Overview de salud del código
- Trending histórico
- Breakdown por tipo de issue

### Security Hotspots
- Identificación automática de vulnerabilidades
- Priorización por impacto

### Maintainability
- Desglose de code smells
- Estimación de esfuerzo para fixes
- Métricas de complejidad ciclomática

## Comandos Útiles

### Análisis Local
```bash
# Instalar SonarScanner
npm install -g sonarqube-scanner

# Ejecutar análisis local
sonar-scanner \
  -Dsonar.projectKey=adsi1407_PragmaCatBreeds \
  -Dsonar.organization=adsi1407 \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.login=your_token
```

### Generar Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Beneficios vs Scripts Personalizados

### ✅ Ventajas de SonarCloud
- **Zero maintenance**: No necesitas mantener scripts
- **Métricas estándar**: Usa métricas reconocidas industrialmente
- **Visualización**: Dashboards profesionales
- **Trending**: Histórico automático
- **Integración**: Works out-of-the-box con GitHub
- **Alerting**: Notificaciones automáticas
- **Security**: Incluye análisis de vulnerabilidades

### 🔧 Configuración Mínima
- 1 archivo de configuración
- 1 workflow de GitHub Actions
- Setup one-time en SonarCloud

## Siguientes Pasos

1. **Configurar SonarCloud**: Importar el repositorio
2. **Agregar SONAR_TOKEN**: En GitHub secrets
3. **Ejecutar primer análisis**: Push a main para trigger
4. **Configurar Quality Gates**: Ajustar umbrales según necesidades
5. **Entrenar al equipo**: En interpretación de métricas

¿Te parece mejor esta aproximación?