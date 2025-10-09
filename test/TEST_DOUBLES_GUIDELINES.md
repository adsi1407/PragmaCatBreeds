# Test Doubles Guidelines

> **Principio fundamental**: Los test doubles (Mocks, Stubs, Fakes) deben estar organizados en archivos separados para promover la reutilización, mantenibilidad y claridad del código de pruebas.

## Principios de Organización

### ❌ INCORRECTO - Definir mocks inline en archivos de test
```dart
// En cat_breeds_bloc_test.dart
class MockGetCatBreedsUseCase extends Mock implements GetCatBreedsUseCase {}
class MockSearchCatBreedsUseCase extends Mock implements SearchCatBreedsUseCase {}

void main() {
  // tests...
}
```

### ✅ CORRECTO - Mocks en archivos separados dentro de test_doubles
```dart
// En test_doubles/mock_get_cat_breeds_use_case.dart
class MockGetCatBreedsUseCase extends Mock implements GetCatBreedsUseCase {}

// En test_doubles/mock_search_cat_breeds_use_case.dart  
class MockSearchCatBreedsUseCase extends Mock implements SearchCatBreedsUseCase {}

// En cat_breeds_bloc_test.dart
import 'test_doubles/mock_get_cat_breeds_use_case.dart';
import 'test_doubles/mock_search_cat_breeds_use_case.dart';

void main() {
  // tests...
}
```

## Reglas Generales

1. **Separación de Responsabilidades**: Cada mock debe estar en su propio archivo
2. **Nomenclatura**: Usar prefijo `Mock` + nombre de la clase/interfaz original
3. **Ubicación**: En carpeta `test_doubles/` dentro del feature o módulo correspondiente
4. **Documentación**: Cada mock debe tener comentarios explicando su propósito
5. **Reutilización**: Los mocks pueden ser importados en múltiples archivos de test
6. **Cohesión**: Los test doubles deben estar cerca de los tests que los utilizan

## Estructura de Directorios Recomendada

```
test/
  ├── TEST_DOUBLES_GUIDELINES.md (este archivo)
  ├── presentation/
  │   ├── cat_breeds/
  │   │   ├── test_doubles/
  │   │   │   ├── mock_cat_breeds_bloc.dart
  │   │   │   ├── mock_get_cat_breeds_use_case.dart
  │   │   │   └── mock_search_cat_breeds_use_case.dart
  │   │   ├── cat_breeds_bloc_test.dart
  │   │   └── cat_breeds_page_test.dart
  │   └── cat_breed_detail/
  │       ├── test_doubles/
  │       │   └── mock_detail_specific_dependencies.dart
  │       └── cat_breed_detail_test.dart
  ├── domain/
  │   └── test_doubles/
  │       ├── mock_repositories.dart
  │       └── mock_entities.dart
  └── infrastructure/
      └── test_doubles/
          ├── mock_data_sources.dart
          └── mock_apis.dart
```

## Tipos de Test Doubles

### Mocks
- **Propósito**: Verificar interacciones (llamadas a métodos)
- **Uso**: Cuando necesitas verificar que se llamaron métodos específicos
- **Ejemplo**: `MockCatBreedsRepository`

### Stubs
- **Propósito**: Proveer respuestas predefinidas
- **Uso**: Cuando necesitas controlar qué devuelve una dependencia
- **Ejemplo**: `StubCatBreedsDataSource`

### Fakes
- **Propósito**: Implementaciones simplificadas pero funcionales
- **Uso**: Para componentes complejos que necesitan funcionar pero de forma simplificada
- **Ejemplo**: `FakeInMemoryCatBreedsRepository`

## Ejemplo de Documentación en Mock

```dart
/// Mock implementation of GetCatBreedsUseCase for testing purposes
/// 
/// This mock allows controlling the behavior of the use case
/// in unit tests by setting predefined responses or exceptions.
/// 
/// Usage:
/// ```dart
/// when(() => mock.call()).thenAnswer((_) async => mockBreeds);
/// ```
class MockGetCatBreedsUseCase extends Mock implements GetCatBreedsUseCase {}
```

## Beneficios de esta Organización

- **Reutilización**: Un mock puede ser usado en múltiples tests del mismo feature
- **Mantenibilidad**: Cambios en un mock se reflejan automáticamente en todos los tests
- **Organización**: Separación clara entre tests y test doubles
- **Claridad**: Los archivos de test se enfocan solo en los tests, no en la configuración
- **Discoverable**: Es fácil encontrar todos los mocks disponibles para un feature
- **Testing Pyramid**: Facilita la implementación de diferentes niveles de testing

## Referencias

- [Testing Best Practices](../docs/TESTING.md)
- [Clean Architecture Testing](../ARCHITECTURE.md#testing-strategy)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)