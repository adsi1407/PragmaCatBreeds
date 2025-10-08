import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/page/cat_breed_detail_page.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/page/cat_breeds_page.dart';

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
      title: 'Cat Breeds',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CatBreedsPage(),
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