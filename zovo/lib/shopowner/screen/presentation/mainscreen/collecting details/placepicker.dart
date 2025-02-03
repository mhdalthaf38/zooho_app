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

class PlacePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
          backgroundColor: AppColors.primaryOrange,
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
             
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
                             
                              ],
                          ),
                      ),
                  ),
              ),
          ]));
  }
}