import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Import the base package
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Conditional import for web
late final _GoogleMapsOverlay? googleMapsOverlay;

void main() {
  // Initialize web-specific code if needed
  if (kIsWeb) {
    googleMapsOverlay = _GoogleMapsOverlay();
  }
  runApp(const MyApp());
}

// Web-specific overlay class
class _GoogleMapsOverlay {
  // Add any web-specific initialization here if needed
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _isApiReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _getCurrentLocation();
  }

  Future<void> _initializeMap() async {
    try {
      if (kIsWeb) {
        // Additional web initialization if needed
        await Future.delayed(const Duration(seconds: 1));
      }
      setState(() {
        _isApiReady = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize maps: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get location: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isApiReady) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Initializing Google Maps...',
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Map View",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF00A896),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _initializeMap();
                  _getCurrentLocation();
                },
                child: Text('Retry', style: GoogleFonts.poppins()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Map View",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF00A896),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? const LatLng(0, 0),
                zoom: 15.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _currentPosition != null
                  ? {
                      Marker(
                        markerId: const MarkerId("current"),
                        position: _currentPosition!,
                        infoWindow: const InfoWindow(title: "Your Location"),
                      ),
                    }
                  : {},
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            mapController.animateCamera(
              CameraUpdate.newLatLngZoom(_currentPosition!, 15));
          }
        },
        backgroundColor: const Color(0xFF00A896),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}