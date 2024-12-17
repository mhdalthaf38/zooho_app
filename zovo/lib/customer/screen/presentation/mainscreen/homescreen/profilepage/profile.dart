import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/mainscreen.dart';
import 'package:zovo/customer/screen/presentation/sign_in/signUp_page.dart';
import 'package:zovo/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.secondaryCream,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/burgerkingimg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Back Icon
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.08),
            child: GestureDetector(
              onTap: () {
               Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainPage()),
        (Route<dynamic> route) => false, // Clears all previous routes
      );
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.secondaryCream,
                size: screenWidth * 0.08,
              ),
            ),
          ),
          // Sign Out Icon
          Positioned(
            
            top: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>  SignUpScreen()),
                    (Route<dynamic> route) => false,
                  );
                });
              },
              child:Padding(
                padding:  EdgeInsets.all(screenWidth * 0.04),
                child: ImageIcon( AssetImage("assets/images/log-out.png",),color: AppColors.accentRed,size: screenWidth * 0.08,),
              ),
            ),
          ),
          // Sliding Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryCream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.08),
                    topRight: Radius.circular(screenWidth * 0.08),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Burger King',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryOrange,
                                  fontSize: screenWidth * 0.08,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '53 | Alexandria, Georgia',
                                style: GoogleFonts.poppins(
                                  color: AppColors.primaryText,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: AlignmentDirectional.center,
                           width: screenWidth * 0.15,
                         height: screenWidth * 0.075,
                           decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 10, 151, 83),
                            borderRadius: BorderRadius.circular(5)
                           ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.white, size: screenWidth * 0.04),
                                Text(
                                  '4.5',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStat('193', 'Total orders', screenWidth),
                          _buildStat('43', 'canceled orders', screenWidth),
                          _buildStat('2040', 'today profit', screenWidth),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Divider(color: Colors.grey[700]),
                      SizedBox(height: screenHeight * 0.02),
                      // Weapon of Choice Section
                      _buildSectionTitle('Discrition', screenWidth),
                      SizedBox(height: screenHeight * 0.01),
                      _buildSectionContent('A Burger King store is a fast-food restaurant chain that serves a variety of burgers, sandwiches, salads, and breakfast items. Founded in 1954, Burger King is the second-largest fast-food hamburger chain in the world', screenWidth),
                      SizedBox(height: screenHeight * 0.03),
                      // Self Summary Section
                      _buildSectionTitle('SELF SUMMARY', screenWidth),
                      SizedBox(height: screenHeight * 0.01),
                      _buildSectionContent(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent in magna sit amet magna tincidunt ultrices.',
                        screenWidth,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      _buildSectionContent(
                        'Sed lobortis libero lacus, posuere sollicitudin tellus vestibulum et. Nam ullamcorper vehicula laoreet.',
                        screenWidth,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  // Function to build stats widget
  Widget _buildStat(String number, String label, double screenWidth) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.poppins(
            color: AppColors.primaryOrange,
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.primaryText,
            fontSize: screenWidth * 0.03,
          ),
        ),
      ],
    );
  }

  // Function to build section titles
  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: AppColors.primaryOrange,
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Function to build section content
  Widget _buildSectionContent(String content, double screenWidth) {
    return Text(
      content,
      style: GoogleFonts.poppins(
        color: AppColors.primaryText,
        fontSize: screenWidth * 0.035,
      ),
    );
  }
}
