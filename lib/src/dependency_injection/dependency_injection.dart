import 'package:get_it/get_it.dart';
import 'package:infrastructure/infrastructure.dart';
import 'package:injectable/injectable.dart';
import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.config.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Configures dependency injection for the entire application using micro-packages
@InjectableInit(
  externalPackageModulesAfter: [ExternalModule(InfrastructurePackageModule)],
)
Future<void> configureDependencies() => getIt.init();
