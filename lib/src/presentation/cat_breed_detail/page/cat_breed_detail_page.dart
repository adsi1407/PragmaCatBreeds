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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                breed.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: breed.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: breed.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ColoredBox(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.pets,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      errorWidget: (context, url, error) => ColoredBox(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.pets,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ColoredBox(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      child: Icon(
                        Icons.pets,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
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
