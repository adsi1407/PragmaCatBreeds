import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import 'package:pragma_cat_breeds/src/presentation/cat_breed_detail/widgets/breed_characteristics_widget.dart';

/// Detail page for displaying comprehensive information about a cat breed
class CatBreedDetailPage extends StatelessWidget {
  const CatBreedDetailPage({
    required this.breed,
    super.key,
  });

  final CatBreed breed;

  static const String routeName = '/cat-breed-detail';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.5; // Imagen ocupa la mitad de la pantalla
    
    return Scaffold(
      body: Column(
        children: [
          // Imagen fija en la parte superior (mitad de pantalla)
          SizedBox(
            height: imageHeight,
            child: Stack(
              children: [
                // Imagen de fondo
                breed.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: breed.imageUrl!,
                        height: imageHeight,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: imageHeight,
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Icon(
                            Icons.pets,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: imageHeight,
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Icon(
                            Icons.pets,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.pets,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                
                // AppBar con nombre de la raza
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    title: Text(
                      breed.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.white,
                    leading: Container(
                      margin: const EdgeInsets.all(4), // Reduced margin for larger tap area
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                        iconSize: 24,
                        padding: const EdgeInsets.all(8), // Ensure minimum tap area
                        tooltip: 'Go back', // Semantic label for accessibility
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido scrolleable en la parte inferior
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic information
                  _buildBasicInfo(context),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  if (breed.description != null) ...[
                    _buildSection(
                      context,
                      'Description',
                      breed.description!,
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Temperament
                  if (breed.temperament != null) ...[
                    _buildSection(
                      context,
                      'Temperament',
                      breed.temperament!,
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Characteristics
                  _buildCharacteristics(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (breed.origin != null)
              _buildInfoRow(
                context,
                Icons.location_on,
                'Origin',
                breed.origin!,
              ),
            
            if (breed.lifeSpan != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.access_time,
                'Life Span',
                '${breed.lifeSpan} years',
              ),
            ],
            
            if (breed.weightMetric != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.scale,
                'Weight',
                '${breed.weightMetric} kg',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacteristics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Characteristics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        BreedCharacteristicsWidget(breed: breed),
      ],
    );
  }
}
