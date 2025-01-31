import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zovo/customer/view/alloffers/Userhompage.dart';
import 'package:zovo/customer/view/homescreen/homescreen.dart';
import 'package:zovo/shopowner/screen/presentation/mainscreen/mainscreen.dart';

import 'package:zovo/shopowner/screen/presentation/mainscreen/collecting%20details/detailspage.dart';

import 'package:zovo/shopowner/screen/presentation/sign_in/signin_page.dart';
import 'package:zovo/services/Auth/Auth_services.dart';
import 'package:zovo/theme.dart';



class Usersignup extends StatefulWidget {
  @override
  _UsersignupState createState() => _UsersignupState();
}

class _UsersignupState extends State<Usersignup> {
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
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
                  "Sign Up",
                  style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w900,
                            color: AppColors.secondaryCream,
                           fontSize: screenWidth * 0.08, // Responsive font
                          ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "you need better offers? then you are at the right place ",
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
                   
                    // Shop Owner Sign-In Button
                  

                    // Customer Sign-In Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                      ),
                      onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                final GoogleSignIn googleSignIn = GoogleSignIn(
                                  clientId: '1034567890-abcdefghijklmnopqrstuvwxyz1234567.apps.googleusercontent.com',
                                  scopes: ['email', 'profile']
                                );
                                await googleSignIn.signOut(); // Sign out first to force account picker
                                final result = await AuthService().Signinwithgoogle();
                                if (result != null) {

                                                      final userRef = FirebaseFirestore.instance.collection('customers').doc( result.user!.email);
                                                      final userData = {
                                                        'email': result.user!.email,
                                                        // 'name': result.user!.displayName,
                                                        // 'photoURL': result.user!.photoURL,
                                                        // 'uid': result.user!.uid,
                                                        // 'createdAt': FieldValue.serverTimestamp(),
                                                      };
                                                      await userRef.set(userData);                           Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => UserHome(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 500),
                              ),
                            );
                          }
                              } catch (e) {
                                print('Error signing in with Google: $e');
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },                  
                      child: isLoading == true ? CircularProgressIndicator(color: AppColors.secondaryCream,) : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.webp',
                            width: screenWidth * 0.055,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            "Sign up with Google",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondaryCream,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }}