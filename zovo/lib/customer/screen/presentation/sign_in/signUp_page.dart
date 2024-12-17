import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zovo/Customer/screen/presentation/mainscreen/mainscreen.dart';
import 'package:zovo/customer/screen/presentation/mainscreen/detailspage.dart';
import 'package:zovo/customer/screen/presentation/sign_in/signin_page.dart';
import 'package:zovo/services/Auth/Auth_services.dart';
import 'package:zovo/theme.dart';



class SignUpScreen extends StatelessWidget {
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
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                        focusColor: AppColors.primaryOrange,
                        floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                        labelText: 'Full Name',
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
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                        focusColor: AppColors.primaryOrange,
                        floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                        labelText: 'Email',
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

                    // Password Field
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                         focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOrange),
                      ),
                        focusColor: AppColors.primaryOrange,
                        floatingLabelStyle: TextStyle(color: AppColors.primaryOrange),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: screenWidth * 0.045), // Responsive font
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: AppColors.secondaryCream,
                      ),
                    ),

                    // Forgot Password
                 
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w900,
                            color: AppColors.secondaryCream,
                           fontSize: screenWidth * 0.045, // Responsive font
                          ), // Responsive font
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Google and Facebook Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015, // Responsive padding
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: Image.asset(
                              'assets/images/google.webp',
                              width: screenWidth * 0.055, // Responsive width
                         
                            ),
                            label: Text(
                              "Google",
                              style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font
                            ),
                            onPressed: () async {
                              try {
                                await GoogleSignIn().signOut(); // Sign out first to force account picker
                                final result = await AuthService().Signinwithgoogle();
                                if (result != null) {
                                  if (result.additionalUserInfo?.isNewUser ?? false) {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => Detailspage(),
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
                                  } else {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
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
                                }
                              } catch (e) {
                                print('Error signing in with Google: $e');
                              }
                            },                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015, // Responsive padding
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              "Sign in",
                              style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignInScreen()),
                              );
                            },
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
  }}