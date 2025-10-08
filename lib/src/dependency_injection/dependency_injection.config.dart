// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:domain/domain.dart' as _i494;
import 'package:get_it/get_it.dart' as _i174;
import 'package:infrastructure/infrastructure.dart' as _i740;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart'
    as _i793;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i793.CatBreedsBloc>(
      () => _i793.CatBreedsBloc(
        gh<_i494.GetCatBreedsUseCase>(),
        gh<_i494.SearchCatBreedsUseCase>(),
      ),
    );
    await _i740.InfrastructurePackageModule().init(gh);
    return this;
  }
}
