import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/marker.dart';
import 'package:zovo/theme.dart';
import 'package:http/http.dart' as http;

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
  Future<Position> _determinePosition() async {
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
      Navigator.push(context, MaterialPageRoute(builder: (context)=>imageDetailspage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save location: $e')),
      );
    }
  
  }

  void _addmarker(LatLng position, String title, String description) {
    setState(() {
      final markerdata =
          MarkedData(position: position, title: title, descrition: description);
      _markedData.add(markerdata);
      _markers.add(Marker(
          width: 80,
          height: 80,
          point: position,
          child: GestureDetector(
              onTap: () {
                print('Marker tapped');
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryOrange,
                    size: 30,
                  ),
                ],
              ))));
    });
  }

  void _showMarkerDialog(BuildContext context, LatLng position) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Marker'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final title = titleController.text;
                    final description = descController.text;
                    _addmarker(position, title, description);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add')),
            ],
          );
        });
  }

  void _showmarkerinfo(MarkedData MarkedData) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(MarkedData.title),
            content: Text(MarkedData.descrition),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close')),
            ],
          );
        });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body) as List;
    if (data.isNotEmpty) {
      setState(() {
        _searchResults = data;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _movetolocation(double lat, double lng) {
    final location = LatLng(lat, lng);
    _mapController.move(location, 18.0);
    setState(() {
      _selectedLocation = location;
      _searchResults = [];
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _searchController.addListener(() {
      _searchPlaces(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                onTap: (tapPosition, point)async {
                  _selectedLocation = point;
                  _draggedPosition = _selectedLocation;
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
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Column(
              children: [
                SizedBox(
                  height: 55,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search places',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _isSearching = false;
                                  _searchController.clear();
                                  _searchResults = [];
                                });
                              },
                            )
                          : null,
                    ),
                    onTap: () => setState(() {
                      _isSearching = true;
                    }),
                  ),
                ),
                if (_isSearching && _searchResults.isNotEmpty)
                  Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final place = _searchResults[index];

                          return ListTile(
                            title: Text(place['display_name']),
                            onTap: () {
                              final lat = double.parse(place['lat']);
                              final lon = double.parse(place['lon']);
                              _movetolocation(lat, lon);
                            },
                          );
                        },
                      ))
              ],
            ),
          ),
           if (_selectedLocation != null && _locationAddress != null)
            Positioned(
              bottom: 40,
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
                        child: Text('Confirm Location'),))]))),
          Positioned(
            top: 550,
            right: 20,
            child: Column(children: [FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              onPressed: 
              _showcurrentlocation,
    
              child: Icon(Icons.location_searching_rounded),
            ),],)
          )
        ],
      ),
    );
  }
}
