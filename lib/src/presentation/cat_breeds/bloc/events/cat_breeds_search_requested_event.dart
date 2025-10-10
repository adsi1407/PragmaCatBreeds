part of 'cat_breeds_event.dart';

/// Event to search cat breeds by a specific query string
class CatBreedsSearchRequested extends CatBreedsEvent {
  const CatBreedsSearchRequested(this.query);

  /// The search query string to filter cat breeds
  final String query;

  @override
  List<Object?> get props => [query];

  @override
  String toString() => 'CatBreedsSearchRequested(query: $query)';
}
