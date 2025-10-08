// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cat Breeds';

  @override
  String get homeTitle => 'Cat Breeds';

  @override
  String get searchHint => 'Search cat breeds...';

  @override
  String get searchBreeds => 'Search breeds';

  @override
  String get loadingBreeds => 'Loading cat breeds...';

  @override
  String get errorLoadingBreeds => 'Error loading cat breeds';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noBreedsFound => 'No cat breeds found';

  @override
  String noResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get breedDetails => 'Breed Details';

  @override
  String get origin => 'Origin';

  @override
  String get temperament => 'Temperament';

  @override
  String get description => 'Description';

  @override
  String get characteristics => 'Characteristics';

  @override
  String get energyLevel => 'Energy Level';

  @override
  String get affectionLevel => 'Affection Level';

  @override
  String get childFriendly => 'Child Friendly';

  @override
  String get dogFriendly => 'Dog Friendly';

  @override
  String get strangerFriendly => 'Stranger Friendly';

  @override
  String get groomingNeeds => 'Grooming Needs';

  @override
  String get sheddingLevel => 'Shedding Level';

  @override
  String get healthIssues => 'Health Issues';

  @override
  String get intelligence => 'Intelligence';

  @override
  String get socialNeeds => 'Social Needs';

  @override
  String get vocalisation => 'Vocalisation';

  @override
  String get experimental => 'Experimental';

  @override
  String get hairless => 'Hairless';

  @override
  String get natural => 'Natural';

  @override
  String get rare => 'Rare';

  @override
  String get rex => 'Rex';

  @override
  String get suppressedTail => 'Suppressed Tail';

  @override
  String get shortLegs => 'Short Legs';

  @override
  String get hypoallergenic => 'Hypoallergenic';

  @override
  String get adaptability => 'Adaptability';

  @override
  String get welcomeMessage => 'Welcome! Discover amazing cat breeds.';

  @override
  String get networkError =>
      'Network connection error. Please check your internet connection.';

  @override
  String get unknownError => 'An unexpected error occurred. Please try again.';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get welcomeLoading => 'Welcome! Loading cat breeds...';

  @override
  String get noBreedsAvailable => 'No cat breeds available';

  @override
  String get clearSearchButton => 'Clear search';

  @override
  String get errorGeneric => 'Oops! Something went wrong';

  @override
  String get tryAgainButton => 'Try again';

  @override
  String get loadingFailed => 'Failed to load cat breeds';

  @override
  String get searchFailed => 'Failed to search cat breeds';

  @override
  String get noCharacteristics => 'No characteristic information available';
}
