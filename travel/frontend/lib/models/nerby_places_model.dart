class NerbyPlacesModel {
  final String image;

  NerbyPlacesModel({required this.image});

  String? get name => null;

  String? get location => null;

  get rating => null;

  get price => null;
}

List<NerbyPlacesModel> nearbyPlaces = [
  NerbyPlacesModel(image: 'assets/places/place7.jpg'),
  NerbyPlacesModel(image: 'assets/places/place6.jpg'),
  NerbyPlacesModel(image: 'assets/places/place5.jpg'),
  NerbyPlacesModel(image: 'assets/places/place4.jpg'),
  NerbyPlacesModel(image: 'assets/places/place3.jpg'),
  NerbyPlacesModel(image: 'assets/places/place2.jpg'),
  NerbyPlacesModel(image: 'assets/places/place1.jpg'),
];
