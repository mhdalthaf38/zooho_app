import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zovo/Customer/screen/presentation/mainscreen/mainscreen.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/collecting%20details/collectingshopimages.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/collecting%20details/detailspage.dart';

import 'package:zovo/customer/screen/presentation/sign_in/signin_page.dart';
import 'package:zovo/services/Auth/Auth_services.dart';
import 'package:zovo/theme.dart';



class Detailspage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController _shopNameController = TextEditingController();
    final TextEditingController _LocationController = TextEditingController();
    final TextEditingController _phonenumberController = TextEditingController();
    final TextEditingController _shopDescriptionController = TextEditingController();
    // Fetching screen height and width dynamically
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primaryOrange, // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondaryCream),
          onPressed: () => Navigator.pop(context),
        ),
        
      ),
      body: Stack(
        children: [
          // Top Text Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03), // Responsive spacing
                Text(
                  "Collecting Details",
                  style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w900,
                            color: AppColors.secondaryCream,
                           fontSize: screenWidth * 0.08, // Responsive font
                          ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do tempor",
                  style: GoogleFonts.poppins(
                    color: AppColors.secondaryCream,
                    fontSize: screenWidth * 0.04,
                  )
                ),
              ],
            ),
          ),

          // Bottom Card Section
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
                    // Full Name Field
                    TextField(
                      controller: _shopNameController,
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                        focusColor: AppColors.primaryOrange,
                        floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                        labelText: 'Shop Name',
                        labelStyle: TextStyle(fontSize: screenWidth * 0.045), // Responsive font
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: AppColors.secondaryCream,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Password Field
                     TextField(
                      controller: _LocationController,
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                        focusColor: AppColors.primaryOrange,
                        floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                        labelText: 'Location',
                        labelStyle: TextStyle(fontSize: screenWidth * 0.045), // Responsive font
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: AppColors.secondaryCream,
                      ),
                    ),
                      SizedBox(height: screenHeight * 0.02),
  TextField(
    controller:_phonenumberController, 
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                        focusColor: AppColors.primaryOrange,
                        floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                        labelText: 'Phone number ',
                        labelStyle: TextStyle(fontSize: screenWidth * 0.045), // Responsive font
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: AppColors.secondaryCream,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

               
TextField(
  controller: _shopDescriptionController,
  maxLines: 3,
  decoration: InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: AppColors.primaryOrange),
    ),
    focusColor: AppColors.primaryOrange,
    floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
    labelText: 'Write about your shop',
    labelStyle: TextStyle(fontSize: screenWidth * 0.045),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    filled: true,
    fillColor: AppColors.secondaryCream,
  ),
),
SizedBox(height: screenHeight * 0.02),                  
                 
                    SizedBox(height: screenHeight * 0.03),

                    // Sign-In Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // Responsive padding
                        ),
                      ),
                   
                        onPressed: () async {
                              final email = FirebaseAuth.instance.currentUser?.email;
                        // Save the details to Firebase
                        await FirebaseFirestore.instance.collection('shops').doc(email).update({
                          'shopName': _shopNameController.text,
                          'location': _LocationController.text,
                          'phoneNumber': _phonenumberController.text,
                          'shopDescription': _shopDescriptionController.text,
                        });

                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => imageDetailspage()), // Replace NextScreen with your next screen widget
                        );
                        },
                      child: Text(
                        "Next",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w900,
                            color: AppColors.secondaryCream,
                           fontSize: screenWidth * 0.045, // Responsive font
                          ), // Responsive font
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Google and Facebook Buttons
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }}
