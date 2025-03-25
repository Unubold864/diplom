class NerbyPlacesModel {
  final String name;
  final String location;
  final String image;
  final double latitude;
  final double longitude;
  double? rating; // Rating can be null
  double? distance; // Distance can be null

  NerbyPlacesModel({
    required this.name,
    required this.location,
    required this.image,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.distance,
  });

  factory NerbyPlacesModel.fromJson(Map<String, dynamic> json) {
    return NerbyPlacesModel(
      name: json['name'],
      location: json['location'],
      image: json['image'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      rating: json['rating']?.toDouble(), // Ensure rating is handled as double if possible
      distance: json['distance']?.toDouble(), // Ensure distance is handled as double
    );
  }
}
