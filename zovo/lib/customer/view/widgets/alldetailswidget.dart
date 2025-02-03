import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:zovo/customer/view/nearby/returentdetails/bloc/resturent_bloc.dart';
import 'package:zovo/customer/view/nearby/returentdetails/resturentpage.dart';
import 'package:zovo/theme.dart';
import 'package:url_launcher/url_launcher.dart';
void showProductDetails(
  BuildContext context,
  LatLng userlocation,
  double shoplongitude,
  double shoplatitude,
  String email,
  String image,
  String itemname,
  String description,
  String shopName,
  String location,
  String offerPrice,
  String shopImages,
) {
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
  showModalBottomSheet(
    isDismissible: true,
    context: context,
    isScrollControlled: true, // Allows full-screen height adjustments
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        controller: DraggableScrollableController(),
        initialChildSize: 0.6, // Start at 60% height
        minChildSize: 0.4, // Minimum size when dragged down
        maxChildSize: 0.65, // Maximum size when dragged up
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: scrollController, // Allows dragging content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      image,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Item Name & Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemname,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.green, size: 18),
                          Text(
                            location,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Price & Restaurant Name
                  Row(
                    children: [
                      Text(
                        "$offerPrice",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.restaurant_menu, color: Colors.green, size: 18),
                      Text(
                        shopName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Description
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Buttons: Menu & Directions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<ResturentBloc>().add(Fetchshopdata(email: email));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Resturentpage(email: email),
                              ),
                            );
                          },
                          icon: Icon(Icons.fastfood_sharp, size: 18),
                          label: Text('Menu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGreen,
                            foregroundColor: AppColors.secondaryCream,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            openGoogleMaps(
                              userlocation.latitude,
                              userlocation.longitude,
                              shoplatitude,
                              shoplongitude,
                            );
                          },
                          icon: Icon(Icons.directions, size: 18),
                          label: Text('Direction'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGreen,
                            foregroundColor: AppColors.secondaryCream,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
