part of 'cat_breeds_event.dart';

/// Event to load all cat breeds from the repository
class CatBreedsLoadRequested extends CatBreedsEvent {
  const CatBreedsLoadRequested();

  @override
  String toString() => 'CatBreedsLoadRequested()';
}
