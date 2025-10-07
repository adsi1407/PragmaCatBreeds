import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

/// Widget that displays breed characteristics with rating bars
class BreedCharacteristicsWidget extends StatelessWidget {
  const BreedCharacteristicsWidget({
    required this.breed,
    super.key,
  });

  final CatBreed breed;

  @override
  Widget build(BuildContext context) {
    final characteristics = _getCharacteristics();
    
    if (characteristics.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No characteristic information available'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: characteristics
              .map((characteristic) => _buildCharacteristicRow(
                    context,
                    characteristic.name,
                    characteristic.value,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCharacteristicRow(
    BuildContext context,
    String name,
    int value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: value / 5.0,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForValue(context, value),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$value/5',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForValue(BuildContext context, int value) {
    if (value <= 2) {
      return Theme.of(context).colorScheme.error;
    } else if (value <= 3) {
      return Colors.orange;
    } else {
      return Theme.of(context).colorScheme.primary;
    }
  }

  List<_Characteristic> _getCharacteristics() {
    final characteristics = <_Characteristic>[];

    if (breed.adaptability != null) {
      characteristics.add(
        _Characteristic('Adaptability', breed.adaptability!),
      );
    }

    if (breed.affectionLevel != null) {
      characteristics.add(
        _Characteristic('Affection Level', breed.affectionLevel!),
      );
    }

    if (breed.childFriendly != null) {
      characteristics.add(
        _Characteristic('Child Friendly', breed.childFriendly!),
      );
    }

    if (breed.dogFriendly != null) {
      characteristics.add(
        _Characteristic('Dog Friendly', breed.dogFriendly!),
      );
    }

    if (breed.energyLevel != null) {
      characteristics.add(
        _Characteristic('Energy Level', breed.energyLevel!),
      );
    }

    if (breed.grooming != null) {
      characteristics.add(
        _Characteristic('Grooming', breed.grooming!),
      );
    }

    if (breed.healthIssues != null) {
      characteristics.add(
        _Characteristic('Health Issues', breed.healthIssues!),
      );
    }

    if (breed.intelligence != null) {
      characteristics.add(
        _Characteristic('Intelligence', breed.intelligence!),
      );
    }

    if (breed.sheddingLevel != null) {
      characteristics.add(
        _Characteristic('Shedding Level', breed.sheddingLevel!),
      );
    }

    if (breed.socialNeeds != null) {
      characteristics.add(
        _Characteristic('Social Needs', breed.socialNeeds!),
      );
    }

    if (breed.strangerFriendly != null) {
      characteristics.add(
        _Characteristic('Stranger Friendly', breed.strangerFriendly!),
      );
    }

    if (breed.vocalisation != null) {
      characteristics.add(
        _Characteristic('Vocalisation', breed.vocalisation!),
      );
    }

    return characteristics;
  }
}

class _Characteristic {
  const _Characteristic(this.name, this.value);

  final String name;
  final int value;
}