// ignore_for_file: public_member_api_docs
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'cat_breeds_error_state.dart';
part 'cat_breeds_initial_state.dart';
part 'cat_breeds_loaded_state.dart';
part 'cat_breeds_loading_state.dart';

/// Base sealed class for all Cat Breeds states
sealed class CatBreedsState extends Equatable {
  const CatBreedsState();

  @override
  List<Object?> get props => [];
}
