import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/page/cat_breed_detail_page.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/page/cat_breeds_page.dart';
import 'package:pragma_cat_breeds/src/presentation/splash/splash_screen.dart';
import 'package:pragma_cat_breeds/src/theme/pragma_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure dependency injection
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: PragmaTheme.lightTheme,
      darkTheme: PragmaTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case CatBreedsPage.routeName:
            return MaterialPageRoute<void>(
              builder: (_) => const CatBreedsPage(),
            );
          case CatBreedDetailPage.routeName:
            final breed = settings.arguments as CatBreed?;
            if (breed != null) {
              return MaterialPageRoute<void>(
                builder: (_) => CatBreedDetailPage(breed: breed),
              );
            }
            return _buildErrorRoute('Invalid breed data');
          default:
            return _buildErrorRoute('Route not found');
        }
      },
    );
  }

  Route<dynamic> _buildErrorRoute(String message) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
