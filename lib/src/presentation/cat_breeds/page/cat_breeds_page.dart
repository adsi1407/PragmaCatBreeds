import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';
import 'package:pragma_cat_breeds/src/dependency_injection/dependency_injection.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breeds_list.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breeds_search_bar.dart';

/// Main page for displaying and searching cat breeds
class CatBreedsPage extends StatelessWidget {
  const CatBreedsPage({super.key});

  static const String routeName = '/cat-breeds';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CatBreedsBloc>()
        ..add(const CatBreedsLoadRequested()),
      child: const CatBreedsView(),
    );
  }
}

/// The view component of the cat breeds page
class CatBreedsView extends StatelessWidget {
  const CatBreedsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
      ),
      body: const Column(
        children: [
          CatBreedsSearchBar(),
          Expanded(
            child: CatBreedsList(),
          ),
        ],
      ),
    );
  }
}
