import 'package:flutter/material.dart';

class Verticalcard extends StatelessWidget {
  final String image;
final String shopname;
final String discription;
final String location;
  const Verticalcard({super.key, required this.image, required this.shopname, required this.discription, required this.location});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width =MediaQuery.of(context).size.width * 0.40; // Adjust width dynamically
        double height = width ; // Maintain aspect ratio

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          child: Stack(
            children: [
              // Background Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  
image, // Replace with actual image URL
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Dark Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              // Text Overlay
              Padding(
                padding: EdgeInsets.all(width * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Text
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        location,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.08, // Responsive font size
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Spacer(),

                    // Title in Malayalam
                    Text(
                      shopname,
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: width * 0.1, // Responsive font size
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),

                    // Bottom details
                    Text(
                      discription,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05, // Responsive font size
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // Views count
                    
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
