import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              const Color(0xFFFFF4CC), // Light yellow shade
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Top orange circle
            Positioned(
              top: -size.width * 0.25, // Adjusted for responsiveness
              right: -size.width * 0.25,
              child: Container(
                width: size.width * 0.5,
                height: size.width * 0.5,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC107), // Orange color
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Bottom orange circle
            Positioned(
              bottom: -size.width * 0.25,
              left: -size.width * 0.25,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xFFFFC107), // Orange color
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/beer_icon.png', // Replace with your beer icon asset
                    width: size.width * 0.25,
                    height: size.width * 0.25,
                  ),
                  SizedBox(height: size.height * 0.02), // Dynamic spacing
                  Text(
                    'deeps',
                    style: TextStyle(
                      fontSize: size.width * 0.09,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005), // Dynamic spacing
                  Text(
                    'BEERCAFE',
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      letterSpacing: 2,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
