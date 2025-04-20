class ReccommendedPlacesModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String location;
  final String description;
  final String phoneNumber;
  final String hotelRating;

  ReccommendedPlacesModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.hotelRating,
  });

  factory ReccommendedPlacesModel.fromJson(Map<String, dynamic> json) {
    return ReccommendedPlacesModel(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      name: json['name'] ?? 'Unknown Place',
      image: json['image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      location: json['location'] ?? 'Unknown Location',
      description: json['description'] ?? 'No description available',
      phoneNumber: json['phone_number'] ?? 'Not available',
      hotelRating: json['hotel_rating'] ?? 'Not rated',
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