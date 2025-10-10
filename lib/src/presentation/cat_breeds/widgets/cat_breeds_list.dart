import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pragma_cat_breeds/l10n/app_localizations.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/widgets/cat_breed_list_item.dart';

/// Widget that displays the list of cat breeds
class CatBreedsList extends StatelessWidget {
  const CatBreedsList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CatBreedsBloc, CatBreedsState>(
      builder: (context, state) {
        return switch (state) {
          CatBreedsInitial() => Center(child: Text(l10n.welcomeLoading)),
          CatBreedsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CatBreedsLoaded() => _buildLoadedState(context, state),
          CatBreedsError() => _buildErrorState(context, state),
        };
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, CatBreedsLoaded state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.breeds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? l10n.noResultsFor(state.searchQuery)
                  : l10n.noBreedsAvailable,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (state.searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  context.read<CatBreedsBloc>().add(
                    const CatBreedsSearchCleared(),
                  );
                },
                child: Text(l10n.clearSearchButton),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CatBreedsBloc>().add(const CatBreedsLoadRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.breeds.length,
        // Performance optimizations
        cacheExtent: 200.0, // Cache items outside viewport for smooth scrolling
        physics:
            const AlwaysScrollableScrollPhysics(), // Improve scroll behavior
        itemBuilder: (context, index) {
          final breed = state.breeds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CatBreedListItem(
              breed: breed,
              onTap: () {
                // Navigate to detail page
                Navigator.of(
                  context,
                ).pushNamed('/cat-breed-detail', arguments: breed);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, CatBreedsError state) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.errorGeneric,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CatBreedsBloc>().add(const CatBreedsLoadRequested());
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.tryAgainButton),
          ),
        ],
      ),
    );
  }
}
