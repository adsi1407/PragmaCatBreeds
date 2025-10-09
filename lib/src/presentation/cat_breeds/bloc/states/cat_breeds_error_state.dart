part of 'cat_breeds_state.dart';

/// Error state when something goes wrong while fetching data
class CatBreedsError extends CatBreedsState {
  const CatBreedsError(this.message);

  /// Error message describing what went wrong
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'CatBreedsError(message: $message)';
}