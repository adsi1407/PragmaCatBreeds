import 'package:bloc_test/bloc_test.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/cat_breeds_bloc.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/events/cat_breeds_event.dart';
import 'package:pragma_cat_breeds/src/presentation/cat_breeds/bloc/states/cat_breeds_state.dart';

/// Mock implementation of CatBreedsBloc for testing purposes
/// 
/// This mock provides a controllable implementation of CatBreedsBloc
/// for use in widget tests and integration tests.
/// It allows setting predefined states and verifying events.
class MockCatBreedsBloc extends MockBloc<CatBreedsEvent, CatBreedsState> 
    implements CatBreedsBloc {}