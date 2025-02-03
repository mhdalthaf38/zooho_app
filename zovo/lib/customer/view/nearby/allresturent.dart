import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:zovo/customer/view/nearby/returentdetails/bloc/resturent_bloc.dart';
import 'package:zovo/customer/view/nearby/returentdetails/menuitems.dart';
import 'package:zovo/customer/view/nearby/returentdetails/resturentpage.dart';
import 'package:zovo/customer/view/widgets/custommarker.dart';
import 'package:zovo/customer/view/widgets/menucard.dart';

import 'package:zovo/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TestNearby extends StatefulWidget {
  TestNearby({
    super.key,
  });

  @override
  State<TestNearby> createState() => _TestNearbyState();
}

class _TestNearbyState extends State<TestNearby> {
  final _mapController = MapController();
  LatLng? _myposition;
   LatLng? mylocation;
  LatLng? _selectedShopLocation;
  String? _selectedShopName;
  String? _selectedShopAddress;
  List<Marker> _markers = [];
  List<LatLng> _routePoints = [];
  bool _isTracking = false;
  String image ='';
  String? useremail;
  bool? ShopStatus;
  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _fetchShopLocations();
  }

  /// 📍 Fetch Current User Location
  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentlatlang = LatLng(position.latitude, position.longitude);

      setState(() {
        _myposition = currentlatlang;
        _mapController.move(currentlatlang, 18);
        mylocation = currentlatlang;
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  /// 🏢 Fetch Shop Locations & Add Clickable Markers
  Future<void> _fetchShopLocations() async {
    FirebaseFirestore.instance
        .collection('shops')
        .snapshots()
        .listen((snapshot) {
      List<Marker> markers = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        double? latitude = data['latitude'];
        double? longitude = data['longitude'];
        String shopName = data['shopName'] ?? "Unnamed Shop";
        String imageUrl = data['shopImages'] ?? "https://via.placeholder.com/80";
        String useremail = data['email'];
        bool shopstatus = data['shopstatus'];
        if (latitude != null && longitude != null) {
          LatLng shopLatLng = LatLng(latitude, longitude);
          markers.add(
            Marker(
              point: shopLatLng,
              width: 100,
              height: 100,
              child: GestureDetector(
                onTap: () => _onShopMarkerTap(
                    shopLatLng, shopName, imageUrl, useremail, shopstatus),
                child: CustomMarkerWidget(
                    shopName: shopName, imageUrl: imageUrl),
              ),
            ),
          );
        }
      }

      setState(() {
        _markers = markers;
      });
    });
  }

  /// 📌 Handle Click on Shop Marker
  Future<void> _onShopMarkerTap(LatLng shopLatLng, String shopName, String images,
      String email, bool statusofShop) async {
    String address = await _getAddressFromLatLng(shopLatLng);
    setState(() {
      ShopStatus = statusofShop;
      useremail = email;
      image = images;
      _selectedShopLocation = shopLatLng;
      _selectedShopName = shopName;
      _selectedShopAddress = address;
      _mapController.move(shopLatLng, 18.0);
    });
  }

  /// 🚗 Fetch Route from User to Selected Shop
  Future<void> _getRoutePoints() async {
    if (_myposition == null || _selectedShopLocation == null) return;

    setState(() {
      _isTracking = true; // ✅ Enable live tracking
    });

    final url =
        'https://router.project-osrm.org/route/v1/driving/${_myposition!.longitude},${_myposition!.latitude};${_selectedShopLocation!.longitude},${_selectedShopLocation!.latitude}?overview=full&geometries=geojson';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['routes'] != null && data['routes'].isNotEmpty) {
      List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
      setState(() {
        _routePoints =
            coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
        _mapController.move(_myposition!, 18);
      });

      // Start tracking the user's live location while navigating
      Geolocator.getPositionStream(
              locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.high))
          .listen((Position newPosition) {
        if (_isTracking) {
          setState(() {
            _myposition = LatLng(newPosition.latitude, newPosition.longitude);
            _mapController.move(_myposition!, 18);
          });
        }
      });
    }
  }

  /// 📌 Function to Request User Location Permission
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('❌ Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('❌ Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error('❌ Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// 📍 Get Address from Latitude & Longitude
  Future<String> _getAddressFromLatLng(LatLng position) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    return data['display_name'] ?? 'Unknown location';
  }

  Future<void> openGoogleMaps(double originLat, double originLng,
      double destLat, double destLng) async {
      
    final Uri googleMapsUri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng",
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $googleMapsUri";
    }
  }

  Widget _imageCard(String imageUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image:
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialZoom: 18),
            children: [
              TileLayer(
                  urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
              MarkerLayer(markers: _markers), // 🔴 Multiple Shop Markers

              if (_myposition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _myposition!,
                      width: 50,
                      height: 50,
                      child: Icon(Icons.person_pin_circle,
                          color: Colors.blue, size: 40),
                    ),
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

          // 📍 Store Details Card when Shop is Clicked
          if (_selectedShopName != null)
            DraggableScrollableSheet(
              initialChildSize: 0.4, // Default height when opened
              minChildSize: 0.1, // Min height (collapsed)
              maxChildSize: 0.4, // Max height (fully expanded)
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screenwidth * 0.4,
                                  left: screenwidth * 0.4),
                              child: Container(
                                width: 6,
                                height: 5,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            _imageCard(image),
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedShopName!,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ShopStatus == true
                              ? Container(
                                  height: screenheight * 0.04,
                                  width: screenwidth * 0.4,
                                  decoration: BoxDecoration(
                                      color: AppColors.accentGreen,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text('Shop is Open',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.secondaryCream,
                                            fontSize: screenwidth * 0.035,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                )
                              : Container(
                                  height: screenheight * 0.04,
                                  width: screenwidth * 0.4,
                                  decoration: BoxDecoration(
                                      color: AppColors.accentRed,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text('Shop is closed',
                                        style: GoogleFonts.poppins(
                                            color: AppColors.secondaryCream,
                                            fontSize: screenwidth * 0.035,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(_selectedShopAddress!,
                                      style:
                                          TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        openGoogleMaps(
                                            mylocation!.latitude,
                                            mylocation!.longitude,
                                            _selectedShopLocation!.latitude,
                                            _selectedShopLocation!.longitude);
                                      },
                                      icon: Icon(Icons.directions, size: 18),
                                      label: Text('Direction'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        foregroundColor: Colors.white,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                       context.read<ResturentBloc>().add(Fetchshopdata(email:useremail! ));
                                    
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Resturentpage(email:useremail! ,
                                                     
                                                    )));
                                      },
                                      icon:
                                          Icon(Icons.fastfood_sharp, size: 18),
                                      label: Text('menu'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        foregroundColor: Colors.white,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_myposition != null) {
                  setState(() {
                    _isTracking =
                        false; // ✅ Stop tracking when user manually recenters
                  });
                  _mapController.move(_myposition!, 18.0);
                }
              },
              child: Icon(Icons.my_location, color: Colors.white),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
