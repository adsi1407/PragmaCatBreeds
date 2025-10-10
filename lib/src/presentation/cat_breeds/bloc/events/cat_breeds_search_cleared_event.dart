part of 'cat_breeds_event.dart';

/// Event to clear the current search and show all cat breeds
class CatBreedsSearchCleared extends CatBreedsEvent {
  const CatBreedsSearchCleared();

  @override
  String toString() => 'CatBreedsSearchCleared()';
}
