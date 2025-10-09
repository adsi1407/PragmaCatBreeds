# Test Doubles Guidelines

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

## Reglas a Seguir

1. **Separación de Responsabilidades**: Cada mock debe estar en su propio archivo
2. **Nomenclatura**: Usar prefijo `Mock` + nombre de la clase/interfaz
3. **Ubicación**: En carpeta `test_doubles/` dentro del feature correspondiente
4. **Documentación**: Cada mock debe tener comentarios explicando su propósito
5. **Reutilización**: Los mocks pueden ser importados en múltiples archivos de test

## Estructura de Directorios
```
test/
  presentation/
    cat_breeds/
      test_doubles/
        mock_cat_breeds_bloc.dart
        mock_get_cat_breeds_use_case.dart
        mock_search_cat_breeds_use_case.dart
      cat_breeds_bloc_test.dart
      cat_breeds_page_test.dart
```

## Beneficios

- **Reutilización**: Un mock puede ser usado en múltiples tests
- **Mantenibilidad**: Cambios en un mock se reflejan en todos los tests que lo usan
- **Organización**: Separación clara entre tests y test doubles
- **Claridad**: Los archivos de test se enfocan solo en los tests, no en la configuración