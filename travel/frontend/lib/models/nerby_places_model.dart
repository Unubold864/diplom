class NerbyPlacesModel {
  final String name;
  final String location;
  final String image;
  final double? latitude;  // Make nullable
  final double? longitude; // Make nullable
  double? rating;
  double? distance;

  NerbyPlacesModel({
    required this.name,
    required this.location,
    required this.image,
    this.latitude,
    this.longitude,
    this.rating,
    this.distance,
  });

  factory NerbyPlacesModel.fromJson(Map<String, dynamic> json) {
    return NerbyPlacesModel(
      name: json['name'],
      location: json['location'],
      image: json['image'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      rating: json['rating']?.toDouble(),
      distance: json['distance']?.toDouble(),
    );
  }
}
