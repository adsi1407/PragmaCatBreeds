part of 'cat_breeds_bloc.dart';

/// Events for the Cat Breeds BLoC
abstract class CatBreedsEvent extends Equatable {
  const CatBreedsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all cat breeds
class CatBreedsLoadRequested extends CatBreedsEvent {
  const CatBreedsLoadRequested();
}

/// Event to search cat breeds by query
class CatBreedsSearchRequested extends CatBreedsEvent {
  const CatBreedsSearchRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to clear search and show all breeds
class CatBreedsSearchCleared extends CatBreedsEvent {
  const CatBreedsSearchCleared();
}