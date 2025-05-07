import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String placeName;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        !serviceEnabled ||
        permission == LocationPermission.denied) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng placeLocation = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(title: Text(widget.placeName)),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: placeLocation,
          initialZoom: 14,
        ),
        children: [
          // ✅ Custom Tile Layer (OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),

          // ✅ Маркер байршуулалт
          MarkerLayer(
            markers: [
              Marker(
                point: placeLocation,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
              if (userLocation != null)
                Marker(
                  point: userLocation!,
                  width: 30,
                  height: 30,
                  child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 30),
                ),
            ],
          ),

          // ✅ Polyline – Жишээ зам (user → газарт очих)
          if (userLocation != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [userLocation!, placeLocation],
                  color: Colors.blueAccent,
                  strokeWidth: 4,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
