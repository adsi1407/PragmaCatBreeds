# App de Razas de Gatos 🐱

Una aplicación Flutter que muestra información sobre diferentes razas de gatos, construida con principios de Arquitectura Limpia y siguiendo las mejores prácticas de la industria.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.8+-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[🇺🇸 English Version](README.md)

## Características ✨

- **Explorar Razas de Gatos**: Ve una lista completa de razas de gatos con información detallada
- **Funcionalidad de Búsqueda**: Búsqueda en tiempo real con debouncing para rendimiento óptimo
- **Información Detallada**: Perfiles completos de razas incluyendo características físicas, temperamento y calificaciones
- **Soporte Offline**: Cache inteligente para mejor experiencia de usuario
- **Arquitectura Limpia**: Base de código modular, testeable y mantenible
- **Diseño Material 3**: UI moderna siguiendo las últimas guías de diseño de Google

## Capturas de Pantalla 📸

| Lista de Razas | Detalles de Raza | Función de Búsqueda |
|----------------|------------------|---------------------|
| _Próximamente_ | _Próximamente_   | _Próximamente_      |

## Arquitectura 🏗️

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

Para documentación detallada de arquitectura, ver [ARCHITECTURE.md](ARCHITECTURE.md).

## Comenzando 🚀

### Prerrequisitos

- Flutter SDK 3.8 o superior
- Dart 3.0 o superior
- Un IDE con soporte para Flutter (VS Code, Android Studio, IntelliJ)

### Instalación

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

### Scripts Disponibles 🛠️

```bash
# Ejecutar la aplicación
flutter run

# Ejecutar tests
flutter test

# Ejecutar tests de integración
flutter test test/integration_test.dart

# Generar cobertura de tests
./scripts/test_coverage.sh

# Analizar calidad de código
flutter analyze

# Formatear código
dart format .

# Limpiar y reconstruir
flutter clean && flutter pub get
```

## Estructura del Proyecto 📁

```
pragma_cat_breeds/
├── lib/
│   ├── main.dart                    # Punto de entrada de la aplicación
│   └── src/
│       ├── dependency_injection/   # Configuración de DI
│       └── presentation/           # Componentes de UI
│           ├── cat_breeds/         # Feature de razas de gatos
│           │   ├── bloc/           # Gestión de estado
│           │   ├── pages/          # Widgets de pantalla
│           │   └── widgets/        # Componentes UI reutilizables
│           └── cat_breed_detail/   # Feature de detalle de raza
├── module/
│   ├── domain/                     # Lógica de negocio
│   │   ├── lib/
│   │   │   └── src/cat_breed/     # Dominio de raza de gato
│   │   └── pubspec.yaml
│   └── infrastructure/            # Capa de datos
│       ├── lib/
│       │   └── src/cat_breed/     # Fuentes de datos de raza de gato
│       └── pubspec.yaml
├── test/                          # Archivos de test
├── scripts/                       # Scripts de desarrollo
└── docs/                         # Documentación
```

## Integración con API 🌐

Esta aplicación se integra con [The Cat API](https://thecatapi.com/) para obtener información de razas de gatos:

- **URL Base**: `https://api.thecatapi.com/v1/`
- **Endpoints Utilizados**:
  - `GET /breeds` - Obtener todas las razas de gatos
  - `GET /breeds/search?q={query}` - Buscar razas de gatos

## Gestión de Estado 🔄

La aplicación usa el patrón **BLoC (Business Logic Component)** para la gestión de estado:

- **Events**: Acciones del usuario y triggers externos
- **States**: Estados de representación de UI
- **BLoC**: Lógica de negocio y transiciones de estado

### BLoCs Principales

- `CatBreedsBloc`: Gestiona la lista de razas de gatos y funcionalidad de búsqueda

## Estrategia de Testing 🧪

### Tipos de Test

- **Tests Unitarios**: Lógica de negocio y casos de uso
- **Tests de Widget**: Componentes UI e interacciones
- **Tests de Integración**: Funcionalidad de extremo a extremo

### Objetivos de Cobertura

- Lógica de Negocio: 100%
- Componentes UI: 90%
- Integración: Flujos principales de usuario

Ejecutar tests con:
```bash
flutter test                    # Tests unitarios y de widget
flutter test --coverage        # Con reporte de cobertura
./scripts/test_coverage.sh      # Generar cobertura detallada
```

## Consideraciones de Rendimiento ⚡

- **Caching**: TTL de 5 minutos para respuestas de API
- **Debouncing de Búsqueda**: Delay de 300ms para UX óptima
- **Carga de Imágenes**: Imágenes de red con cache y placeholders
- **Gestión de Memoria**: Disposición adecuada de recursos

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

---

Hecho con ❤️ usando Flutter y principios de Arquitectura Limpia.