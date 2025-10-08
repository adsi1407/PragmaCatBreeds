import 'dart:async';

import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'cat_breeds_event.dart';
part 'cat_breeds_state.dart';

/// BLoC for managing cat breeds list and search functionality
@injectable
class CatBreedsBloc extends Bloc<CatBreedsEvent, CatBreedsState> {
  CatBreedsBloc(
    this._getCatBreedsUseCase,
    this._searchCatBreedsUseCase,
  ) : super(const CatBreedsInitial()) {
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
      emit(CatBreedsError('Failed to load cat breeds: ${e}'));
    }
  }

  /// Handle search request with debouncing
  Future<void> _onSearchRequested(
    CatBreedsSearchRequested event,
    Emitter<CatBreedsState> emit,
  ) async {
    // Cancel previous timer
    _searchTimer?.cancel();
    
    final query = event.query.trim();
    
    // If query is empty, show all breeds
    if (query.isEmpty) {
      emit(CatBreedsLoaded(
        breeds: _allBreeds,
      ));
      return;
    }
    
    // Show current state as searching
    if (state is CatBreedsLoaded) {
      final currentState = state as CatBreedsLoaded;
      emit(currentState.copyWith(
        isSearching: true,
        searchQuery: query,
      ));
    }
    
    // Debounce search requests
    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _searchCatBreedsUseCase(query);
        
        emit(CatBreedsLoaded(
          breeds: results,
          searchQuery: query,
        ));
      } catch (e) {
        emit(CatBreedsError('Failed to search cat breeds: ${e}'));
      }
    });
  }

  /// Handle clear search request
  void _onSearchCleared(
    CatBreedsSearchCleared event,
    Emitter<CatBreedsState> emit,
  ) {
    _searchTimer?.cancel();
    
    emit(CatBreedsLoaded(
      breeds: _allBreeds,
    ));
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}