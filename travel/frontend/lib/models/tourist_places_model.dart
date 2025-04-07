class TouristPlacesModel {
  final String name;
  final String image;

  TouristPlacesModel({required this.name, required this.image});
}

List<TouristPlacesModel> touristPlaces = [
  TouristPlacesModel(name: "All", image: "assets/icons/mountain.png"),
  TouristPlacesModel(name: "Hiking", image: "assets/icons/beach.png"),
  TouristPlacesModel(name: "Forest", image: "assets/icons/desert.png"),
  TouristPlacesModel(name: "Camp", image: "assets/icons/forest.png"),
];
