// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Razas de Gatos';

  @override
  String get homeTitle => 'Razas de Gatos';

  @override
  String get searchHint => 'Buscar razas de gatos...';

  @override
  String get searchBreeds => 'Buscar razas';

  @override
  String get loadingBreeds => 'Cargando razas de gatos...';

  @override
  String get errorLoadingBreeds => 'Error al cargar las razas de gatos';

  @override
  String get tryAgain => 'Intentar de Nuevo';

  @override
  String get noBreedsFound => 'No se encontraron razas de gatos';

  @override
  String noResultsFor(String query) {
    return 'No hay resultados para \"$query\"';
  }

  @override
  String get breedDetails => 'Detalles de la Raza';

  @override
  String get origin => 'Origen';

  @override
  String get temperament => 'Temperamento';

  @override
  String get description => 'Descripción';

  @override
  String get characteristics => 'Características';

  @override
  String get energyLevel => 'Nivel de Energía';

  @override
  String get affectionLevel => 'Nivel de Afecto';

  @override
  String get childFriendly => 'Amigable con Niños';

  @override
  String get dogFriendly => 'Amigable con Perros';

  @override
  String get strangerFriendly => 'Amigable con Extraños';

  @override
  String get groomingNeeds => 'Necesidades de Aseo';

  @override
  String get sheddingLevel => 'Nivel de Muda';

  @override
  String get healthIssues => 'Problemas de Salud';

  @override
  String get intelligence => 'Inteligencia';

  @override
  String get socialNeeds => 'Necesidades Sociales';

  @override
  String get vocalisation => 'Vocalización';

  @override
  String get experimental => 'Experimental';

  @override
  String get hairless => 'Sin Pelo';

  @override
  String get natural => 'Natural';

  @override
  String get rare => 'Rara';

  @override
  String get rex => 'Rex';

  @override
  String get suppressedTail => 'Cola Suprimida';

  @override
  String get shortLegs => 'Patas Cortas';

  @override
  String get hypoallergenic => 'Hipoalergénico';

  @override
  String get adaptability => 'Adaptabilidad';

  @override
  String get welcomeMessage =>
      '¡Bienvenido! Descubre increíbles razas de gatos.';

  @override
  String get networkError =>
      'Error de conexión de red. Por favor, verifica tu conexión a internet.';

  @override
  String get unknownError =>
      'Ocurrió un error inesperado. Por favor, inténtalo de nuevo.';

  @override
  String get refreshData => 'Actualizar Datos';

  @override
  String get clearSearch => 'Limpiar Búsqueda';
}
