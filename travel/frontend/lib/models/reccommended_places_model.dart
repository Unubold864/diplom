class ReccommendedPlacesModel {
  final String image;
  final double rating;
  final String location;

  ReccommendedPlacesModel({
    required this.image,
    required this.rating,
    required this.location,
  });

  String? get name => null;
}

List<ReccommendedPlacesModel> recommendedPlaces = [
  ReccommendedPlacesModel(
    image: "assets/places/place5.jpg",
    rating: 4.4,
    location: "Ulaanbaatar",
  ),
  ReccommendedPlacesModel(
    image: "assets/places/place4.jpg",
    rating: 4.4,
    location: "Khuvsgul Lake",
  ),
  ReccommendedPlacesModel(
    image: "assets/places/place3.jpg",
    rating: 4.4,
    location: "Zavkhan",
  ),
  ReccommendedPlacesModel(
    image: "assets/places/place2.jpg",
    rating: 4.4,
    location: "Uvs, Ulaangomb",
  ),
  ReccommendedPlacesModel(
    image: "assets/places/place1.jpg",
    rating: 4.4,
    location: "Gobi Khangai",
  ),
];
