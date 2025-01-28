import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/marker.dart';
import 'package:http/http.dart' as http;
import 'package:zovo/theme.dart';

class directionscreen extends StatefulWidget {
  final storelatitude;
  final storelongitude;
  String storename;
   directionscreen({super.key, required this.storelatitude, required this.storelongitude,required this.storename});

  @override
  State<directionscreen> createState() => _directionscreenState();
}

class _directionscreenState extends State<directionscreen> {
  final _mapController = MapController();
  List<Marker> _markers = [];
  LatLng? _myposition;
  LatLng? _shoplocation;
  LatLng? _draggedPosition;
  bool _isDragging = false;
  List<LatLng> _routePoints = [];
  String? _locationAddress;
  Future<String> _getAddressFromLatLng(LatLng position) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    return data['display_name'];
  }

  Future<void> _getRoutePoints() async {
    try {
       cureentlocation();
    if (_myposition != null) {
      final url = 'https://router.project-osrm.org/route/v1/driving/${_myposition!.longitude},${_myposition!.latitude};${widget.storelongitude},${widget.storelatitude}?overview=full&geometries=geojson';
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
       LatLng currentlatlang = LatLng(_myposition!.latitude, _myposition!.longitude);
      List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _mapController.move(currentlatlang, 19.0);
        _routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });
    }
    } catch (e) {
      SnackBar(content: Text('try again: $e'));
    }
   
  }

  void _showshoplocation() async {
    try {
      LatLng currentlatlang = LatLng(widget.storelatitude, widget.storelongitude);
      String address = await _getAddressFromLatLng(currentlatlang);
      setState(() {
        _mapController.move(currentlatlang, 19.0);
        _shoplocation = currentlatlang;
        _locationAddress = address;
      });
    } catch (e) {
      print(e);
    }
  }

  void cureentlocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentlatlang = LatLng(position.latitude, position.longitude);
      String address = await _getAddressFromLatLng(currentlatlang);
     
      setState(() {
         
        
        _myposition = currentlatlang;
      });
    } catch (e) {
      print(e);
    }
  }

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

  @override
  void initState() {
   
    setState(() {
       _showshoplocation();
       cureentlocation();
    });
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
             
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
                ),
              if (_shoplocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                        point: _shoplocation!,
                        width: 80,
                        height: 80,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ))
                  ],
                ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
           if (_locationAddress != null)
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
                      widget.storename??'Store location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('location:${_locationAddress!}'),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()async {
   _getRoutePoints();

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Direction'),))]))),
        
        ],
      ),
    );
  }
}
