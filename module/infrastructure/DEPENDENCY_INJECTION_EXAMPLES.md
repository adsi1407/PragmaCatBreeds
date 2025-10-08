# Dependency Injection Examples

## Micro-package Pattern Implementation

### 1. Infrastructure Module with Injectable

The infrastructure module uses the micro-package pattern for clean dependency management:

```dart
// module/infrastructure/lib/dependency_injection/infrastructure_module.dart
@InjectableInit(
  initializerName: 'initInfrastructureModule',
  preferRelativeImports: false,
  asExtension: false,
  generateForDir: ['lib'],
  usesNullSafety: true,
)
@MicroPackageModule()
abstract class InfrastructureModule {
  @lazySingleton
  DioRetryInterceptor dioRetryInterceptor() => DioRetryInterceptor();

  @preResolve
  @lazySingleton
  Future<Dio> dio(DioRetryInterceptor retryInterceptor) async {
    final dio = Dio();
    dio.interceptors.add(retryInterceptor);
    dio.options.baseUrl = 'https://api.thecatapi.com/v1';
    return dio;
  }

  @lazySingleton
  CatBreedTranslator catBreedTranslator() => CatBreedTranslator();

  @lazySingleton
  CatBreedCache catBreedCache() => CatBreedCache();

  @lazySingleton
  CatBreedApi catBreedApi(Dio dio, CatBreedTranslator translator) =>
      CatBreedApi(dio, translator);

  @lazySingleton
  CatBreedRepositoryApi catBreedRepositoryApi(
    CatBreedApi api,
    CatBreedTranslator translator,
  ) => CatBreedRepositoryApi(api, translator);

  @lazySingleton
  CatBreedRepository catBreedRepository(
    CatBreedRepositoryApi repositoryApi,
    CatBreedCache cache,
  ) => CatBreedRepositoryProxy(repositoryApi, cache);

  @lazySingleton
  GetCatBreedsUseCase getCatBreedsUseCase(CatBreedRepository repository) =>
      GetCatBreedsUseCase(repository);

  @lazySingleton
  SearchCatBreedsUseCase searchCatBreedsUseCase(CatBreedRepository repository) =>
      SearchCatBreedsUseCase(repository);
}

/// Initializes the infrastructure micro-package dependencies.
@InjectableInit.microPackage()
void initInfrastructure() {}
```

### 2. Auto-generated Module Registration

The code generation creates two complementary files:

**infrastructure.module.dart** (Direct usage):
```dart
class InfrastructurePackageModule extends MicroPackageModule {
  @override
  FutureOr<void> init(GetItHelper gh) async {
    final infrastructureModule = _$InfrastructureModule();
    
    gh.lazySingleton<DioRetryInterceptor>(
        () => infrastructureModule.dioRetryInterceptor());
    gh.lazySingleton<CatBreedTranslator>(
        () => infrastructureModule.catBreedTranslator());
    gh.lazySingleton<CatBreedCache>(
        () => infrastructureModule.catBreedCache());
        
    await gh.lazySingletonAsync<Dio>(
      () => infrastructureModule.dio(gh<DioRetryInterceptor>()),
      preResolve: true,
    );
    
    // Complete dependency chain...
  }
}
```

**infrastructure_module.module.dart** (Function-based):
```dart
// Alternative approach with initInfrastructure() pattern
```

### 3. Main Application DI Setup

The main application uses the ultra-clean micro-package pattern:

```dart
// lib/src/dependency_injection/dependency_injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:infrastructure/infrastructure.dart';

import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.config.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Configures dependency injection for the entire application using micro-packages
@InjectableInit(
  externalPackageModulesAfter: [
    ExternalModule(InfrastructurePackageModule),
  ],
)
Future<void> configureDependencies() => getIt.init();
```

### 4. Public API Exports

The infrastructure module exports only essential public API:

```dart
// module/infrastructure/lib/infrastructure.dart
// Infrastructure Module Exports
// Only essential public API components are exported

// Dependency Injection
export 'dependency_injection/infrastructure_module.dart';
export 'dependency_injection/infrastructure_module.module.dart';

// Main Repository Implementation
export 'src/cat_breed/cat_breed_repository_proxy.dart';
```

**Benefits**: 
- Clean API surface
- Internal implementation details hidden
- Easier to maintain and refactor

### 5. Usage Benefits

#### Before (Manual Registration)
```dart
// Old way - manual registration
void _registerApiDependencies() {
  final dio = Dio();
  dio.interceptors.add(DioRetryInterceptor());
  dio.options.baseUrl = 'https://api.thecatapi.com/v1';
  getIt.registerLazySingleton<Dio>(() => dio);
  
  getIt.registerLazySingleton<CatBreedTranslator>(
    () => CatBreedTranslator(),
  );
  
  getIt.registerLazySingleton<CatBreedApi>(
    () => CatBreedApi(getIt(), getIt()),
  );
  
  // ... more manual registrations
}
```

#### After (Micro-package Pattern)
```dart
// New way - automated registration
@InjectableInit(
  externalPackageModulesAfter: [
    ExternalModule(InfrastructurePackageModule),
  ],
)
Future<void> configureDependencies() => getIt.init();
// All dependencies auto-registered!
```

### 6. Key Advantages

1. **Code Generation**: Dependencies are automatically registered
2. **Type Safety**: Compile-time validation of dependencies
3. **Modularity**: Clear separation between packages
4. **Maintainability**: Minimal boilerplate code
5. **Testability**: Easy to mock dependencies per module
6. **Async Support**: Proper handling of async dependencies with @preResolve

### 7. Testing with Micro-packages

```dart
// test/widget_test.dart
void main() {
  setUp(() async {
    // Reset GetIt for each test
    await getIt.reset();
    
    // Register only test dependencies
    await configureDependencies();
    
    // Override specific dependencies for testing
    getIt.registerLazySingleton<CatBreedRepository>(
      () => MockCatBreedRepository(),
    );
  });
}
```

## Architecture Benefits

The micro-package pattern provides:

- **Clean Architecture**: Clear boundaries between layers
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each module has a focused purpose
- **Open/Closed Principle**: Easy to extend without modifying existing code
- **Testability**: Easy to mock and test individual components
- **Code Generation**: Automatic dependency resolution and registration