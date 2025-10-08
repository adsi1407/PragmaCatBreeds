import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:infrastructure/infrastructure.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Configures dependency injection for the entire application.
/// 
/// This function initializes all modules and their dependencies
/// following the Clean Architecture pattern.
Future<void> configureDependencies() async {
  // Infrastructure dependencies
  getIt.registerLazySingleton<DioRetryInterceptor>(DioRetryInterceptor.new);
  
  final dio = Dio();
  dio.options
    ..connectTimeout = const Duration(seconds: 30)
    ..receiveTimeout = const Duration(seconds: 30)
    ..baseUrl = 'https://api.thecatapi.com/v1/';
  dio.interceptors.add(getIt<DioRetryInterceptor>());
  getIt.registerLazySingleton<Dio>(() => dio);
  
  getIt.registerLazySingleton<CatBreedTranslator>(CatBreedTranslator.new);
  getIt.registerLazySingleton<CatBreedApi>(() => CatBreedApi(getIt<Dio>()));
  getIt.registerLazySingleton<CatBreedCache>(CatBreedCache.new);
  
  getIt.registerLazySingleton<CatBreedRepositoryApi>(
    () => CatBreedRepositoryApi(getIt<CatBreedApi>(), getIt<CatBreedTranslator>()),
  );
  
  getIt.registerLazySingleton<CatBreedRepository>(
    () => CatBreedRepositoryProxy(getIt<CatBreedRepositoryApi>(), getIt<CatBreedCache>()),
  );
  
  // Domain dependencies
  getIt.registerLazySingleton<GetCatBreedsUseCase>(
    () => GetCatBreedsUseCase(getIt<CatBreedRepository>()),
  );
  
  getIt.registerLazySingleton<SearchCatBreedsUseCase>(
    () => SearchCatBreedsUseCase(getIt<CatBreedRepository>()),
  );
  
  // Presentation dependencies
  getIt.registerFactory<CatBreedsBloc>(
    () => CatBreedsBloc(
      getIt<GetCatBreedsUseCase>(),
      getIt<SearchCatBreedsUseCase>(),
    ),
  );
}