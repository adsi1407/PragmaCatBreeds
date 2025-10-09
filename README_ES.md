# Cat Breeds App 🐱 - Español

## Resumen
-------
Una aplicación Flutter que muestra información sobre diferentes razas de gatos, construida con principios de Arquitectura Limpia y siguiendo las mejores prácticas de la industria.

## Requerimientos iniciales del reto ✨
--------------------------------
- **Explorar Razas de Gatos**: Ve una lista completa de razas de gatos con información detallada
- **Funcionalidad de Búsqueda**: Búsqueda en tiempo real con debouncing para rendimiento óptimo
- **Información Detallada**: Perfiles completos de razas incluyendo características físicas, temperamento y calificaciones

## Versión de Flutter y requisitos
------------------------------
- Canal: stable
- Versión probada: Flutter 3.32.x y Dart 3.8.x (ver `pubspec.yaml`)
- Requisitos para abrir y ejecutar:
  - Flutter SDK instalado y en PATH
  - SDK de Android (o Xcode para iOS)
  - Ejecutar `flutter pub get` desde la raíz del repositorio

## Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd pragma_cat_breeds
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   cd module/domain && flutter pub get
   cd ../infrastructure && flutter pub get
   cd ../..
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## Arquitectura 🏗️

📖 **Para información técnica detallada, consulta:**
- [ARCHITECTURE.md](ARCHITECTURE.md) - Documentación completa de arquitectura
- [docs/PRESENTATION_ARCHITECTURE.md](docs/PRESENTATION_ARCHITECTURE.md) - Patrones de capa de presentación
- [docs/PERFORMANCE.md](docs/PERFORMANCE.md) - Guía de optimización de rendimiento
- [CONTRIBUTING.md](CONTRIBUTING.md) - Lineamientos de desarrollo

## ¿Por qué se usó Arquitectura Limpia?
-----------------------------------
Aunque el reto original era pequeño, el proyecto usa Arquitectura Limpia para:
- Separar las capas de dominio, infraestructura y presentación
- Hacer que los casos de uso y entidades sean independientes de los frameworks
- Demostrar la capacidad de estructurar código testeable y mantenible

Este proyecto sigue los principios de **Arquitectura Limpia** con clara separación de responsabilidades:

```
lib/
├── src/
│   ├── presentation/     # Capa de UI (Páginas, Widgets, BLoCs)
│   └── dependency_injection/ # Configuración de DI
module/
├── domain/              # Capa de Lógica de Negocio
│   ├── entities/        # Entidades centrales de negocio
│   ├── repositories/    # Interfaces abstractas de repositorio
│   └── use_cases/       # Casos de uso de negocio
└── infrastructure/      # Capa de Datos
    ├── repositories/    # Implementaciones de repositorio
    ├── datasources/     # Fuentes de datos externas (API, Cache)
    └── models/          # DTOs y modelos de datos
```

**Modularización por paquetes**
---------------------------
La base de código está modularizada para limitar librerías por paquete:
- `module/domain` – entidades de dominio, interfaces de repositorio y casos de uso
- `module/infrastructure` – implementaciones, API, cache, BD y DAOs
- App raíz – capa de presentación, composición DI y wiring

Para documentación detallada de arquitectura, ver [ARCHITECTURE.md](ARCHITECTURE.md).

## Patrones de diseño implementados
--------------------------------
- BLoC (flutter_bloc) para gestión de estado
- Inyección de dependencias con `get_it` + `injectable`
- Patrón Repository para abstracción de fuentes de datos
- Traductores/mappers para transformar DTOs <-> entidades de dominio
- Proxy para capas de cache/API
- DAO (Drift) para persistencia local

## Principios SOLID
----------------
Se respetaron principios SOLID: responsabilidad única, inversión de dependencias y otros para mantener el código limpio.

