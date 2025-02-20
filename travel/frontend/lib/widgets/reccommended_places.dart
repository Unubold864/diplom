import 'package:flutter/material.dart';
import 'package:frontend/models/reccommended_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart';
import 'package:ionicons_named/ionicons_named.dart';

class ReccommendedPlaces extends StatelessWidget {
  const ReccommendedPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _RecommendedPlaceCard(
          place: recommendedPlaces[index],
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: recommendedPlaces.length,
      ),
    );
  }
}

class _RecommendedPlaceCard extends StatelessWidget {
  final ReccommendedPlacesModel place;

  const _RecommendedPlaceCard({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 0.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                const SizedBox(height: 8),
                _buildTitleRow(theme),
                const SizedBox(height: 8),
                _buildLocation(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        place.image,
        width: double.maxFinite,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline),
          );
        },
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "St Regis Bora Bora",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.star,
          color: Colors.yellow.shade700,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          "4.4",
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        Icon(
          ionicons['location_outline'],
          color: theme.primaryColor,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          "French Polynesia",
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TouristDetailsPage(
          image: place.image,
        ),
      ),
    );
  }
}
