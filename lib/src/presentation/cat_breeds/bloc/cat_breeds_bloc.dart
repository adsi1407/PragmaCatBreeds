import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';

/// BLoC for managing cat breeds list and search functionality
@injectable
class CatBreedsBloc extends Bloc<CatBreedsEvent, CatBreedsState> {
  CatBreedsBloc(this._getCatBreedsUseCase, this._searchCatBreedsUseCase)
    : super(const CatBreedsInitial()) {
    on<CatBreedsLoadRequested>(_onLoadRequested);
    on<CatBreedsSearchRequested>(_onSearchRequested);
    on<CatBreedsSearchCleared>(_onSearchCleared);
  }

  final GetCatBreedsUseCase _getCatBreedsUseCase;
  final SearchCatBreedsUseCase _searchCatBreedsUseCase;

  List<CatBreed> _allBreeds = [];
  Timer? _searchTimer;

  /// Handle load all breeds request
  Future<void> _onLoadRequested(
    CatBreedsLoadRequested event,
    Emitter<CatBreedsState> emit,
  ) async {
    emit(const CatBreedsLoading());

    try {
      final breeds = await _getCatBreedsUseCase();
      _allBreeds = breeds;

      emit(CatBreedsLoaded(breeds: breeds));
    } catch (e) {
      emit(CatBreedsError('Failed to load cat breeds: $e'));
    }
  }

  /// Handle search request
  Future<void> _onSearchRequested(
    CatBreedsSearchRequested event,
    Emitter<CatBreedsState> emit,
  ) async {
    // Cancel previous timer
    _searchTimer?.cancel();

    final query = event.query.trim();

    // If query is empty, show all breeds
    if (query.isEmpty) {
      emit(
        CatBreedsLoaded(
          breeds: _allBreeds,
          isSearching: false,
          searchQuery: '',
        ),
      );
      return;
    }

    // Show current state as searching
    if (state is CatBreedsLoaded) {
      final currentState = state as CatBreedsLoaded;
      emit(currentState.copyWith(isSearching: true, searchQuery: query));
    }

    // Execute search immediately (debouncing is handled in UI layer)
    try {
      final results = await _searchCatBreedsUseCase(query);

      if (!emit.isDone) {
        emit(
          CatBreedsLoaded(
            breeds: results,
            isSearching: true,
            searchQuery: query,
          ),
        );
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(CatBreedsError('Failed to search cat breeds: $e'));
      }
    }
  }

  /// Handle clear search request
  Future<void> _onSearchCleared(
    CatBreedsSearchCleared event,
    Emitter<CatBreedsState> emit,
  ) async {
    _searchTimer?.cancel();

    emit(const CatBreedsLoading());

    try {
      final breeds = await _getCatBreedsUseCase();
      _allBreeds = breeds;

      emit(
        CatBreedsLoaded(breeds: breeds, isSearching: false, searchQuery: ''),
      );
    } catch (e) {
      emit(CatBreedsError('Failed to clear search: $e'));
    }
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}
