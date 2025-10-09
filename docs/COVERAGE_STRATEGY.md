# 📊 Test Coverage Strategy

## 🎯 Overview

Este proyecto implementa una **estrategia de cobertura granular y realista** donde cada tipo de test solo mide los archivos que puede cubrir de manera práctica.

## 🧩 Arquitectura de Cobertura

### 📋 **Problema Resuelto**
- **Antes**: Cobertura inflada - cada tipo de test medía TODA la aplicación
- **Ahora**: Cobertura específica - cada test mide solo su dominio de responsabilidad

### 🔧 **Checkers Específicos**

| Checker | Archivos Medidos | Archivos Excluidos | Umbral |
|---------|------------------|-------------------|---------|
| **BLoC** | `/bloc/`, `_bloc.dart`, `/events/`, `/states/` | UI, APIs, main.dart, DI | 50% |
| **Domain** | `/domain/`, `/entities/`, `/use_cases/`, `/repositories/` | UI, infrastructure, APIs | 90% |
| **Infrastructure** | `/infrastructure/`, `/api/`, `/dto/`, `_repository_impl.dart` | UI, domain, main.dart | 60% |
| **Widgets** | `/widgets/`, `_widget.dart` | Pages, BLoCs, APIs, domain | 40% |
| **Pages** | `/page/`, `/pages/`, `_page.dart` | Widgets, BLoCs, APIs, domain | 40% |

## 📁 **Archivos de Cobertura**

```bash
tool/ci/
├── check_bloc_coverage.dart          # BLoC-specific coverage
├── check_domain_coverage.dart        # Domain layer coverage  
├── check_infrastructure_coverage.dart # Infrastructure layer coverage
├── check_widgets_coverage.dart       # Widget-specific coverage
├── check_pages_coverage.dart         # Page-specific coverage
└── check_coverage.dart              # Generic fallback (deprecated)
```

## 🔍 **Filosofía de Medición**

### ✅ **Principios:**
1. **Realismo**: Solo medir archivos que el test puede alcanzar
2. **Especificidad**: Cada tipo de test tiene su dominio
3. **Exclusión inteligente**: Automáticamente excluye archivos irrelevantes
4. **Umbrales apropiados**: Diferentes expectativas por tipo

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

#### **Domain Tests**
```dart
// ✅ Medido
module/domain/lib/src/entities/cat_breed.dart
module/domain/lib/src/use_cases/get_cat_breeds_use_case.dart
module/domain/lib/src/repositories/cat_breed_repository.dart

// ❌ Excluido
lib/src/presentation/               # UI layer
module/infrastructure/             # Implementation details
```

## 🚀 **Uso en CI/CD**

### **GitHub Actions Workflow:**
```yaml
# BLoC Coverage
- run: flutter test --coverage --tags=bloc
- run: dart run tool/ci/check_bloc_coverage.dart coverage-bloc.lcov 50

# Domain Coverage  
- run: flutter test --coverage
- run: dart run tool/ci/check_domain_coverage.dart coverage-domain.lcov 90

# Infrastructure Coverage
- run: flutter test --coverage
- run: dart run tool/ci/check_infrastructure_coverage.dart coverage-infra.lcov 60
```

### **Comandos Locales:**
```bash
# Test individual coverage
flutter test --coverage --tags=bloc
dart run tool/ci/check_bloc_coverage.dart coverage/lcov.info 50

# Test all types
flutter test --coverage
dart run tool/ci/check_domain_coverage.dart coverage/lcov.info 90
dart run tool/ci/check_infrastructure_coverage.dart coverage/lcov.info 60
dart run tool/ci/check_widgets_coverage.dart coverage/lcov.info 40
dart run tool/ci/check_pages_coverage.dart coverage/lcov.info 40
```

## 🎯 **Umbrales y Justificación**

| Layer | Umbral | Justificación |
|-------|--------|---------------|
| **Domain** | 90% | Lógica de negocio crítica, fácil de testear |
| **Infrastructure** | 60% | APIs externas, I/O, más complejo |
| **BLoC** | 50% | Lógica de presentación, dependencias externas |
| **Widgets** | 40% | UI compleja, dependencias de Flutter |
| **Pages** | 40% | Integración completa, navegación |

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