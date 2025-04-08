import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
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
  late GoogleMapController mapController;
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
        await Future.delayed(const Duration(seconds: 1));
      }
      setState(() => _isApiReady = true);
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
          _errorMessage = 'Please enable location services';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are required';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied. Please enable them in app settings.';
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
        _errorMessage = 'Error getting location: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Getting your location...',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Finder", style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 60, color: Colors.red[400]),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                    _isLoading = true;
                  });
                  _initializeMap();
                  _getCurrentLocation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isApiReady) return _buildLoadingScreen();
    if (_errorMessage != null) return _buildErrorScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text("Location Finder", style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? const LatLng(0, 0),
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // We'll add our own button
            markers: _currentPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId("current"),
                      position: _currentPosition!,
                      infoWindow: const InfoWindow(title: "You are here"),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      ),
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentPosition != null) {
                  mapController.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentPosition!, 15),
                  );
                }
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: Colors.blue[700]),
              elevation: 2,
            ),
          ),
          if (_currentPosition != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.blue[700]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Location',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, '
                            'Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}