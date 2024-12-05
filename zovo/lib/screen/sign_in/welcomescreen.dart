import 'package:flutter/material.dart';
import 'package:zovo/screen/sign_in/signup_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        children: [
          // Top Section with Logo and Text
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo.png', // Replace with your logo asset
                    height: screenHeight * 0.15, // Responsive height
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Title
                  Text(
                    "deeps",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Subtitle
                  Text(
                    "BEER CAFE",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Responsive font size
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section with Welcome Text and Buttons
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(screenHeight * 0.03),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Text
                    Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: screenWidth * 0.07, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Subtitle Text
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do tempor incididunt ut labore et.",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.black54,
                      ),
                    ),
                    Spacer(),
                    // Buttons Row
                    Row(
                      children: [
                        // Sign In Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015, // Responsive padding
                              ),
                            ),
                            onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: screenWidth * 0.045, // Responsive font size
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        // Sign Up Button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                             
                              side: BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015, // Responsive padding
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: screenWidth * 0.045, // Responsive font size
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
