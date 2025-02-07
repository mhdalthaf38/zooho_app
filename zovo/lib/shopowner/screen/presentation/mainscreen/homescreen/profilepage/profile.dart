import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/detailspage.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/mainscreen.dart';

import 'package:zovo/shopowner/screen/presentation/sign_in/welcomescreen.dart';

import 'package:zovo/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('shops')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        String images =snapshot.data!['shopImages'];
        String shopName = snapshot.data!['shopName'];
        String shopAddress = snapshot.data!['location'] ;

        String shopPhone = snapshot.data!['phoneNumber'] ;
        String shopDescription = snapshot.data!['shopDescription'] ;
        String shoparea = snapshot.data!['area'] ;
   
//there no such data as shopImages in the database we need to navigate to details page
        if (shopName == null || shopName == '') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Detailspage()),
            (Route<dynamic> route) => false,
          );
        }
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
                  child: PageView.builder(
                    itemCount: images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(images),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
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
                      (Route<dynamic> route) => false, 
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Sign Out'),
                          content: Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut().then((value) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                });
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: ImageIcon(
                      AssetImage("assets/images/log-out.png"),
                      color: AppColors.accentRed,
                      size: screenWidth * 0.08,
                    ),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                    
                                      child: Text(
                                        overflow:TextOverflow.ellipsis ,
                                        '$shopName',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.primaryOrange,
                                          fontSize: screenWidth * 0.08,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '$shopAddress , $shoparea',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryText,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: AppColors.primaryOrange,
                                          size: screenWidth * 0.04,
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text(
                                          shopPhone,
                                          style: GoogleFonts.poppins(
                                            color: AppColors.primaryText,
                                            fontSize: screenWidth * 0.035,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: AlignmentDirectional.center,
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.075,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 10, 151, 83),
                                  borderRadius: BorderRadius.circular(5),
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
                          _buildSectionContent(
                            '$shopDescription',
                            screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                        
                          
                          
                
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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