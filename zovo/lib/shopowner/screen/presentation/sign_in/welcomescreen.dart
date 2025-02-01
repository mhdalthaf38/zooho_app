import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zovo/customer/view/sigup/usersignup.dart';
import 'package:zovo/shopowner/screen/presentation/sign_in/signUp_page.dart';

import 'package:zovo/theme.dart';





class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      body: Column(
        children: [
          // Top Section with Logo and Text
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: AppColors.secondaryCream,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  SizedBox(height: screenHeight * 0.02),
                  // Title
                  Text(
                    "ZOOho",
                    style: GoogleFonts.poppins(color: AppColors.primaryOrange, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  // Subtitle
                  Text(
                    "Grab your offers",
                    style: GoogleFonts.poppins(color: AppColors.primaryText, fontSize: 20, fontWeight: FontWeight.bold),
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
                color: AppColors.primaryOrange,
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
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: screenWidth * 0.09, // Responsive font size
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Subtitle Text
                    Text(
                      "We here to help you to find your best offers",
                      style: GoogleFonts.poppins(
                         color: Colors.white,
                        fontSize: screenWidth * 0.05, // Responsive font size
                      )
                    ),
                    Spacer(),
                    // Buttons Row
                    Row(
                      children: [
                        // Sign In Button
                     
                        // Sign Up Button
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Usersignup()));
                            },
                            child: Text(
                              "For Offers",
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryText,
                                fontSize: screenWidth * 0.04, // Responsive font size
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                            },
                            child: FittedBox(
                              child: Text(
                                "For bussiness",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryText,
                                  fontSize: screenWidth * 0.04, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                )
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
