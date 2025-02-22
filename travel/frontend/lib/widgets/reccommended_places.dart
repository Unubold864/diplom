import 'package:flutter/material.dart';
import 'package:frontend/models/reccommended_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart';
import 'package:ionicons_named/ionicons_named.dart';

class ReccommendedPlaces extends StatelessWidget {
  const ReccommendedPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // Increased height for better visibility
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

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 240, // Increased width for better spacing
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToDetails(context),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  persianGreen.withOpacity(0.1), // Light Persian Green
                  Colors.white.withOpacity(0.8), // Slightly transparent white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(),
                  const SizedBox(height: 12),
                  _buildTitleRow(theme),
                  const SizedBox(height: 8),
                  _buildLocation(theme),
                ],
              ),
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
        height: 160, // Increased height for better visibility
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 160,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.grey),
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
            place.name ?? 'Unknown Place', // Use the place name from the model
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: persianGreen, // Persian Green text
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
          place.rating.toString(), // Use the rating from the model
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        Icon(
          ionicons['location_outline'],
          color: persianGreen, // Persian Green icon
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          place.location, // Use the location from the model
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