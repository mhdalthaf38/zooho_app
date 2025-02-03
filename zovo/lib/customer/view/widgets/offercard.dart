import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/theme.dart';

class Offercard extends StatelessWidget {
  final String available;
  final String remainingtime;
  final String imageUrl;
  final String itemname;
  final String price;
  final String shopName;
  final String offerprice;
  final String location;
  final String description;

  const Offercard({
    super.key,
    required this.available,
    required this.remainingtime,
    required this.imageUrl,
    required this.itemname,
    required this.price,
    required this.shopName,
    required this.offerprice,
    required this.location,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondaryCream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with Gradient Overlay
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Background Image
                  Image.network(
                    imageUrl,
                    width: screenWidth * 0.40,
                    height: screenHeight * 0.195,
                    fit: BoxFit.cover,
                  ),
                  
                  // Gradient Overlay
                  Container(
                    width: screenWidth * 0.40,
                    height: screenHeight * 0.195,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6), // Dark at the bottom
                          Colors.transparent, // Fades to transparent at the top
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  // Favorite Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite_border, color: Colors.white),
                  ),

                  // Price Tag
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Item\n  At ₹$price',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),

          // Restaurant Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemname,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                shopName != ''
                    ? Row(
                        children: [
                          Icon(Icons.restaurant_menu, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text(shopName, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : SizedBox.shrink(),

                Text(
                  description,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  available,
                  style: GoogleFonts.poppins(
                    color: available == 'Available' ? AppColors.accentGreen : AppColors.accentRed,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.03,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                Text(
                  'Ends in $remainingtime ',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondaryText,
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  location,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(height: 20),

                // Discount Offer Section
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        'EXTRA $offerprice% OFF',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 4),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
