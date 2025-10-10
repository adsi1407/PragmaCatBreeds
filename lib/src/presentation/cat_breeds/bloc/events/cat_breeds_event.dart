// ignore_for_file: public_member_api_docs
import 'package:equatable/equatable.dart';

part 'cat_breeds_load_requested_event.dart';
part 'cat_breeds_search_requested_event.dart';
part 'cat_breeds_search_cleared_event.dart';

/// Base sealed class for all Cat Breeds events
sealed class CatBreedsEvent extends Equatable {
  const CatBreedsEvent();

  @override
  List<Object?> get props => [];
}
