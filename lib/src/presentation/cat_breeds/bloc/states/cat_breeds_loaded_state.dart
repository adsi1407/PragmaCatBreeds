part of 'cat_breeds_state.dart';

/// Loaded state containing the cat breeds data
class CatBreedsLoaded extends CatBreedsState {
  const CatBreedsLoaded({
    required this.breeds,
    this.isSearching = false,
    this.searchQuery = '',
  });

  /// List of cat breeds to display
  final List<CatBreed> breeds;

  /// Flag indicating if a search is currently active
  final bool isSearching;

  /// Current search query string
  final String searchQuery;

  @override
  List<Object?> get props => [breeds, isSearching, searchQuery];

  /// Create a copy of this state with updated values
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

  @override
  String toString() =>
      'CatBreedsLoaded(breeds: ${breeds.length}, isSearching: $isSearching, searchQuery: $searchQuery)';
}
