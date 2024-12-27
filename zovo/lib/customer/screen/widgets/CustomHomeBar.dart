import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/theme.dart';

class CustomOFFERCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rate;
  final String available;
  final String cuisine;
  final String distance;
  final String? offer;

  const CustomOFFERCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.available,
    required this.cuisine,
    required this.distance,
    required this.rate,
    this.offer,
  });

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;

    // Dynamic sizing based on screen width
    final imageSize = screenWidth * 0.34;
    final fontSize = screenWidth * 0.04;

    return Container(
      width: screenWidth * 0.9,
      color: AppColors.secondaryCream,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ITEMS',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: imageSize * 0.12, fontWeight: FontWeight.w900, letterSpacing: 0.01),
                        ),
                        Text(
                          'AT ₹179',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: imageSize * 0.14, fontWeight: FontWeight.w900, letterSpacing: 0.01),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryText,
                          fontSize: fontSize * 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    PopupMenuButton<String>(
                      
                      color: AppColors.secondaryCream,
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.primaryText,
                        size: fontSize * 1.5,
                      ),
                      onSelected: (value) {
                        // Handle the selection
                        print('Selected: $value');
                        // You can perform actions based on selected value here
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'Available',
                          child: Text('Available',style: GoogleFonts.poppins(color: AppColors.accentGreen, fontSize: fontSize * 1, fontWeight: FontWeight.bold),),
                        ),
                        PopupMenuItem<String>(
                          value: 'Not Available',
                          child: Text('Not Available',style: GoogleFonts.poppins(color: AppColors.accentRed, fontSize: fontSize * 1, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ],
                ),
               
                Text(
                  '$available',
                  style: GoogleFonts.poppins(
                    color: AppColors.secondaryText,
                    fontSize: fontSize * 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$offer / ₹$rate',
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryOrange,
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                 Text('Ends in $cuisine Hr',style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: fontSize * 0.8, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
