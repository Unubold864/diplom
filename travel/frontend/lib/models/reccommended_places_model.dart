import 'package:uuid/uuid.dart';

class ReccommendedPlacesModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String location;
  final String description;
  final String phoneNumber;
  final String hotelRating;
  final List<String> images;

  ReccommendedPlacesModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.hotelRating,
    this.images = const [],
  });

  factory ReccommendedPlacesModel.fromJson(Map<String, dynamic> json) {
    // Handle image URLs
    String mainImage = json['image'] ?? '';
    if (mainImage.isNotEmpty && !mainImage.startsWith('http')) {
      mainImage = 'http://127.0.0.1:8000${mainImage.startsWith('/') ? '' : '/'}$mainImage';
    }

    // Process gallery images
    List<String> galleryImages = [];
    if (json['images'] != null) {
      for (var img in json['images']) {
        String imgUrl = img['image'];
        if (!imgUrl.startsWith('http')) {
          imgUrl = 'http://127.0.0.1:8000${imgUrl.startsWith('/') ? '' : '/'}$imgUrl';
        }
        galleryImages.add(imgUrl);
      }
    }
    return ReccommendedPlacesModel(
      id: json['id']?.toString() ?? const Uuid().v4(),
      name: json['name'] ?? 'Unknown Place',
      image: json['image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      location: json['location'] ?? 'Unknown Location',
      description: json['description'] ?? 'No description available',
      phoneNumber: json['phone_number'] ?? 'Not available',
      hotelRating: json['hotel_rating'] ?? 'Not rated',
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'location': location,
      'description': description,
      'phone_number': phoneNumber,
      'hotel_rating': hotelRating,
    };
  }
}