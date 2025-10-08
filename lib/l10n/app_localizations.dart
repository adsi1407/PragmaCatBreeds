import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Cat Breeds'**
  String get appTitle;

  /// Title for the home screen
  ///
  /// In en, this message translates to:
  /// **'Cat Breeds'**
  String get homeTitle;

  /// Hint text for the search input
  ///
  /// In en, this message translates to:
  /// **'Search cat breeds...'**
  String get searchHint;

  /// Label for search functionality
  ///
  /// In en, this message translates to:
  /// **'Search breeds'**
  String get searchBreeds;

  /// Loading message when fetching breeds
  ///
  /// In en, this message translates to:
  /// **'Loading cat breeds...'**
  String get loadingBreeds;

  /// Error message when breeds fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading cat breeds'**
  String get errorLoadingBreeds;

  /// Button text to retry an action
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Message when no breeds match the search
  ///
  /// In en, this message translates to:
  /// **'No cat breeds found'**
  String get noBreedsFound;

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResultsFor(String query);

  /// Title for the breed details screen
  ///
  /// In en, this message translates to:
  /// **'Breed Details'**
  String get breedDetails;

  /// Label for breed origin
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// Label for breed temperament
  ///
  /// In en, this message translates to:
  /// **'Temperament'**
  String get temperament;

  /// Label for breed description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Title for breed characteristics section
  ///
  /// In en, this message translates to:
  /// **'Characteristics'**
  String get characteristics;

  /// Label for energy level characteristic
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get energyLevel;

  /// Label for affection level characteristic
  ///
  /// In en, this message translates to:
  /// **'Affection Level'**
  String get affectionLevel;

  /// Label for child friendly rating
  ///
  /// In en, this message translates to:
  /// **'Child Friendly'**
  String get childFriendly;

  /// Label for dog friendly rating
  ///
  /// In en, this message translates to:
  /// **'Dog Friendly'**
  String get dogFriendly;

  /// Label for stranger friendly rating
  ///
  /// In en, this message translates to:
  /// **'Stranger Friendly'**
  String get strangerFriendly;

  /// Label for grooming needs rating
  ///
  /// In en, this message translates to:
  /// **'Grooming Needs'**
  String get groomingNeeds;

  /// Label for shedding level rating
  ///
  /// In en, this message translates to:
  /// **'Shedding Level'**
  String get sheddingLevel;

  /// Label for health issues rating
  ///
  /// In en, this message translates to:
  /// **'Health Issues'**
  String get healthIssues;

  /// Label for intelligence rating
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get intelligence;

  /// Label for social needs rating
  ///
  /// In en, this message translates to:
  /// **'Social Needs'**
  String get socialNeeds;

  /// Label for vocalisation rating
  ///
  /// In en, this message translates to:
  /// **'Vocalisation'**
  String get vocalisation;

  /// Label for experimental breed status
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get experimental;

  /// Label for hairless breed characteristic
  ///
  /// In en, this message translates to:
  /// **'Hairless'**
  String get hairless;

  /// Label for natural breed characteristic
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get natural;

  /// Label for rare breed characteristic
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get rare;

  /// Label for rex breed characteristic
  ///
  /// In en, this message translates to:
  /// **'Rex'**
  String get rex;

  /// Label for suppressed tail characteristic
  ///
  /// In en, this message translates to:
  /// **'Suppressed Tail'**
  String get suppressedTail;

  /// Label for short legs characteristic
  ///
  /// In en, this message translates to:
  /// **'Short Legs'**
  String get shortLegs;

  /// Label for hypoallergenic characteristic
  ///
  /// In en, this message translates to:
  /// **'Hypoallergenic'**
  String get hypoallergenic;

  /// Label for adaptability rating
  ///
  /// In en, this message translates to:
  /// **'Adaptability'**
  String get adaptability;

  /// Welcome message shown initially
  ///
  /// In en, this message translates to:
  /// **'Welcome! Discover amazing cat breeds.'**
  String get welcomeMessage;

  /// Error message for network issues
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please check your internet connection.'**
  String get networkError;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unknownError;

  /// Button text to refresh data
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// Button text to clear search field
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
