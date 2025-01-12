import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/theme.dart';

class PlacePicker extends StatefulWidget {
    @override
    _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
    bool _locationSaved = false;
    bool _isLoading = false;

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

          // Check if location services are enabled
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
              // Location services are not enabled, don't continue
              return Future.error('Location services are disabled.');
          }

          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied) {
                  // Permissions are denied, don't continue
                  return Future.error('Location permissions are denied');
              }
          }

          if (permission == LocationPermission.deniedForever) {
              // Permissions are denied forever, don't continue
              return Future.error(
                      'Location permissions are permanently denied, we cannot request permissions.');
          }

          // Get the current location
          Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
          final email = FirebaseAuth.instance.currentUser?.email;
          // Store the location in Firebase
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

    @override
    Widget build(BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
      return  Scaffold(
        backgroundColor: AppColors.primaryOrange, // Background color
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.secondaryCream),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(children: [
          // Top Text Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03), // Responsive spacing
                Text(
                  " your Shop Location",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondaryCream,
                    fontSize: screenWidth * 0.08, // Responsive font
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                    "MAke sure you are at your shop location if its not you can't continue",
                    style: GoogleFonts.poppins(
                      color: AppColors.secondaryCream,
                      fontSize: screenWidth * 0.04,
                    )),
              ],
            ),
          ),

          // Bottom Card Section
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
                    // Full Name Field
                   ElevatedButton(
                     style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // Responsive padding
                        ),
                      ),
                            onPressed: _isLoading ? null : _getCurrentLocation,
                            child: _isLoading 
                              ? CircularProgressIndicator(color: AppColors.secondaryCream)
                              : Text('Shop Location',style:  GoogleFonts.poppins(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondaryCream,
                                  fontSize: screenWidth * 0.045, // Responsive font
                                ),),
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
                          vertical: screenHeight * 0.02, // Responsive padding
                        ),
                      ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => imageDetailspage()));
                                },
                                child: Text('Next',style:  GoogleFonts.poppins(
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondaryCream,
                          fontSize: screenWidth * 0.045, // Responsive font
                        ),),
                            ),
                  ],
                ),
              ),
            ),
          ),
        ]));
    }
}