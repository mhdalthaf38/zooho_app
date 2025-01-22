import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/marker.dart';
import 'package:zovo/theme.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({super.key});

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  List<MarkedData> _markedData = [];
  List<Marker> _markers = [];
  LatLng? _selectedLocation;
  LatLng? _myposition;
  LatLng? _draggedPosition;
  bool _isDragging = false;
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  String? _locationAddress;

  Future<void> _saveLocationToFirebase(LatLng location) async {
    try {
         final email = FirebaseAuth.instance.currentUser?.email;
      await FirebaseFirestore.instance.collection('shops').doc(email).update({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'address': _locationAddress,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save location: $e')),
      );
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    return data['display_name'];
  }

  void _showcurrentlocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentlatlang = LatLng(position.latitude, position.longitude);
      String address = await _getAddressFromLatLng(currentlatlang);
      setState(() {
        _mapController.move(currentlatlang, 19.0);
        _myposition = currentlatlang;
        _locationAddress = address;
      });
    } catch (e) {
      print(e);
    }
  }
Future<Position>_determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                onTap: (tapPosition, point) async {
                  String address = await _getAddressFromLatLng(point);
                  setState(() {
                    _selectedLocation = point;
                    _draggedPosition = point;
                    _locationAddress = address;
                    _markers = [
                      Marker(
                        point: point,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.indigo,
                          size: 40,
                        ),
                      ),
                    ];
                  });
                },
                initialZoom: 15.0),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(markers: _markers),
              if (_isDragging && _draggedPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                        point: _draggedPosition!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.indigo,
                          size: 40,
                        ))
                  ],
                ),
              if (_myposition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                        point: _myposition!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 40,
                        ))
                  ],
                )
            ],
          ),
          if (_selectedLocation != null && _locationAddress != null)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selected Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_locationAddress!),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _saveLocationToFirebase(_selectedLocation!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Confirm Location'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(children: [FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              onPressed: _showcurrentlocation,
              child: Icon(Icons.location_searching_rounded),
            ),],)
          )
        ],
      ),
    );
  }
}