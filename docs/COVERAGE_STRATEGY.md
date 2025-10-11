# 📊 Test Coverage Strategy

## 🎯 Overview

Este proyecto implementa una **estrategia de cobertura granular y realista** donde cada tipo de test solo mide los archivos que puede cubrir de manera práctica.

## 🧩 Arquitectura de Cobertura

### 📋 **Problema Resuelto**
- **Antes**: Cobertura inflada - cada tipo de test medía TODA la aplicación
- **Ahora**: Cobertura específica - cada test mide solo su dominio de responsabilidad

### 🔧 **Checkers Específicos**

| Checker | Files Measured | Files Excluded | Threshold |
|---------|----------------|-----------------|-----------|
| **BLoC** | `/bloc/`, `_bloc.dart`, `/events/`, `/states/` | UI, APIs, main.dart, DI | 50% |
| **Domain** | Entire `module/domain/` module | Generated files (.g.dart) | 90% |
| **Infrastructure** | Entire `module/infrastructure/` module | Generated files (.g.dart) | 60% |
| **Widgets** | `/widgets/`, `_widget.dart` | Pages, BLoCs, APIs, domain | 40% |
| **Pages** | `/page/`, `/pages/`, `_page.dart` | Widgets, BLoCs, APIs, domain | 40% |

## 📁 **Archivos de Cobertura**

```bash
scripts/ci/validation/
├── check_bloc_coverage.dart          # BLoC-specific coverage
├── check_widgets_coverage.dart       # Widget-specific coverage
├── check_pages_coverage.dart         # Page-specific coverage
└── check_coverage.dart              # Generic checker (domain, infrastructure)
```

## 🔍 **Filosofía de Medición**

### ✅ **Principles:**
1. **Realism**: Only measure files that tests can actually reach
2. **Specificity**: Presentation tests have specific checkers  
3. **Modular simplicity**: Separate modules (domain/infrastructure) use generic checker
4. **Intelligent exclusion**: Automatically excludes irrelevant files
5. **Appropriate thresholds**: Different expectations per type

### 🎯 **Ejemplos Prácticos:**

#### **BLoC Tests (81.2% coverage)**
```dart
// ✅ Medido
lib/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart
lib/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart
lib/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart

// ❌ Excluido (no alcanzable desde BLoC tests)
lib/main.dart
lib/src/dependency_injection/dependency_injection.dart
lib/src/presentation/cat_breeds/page/cat_breeds_page.dart
```

#### **Domain Tests (module/domain/)**
```dart
// ✅ Measured - ENTIRE MODULE
module/domain/lib/src/entities/cat_breed.dart
module/domain/lib/src/use_cases/get_cat_breeds_use_case.dart
module/domain/lib/src/repositories/cat_breed_repository.dart

// ❌ Automatically excluded
module/domain/lib/src/*.g.dart         # Generated files
```

#### **Infrastructure Tests (module/infrastructure/)**
```dart
// ✅ Measured - ENTIRE MODULE  
module/infrastructure/lib/src/cat_breed/api/cat_breed_api.dart
module/infrastructure/lib/src/cat_breed/dto/cat_breed_dto.dart
module/infrastructure/lib/src/cat_breed/repository/cat_breed_repository_impl.dart

// ❌ Automatically excluded
module/infrastructure/lib/src/*.g.dart # Generated files
```

## 🚀 **Uso en CI/CD**

### **GitHub Actions Workflow:**
```yaml
# BLoC Coverage (specific)
- run: flutter test --coverage --tags=bloc
- run: dart run tool/ci/check_bloc_coverage.dart coverage-bloc.lcov 50

# Domain Coverage (generic - entire module)
- run: flutter test --coverage
- run: dart run tool/ci/check_coverage.dart coverage-domain.lcov 90

# Infrastructure Coverage (generic - entire module)
- run: flutter test --coverage
- run: dart run tool/ci/check_coverage.dart coverage-infra.lcov 60

# Widget Coverage (specific)
- run: flutter test --coverage --exclude-tags=golden,accessibility,bloc
- run: dart run tool/ci/check_widgets_coverage.dart coverage-widgets.lcov 40
```

### **Local Commands:**
```bash
# Test BLoC coverage (specific)
flutter test --coverage --tags=bloc
dart run tool/ci/check_bloc_coverage.dart coverage/lcov.info 50

# Test Domain coverage (generic - entire module)
cd module/domain && flutter test --coverage
dart run ../../tool/ci/check_coverage.dart coverage/lcov.info 90

# Test Infrastructure coverage (generic - entire module)
cd module/infrastructure && flutter test --coverage  
dart run ../../tool/ci/check_coverage.dart coverage/lcov.info 60

# Test Widget coverage (specific)
flutter test --coverage test/presentation/**/widgets --exclude-tags=golden,accessibility,bloc
dart run tool/ci/check_widgets_coverage.dart coverage/lcov.info 40
```

## 🎯 **Thresholds and Justification**

| Layer | Threshold | Justification |
|-------|-----------|---------------|
| **Domain** | 90% | Critical business logic, isolated module, easy to test |
| **Infrastructure** | 60% | External APIs, I/O operations, isolated module but more complex |
| **BLoC** | 50% | Presentation logic, external dependencies, specific filtering |
| **Widgets** | 40% | Complex UI, Flutter dependencies, specific filtering |
| **Pages** | 40% | Full integration, navigation, specific filtering |

## 📈 **Beneficios Obtenidos**

### ✅ **Antes vs Ahora:**
- **BLoC**: De ~30% inflado → **81.2% realista**
- **CI Pipeline**: De fallando → **pasando consistentemente**
- **Developers**: De frustración → **métricas útiles**
- **Maintenance**: De manual → **automático y específico**

### 🎯 **Métricas Realistas:**
- Cada tipo de test mide solo su responsabilidad
- Umbrales apropiados por complejidad de layer
- Exclusión automática de archivos irrelevantes
- Reports específicos y claros

## 🔧 **Mantenimiento**

### **Agregar nuevos tipos de archivos:**
1. Identificar el checker apropiado
2. Actualizar patrones de inclusión/exclusión
3. Ajustar umbrales si necesario
4. Documentar cambios

### **Debugging cobertura baja:**
```bash
# Ver qué archivos están siendo medidos
dart run tool/ci/check_bloc_coverage.dart coverage/lcov.info 50

# Analizar archivos específicos en lcov.info
grep "SF:" coverage/lcov.info | grep bloc
```

## 💡 **Best Practices**

### ✅ **Recomendado:**
- Usar checker específico para cada tipo de test
- Ajustar umbrales basado en complejidad real
- Agregar nuevos patrones cuando aparezcan nuevos tipos de archivos
- Revisar coverage reports regularmente

### ❌ **Evitar:**
- Usar checker genérico para todos los tipos
- Umbrales unrealistas (95%+ para UI)
- Incluir archivos que el test no puede alcanzar
- Ignorar coverage reports - son métricas valiosas ahora