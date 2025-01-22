import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';


import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/map.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/marker.dart';
import 'package:zovo/theme.dart';

class PlacePicker extends StatefulWidget {
  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  bool _locationSaved = false;
  bool _isLoading = false;
  final _mapController = MapController();
  final _searchController = TextEditingController();
  List<MarkedData> _markedData = [];
List<Marker> _markers = [];
LatLng? _selectedLocation;
LatLng? _myposition;
LatLng? _draggedPosition;
bool _isDragging = false;
TextEditingController _searchControllerinmap = TextEditingController();
List<dynamic> _searchResults = [];
bool _isSearching = false;

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }


  Future<void> requestLocationPermission() async {
      var status = await Permission.location.request();
      if (status.isGranted) {
          // Permission granted
      } else if (status.isDenied || status.isPermanentlyDenied) {
          // Handle permission denial
      }
  }

  Future<void> _getCurrentLocation() async {
      setState(() {
        _isLoading = true;
      });
        
      try {
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

        Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
        final email = FirebaseAuth.instance.currentUser?.email;
        await FirebaseFirestore.instance.collection('shops').doc(email).update({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
            _locationSaved = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location saved successfully!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
  }

  void _showMapPicker() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child:Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                 onTap: (tapPosition, LatLng) {
                   
                 },
                       initialZoom: 13.0
                       
                    ),
                    children: [
TileLayer(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",)
                    ],
                     )
                ],
              ),
          ),
      );
  }
  @override
  Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
          backgroundColor: AppColors.primaryOrange,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.secondaryCream),
                  onPressed: () => Navigator.pop(context),
              ),
          ),
          body: Stack(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          SizedBox(height: screenHeight * 0.03),
                          Text(
                              " your Shop Location",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondaryCream,
                                  fontSize: screenWidth * 0.08,
                              ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                              "Make sure you are at your shop location if its not you can't continue",
                              style: GoogleFonts.poppins(
                                  color: AppColors.secondaryCream,
                                  fontSize: screenWidth * 0.04,
                              )),
                      ],
                  ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryCream,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryOrange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.02,
                                          ),
                                      ),
                                      onPressed: _isLoading ? null : _getCurrentLocation,
                                      child: _isLoading 
                                          ? CircularProgressIndicator(color: AppColors.secondaryCream)
                                          : Text('Current Location',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.secondaryCream,
                                                  fontSize: screenWidth * 0.045,
                                              ),
                                          ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryOrange,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.02,
                                          ),
                                      ),
                                      onPressed:() {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Mapscreen()));
                                      },
                                      child: Text('Pick from Map',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w900,
                                              color: AppColors.secondaryCream,
                                              fontSize: screenWidth * 0.045,
                                          ),
                                      ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  if (_locationSaved)
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primaryOrange,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: screenHeight * 0.02,
                                              ),
                                          ),
                                          onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => imageDetailspage()));
                                          },
                                          child: Text('Next',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.secondaryCream,
                                                  fontSize: screenWidth * 0.045,
                                              ),
                                          ),
                                      ),
                              ],
                          ),
                      ),
                  ),
              ),
          ]));
  }
}