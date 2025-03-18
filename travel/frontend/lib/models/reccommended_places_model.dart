class ReccommendedPlacesModel {
  final String name;
  final String image;
  final double rating;
  final String location;

  ReccommendedPlacesModel({
    required this.name,
    required this.image,
    required this.rating,
    required this.location,
  });

  // Factory constructor to create an instance from a JSON object
  factory ReccommendedPlacesModel.fromJson(Map<String, dynamic> json) {
    return ReccommendedPlacesModel(
      name: json['name'] ?? 'Unknown Place', // Handle missing name
      image: json['image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0, // Ensure rating is a double
      location: json['location'] ?? '',
    );
  }

  // Method to convert the model to JSON (optional, if you need to send data back to the server)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
      'location': location,
    };
  }
}
