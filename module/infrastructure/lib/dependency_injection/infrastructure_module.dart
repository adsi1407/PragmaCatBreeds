import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../src/cat_breed/cat_breed_api.dart';
import '../src/cat_breed/cat_breed_cache.dart';
import '../src/cat_breed/cat_breed_repository_api.dart';
import '../src/cat_breed/cat_breed_repository_proxy.dart';
import '../src/cat_breed/network/dio_retry_interceptor.dart';
import '../src/cat_breed/network/translator/cat_breed_translator.dart';

/// Infrastructure module for dependency injection.
/// 
/// This module provides all the infrastructure layer dependencies
/// including HTTP clients, repositories, caches, and translators.
@module
abstract class InfrastructureModule {
  /// Provides the DioRetryInterceptor for handling request retries.
  @lazySingleton
  DioRetryInterceptor dioRetryInterceptor() => DioRetryInterceptor();

  /// Provides the configured Dio HTTP client.
  @preResolve
  @lazySingleton
  Future<Dio> dio(DioRetryInterceptor retryInterceptor) async {
    final dio = Dio();
    
    // Configure base options
    dio.options
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..sendTimeout = const Duration(seconds: 30);
    
    // Add retry interceptor
    dio.interceptors.add(retryInterceptor);
    retryInterceptor.attach(dio);
    
    return dio;
  }

  /// Provides the Cat Breed API client.
  @lazySingleton
  CatBreedApi catBreedApi(Dio dio) => CatBreedApi(dio);

  /// Provides the Cat Breed translator.
  @lazySingleton
  CatBreedTranslator catBreedTranslator() => const CatBreedTranslator();

  /// Provides the Cat Breed cache.
  @lazySingleton
  CatBreedCache catBreedCache() => CatBreedCache();

  /// Provides the Cat Breed repository API implementation.
  @lazySingleton
  CatBreedRepositoryApi catBreedRepositoryApi(
    CatBreedApi api,
    CatBreedTranslator translator,
  ) =>
      CatBreedRepositoryApi(api, translator);

  /// Provides the Cat Breed repository with caching proxy.
  @LazySingleton(as: CatBreedRepository)
  CatBreedRepositoryProxy catBreedRepository(
    CatBreedRepositoryApi repositoryApi,
    CatBreedCache cache,
  ) =>
      CatBreedRepositoryProxy(repositoryApi, cache);

  /// Provides the Get Cat Breeds use case.
  @lazySingleton
  GetCatBreedsUseCase getCatBreedsUseCase(CatBreedRepository repository) =>
      GetCatBreedsUseCase(repository);

  /// Provides the Search Cat Breeds use case.
  @lazySingleton
  SearchCatBreedsUseCase searchCatBreedsUseCase(CatBreedRepository repository) =>
      SearchCatBreedsUseCase(repository);
}