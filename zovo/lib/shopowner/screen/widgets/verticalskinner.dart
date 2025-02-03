import 'package:flutter/material.dart';

class Verticalcard extends StatelessWidget {
  final String image;

  const Verticalcard({super.key, required this.image});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.45; // Adjust width dynamically
        double height = width * 1.4; // Maintain aspect ratio

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
                child: Image.asset(
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
                        'Paal Kappa',
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
                      'പാൽ കപ്പ',
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
                      'പാൽ കപ്പ ഇത്ര രുചിയോ? | Paal Kapp...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.05, // Responsive font size
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // Views count
                    Text(
                      '34K views',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.045, // Responsive font size
                      ),
                    ),
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
