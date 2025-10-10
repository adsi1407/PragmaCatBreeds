//@GeneratedMicroModule;InfrastructurePackageModule;package:infrastructure/dependency_injection/infrastructure_module.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:dio/dio.dart' as _i361;
import 'package:domain/domain.dart' as _i494;
import 'package:infrastructure/dependency_injection/infrastructure_module.dart'
    as _i1037;
import 'package:infrastructure/src/cat_breed/api/cat_breed_api.dart' as _i748;
import 'package:infrastructure/src/cat_breed/api/cat_breed_repository_api.dart'
    as _i913;
import 'package:infrastructure/src/cat_breed/api/network/dio_retry_interceptor.dart'
    as _i373;
import 'package:infrastructure/src/cat_breed/api/network/translator/cat_breed_translator.dart'
    as _i477;
import 'package:infrastructure/src/cat_breed/cache/cat_breed_cache.dart'
    as _i923;
import 'package:injectable/injectable.dart' as _i526;

class InfrastructurePackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) async {
    final infrastructureModule = _$InfrastructureModule();
    gh.lazySingleton<_i373.DioRetryInterceptor>(
      () => infrastructureModule.dioRetryInterceptor(),
    );
    gh.lazySingleton<_i477.CatBreedTranslator>(
      () => infrastructureModule.catBreedTranslator(),
    );
    gh.lazySingleton<_i923.CatBreedCache>(
      () => infrastructureModule.catBreedCache(),
    );
    await gh.lazySingletonAsync<_i361.Dio>(
      () => infrastructureModule.dio(gh<_i373.DioRetryInterceptor>()),
      preResolve: true,
    );
    gh.lazySingleton<_i748.CatBreedApi>(
      () => infrastructureModule.catBreedApi(
        gh<_i361.Dio>(),
        gh<_i477.CatBreedTranslator>(),
      ),
    );
    gh.lazySingleton<_i913.CatBreedRepositoryApi>(
      () => infrastructureModule.catBreedRepositoryApi(
        gh<_i748.CatBreedApi>(),
        gh<_i477.CatBreedTranslator>(),
      ),
    );
    gh.lazySingleton<_i494.CatBreedRepository>(
      () => infrastructureModule.catBreedRepository(
        gh<_i913.CatBreedRepositoryApi>(),
        gh<_i923.CatBreedCache>(),
      ),
    );
    gh.lazySingleton<_i494.GetCatBreedsUseCase>(
      () => infrastructureModule.getCatBreedsUseCase(
        gh<_i494.CatBreedRepository>(),
      ),
    );
    gh.lazySingleton<_i494.SearchCatBreedsUseCase>(
      () => infrastructureModule.searchCatBreedsUseCase(
        gh<_i494.CatBreedRepository>(),
      ),
    );
  }
}

class _$InfrastructureModule extends _i1037.InfrastructureModule {}
