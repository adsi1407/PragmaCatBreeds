part of 'cat_breeds_bloc.dart';

/// States for the Cat Breeds BLoC
sealed class CatBreedsState extends Equatable {
  const CatBreedsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CatBreedsInitial extends CatBreedsState {
  const CatBreedsInitial();
}

/// Loading state
class CatBreedsLoading extends CatBreedsState {
  const CatBreedsLoading();
}

/// Loaded state with cat breeds
class CatBreedsLoaded extends CatBreedsState {
  const CatBreedsLoaded({
    required this.breeds,
    this.isSearching = false,
    this.searchQuery = '',
  });

  final List<CatBreed> breeds;
  final bool isSearching;
  final String searchQuery;

  @override
  List<Object?> get props => [breeds, isSearching, searchQuery];

  /// Create a copy with updated values
  CatBreedsLoaded copyWith({
    List<CatBreed>? breeds,
    bool? isSearching,
    String? searchQuery,
  }) {
    return CatBreedsLoaded(
      breeds: breeds ?? this.breeds,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Error state
class CatBreedsError extends CatBreedsState {
  const CatBreedsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}