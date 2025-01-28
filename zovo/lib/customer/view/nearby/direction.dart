import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class DirectionScreen extends StatefulWidget {
  final double storeLatitude;
  final double storeLongitude;

  const DirectionScreen({Key? key, required this.storeLatitude, required this.storeLongitude}) : super(key: key);

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  final MapController _mapController = MapController();
  LatLng? _myPosition;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _myPosition = LatLng(position.latitude, position.longitude);
        _mapController.move(_myPosition!, 15.0);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _getRoutePoints() async {
    if (_myPosition != null) {
      final url = 'https://router.project-osrm.org/route/v1/driving/${_myPosition!.longitude},${_myPosition!.latitude};${widget.storeLongitude},${widget.storeLatitude}?overview=full&geometries=geojson';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'Location services are disabled.';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw 'Location permissions are denied';
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Your location to Kpf Chicken',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialZoom: 13.0),
            children: [
              TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 6.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              if (_myPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myPosition!,
                      width: 50,
                      height: 50,
                      child: Icon(Icons.my_location, color: Colors.green, size: 40),
                    )
                  ],
                ),
            
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '3 hr 27 min (134 km)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Fastest route now, avoids road closure', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  onPressed: _getRoutePoints,
                  label: Text('Start'),
                  icon: Icon(Icons.navigation),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
