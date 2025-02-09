import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/shopowner/screen/widgets/vegornonveg.dart';
import 'package:zovo/theme.dart';

class todayoffercard extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final String priceInfo;
  final String rating;
  final String deliveryTime;
  final String cuisines;
  final String remainingtime;
  final String discountoffer;
  final bool VegOrNonVeg;

  const todayoffercard({
    Key? key,
    required this.imageUrl,
    required this.restaurantName,
    required this.priceInfo,
    required this.rating,
    required this.deliveryTime,
    required this.cuisines,
    required this.remainingtime , required this.discountoffer, required this.VegOrNonVeg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.secondaryCream,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.secondaryCream,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(screenWidth * 0.05),
                      bottom: Radius.circular(screenWidth * 0.05)),
                  child: Container(
                    height: screenheight * 0.195,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:imageUrl == ''?AssetImage('assets/images/noimage.jpg'):NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6), // Dark bottom
                            Colors.black.withOpacity(0.3),
                            Colors.transparent, // Fade out
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Free Delivery Tag
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'EXTRA $discountoffer%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "OFF",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Favorite (Heart) Icon
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child: Icon(Icons.favorite_border,
                      color: Colors.black, size: 16),
                ),
              ),
              // Price Info
              Positioned(
                bottom: 20,
                left: 8,
                child: Text(
                  "ITEM\nAT $priceInfo",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black38,
                      ),
                    ],
                ),
              ),),
               Positioned(
                bottom: 25,
                right: 10,
                child: VegNonVegIcon(isVeg: VegOrNonVeg,),),
              
              // Ad Tag (if applicable)
             
                // Positioned(
                //   top: screenWidth * 0.09,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Color(0xFFFFE5E5),
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                //     child: Row(
                //       children: [
                //         Text(
                //           'EXTRA $discountoffer% OFF',
                //           style: GoogleFonts.poppins(
                //             fontSize: 12,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.red,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              
            ],
            
          ),
          
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: AppColors.secondaryText, fontSize: 12),
                ),
                Text(
                 cuisines.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.timelapse, color: Colors.green, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Ends in $remainingtime Hr",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