## Mejoras de rendimiento en widgets ⚡
---------------------------------
- Uso de constructores const cuando es posible
- Widgets pequeños para reducir áreas de rebuild
- `cached_network_image` para imágenes remotas
- Evitar trabajo pesado en `build` y mover cálculos costosos fuera del árbol de widgets

## Pruebas realizadas
------------------
- Unit tests: dominio y casos de uso
- Widget tests: renderizado, interacciones y semántica
- Integration tests: flujos end-to-end
- Golden tests: baselines de UI para detectar regresiones
- Accessibility tests: validación de labels y semántica

La capa de dominio alcanza **100% de cobertura** con pruebas unitarias comprehensivas. Para documentación detallada de pruebas, patrones y ejemplos, consulta:
- **[Pruebas de Capa de Dominio](module/domain/test/README.md)** - Guía completa con 37 casos de prueba
- **[ARCHITECTURE.md - Estrategia de Testing](ARCHITECTURE.md#testing-strategy)** - Resumen del enfoque de pruebas

## Buenas prácticas en pruebas
--------------------------
- Patrón Triple-A (Arrange-Act-Assert) y principios FIRST aplicados en pruebas unitarias
- Uso de mocks y fakes para aislar unidades bajo prueba
- Inclusión de `localizationsDelegates` en tests para aserciones robustas ante locales

## Scripts de Desarrollo 🛠️
--------------------------

El proyecto incluye dos tipos de scripts para diferentes casos de uso:

### Scripts de Desarrollador (`scripts/`)
**Para uso manual por desarrolladores** - interfaz amigable con retroalimentación visual:

```bash
# Configurar entorno de desarrollo
./scripts/setup.sh

# Generar reportes de cobertura con salida HTML
./scripts/test_coverage.sh      # Linux/macOS
./scripts/test_coverage.bat     # Windows

# Ejecutar pruebas de rendimiento
./scripts/performance_test.sh
```

### Scripts de Automatización (`tool/`)
**Para CI/CD y automatización** - salida mínima, datos estructurados:

```bash
# Verificar umbral de cobertura (usado en CI)
dart run tool/ci/check_coverage.dart coverage.lcov 90

# Analizar problemas de código (usado en CI)
dart run tool/ci/analyze_check.dart analyze_output.json
```

Ambos tipos de scripts usan **umbrales de cobertura consistentes**:
- Dominio: 90% | Infraestructura: 60% | Presentation BLoC: 50% | Widgets: 40%

## Buenas prácticas de código
-------------------------
- Nombres claros para archivos, clases y tests
- Widgets pequeños y estilos reutilizables
- Análisis estático (linting) con `very_good_analysis` recomendado

## Internacionalización (i18n) 🌍
--------------------------------

La aplicación soporta múltiples idiomas mediante el framework de internacionalización de Flutter:

### Idiomas Soportados

- **Inglés (en)**: Idioma predeterminado
- **Español (es)**: Idioma secundario

### Configuración

El sistema i18n se configura mediante `l10n.yaml`:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### Estructura de Archivos ARB

Las cadenas de localización se definen en archivos ARB (Application Resource Bundle):

- **Inglés**: `lib/l10n/app_en.arb`
- **Español**: `lib/l10n/app_es.arb`

Ejemplo de estructura ARB:
```json
{
  "@@locale": "es",
  "appTitle": "Razas de Gatos",
  "@appTitle": {
    "description": "El título de la aplicación"
  },
  "searchHint": "Buscar razas de gatos..."
}
```

### Uso en Código

```dart
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';

// En el método build
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

### Agregar Nuevas Traducciones

1. **Editar archivos ARB** con nuevas claves
2. **Generar archivos de localización**:
   ```bash
   flutter gen-l10n
   ```
3. **Usar nuevas cadenas** en tus widgets

### Agregar Nuevos Idiomas

1. Crear nuevo archivo ARB: `lib/l10n/app_{locale}.arb`
2. Agregar locale a `supportedLocales` en `main.dart`
3. Ejecutar `flutter gen-l10n` para generar archivos de localización

Para implementación detallada, ver [ARCHITECTURE.md](ARCHITECTURE.md#internationalization-i18n).

## Retry interceptor (DioRetryInterceptor)
-------------------------------------
- Propósito: un interceptor ligero de Dio que reintenta peticiones GET/HEAD en errores de servidor (5xx) usando backoff exponencial.
- Ubicación: `module/infrastructure/lib/src/product/network/dio_retry_interceptor.dart`.

## Pipeline de CI
-------------
- GitHub Actions configurado para ejecutar pruebas, análisis y comprobar cobertura por módulo.
- Scripts custom en `tool/ci/` para validar cobertura y análisis.

## Releases
--------
Este repositorio crea GitHub Releases automáticamente cuando se publica una etiqueta que coincida con `v*` (por ejemplo `v1.2.3`). El workflow está definido en `.github/workflows/release.yml` y creará una release subiendo un archivo zip del repositorio como un asset.

Para desencadenar una release localmente:

1. Crea y push una etiqueta:

  git tag v1.2.3; git push origin v1.2.3

2. El workflow de GitHub Actions se ejecutará y creará la release.

## Seguridad / Escaneo de secretos
--------------------------------
Este repositorio ejecuta un workflow automatizado de escaneo de secretos usando gitleaks.

- El workflow se encuentra en `.github/workflows/gitleaks.yml` y se ejecuta en pull requests, en pushes a `main` y semanalmente por cron.
- Cuando gitleaks detecta posibles secretos genera un artefacto `gitleaks-report.json` y el job falla para ayudar a prevenir merges accidentales.
- Para reducir falsos positivos puedes añadir un archivo de baseline llamado `.gitleaks.baseline.json` en la raíz del repositorio.

## Contribuir 🤝

1. Hacer fork del repositorio
2. Crear una rama de feature (`git checkout -b feature/caracteristica-increible`)
3. Hacer los cambios siguiendo los estándares de código
4. Agregar tests para nueva funcionalidad
5. Commit de los cambios (`git commit -m 'Agregar característica increíble'`)
6. Push a la rama (`git push origin feature/caracteristica-increible`)
7. Abrir un Pull Request

### Estándares de Código

- Seguir [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Usar mensajes de commit significativos siguiendo [Conventional Commits](https://www.conventionalcommits.org/)
- Mantener cobertura de tests sobre 90%
- Documentar APIs públicas

## Dependencias 📦

### Dependencias Principales

- `flutter_bloc`: Gestión de estado
- `get_it`: Inyección de dependencias
- `dio`: Cliente HTTP
- `cached_network_image`: Cache de imágenes
- `equatable`: Igualdad de valores

### Dependencias de Desarrollo

- `flutter_test`: Framework de testing
- `bloc_test`: Utilidades de testing para BLoC
- `very_good_analysis`: Reglas de linting
- `build_runner`: Generación de código

Para la lista completa de dependencias, ver [pubspec.yaml](pubspec.yaml).

## Solución de Problemas 🔧

### Problemas Comunes

**Errores de build después de clonar:**
```bash
flutter clean
flutter pub get
cd module/domain && flutter pub get
cd ../infrastructure && flutter pub get
```

**Fallos en tests:**
- Asegurar conexión a internet para tests de integración
- Verificar disponibilidad de API en https://thecatapi.com/

**Problemas de rendimiento:**
- Limpiar cache de la app
- Verificar conectividad de red
- Verificar almacenamiento del dispositivo

## Licencia 📄

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## Reconocimientos 🙏

- [The Cat API](https://thecatapi.com/) por proporcionar datos de razas de gatos
- Equipo de Flutter por el framework increíble
- Comunidad de Arquitectura Limpia por la guía arquitectural

## Contacto 📧

- **Proyecto**: Pragma Cat Breeds
- **Documentación**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **Issues**: Por favor usar GitHub Issues para reportes de bugs y solicitudes de features
