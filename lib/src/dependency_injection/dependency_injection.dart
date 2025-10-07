import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:infrastructure/infrastructure.dart';

import 'dependency_injection.config.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Configures dependency injection for the entire application.
/// 
/// This function initializes all modules and their dependencies
/// following the Clean Architecture pattern.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await getIt.init();
}