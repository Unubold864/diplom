class ReccommendedPlacesModel {
  final String name;
  final String image;
  final double rating;
  final String location;
  final String description; // Added description
  final String phoneNumber; // Added phone number
  final String hotelRating; // Added hotel rating

  ReccommendedPlacesModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.hotelRating,
  });

  // Factory constructor to create an instance from a JSON object
  factory ReccommendedPlacesModel.fromJson(Map<String, dynamic> json) {
    return ReccommendedPlacesModel(
      name: json['name'] ?? 'Unknown Place',
      image: json['image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      location: json['location'] ?? '',
      description: json['description'] ?? 'No description available', // Default value
      phoneNumber: json['phone_number'] ?? 'No phone number available', // Default value
      hotelRating: json['hotel_rating'] ?? 'No rating available', // Default value
    );
  }

  Object? get id => null;

  Map<String, dynamic> toJson() {
    return {
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
