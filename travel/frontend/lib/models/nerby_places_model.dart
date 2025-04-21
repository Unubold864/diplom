class NerbyPlacesModel {
  final String? name;
  final String? location;
  final String? image;
  final double? rating;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String? phoneNumber;
  final List<String> images;
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
    this.images = const [],
  });

  factory NerbyPlacesModel.fromJson(Map<String, dynamic> json) {
    
    // Process main image
    String? imageUrl = json['image'] is String ? json['image'] : null;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = 'http://127.0.0.1:8000${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
    }

    // Process gallery images
    List<String> galleryImages = [];
    if (json['images'] != null && json['images'] is List) {
      for (var img in json['images']) {
        if (img is String) {
          String imgUrl = img;
          if (!imgUrl.startsWith('http')) {
            imgUrl = 'http://127.0.0.1:8000${imgUrl.startsWith('/') ? '' : '/'}$imgUrl';
          }
          galleryImages.add(imgUrl);
        } else if (img is Map && img['image'] is String) {
          String imgUrl = img['image'];
          if (!imgUrl.startsWith('http')) {
            imgUrl = 'http://127.0.0.1:8000${imgUrl.startsWith('/') ? '' : '/'}$imgUrl';
          }
          galleryImages.add(imgUrl);
        }
      }
    }

    // Process distance
    double? distanceValue;
    if (json['distance'] != null) {
      try {
        distanceValue = json['distance'] is double 
            ? json['distance'] 
            : double.tryParse(json['distance'].toString());
      } catch (e) {
        print('Error parsing distance: $e');
      }
    }

    print('Raw description from API: ${json['description']}');
    
    // Process description
    String? description;
    if (json['description'] != null) {
      if (json['description'] is String) {
        description = json['description'];
      } else {
        description = json['description'].toString();
      }
    }

    return NerbyPlacesModel(
      name: json['name']?.toString(),
      location: json['location']?.toString(),
      image: imageUrl,
      rating: json['rating'] is double ? json['rating'] : 
             json['rating'] is int ? json['rating'].toDouble() : 
             json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      latitude: json['latitude'] is double ? json['latitude'] : 
               json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] is double ? json['longitude'] : 
                json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      description: json['description']?.toString() ?? 'No description available',
      phoneNumber: json['phone_number']?.toString(),
      distance: distanceValue,
      images: galleryImages,
    );
  }

  get id => null;
}