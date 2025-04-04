class NerbyPlacesModel {
  final String? name;
  final String? location;
  final String? image;
  final double? rating;
  final double? latitude;
  final double? longitude;
  final String? description; // Added description field
  final String? phoneNumber;  // Added phone number field
  double? distance;

  NerbyPlacesModel({
    this.name,
    this.location,
    this.image,
    this.rating,
    this.latitude,
    this.longitude,
    this.description,
    this.phoneNumber,
    this.distance,
  });

  factory NerbyPlacesModel.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json'); // Debug print
    
    // Extract image URL and debug it
    String? imageUrl = json['image'];
    print('Original image URL: $imageUrl');
    
    // Ensure the image URL is properly formed
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      // If the URL is relative, convert it to absolute
      // Modify this base URL to match your backend
      if (imageUrl.startsWith('/')) {
        imageUrl = 'http://127.0.0.1:8000$imageUrl';
      } else {
        imageUrl = 'http://127.0.0.1:8000/$imageUrl';
      }
      print('Corrected image URL: $imageUrl');
    }

    // Parse distance from JSON if it exists
    double? distanceValue;
    if (json['distance'] != null) {
      try {
        distanceValue = double.parse(json['distance'].toString());
        print('Distance from API: $distanceValue km');
      } catch (e) {
        print('Error parsing distance: $e');
      }
    }

    return NerbyPlacesModel(
      name: json['name'],
      location: json['location'],
      image: imageUrl,
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : null,
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      description: json['description'], // Parse description from JSON
      phoneNumber: json['phone_number'], // Parse phone number from JSON
      distance: distanceValue, // Set the distance from API
    );
  }
}