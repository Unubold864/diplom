class NerbyPlacesModel {
  final String name;
  final String location;
  final String image;
  final double rating;
  final double distance;

  NerbyPlacesModel({
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.distance,
  });

  // Add fromJson method to map JSON data to the model
  factory NerbyPlacesModel.fromJson(Map<String, dynamic> json) {
    return NerbyPlacesModel(
      name: json['name'] ?? 'Unknown',
      location: json['location'] ?? 'Unknown location',
      image: json['image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      distance: json['distance']?.toDouble() ?? 0.0,
    );
  }
}
